#!/usr/bin/env bash

NUM=1855714

CHANGE_LIST=$(git diff --exit-code --cached --name-only --diff-filter=ACM -- '*.md')

SUCCESS_COUNT=0
FAIL_COUNT=0
for CHANGED_FILE in $CHANGE_LIST; do
    echo "이미지경로를 교정할 문서 파일: [$CHANGED_FILE]"

    RESOURCE_DIR=$(head -n 1 "$CHANGED_FILE" | grep -E -o '[A-F0-9-]{2}/[A-F0-9-]{34}$' || echo "default")
    TARGET_PATH="./resource/$RESOURCE_DIR"

    echo "생성할 디렉토리 경로: [$TARGET_PATH]"
    mkdir -p "$TARGET_PATH"

    # GitHub user attachments와 기존 URL 패턴을 모두 포함
    URI_LIST=$(grep -E -o 'https://(((user-images\.githubuser.*?/'"$NUM"'/)|(pbs.twimg.com/media/)|(video.twimg.com/.+_video/)).*?(png|jpg|gif|mp4)|github.com/user-attachments/assets/[a-f0-9-]+)' "$CHANGED_FILE" || echo "")

    if [ -z "$URI_LIST" ]; then
        echo "처리할 URI가 없습니다."
        continue
    fi

    echo "$URI_LIST" | while read -r URI; do
        if [[ $URI == *"github.com/user-attachments/assets/"* ]]; then
            # GitHub user attachments 형식 처리
            FILE_NAME=$(echo "$URI" | awk -F/ '{print $NF}')
        else
            # 기존 방식으로 파일 이름 추출
            FILE_NAME=$(echo "$URI" | sed 's,^.*/,,')
        fi
        
        RESOLVE_FILE_PATH="$TARGET_PATH/$FILE_NAME"
        RESOLVE_URL=$(echo "$RESOLVE_FILE_PATH" | sed -E 's/^\.//')

        echo "작업 대상 URI: [$URI]"
        echo "작업 대상 파일 패스: [$RESOLVE_FILE_PATH]"
        
        if curl -L -o "$RESOLVE_FILE_PATH" "$URI" \
            -#  \
            --connect-timeout 30 \
            --max-time 300 \
            --retry 3 \
            --retry-delay 5 \
            --retry-max-time 60; then
            echo "DOWNLOAD SUCCESS: $FILE_NAME"
            sed -i.bak -E 's,'"$URI"','"$RESOLVE_URL"',g' "$CHANGED_FILE" && rm "$CHANGED_FILE.bak"

            git add "$RESOLVE_FILE_PATH"

            SUCCESS_COUNT=$((SUCCESS_COUNT+1))
        else
            echo "DOWNLOAD FAIL: $FILE_NAME"
            rm -f "$RESOLVE_FILE_PATH"
            FAIL_COUNT=$((FAIL_COUNT+1))
        fi
    done
    git add "$CHANGED_FILE"
done

printf "Success: %d, Fail: %d\n" $SUCCESS_COUNT $FAIL_COUNT