# Sparkle-Lite
[Sparkle-Lite](https://github.com/goddaneel/sparkle) 是去除特权功能的 [Sparkle](https://github.com/xishang0128/sparkle.git) 非官方分支，测试中，可能存在恶性 Bug，请勿使用。



## Sparkle-Lite 主仓库
此仓库为主仓库，包括如下内容：
- flatpak 打包工具及流程






## 介绍
### 修改内容
- 与上游项目版本号规则有差异，不能混装
- 无任何提权功能，无法使用 tun、内核更新等功能
- 修改了桌面图标及托盘图标



## 构筑
### 构筑环境
#### 系统环境
|系统|版本|
|-|-|
|Linux|>= 6.12.43|


#### 软件依赖
|包|命令|版本|
|-|-|-|
|`git`|git|>= 2.47.3|
|`bash`|bash|>= 5.2.37|
|`just`|just|>= 1.40.0|
|`mkdir`|mkdir|>= 9.7|
|`cp`|cp|>= 9.7|
|`shasum`|shasum|>= 6.04|


#### 命令执行
- `just clean-all`：清理至全新环境
- `just flatpak-work`：构筑 flatpak 软件包