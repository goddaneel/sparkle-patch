# Sparkle Patch
[Sparkle-Lite](https://github.com/goddaneel/sparkle) 的附属仓库，包括如下内容：
- 基于 Bubblewrap 工具的测试构建沙盒




## 构筑环境
### 系统环境
- Linux (>= 6.12.43)
- Debian (>= 13/trixie)



### 软件依赖
- `git`     git (>= 2.47.3)
- `make`    make (>= 4.4.1)
- `bash`    bash (>= 5.2.37)
- `jq`      jq (>= 1.7)
- `mkdir`   mkdir (>= 9.7)
- `cp`      cp (>= 9.7)
- `bwrap`   bubblewrap (>= 0.11.0)
- `npm`     npm (>= 9.2.0)
- `node`    node (>= 20.19.2)
- `shasum`  shasum (>= 6.04)



### 资源依赖
- `_gs_path_origin` 变量  
    sparkle 项目仓库地址，可手动配置。默认为 `./sparkle`，可直接 clone 于此，也可以链接于此。



### 命令执行
#### clean
- `make clean-gitnew`  
    使用 `git clean -fxd` 清理环境，但排除 `./sparkle`。

- `make clean-gitnew`  
    使用 `git clean -fxd` 清理环境，但排除 `./sparkle` 和 `./temp` 下的预设文件夹。


#### patch
- `make patch-diff`
    对比 patch 文件夹与项目文件夹中对应文件的差异。


#### init
- `make init-pnpm`  
    在沙盒环境内安装 pnpm。

- `make init-env`  
    在沙盒环境内 sparkle 项目下执行 `pnpm install`。

- `make init-envfix`  
    在沙盒环境内 sparkle 项目下修复 electron 依赖。


#### build
- `make build-deb`  
    在沙盒环境内构筑 x64 架构的 deb 包。


#### work
- `make work-init`
    执行环境初始化流程，包括 clean-gitenv、init-pnpm、init-env、init-envfix。

- `make work-build`
    执行构建流程，包括 clean-gitenv、init-pnpm、init-env、init-envfix、build-deb。


#### debug
- `make debug-cr`  
    进入沙盒环境内部，通过 bash 进行交互。但对 sparkle 项目仓库文件夹只读。

- `make debug-cv`  
    进入沙盒环境内部，通过 bash 进行交互。可对 sparkle 项目仓库文件夹进行读写，但读写结果为临时，不会影响主机文件。


#### test
- `make test-cr`  
    进入沙盒环境内部，通过 bash 进行交互，不载入 `./temp` 中文件夹。但对 sparkle 项目仓库文件夹只读。

- `make test-cv`  
    进入沙盒环境内部，通过 bash 进行交互,不载入 `./temp` 中文件夹。可对 sparkle 项目仓库文件夹进行读写，但读写结果为临时，不会影响主机文件。
