# OpenWrt Cloud Build — Qualcomm IPQ60XX

基于 GitHub Actions 的 OpenWrt 固件自动构建，面向 **Qualcomm IPQ60XX** 设备（ zn_m2 ）。

## 固件

- **ImmortalWrt**（[VIKINGYFY fork](https://github.com/VIKINGYFY/immortalwrt)，main 分支）· 6.x 内核 · NSS 硬件加速
- 无 WiFi 版本：ath11k / wpad / hostapd 全部排除，纯有线场景
- 默认 LAN：192.168.50.1

## Release 内容

每次成功构建发布 GitHub Release（保留最近 **3** 个）：

- `*.bin` — sysupgrade / factory 固件镜像
- `sha256sums` — 扁平路径校验和，`sha256sum -c` 直接可用
- `*.buildinfo` — 构建信息
- `<tag>.config` — 完整 .config（构建配置存档）

每个 Release 的 body 记录：内核版本、上游精确 commit 与日期。

## 构建调度

- **每周六 08:00（UTC+8）** 定时构建
- 手动触发：Actions → OpenWrt Build → Run workflow（可选 SSH 调试模式）
- 构建失败时 Telegram 通知

## 仓库结构

- `.github/workflows/ipq60xx_nowifi.yml` — 构建工作流
- `.github/workflows/clean_up.yml` — 每周清理（runs / releases）
- `configs/ipq60xx_nowifi_6.x.config` — 构建配置
- `scripts/settings.sh` — 构建前定制（品牌 / 网络 / DTS）
- `scripts/packages.sh` — 自定义 feed 预留
