#!/bin/bash

# _wiki 폴더 경로
WIKI_DIR="_wiki"

# 모든 .md 파일을 찾고 반복
find "$WIKI_DIR" -type f -name "*.md" | while read -r file; do
    # 첫 줄 읽기
    first_line=$(head -n 1 "$file")
    
    # 파일에 layout: wiki 추가
    {
        echo "$first_line"  # 첫 줄 출력
        echo "layout: wiki"  # 추가할 텍스트 출력
        tail -n +2 "$file"   # 두 번째 줄부터 끝까지 출력
    } > temp_file && mv temp_file "$file"
done
