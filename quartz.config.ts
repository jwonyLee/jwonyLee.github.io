import { QuartzConfig } from "./quartz/cfg"
import * as Plugin from "./quartz/plugins"

/**
 * Quartz 4.0 Configuration
 *
 * See https://quartz.jzhao.xyz/configuration for more information.
 */
const config: QuartzConfig = {
  configuration: {
    pageTitle: "🌩️ 먹구름",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: "google",
      tagId: "G-Z4HL86NN7E"
    },
    locale: "ko-KR",
    baseUrl: "rieul.tech",
    ignorePatterns: ["private", "templates", ".obsidian"],
    defaultDateType: "modified",
    theme: {
      fontOrigin: "googleFonts",
      cdnCaching: true,
      typography: {
        header: "Noto Sans Korean",
        body: "Noto Sans Korean",
        code: "IBM Plex Mono",
      },
      colors: {
        lightMode: {
          light: "#FFFCF0", // ✅ 페이지 배경
          lightgray: "#F2F0E5", // 테두리
          gray: "#6F6E69", // ✅ 그래프 링크, 두꺼운 테두리
          darkgray: "#100F0F", // ✅ 본문 
          dark: "#100F0F", // ✅ 헤더 텍스트 및 아이콘
          secondary: "#4385BE", // ✅ 링크 색상, 현재 그래프 노드
          tertiary: "#4385BE", // ✅ 호버 색상, 방문 그래프 노드
          highlight: "#F2F0E5", // ✅ 내부 링크 배경, 강조 표시된 텍스트, 강조 표시된 코드 줄
        },
        darkMode: {
          light: "#100F0F", // ✅
          lightgray: "#1C1B1A", // ✅ 
          gray: "#878580", // ✅ 
          darkgray: "#CECDC3",
          dark: "#CECDC3",
          secondary: "#205EA6",
          tertiary: "#205EA6",
          highlight: "#1C1B1A", // ✅
        },
      },
    },
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate({
        priority: ["git", "frontmatter", "filesystem"],
      }),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
        keepBackground: false,
      }),
      Plugin.ObsidianFlavoredMarkdown({ enableInHtmlEmbed: false }),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({ markdownLinkResolution: "absolute" }),
      Plugin.Description(),
      Plugin.Latex({ renderEngine: "katex" }),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.NotFoundPage(),
    ],
  },
}

export default config
