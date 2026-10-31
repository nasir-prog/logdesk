#! /usr/bin/env bash
readonly APP_NAME='logdesk'
readonly VERSION='0.1'
readonly ERROR_LOG="$HOME/logdesk/errors.log"
## need to add general.log


print_help() {
printf '%s version %s\n' "$APP_NAME" "$VERSION"
printf 'This utilit was wrote by nasir-prog\n'
printf 'Usage: %s COMMAND\n' "$0"
echo 
(
printf "''|help|--help|-h;print info about utilit logdesk\n"
printf "info PATHS;print file name,count of lines\n"
) | column -t -s ";" -o "       " -N "COMMAND,USAGE"
}
readonly -f print_help

print_error() {
    printf 'Error - %s. Exit code %s\n' "$1" "$2" | tee -a "$ERROR_LOG" >&2
    printf 'Use "help" if you have questions\n' >&2
}
readonly -f print_error

arg_checker() {
    local count="$#"
    for ((i=1; i<=count; i++));do
        if [[ ! -e $1 ]];then 
            print_error "File '$1' not found" "4"
            shift
            return 4
        elif [[ ! -f $1 ]];then
            print_error "'$1' is not file" "5"
            shift
            return 5
        elif [[ ! -r $1 ]];then
            print_error "Cant read this file: '$1'" "6"
            shift
            return 6
        else
            print_info "$1"
            shift
        fi
    done
        
}
readonly -f arg_checker

print_info() {
    (
    printf 'File:; %s\n' "$1"
    printf "Count of lines:; $(wc -l < "$1")\n"
    awk '$1 == "ERROR"{counter++} END {printf "Errors:; %d\n", counter + 0}' "$1"
    printf "Top errors:\n"
     )|column -t -o "        " -s ";"
    
    (
    result=$(cat "$1" | grep -e "^ERROR" | sort |uniq -c | sed -E 's/^[[:space:]]+([0-9]+)/\1; /' | column -t -s ';'| sort -n -r | head -n 5)
    if [[ "$result" == "" ]];then
        printf "No errors\n\n"
    else
        printf "%s\n\n" "$result"
    fi
    )|column -t -s ";"
}
readonly -f print_info

main() {
    case "$1" in
        ""|help|-h|--help)
            print_help
            ;;
        info)
            shift
            arg_checker "$@"
            ;;
        *)
            print_error "Unknown command" "7"
            return 7
            ;;
        esac
}
readonly -f main
main "$@"
