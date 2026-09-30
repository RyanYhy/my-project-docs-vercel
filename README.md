# YHY Study Website

个人学习与项目文档站，基于 [Hugo Extended](https://gohugo.io/) 与 [Oink](https://oink.pgsty.com) 主题构建。

- **线上（Vercel）**：<https://ryan.0412.online/>
- **GitHub Pages（镜像）**：<https://ryanyhy.github.io/YHY-Website/>
- **本仓库**：[RyanYhy/my-project-docs-vercel](https://github.com/RyanYhy/my-project-docs-vercel)
- **Pages 源码**：[RyanYhy/YHY-Website](https://github.com/RyanYhy/YHY-Website)

## 内容栏目

| 栏目 | 说明 |
| ---- | ---- |
| [经历](content/experience/) | 项目与竞赛文档，含 [2026 RAICOM 智能侦察](content/experience/2026-raicom/) |
| [学习](content/learn/) | 学习笔记 |
| [博客](content/blog/) | 随笔与更新 |
| [友链](content/links.md) | 推荐站点 |

## 本地预览

需要 [Hugo Extended](https://gohugo.io/installation/)（版本见 `go.mod` / CI 配置）。

```powershell
cd my-project-docs-vercel
hugo server
```

浏览器打开 <http://localhost:1313/>。

生产构建：

```powershell
hugo --gc --minify
```

## 双语与评论

中文是默认语言，英文入口为 `/en/`。英文内容使用同目录的 `.en.md` 文件，
翻译约定见 [TRANSLATION.md](TRANSLATION.md)。

博客文章通过 Oink 内置的 Giscus 接入评论，评论保存在
`RyanYhy/my-project-docs-vercel` 的 `Announcements` Discussions 分类。
首页、栏目列表、学习和经历文档不显示评论。评论界面随页面语言切换，颜色随
站点深浅色设置切换。读者使用 GitHub 登录后发表评论。

中英文页面与 GitHub Pages 镜像共用同一条讨论：`mapping: specific`，
`data-term` 为不带语言和站点前缀的 `/blog/<slug>/`。两个项目都启用博客文章
评论；博客列表页通过 `comments: false` 单独关闭。

本地运行 `hugo server --disableFastRender`，打开任意博客文章并滚动到底部查看
评论区。首次发言或回应前尚未创建 Discussion 属于正常情况。配置中的仓库 ID
和分类 ID 是公开标识；不要填写 GitHub token。

## 部署

本仓库走 **Vercel**，不发布 GitHub Pages（Pages 仍由 [YHY-Website](https://github.com/RyanYhy/YHY-Website) 负责）。

1. 打开 [vercel.com](https://vercel.com)，用 GitHub 登录。
2. **Add New → Project**，Import `RyanYhy/my-project-docs-vercel`。
3. 构建设置留空即可：`vercel.json` 已指定构建命令与输出目录 `public`。
4. 点 **Deploy**。生产域名是 <https://ryan.0412.online/>（Vercel 项目里绑定的自定义域名）。

之后每次 push `main`，Vercel 会按 [`build.sh`](build.sh) 安装 Hugo Extended **0.164.0** 并重新发布。

## 技术栈

- **静态站点**：Hugo Extended
- **主题**：[Oink](https://github.com/pgsty/oink)（Hugo Module，`go.mod` 中 `require github.com/pgsty/oink`）
- **托管**：Vercel（本仓库）；GitHub Pages 仍托管原仓库

## 许可与署名

| 部分 | 许可 |
| ---- | ---- |
| 站点脚手架与构建工具（衍生自 [oink.pgsty.com](https://github.com/pgsty/oink.pgsty.com)） | [Apache License 2.0](LICENSE) |
| 本站原创文档内容 | [CC BY 4.0](LICENSE-CC-BY-4.0) |

主题由 [Oink](https://oink.pgsty.com) 提供；本站文字与项目文档版权归 [Ryan Yhy](https://github.com/RyanYhy)。
