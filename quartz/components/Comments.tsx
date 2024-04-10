// import commentsScript from "./scripts/comments.inline"
import commentsScript from "./scripts/comments.inline"
import { QuartzComponentConstructor, QuartzComponentProps } from "./types"

function Footer(props: QuartzComponentProps) {
    return (
        <script src="https://giscus.app/client.js"
        data-repo="jwonylee/jwonyLee.github.io"
        data-repo-id="MDEwOlJlcG9zaXRvcnkzNzEwNDM4NjY="
        data-category="Comments"
        data-category-id="DIC_kwDOFh2uGs4Cel1y"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="top"
        data-theme="dark_tritanopia"
        data-lang="ko"
        crossorigin="anonymous"
        async>
        </script>
    )
  }
  
  Footer.beforeDOMLoaded = commentsScript
  
  export default (() => Footer) satisfies QuartzComponentConstructor