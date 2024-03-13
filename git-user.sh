#!/bin/bash

# git-user: A tool to manage Git user and email information

CONFIG_FILE="$HOME/.git_user_profiles"

set_user_info() {
    local scope="local"
    if [[ "$1" == "--global" ]]; then
        scope="global"
        shift
    fi

    read -p "Enter user name: " name
    read -p "Enter email: " email
    read -p "Enter alias (default: $name): " alias
    alias=${alias:-$name}

    git config --$scope user.name "$name"
    git config --$scope user.email "$email"
    echo "User information set to Name: $name, Email: $email (Scope: $scope)"

    add_user_profile "$alias" "$name" "$email"
}

show_user_info() {
    name=$(git config user.name)
    email=$(git config user.email)
    echo "Current user information: Name: $name, Email: $email"
}

add_user_profile() {
    local alias="$1"
    local name="$2"
    local email="$3"

    if grep -q "^$alias " "$CONFIG_FILE"; then
        echo "Profile '$alias' already exists."
        return
    fi

    echo "$alias $name $email" >> "$CONFIG_FILE"
    echo "Added profile '$alias' with Name: $name, Email: $email"
}

delete_user_profile() {
    echo "Available profiles:"
    local i=1
    local choices=()
    while IFS=' ' read -r alias name email; do
        choices[i]="$alias $name $email"
        echo "$i) Alias: $alias, Name: $name, Email: $email"
        ((i++))
    done < "$CONFIG_FILE"

    read -p "Choose a profile to delete [1-${#choices[@]}]: " choice
    if ! [[ $choice =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#choices[@]}" ]; then
        echo "Invalid selection."
        return
    fi

    local toDelete="${choices[$choice]}"
    grep -v "^$toDelete" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "Deleted profile '${toDelete%% *}'."
}

switch_user_info() {
    local alias="$1"
    local profile
    profile=$(grep "^$alias " "$CONFIG_FILE")
    if [ -z "$profile" ]; then
        echo "Profile '$alias' not found."
        return
    fi

    IFS=' ' read -r alias name email <<< "$profile"
    echo "Switching to profile '$alias' with Name: $name, Email: $email."
    git config user.name "$name"
    git config user.email "$email"
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
        set_user_info "$2"
        ;;
    show)
        show_user_info
        ;;
    add)
        read -p "Enter user name: " name
        read -p "Enter email: " email
        read -p "Enter alias: " alias
        add_user_profile "$alias" "$name" "$email"
        ;;
    delete)
        delete_user_profile
        ;;
    switch)
        switch_user_info "$2"
        ;;
    list)
        list_profiles
        ;;
    *)
        echo "Usage: git-user [set [--global] | show | add | delete | switch <alias> | list]"
        exit 1
        ;;
esac

exit 0
