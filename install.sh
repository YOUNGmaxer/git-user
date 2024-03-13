#!/bin/bash

# 安装脚本的名称
SCRIPT_NAME="git-user.sh"

# 目标目录
TARGET_DIR="/usr/local/bin"

# 目标命令的名称
TARGET_CMD="git-user"

# 检查 git-user.sh 脚本是否存在于当前目录中
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "错误：$SCRIPT_NAME 不存在于当前目录中。"
    exit 1
fi

# 给予脚本执行权限
chmod +x "$SCRIPT_NAME"

# 将脚本移动到 /usr/local/bin
if [ -w "$TARGET_DIR" ] || [ -w "$TARGET_DIR/$TARGET_CMD" ]; then
    # 直接移动并重命名脚本
    mv "$SCRIPT_NAME" "$TARGET_DIR/$TARGET_CMD"
    echo "$TARGET_CMD 已成功安装到 $TARGET_DIR。"
else
    # 如果目标目录不可写，尝试使用 sudo
    echo "尝试使用 sudo 权限安装到 $TARGET_DIR..."
    sudo mv "$SCRIPT_NAME" "$TARGET_DIR/$TARGET_CMD" && echo "$TARGET_CMD 已成功安装到 $TARGET_DIR。"
fi

# 检查是否成功安装
if [ -f "$TARGET_DIR/$TARGET_CMD" ]; then
    echo "安装成功。你现在可以在任何地方通过命令 '$TARGET_CMD' 来使用 git-user 了。"
else
    echo "安装失败。"
fi
