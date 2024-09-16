(function() {
    function getTarget() {
        var thisName = document.getElementById('thisName').value;
        return encodeURI(thisName);
    }

    const recursiveLimit = 30;
    const target = getTarget();
    insertParent(target, 0, [])

    /**
     * 부모 문서 목록을 받아, 부모 문서들의 링크를 만들어준다.
     */
    function makeHTML(plist) {
        if (plist == null || plist.length < 1) {
            return "";
        }
        var pr = "상위 문서: "
        for (var i = 0; i < plist.length; i++) {
            const absoluteUrl = new URL(plist[i].url, window.location.origin).href;
            pr += `<a href="${absoluteUrl}">${plist[i].title}</a>`;
            if (i < plist.length - 1) {
                pr += `<span> / </span>`;
            }
        }
        return pr;
    }

    function fetchMetadata(target, recursiveCount, parentList) {
        fetch(`/data/metadata/${target}.json`)
            .then(response => response.json())
            .then(function(data) {
                if (data == null) {
                    return;
                }
                parentList.unshift(data);
    
                if (data.parent == null) {
                    parentList.pop();   // this 문서가 부모 문서 목록에 나오지 않도록 제거해준다.
                    document.getElementById('parent-list').innerHTML = makeHTML(parentList);
                    return;
                }
    
                setTimeout(() => insertParent(data.parent, recursiveCount + 1, parentList), 0);
                return;
            })
            .catch(function(error) {
                console.error(`Failed to fetch metadata for ${target}:`, error);
                fetchMatchedPermalink(target, recursiveCount, parentList);
            });
    }
    
    function fetchMatchedPermalink(target, recursiveCount, parentList) {
        fetch('/data/total-matched-permalink.json')
            .then(response => response.json())
            .then(function(matchedData) {
                const matchedPermalink = matchedData[target];
    
                if (matchedPermalink) {
                    fetchMetadata(matchedPermalink, recursiveCount, parentList);
                } else {
                    console.error(`No matched permalink found for ${target}`);
                }
            })
            .catch(function(error) {
                console.error('Failed to fetch total-matched-permalink.json:', error);
            });
    }
    
    /**
     * 재귀하며 부모 문서 정보를 가져온다.
     * 모든 부모 문서를 가져오면 화면에 부모 문서 링크를 만들어 준다.
     */
    function insertParent(target, recursiveCount, parentList) {
        if (recursiveCount > recursiveLimit) {
            return;
        }
    
        fetchMetadata(target, recursiveCount, parentList);
    }
})();