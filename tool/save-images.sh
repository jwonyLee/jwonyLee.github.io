#!/usr/bin/env bash

# github에 올린 user-images를 자동으로 다운로드합니다.

NUM=1855714

CHANGE_LIST=`git diff --exit-code --cached --name-only --diff-filter=ACM -- '*.md'`

SUCCESS_COUNT=0
FAIL_COUNT=0
for CHANGED_FILE in $CHANGE_LIST; do
    echo "이미지경로를 교정할 문서 파일: [$CHANGED_FILE]"

    RESOURCE_DIR=`head $CHANGED_FILE | egrep -o '[A-F0-9-]{2}/[A-F0-9-]{34}$'`
    TARGET_PATH="./resource/$RESOURCE_DIR"

    echo "생성할 디렉토리 경로: [$TARGET_PATH]"
    mkdir -p $TARGET_PATH

    # GitHub user attachments와 기존 URL 패턴을 모두 포함
    URI_LIST=`ag "https://(((user-images\.githubuser.*?\/$NUM\/)|(pbs.twimg.com/media/)|(video.twimg.com/.+_video/)).*?(png|jpg|gif|mp4)|github.com/user-attachments/assets/[a-f0-9-]+)" -o $CHANGED_FILE`

    for URI in $URI_LIST; do
        if [[ $URI == *"github.com/user-attachments/assets/"* ]]; then
            # GitHub user attachments 형식 처리
            FILE_NAME=$(echo $URI | awk -F/ '{print $NF}')
        else
            # 기존 방식으로 파일 이름 추출
            FILE_NAME=`echo $URI | sed 's,^.*/,,'`
        fi
        
        RESOLVE_FILE_PATH="$TARGET_PATH/$FILE_NAME"
        RESOLVE_URL=`echo "$RESOLVE_FILE_PATH" | sed -E 's/^\.//'`

        echo "작업 대상 URI: [$URI]"
        echo "작업 대상 파일 패스: [$RESOLVE_FILE_PATH]"
        curl -s -L $URI > $RESOLVE_FILE_PATH

        if [ "$?" == "0" ]; then
            echo "DOWNLOAD SUCCESS: $FILE_NAME"
            sed -i '' -E 's, *'"$URI"' *, '$RESOLVE_URL' ,g' $CHANGED_FILE

            git add $RESOLVE_FILE_PATH

            SUCCESS_COUNT=$((SUCCESS_COUNT+1))
        else
            echo "DOWNLOAD FAIL: $FILE_NAME"
            rm -f $RESOLVE_FILE_PATH
            FAIL_COUNT=$((FAIL_COUNT+1))
        fi
    done
    git add $CHANGED_FILE
done

printf "Success: %d, Fail: %d\n" $SUCCESS_COUNT $FAIL_COUNT