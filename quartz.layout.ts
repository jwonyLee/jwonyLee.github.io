import { PageLayout, SharedLayout } from "./quartz/cfg"
import * as Component from "./quartz/components"

// components shared across all pages
export const sharedPageComponents: SharedLayout = {
  head: Component.Head(),
  header: [],
  footer: Component.Footer({
    links: {
      GitHub: "https://github.com/jwonylee",
    },
  }),
}

// components for pages that display a single page (e.g. a single note)
export const defaultContentPageLayout: PageLayout = {
  beforeBody: [
    Component.Breadcrumbs(),
    Component.ArticleTitle(),
    Component.ContentMeta(),
    Component.TagList(),
  ],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Search(),
    Component.DesktopOnly(Component.RecentNotes({ 
      title: "Recent",
      limit: 3,
      sort: (lhs, rhs) => {
        const getDateValue = (item) => {
          // frontmatter의 modified를 우선적으로 사용
          if (item.frontmatter?.dates.find(date => date["modified"])) {
            return item.frontmatter?.dates.find(date => date["modified"])["modified"]
          } else if (item.frontmatter?.dates.find(date => date["created"])) {
            return item.frontmatter?.dates.find(date => date["created"])["created"]
          } else if (item.dates.created) {
            return item.dates.created
          }
          return new Date().getTime();
        }

        const lhsDate = getDateValue(lhs)
        const rhsDate = getDateValue(rhs)

        return rhsDate - lhsDate
      },
    })),
    Component.DesktopOnly(Component.Explorer()),
  ],
  right: [
    Component.Darkmode(),
    Component.Graph(),
    Component.DesktopOnly(Component.TableOfContents()),
    Component.Backlinks(),
    Component.Comments()
  ],
}

// components for pages that display lists of pages  (e.g. tags or folders)
export const defaultListPageLayout: PageLayout = {
  beforeBody: [Component.Breadcrumbs(), Component.ArticleTitle(), Component.ContentMeta()],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Search(),
    Component.Darkmode(),
    Component.DesktopOnly(Component.Explorer()),
  ],
  right: [],
}
