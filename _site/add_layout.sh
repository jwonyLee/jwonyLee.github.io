#!/bin/bash

# _wiki 폴더로 이동
cd _wiki || exit

# 날짜 형식 변경 함수
convert_date_format() {
    date_string="$1"
    if [[ $date_string =~ ([0-9]{4}-[0-9]{2}-[0-9]{2})T([0-9]{2}:[0-9]{2}:[0-9]{2})\+([0-9]{2}:[0-9]{2}) ]]; then
        echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]} +${BASH_REMATCH[3]}"
    else
        echo "$date_string"
    fi
}

# 태그 처리 함수
process_tag() {
    local tag="$1"
    tag="${tag//_/-}"
    echo "$tag"
}

# 제목에서 카테고리 추출 및 쌍따옴표 제거 함수
process_title() {
    local title="$1"
    local category=""
    
    # 쌍따옴표 제거
    title="${title#\"}"
    title="${title%\"}"
    
    # 대괄호 안의 카테고리 추출
    if [[ $title =~ ^\[([^\]]+)\](.*) ]]; then
        category="${BASH_REMATCH[1]}"
        title="${BASH_REMATCH[2]}"
    fi
    
    # 앞뒤 공백 제거
    title=$(echo "$title" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    
    echo "$title|$category"
}

# 모든 .md 파일을 처리
for file in *.md; do
    temp_file=$(mktemp)
    frontmatter_start=false
    frontmatter_end=false
    title=""
    summary=""
    permalink=""
    date=""
    updated=""
    tags=""
    public="true"
    parent=""
    latex="true"
    comment="true"
    category=""

    # 파일명에서 날짜 추출
    filename_date=$(echo "$file" | sed -n 's/^\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\).*/\1/p')

    while IFS= read -r line; do
        if [[ $line == "---" && $frontmatter_start == false ]]; then
            frontmatter_start=true
            echo "---" >> "$temp_file"
        elif [[ $line == "---" && $frontmatter_start == true && $frontmatter_end == false ]]; then
            frontmatter_end=true
            # date가 비어있으면 파일명에서 추출한 날짜 사용
            if [[ -z "$date" && -n "$filename_date" ]]; then
                date="$filename_date"
            fi
            # updated가 비어있으면 date 값 사용
            if [[ -z "$updated" ]]; then
                updated="$date"
            fi
            # 제목 처리
            IFS='|' read -r processed_title extracted_category <<< "$(process_title "$title")"
            # 수집된 정보를 새 형식으로 작성
            echo "layout: wiki" >> "$temp_file"  # layout: wiki 추가
            echo "title: $processed_title" >> "$temp_file"
            echo "summary: $summary" >> "$temp_file"
            echo "permalink: $permalink" >> "$temp_file"
            echo "date: $date" >> "$temp_file"
            echo "updated: $(convert_date_format "$updated")" >> "$temp_file"
            if [[ -n "$extracted_category" ]]; then
                tags="$(process_tag "$extracted_category") $tags"
            fi
            echo "tag: $tags" >> "$temp_file"
            echo "public: $public" >> "$temp_file"
            echo "parent: $parent" >> "$temp_file"
            [[ -n "$category" ]] && echo "category: $category" >> "$temp_file"
            echo "latex: $latex" >> "$temp_file"
            echo "comment: $comment" >> "$temp_file"
            echo "---" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "* TOC" >> "$temp_file"
            echo "{:toc}" >> "$temp_file"
        elif $frontmatter_start && ! $frontmatter_end; then
            if [[ $line =~ ^title:\ *(.*) ]]; then
                title="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^summary:\ *(.*) ]]; then
                summary="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^permalink:\ *(.*) ]]; then
                permalink="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^date:\ *(.*) ]]; then
                date="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^updated:\ *(.*) ]]; then
                updated="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^tags:\ *$ ]] || [[ $line =~ ^tag:\ *$ ]]; then
                :
            elif [[ $line =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
                tag="${BASH_REMATCH[1]}"
                processed_tag=$(process_tag "$tag")
                tags+="$processed_tag "
            elif [[ $line =~ ^public:\ *(.*) ]]; then
                public="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^parent:\ *(.*) ]]; then
                parent="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^latex:\ *(.*) ]]; then
                latex="${BASH_REMATCH[1]}"
            elif [[ $line =~ ^comment:\ *(.*) ]]; then
                comment="${BASH_REMATCH[1]}"
            fi
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$file"

    mv "$temp_file" "$file"
done

echo "모든 파일의 프론트매터가 업데이트되었습니다."