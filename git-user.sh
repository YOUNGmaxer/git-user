#!/bin/bash

# git-user: A tool to manage Git user and email information

CONFIG_FILE="$HOME/.git_user_profiles"

highlight_text() {
    echo "\033[1;32m$1\033[0m" # Green color and bold
}

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

show_profiles_with_highlight() {
    local current_name=$(git config user.name)
    local current_email=$(git config user.email)
    local action="${1:-list}"  # 默认动作是list，可以通过参数指定其他动作

    echo "Available profiles:"
    local i=1
    local choices=()
    while IFS=' ' read -r alias name email; do
        local display_info="Alias: $alias, Name: $name, Email: $email"
        choices[i]="$alias $name $email"

        if [[ "$name" == "$current_name" ]] && [[ "$email" == "$current_email" ]]; then
            display_info=$(highlight_text "$display_info (Current)")
        fi

        echo "$i) $display_info"
        ((i++))
    done < "$CONFIG_FILE"

    if [[ "$action" == "delete" || "$action" == "switch" ]]; then
        read -p "Choose a profile to $action [1-${#choices[@]}]: " choice
        if ! [[ $choice =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#choices[@]}" ]; then
            echo "Invalid selection."
            return
        fi

        if [[ "$action" == "delete" ]]; then
            local toDelete="${choices[$choice]}"
            grep -v "^$toDelete" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
            echo "Deleted profile '${toDelete%% *}'."
        elif [[ "$action" == "switch" ]]; then
            local toSwitch="${choices[$choice]}"
            IFS=' ' read -r alias name email <<< "$toSwitch"
            git config user.name "$name"
            git config user.email "$email"
            echo "Switched to profile '$alias' with Name: $name, Email: $email."
        fi
    fi
}

delete_user_profile() {
    show_profiles_with_highlight "delete"
}

switch_user_info() {
    show_profiles_with_highlight "switch"
}

list_profiles() {
    show_profiles_with_highlight
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
