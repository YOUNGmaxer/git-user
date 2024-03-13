# gu（git-user）

English | [中文](./README.zh-CN.md)

`gu` is a command-line tool for managing multiple Git user profiles on a single machine, facilitating the switching of user information between personal and work projects.

## Installation

Run the following commands to install `gu`:

```bash
git clone https://github.com/YOUNGmaxer/git-user.git
cd git-user
sh ./install.sh
```

## Usage

### Set User Information

- For the current directory: `gu set`
- Globally: `gu set --global`

### Show Current User

```bash
gu show
```

### Add/Delete User Profiles

- To add: `gu add` and follow the prompts.
- To delete: `gu delete` and select the profile to be deleted.

### Switch/List User Profiles

- To switch: `gu switch` and select a profile.
- To list: `gu list`