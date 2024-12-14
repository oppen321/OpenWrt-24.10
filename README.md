### 基于OpenWrt官方24.10分支源码编译的x86固件
# OpenWrt 固件自动编译项目

## 项目介绍

本项目使用 GitHub Actions 实现在线编译 OpenWrt 固件，主要针对 x86 平台，分支为 `24.10`，旨在提供高效、便捷的固件定制服务。

## 项目特点

- **在线编译**：无需本地搭建编译环境，依托 GitHub Actions 自动完成固件构建。
- **基于 OpenWrt 官方源码**：采用最新的 `24.10` 分支，确保稳定性和功能的前沿性。
- **高自由度定制**：支持添加自定义插件、调整内核参数等，满足不同用户需求。

## 使用说明

### 1. Fork 项目

点击右上角的 `Fork` 按钮，将本项目 Fork 到您的 GitHub 仓库，更换相关密钥。

### 2. 修改配置文件

根据需求编辑以下文件：

- **`.config` 文件**：用于指定固件的编译选项，您可以通过 [OpenWrt 官方配置工具](https://firmware-selector.openwrt.org/)生成适配的配置文件。
- **`feeds.conf.default` 文件**：添加您需要的第三方软件源。
- **`diy.sh` 文件**：用于添加自定义修改。

### 3. 启用 GitHub Actions

进入您 Fork 的仓库：

1. 点击 `Actions` 选项卡。
2. 启用工作流（点击 "I understand my workflows" 按钮）。

### 4. 开始编译

在 `Actions` 页面选择 `Build` 工作流，点击 `Run workflow` 按钮手动触发编译。

编译完成后，固件将在仓库的 `Releases` 页面中生成。

## 自定义功能

您可以通过修改以下文件实现个性化定制：

- **插件管理**：编辑 `feeds.conf.default`，添加或移除插件源。
- **网络配置**：在 `files/etc/config/network` 中预置网络配置文件。
- **WiFi 设置**：在 `files/etc/config/wireless` 文件中预设双频 WiFi 参数。

## 注意事项

1. 推荐使用 `Ubuntu` 系统以确保依赖安装顺利。
2. 分支为 `24.10`，请确保源码与配置文件匹配。
3. 若编译遇到问题，可以通过 Issue 提交反馈。

## 相关链接

- [OpenWrt 官方网站](https://openwrt.org/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [OpenWrt 配置工具](https://firmware-selector.openwrt.org/)

## 致谢

感谢 [OpenWrt](https://github.com/openwrt) 社区的支持，以及所有插件开发者的贡献。

---

**免责声明**

本项目仅用于个人学习与研究，不提供任何商业用途的支持。固件使用风险由用户自行承担。
