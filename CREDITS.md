# 代码和协议来源

- 本项目软件按 GNU GPL v3 或后续版本发布。Electron 运行库和附带依赖保留各自的许可文件。
- 星璨岚 `1D6B:0113` 的 HID 设备识别、连接和控制流程参考 [LycoRepo/lcdmuse-driver-aigo](https://github.com/LycoRepo/lcdmuse-driver-aigo)。相关实现保留 GPL 许可和上游署名。
- 百一 HID 协议与参考实现来自 **FoxPodZ**（[foxpodz.de](https://foxpodz.de/)）的 [ryuo-iv-screen](https://github.com/FoxPodZ/ryuo-iv-screen)。保留上游的 [GPLv3 §7(b) 署名条件](https://github.com/FoxPodZ/ryuo-iv-screen/blob/main/LICENSE-ADDITIONAL-TERMS.md)。
- [Savathun/LanScreen](https://github.com/Savathun/LanScreen) 提供同系列屏幕的实时 JPEG 分包说明。 [croakfang/aigo-screen-reverse](https://github.com/croakfang/aigo-screen-reverse) 提供星璨辰的协议说明。
- 音乐模式参考 [Savathun/LanScreen 的小屏布局、Windows 媒体会话和本地 LRC 工作流](https://github.com/Savathun/LanScreen)。频谱助手移植了 LanScreen 的 `Audio.cs` 并使用 [NAudio](https://github.com/naudio/NAudio)。两项 MIT 许可随助手保存在 `runtime/spectrum`。仅播放器频谱参考 [Microsoft Application Loopback](https://learn.microsoft.com/en-us/samples/microsoft/windows-classic-samples/applicationloopbackaudio-sample/)。专注模式参考 [Pomatez](https://github.com/zidoro/pomatez) 的可调专注和休息时段。
- 新版横屏排版参考 [Savathun/LanScreen](https://github.com/Savathun/LanScreen) 的封面取色与频谱、[desk-beam](https://github.com/yunxiao11xie/desk-beam) 的副屏歌词和 [Turing Smart Screen](https://github.com/mathoudebine/turing-smart-screen-python/blob/main/res/themes/themes.md) 的小屏监控主题。
- 网易云音乐的同步歌词来自网易云 Web 接口。查询方式参考 [ivLyrics 的网易云歌词源](https://github.com/1-Dot/ivlyrics-netease-cloud-music) 和 [HyPlayer/NeteaseCloudMusicAPI](https://github.com/HyPlayer/NeteaseCloudMusicAPI)。本地播放列表的位置参考 [MyLyrics](https://github.com/ZiweiZhou99/MyLyrics)。其他媒体来源的在线歌词由 [LRCLIB](https://lrclib.net/) 提供。
- 网易云本地播放记录的解码和事件识别参考 [Coooookies/netease-cloudmusic-detector](https://github.com/Coooookies/netease-cloudmusic-detector)，随附 MIT 许可。
- 预设画面由本项目的 Canvas 渲染程序生成。
