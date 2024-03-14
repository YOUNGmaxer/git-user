# gu（git-user）

中文 | [English](./README.md)

`gu` 是一个命令行工具，用于在单个机器上管理多个 Git 用户配置文件，便于在个人和工作项目之间切换用户信息。

## 安装

运行以下命令安装 `gu`：

```bash
curl -sSL https://raw.githubusercontent.com/YOUNGmaxer/git-user/main/install.sh | bash
```

## 使用

### 设置用户信息

- 当前目录：`gu set`
- 全局：`gu set --global`

### 显示当前用户

```bash
gu show
```

### 添加/删除用户配置文件

- 添加：`gu add` 并按提示操作。
- 删除：`gu delete` 并选择要删除的配置文件。

### 切换/列出用户配置文件

- 切换：`gu switch` 并选择配置文件。
- 列出：`gu list`
