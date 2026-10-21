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

print_log_errors()
{   local counter=0
    awk -v counter="$counter" '$1 == "ERROR"{counter++}' $1
    return counter
}
readonly -f print_log_errors

print_error() {
    printf 'Error - %s. Exit code %s\n' "$1" "$2" | tee -a $ERROR_LOG >&2
    printf 'Use "help" if you have questions\n' >&2
}
readonly -f print_error

arg_checker() {
    if [[ $# -ne 1 ]];then
        print_error "Utilit can get only one argument" "3"
        return 3
    elif [[ ! -e $1 ]];then 
        print_error "File not found" "4"
        return 4
    elif [[ ! -f $1 ]];then
        print_error "It is not file" "5"
        return 5
    elif [[ ! -r $1 ]];then
        print_error "Cant read this file" "6"
        return 6
    else
        print_info "$1"
    fi
        
}
readonly -f arg_checker

print_info() {
    printf 'File: %s\n' "$1"
    printf "Count of lines: $(wc -l < "$1")\n"
    awk '$1 == "ERROR"{counter++} END {printf "Errors: %d\n", counter + 0}' $1

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
