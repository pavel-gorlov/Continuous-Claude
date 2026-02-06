#!/usr/bin/env bash
set -euo pipefail

# Telegram notification script for Claude Code hooks
# Mirrors show-toast.sh interface but sends to Telegram instead

readonly ENV_FILE="${HOME}/.claude/.env"
readonly LOG="${HOME}/.claude/telegram/telegram-error.log"

# Extract project name from CLAUDE_PROJECT_DIR
get_project_name() {
    if [[ -n "${CLAUDE_PROJECT_DIR:-}" ]]; then
        basename "$CLAUDE_PROJECT_DIR"
    else
        echo "unknown"
    fi
}

# Hook mode defaults - notification mode
readonly NOTIFICATION_MESSAGE="Waiting for your response"

# Hook mode defaults - stop mode
readonly STOP_MESSAGE="Task completed"

# Debug mode
debug() {
    if [[ "${TELEGRAM_DEBUG:-}" == "1" ]]; then
        echo "DEBUG: $*" >&2
    fi
}

# Load environment variables from .env file
load_env() {
    if [[ ! -f "$ENV_FILE" ]]; then
        debug "Environment file not found: $ENV_FILE"
        return 1
    fi

    # Source .env file, ignoring comments and empty lines
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
        # Remove leading/trailing whitespace from key
        key=$(echo "$key" | xargs)
        # Skip if key is empty after trimming
        [[ -z "$key" ]] && continue
        # Export the variable (value may be empty)
        export "$key"="$value"
    done < <(grep -v '^[[:space:]]*#' "$ENV_FILE" | grep '=')

    debug "Loaded environment from $ENV_FILE"
}

# Logging function - creates log file only on first error
log_error() {
    local message="$1"
    local log_dir
    log_dir="$(dirname "$LOG")"

    # Create log directory if it doesn't exist
    [[ -d "$log_dir" ]] || mkdir -p "$log_dir"

    # Append error with timestamp
    echo "[$(date -Iseconds)] ERROR: ${message}" >> "$LOG"
}

# Parse hook payload from stdin and extract relevant fields
parse_hook_payload() {
    local payload message
    # Read from stdin with timeout to avoid hanging
    if payload=$(timeout 0.1s cat 2>/dev/null); then
        debug "Received hook payload: ${payload:0:200}..."

        # Try to extract message from JSON payload using basic string manipulation
        if [[ "$payload" =~ \"message\"[[:space:]]*:[[:space:]]*\"([^\"]*) ]]; then
            message="${BASH_REMATCH[1]}"
            debug "Extracted message from hook payload: $message"
            echo "$message"
            return 0
        else
            debug "No message field found in hook payload"
        fi
    else
        debug "No hook payload received from stdin"
    fi

    echo ""
    return 1
}

# Escape text for Telegram MarkdownV2
escape_markdown() {
    local text="$1"
    # Escape special characters for MarkdownV2
    echo "$text" | sed 's/[_*\[\]()~`>#+=|{}.!-]/\\&/g'
}

# Send message to Telegram
send_telegram() {
    local title="$1"
    local message="$2"

    # Check if Telegram is enabled
    if [[ "${TELEGRAM_ENABLED:-}" != "true" ]]; then
        debug "Telegram notifications disabled (TELEGRAM_ENABLED != true)"
        return 0
    fi

    # Validate required variables
    if [[ -z "${TELEGRAM_BOT_TOKEN:-}" ]]; then
        log_error "TELEGRAM_BOT_TOKEN not set"
        return 1
    fi

    if [[ -z "${TELEGRAM_CHAT_ID:-}" ]]; then
        log_error "TELEGRAM_CHAT_ID not set"
        return 1
    fi

    # Format message
    local formatted_text
    formatted_text="*${title}*

${message}"

    debug "Sending Telegram message: $formatted_text"

    # Send via Telegram Bot API
    local response
    local http_code

    response=$(curl -s -w "\n%{http_code}" \
        --max-time 10 \
        -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=${formatted_text}" \
        -d "parse_mode=Markdown" \
        2>&1)

    http_code=$(echo "$response" | tail -n1)
    local body
    body=$(echo "$response" | sed '$d')

    if [[ "$http_code" != "200" ]]; then
        log_error "Telegram API error (HTTP $http_code): $body"
        return 1
    fi

    # Check if response contains "ok":true
    if [[ "$body" =~ \"ok\":true ]]; then
        debug "Telegram message sent successfully"
        return 0
    else
        log_error "Telegram API returned error: $body"
        return 1
    fi
}

# Main argument parsing and execution
main() {
    local title=""
    local message=""
    local hook_mode=""

    # Load environment variables
    load_env || true

    # Get project name for hook modes
    local project_name
    project_name=$(get_project_name)

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --notification-hook)
                hook_mode="notification"
                title="[$project_name] Claude Code"
                message="$NOTIFICATION_MESSAGE"
                shift
                ;;
            --stop-hook)
                hook_mode="stop"
                title="[$project_name] Claude Code"
                message="$STOP_MESSAGE"
                shift
                ;;
            --title|-t)
                [[ -n "${2:-}" ]] || { log_error "Missing value for --title"; exit 1; }
                title="$2"
                shift 2
                ;;
            --message|-m)
                [[ -n "${2:-}" ]] || { log_error "Missing value for --message"; exit 1; }
                message="$2"
                shift 2
                ;;
            --help|-h)
                cat <<EOF
Usage: $0 [OPTIONS]

Hook modes:
  --notification-hook    Run in notification hook mode (default: "Claude Code" / "Waiting for your response")
  --stop-hook           Run in stop hook mode (default: "Claude Code" / "Task completed")

Manual mode options:
  --title, -t TEXT      Notification title
  --message, -m TEXT    Notification message

Other options:
  --help, -h            Show this help message

Environment variables (from ~/.claude/.env):
  TELEGRAM_ENABLED      Set to "true" to enable (default: disabled)
  TELEGRAM_BOT_TOKEN    Bot token from @BotFather
  TELEGRAM_CHAT_ID      Your chat ID

Debug:
  TELEGRAM_DEBUG=1      Enable debug output

Examples:
  $0 --notification-hook                    # Hook mode for notifications
  $0 --stop-hook                           # Hook mode for task completion
  $0 --title "Test" --message "Hello"      # Manual notification

EOF
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Error: Unknown option: $1" >&2
                echo "Use --help for usage information" >&2
                exit 1
                ;;
        esac
    done

    # Parse hook payload if in hook mode and use extracted message
    if [[ -n "$hook_mode" ]]; then
        local hook_message
        if hook_message=$(parse_hook_payload) && [[ -n "$hook_message" ]]; then
            message="$hook_message"
            debug "Using message from hook payload: $message"
        else
            debug "No valid message in hook payload, using defaults"
        fi
    fi

    # Set defaults if not specified
    [[ -n "$title" ]] || title="Claude Code"
    [[ -n "$message" ]] || message="Notification"

    # Send notification (silently handle errors to avoid disrupting Claude)
    if ! send_telegram "$title" "$message"; then
        # Error already logged, exit silently for hook mode
        if [[ -n "$hook_mode" ]]; then
            exit 0  # Silent exit for hook mode
        else
            exit 1  # Normal exit for manual mode
        fi
    fi

    exit 0
}

# Run main function with all arguments
main "$@"
