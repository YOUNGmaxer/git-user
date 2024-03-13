# git-user

English | [中文](./README.zh-CN.md)

`git-user` is a command-line tool for managing multiple Git user profiles on a single machine, facilitating the switching of user information between personal and work projects.

## Installation

Run the following commands to install `git-user`:

```bash
git clone https://github.com/YOUNGmaxer/git-user.git
cd git-user
sh ./install.sh
```

## Usage

### Set User Information

- For the current directory: `git-user set`
- Globally: `git-user set --global`

### Show Current User

```bash
git-user show
```

### Add/Delete User Profiles

- To add: `git-user add` and follow the prompts.
- To delete: `git-user delete` and select the profile to be deleted.

### Switch/List User Profiles

- To switch: `git-user switch` and select a profile.
- To list: `git-user list`