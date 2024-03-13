#!/bin/bash

# git-user: A tool to manage Git user and email information

CONFIG_FILE="$HOME/.git_user_profiles"

highlight_text() {
    echo "$(tput setaf 2)$(tput bold)$1$(tput sgr0)"
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

# Function to list profiles and highlight the current user
list_profiles() {
    local current_name=$(git config user.name)
    local current_email=$(git config user.email)
    
    echo "Available profiles:"
    local i=1
    while IFS=' ' read -r alias name email; do
        local display_info="$i) Alias: $alias, Name: $name, Email: $email"
        if [[ "$name" == "$current_name" ]] && [[ "$email" == "$current_email" ]]; then
            display_info+=" (Current)"
            echo $(highlight_text "$display_info")
        else
            echo "$display_info"
        fi
        ((i++))
    done < "$CONFIG_FILE"
}

# Interactive function to delete a profile
delete_user_profile() {
    list_profiles
    local profiles=($(awk '{print $1}' "$CONFIG_FILE"))
    
    read -p "Enter the number of the profile to delete: " choice
    local valid_choice_regex='^[0-9]+$'
    if ! [[ $choice =~ $valid_choice_regex ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#profiles[@]}" ]; then
        echo "Invalid selection."
        return
    fi

    # Construct the pattern to avoid partial matches
    local profile_to_delete="${profiles[$choice-1]}"
    sed -i "/^$profile_to_delete /d" "$CONFIG_FILE"
    echo "Profile deleted."
}

# Interactive function to switch the current user profile
switch_user_info() {
    list_profiles
    local profiles=($(awk '{print $1}' "$CONFIG_FILE"))
    
    read -p "Enter the number of the profile to switch to: " choice
    local valid_choice_regex='^[0-9]+$'
    if ! [[ $choice =~ $valid_choice_regex ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#profiles[@]}" ]; then
        echo "Invalid selection."
        return
    fi

    local selected_alias="${profiles[$choice-1]}"
    local selected_profile=$(grep "^$selected_alias " "$CONFIG_FILE")
    IFS=' ' read -r alias name email <<< "$selected_profile"
    git config user.name "$name"
    git config user.email "$email"
    echo "Switched to profile: Alias: $alias, Name: $name, Email: $email."
}

show_help() {
    echo "Usage: git-user [COMMAND] [--global]"
    echo ""
    echo "A tool to manage Git user and email information."
    echo ""
    echo "Commands:"
    echo "  set [--global]              Set user info for the current directory or globally."
    echo "  show                        Show the current user info."
    echo "  add                         Interactively add a new user profile with a unique alias."
    echo "  delete                      Interactively delete an existing user profile."
    echo "  switch                      Interactively switch between user profiles."
    echo "  list                        List all available user profiles with the current one highlighted."
    echo "  --help                      Show this help message and exit."
    echo ""
    echo "Examples:"
    echo "  git-user set --global       Set global Git user name and email."
    echo "  git-user switch             Interactively switch to another Git user profile."
    echo "  git-user add                Add a new Git user profile."
    echo "  git-user list               List all Git user profiles."
}

# Main program
case "$1" in
    --help|-h)
        show_help
        ;;
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
        echo "Invalid command. Use --help or -h for usage information."
        exit 1
        ;;
esac

exit 0
