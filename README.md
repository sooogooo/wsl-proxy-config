# WSL 代理配置文档

## 概览

在 WSL2 (Ubuntu) 中配置透明代理，访问 GFW 屏蔽内容时走宿主机代理，
本地、私有网段、国内主流站点全部直连。

- **代理地址**：`http://127.0.0.1:10808`（宿主机 Windows 侧代理工具监听端口）
- **生效范围**：bash、zsh（oh-my-zsh）、git
- **路由策略**：env var `no_proxy` 白名单直连 + 代理工具自身规则双重保障

---

## 文件清单

| 文件 | 说明 |
|------|------|
| `~/.proxy.sh` | 代理核心配置，定义变量与 `proxy_on/off/status` 函数 |
| `~/.bashrc` | bash 启动时 source `~/.proxy.sh` |
| `~/.zshrc` | zsh 启动时 source `~/.proxy.sh` |
| `~/.gitconfig` | git 全局 HTTP/HTTPS 代理 + gitee.com 直连例外 |

---

## 工作原理

```
新建终端（bash 或 zsh）
  └─ 加载 .bashrc / .zshrc
       └─ source ~/.proxy.sh
            ├─ 设置 http_proxy / https_proxy = http://127.0.0.1:10808
            └─ 设置 no_proxy = <本地+私网+国内域名白名单>

curl / wget / pip / npm 等工具读取上述 env var：
  ├─ 目标域名在 no_proxy 中 → 直连
  └─ 其余 → 通过 127.0.0.1:10808 转发至代理工具
```

git 额外从 `~/.gitconfig` 读取 `http.proxy`，与 env var 保持一致。

---

## 常用命令

```bash
proxy_on      # 开启代理（新 shell 默认已开启）
proxy_off     # 关闭代理（临时直连所有流量）
proxy_status  # 查看当前状态
```

---

## 修改代理端口

编辑 `~/.proxy.sh` 第 5 行：

```bash
_PROXY_URL="http://127.0.0.1:<新端口>"
```

若代理类型为 SOCKS5，将 `http://` 改为 `socks5://`，同步修改 git 配置：

```bash
git config --global http.proxy  "socks5://127.0.0.1:<端口>"
git config --global https.proxy "socks5://127.0.0.1:<端口>"
```

---

## 添加直连域名

编辑 `~/.proxy.sh` 中的 `_NO_PROXY` 变量，在末尾追加（注意行尾反斜杠）：

```bash
_NO_PROXY="...\
.example.com,.example2.cn"
```

---

## 恢复备份

```bash
cp ~/.proxy_backup/proxy.sh ~/.proxy.sh
```

若 `.bashrc` / `.zshrc` 中的 source 行丢失：

```bash
echo '[ -f ~/.proxy.sh ] && source ~/.proxy.sh' >> ~/.bashrc
echo '[ -f ~/.proxy.sh ] && source ~/.proxy.sh' >> ~/.zshrc
```

若 git 代理丢失：

```bash
git config --global http.proxy  "http://127.0.0.1:10808"
git config --global https.proxy "http://127.0.0.1:10808"
git config --global "http.https://gitee.com.proxy" ""
```

---

## no_proxy 覆盖范围

- 本地回环：`localhost`, `127.0.0.0/8`, `::1`
- 私有网段：`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`
- 国内域名：百度、腾讯、阿里、京东、微博、知乎、B站、抖音、快手、爱奇艺、优酷、
  搜狐、美团、小米、华为、新华网、CSDN、Gitee、豆瓣、拼多多 等主流平台及 CDN 域名
- 顶级域名：`.cn`, `.com.cn`, `.gov.cn`, `.edu.cn`

---

备份生成时间：2026-07-12
