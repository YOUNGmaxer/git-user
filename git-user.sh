#!/bin/bash

# git-user: A tool to manage Git user and email information

CONFIG_FILE="$HOME/.git_user_profiles"

set_user_info() {
    local scope="local"
    if [[ "$1" == "--global" ]]; then
        scope="global"
        shift
    fi
    git config --$scope user.name "$1"
    git config --$scope user.email "$2"
    echo "User information set to Name: $1, Email: $2 (Scope: $scope)"
}

show_user_info() {
    name=$(git config user.name)
    email=$(git config user.email)
    echo "Current user information: Name: $name, Email: $email"
}

add_user_profile() {
    echo "$1 $2 $3" >> "$CONFIG_FILE"
    echo "Added profile '$1' with Name: $2, Email: $3"
}

switch_user_info() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "No user profiles found. Please add a profile using 'git-user add <alias> <name> <email>'."
        exit 1
    fi

    profile=$(grep "^$1 " "$CONFIG_FILE")
    if [ -z "$profile" ]; then
        echo "Profile '$1' not found in $CONFIG_FILE."
        exit 1
    fi

    IFS=' ' read -r alias name email <<< "$profile"
    set_user_info "$name" "$email"
}

list_profiles() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "No user profiles found."
        return
    fi

    echo "Available profiles:"
    while IFS=' ' read -r alias name email; do
        echo "  Alias: $alias, Name: $name, Email: $email"
    done < "$CONFIG_FILE"
}

# Main program
case "$1" in
    set)
        set_user_info "$2" "$3" "$4"
        ;;
    show)
        show_user_info
        ;;
    add)
        add_user_profile "$2" "$3" "$4"
        ;;
    switch)
        switch_user_info "$2"
        ;;
    list)
        list_profiles
        ;;
    *)
        echo "Usage: git-user [set [--global] <name> <email> | show | add <alias> <name> <email> | switch <alias> | list]"
        exit 1
        ;;
esac

exit 0
