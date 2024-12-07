#!/bin/bash

# 创建文件夹结构
mkdir -p files/bin

# 创建脚本文件
cat << 'EOF' > files/bin/ZeroWrt
#!/usr/bin/zsh

# 彩色输出函数
color_output() {
    echo -e "$1"
}

# 打印脚本头部，增加美观
print_header() {
    clear
    color_output "\e[35m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"
    color_output "\e[35m\     _____           __        __    _      / \e[0m"
    color_output "\e[35m\    |__  /___ _ __ __\ \      / / __| |_    / \e[0m"
    color_output "\e[35m\      / // _ \ '__/ _ \ \ /\ / / '__| __|   / \e[0m"
    color_output "\e[35m\     / /|  __/ | | (_) \ V  V /| |  | |_    / \e[0m"
    color_output "\e[35m\    /____\___|_|  \___/ \_/\_/ |_|   \__|   / \e[0m"
    color_output "\e[35m\          Z e r o W r t   By   Z e r o      / \e[0m"
    color_output "\e[31m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[0m"
    color_output "==============================================="
    color_output "                               版本: 1.0.0 "
    color_output "                               作者: Zero  "
    color_output "                               日期: $(date +'%Y-%m-%d') "
    color_output "==============================================="
    color_output "  本脚本帮助您设置 ZeroWrt。                "
    color_output "  博客地址: https://www.kejizero.online      "
    color_output "==============================================="
}

# 显示菜单
show_menu() {
    echo "=============================="
    echo "          ZeroWrt 菜单         "
    echo "=============================="
    echo "1. 更改 LAN 口 IP 地址"
    echo "2. 更改管理员密码"
    echo "3. 切换默认主题"
    echo "4. 恢复出厂设置"
    echo "0. 退出"
    echo "=============================="
    printf "请输入您的选择 [0-4]: "
    read choice
    case "$choice" in
        1) change_ip ;;
        2) change_password ;;
        3) change_theme ;;
        4) reset_config ;;
        0) exit 0 ;;
        *) echo "无效选项，请重新输入"; show_menu ;;
    esac
}

# 1. 更换 LAN 口 IP 地址
change_ip() {
    printf "请输入新的 LAN 口 IP 地址（如 192.168.1.2）："
    read new_ip
    if [[ -n "$new_ip" ]]; then
        uci set network.lan.ipaddr="$new_ip"
        uci commit network
        /etc/init.d/network restart
        echo "LAN 口 IP 已成功更改为 $new_ip"
    else
        echo "无效的 IP 地址，操作取消。"
    fi
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 2. 更改管理员密码
change_password() {
    printf "请输入新的管理员密码："
    read new_password
    if [[ -n "$new_password" ]]; then
        # 使用 OpenWrt 的 `passwd` 工具更新密码
        echo -e "$new_password\n$new_password" | passwd root
        echo "管理员密码已成功更改。"
    else
        echo "无效的密码，操作取消。"
    fi
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 3. 切换默认主题
change_theme() {
    # 使用 UCI 修改 luci 配置
    uci set luci.main.mediaurlbase='/luci-static/bootstrap'
    uci commit luci
    echo "主题已成功切换为设计主题。"
    printf "按 Enter 键返回菜单..."
    read
    show_menu
}

# 4. 一键重置配置
reset_config() {
    echo "恢复出厂设置中..."
    firstboot -y
    echo "设备将在 5 秒钟后重启..."
    sleep 5
    reboot
}

# 启动菜单
print_header
show_menu
EOF

# 设置脚本权限
chmod +x files/bin/ZeroWrt
