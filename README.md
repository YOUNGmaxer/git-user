# git-user

`git-user` is a command-line tool designed to manage multiple Git user profiles on a single machine. This tool makes it easy to switch between different user profiles for personal and work projects, helping maintain proper user information across different repositories.

## Features

- **Set User Information**: Quickly set Git username and email for the current directory or globally across all repositories.
- **Show Current User**: Display the current Git user name and email configuration.
- **Add User Profile**: Interactively add a new user profile with a unique alias, name, and email.
- **Delete User Profile**: Interactively delete an existing user profile.
- **Switch User Profile**: Interactively switch between different user profiles.
- **List User Profiles**: List all available user profiles, highlighting the currently active user.

## Installation

To install `git-user`, clone this repository and run the installation script:

```bash
git clone https://github.com/yourusername/git-user.git
cd git-user
./install.sh
```

This will install `git-user` to `/usr/local/bin`, making it accessible globally. Make sure you have the necessary permissions or you might need to run the script with `sudo`.

## Usage

Below are some common use cases for `git-user`:

### Set User Information

To set the Git user name and email for the current directory:

```bash
git-user set
```

To set the Git user name and email globally (for all repositories):

```bash
git-user set --global
```

### Show Current User

To display the current Git user name and email configuration:

```bash
git-user show
```

### Add a New User Profile

To add a new user profile with an alias:

```bash
git-user add
```

Follow the interactive prompts to enter the user name, email, and alias.

### Delete a User Profile

To delete an existing user profile:

```bash
git-user delete
```

Choose the profile to delete from the interactive list.

### Switch User Profile

To switch between user profiles:

```bash
git-user switch
```

Select the desired profile from the interactive list.

### List User Profiles

To list all configured user profiles:

```bash
git-user list
```

The current active profile will be highlighted.

## Contributing

Contributions are welcome! Please feel free to submit a pull request.
