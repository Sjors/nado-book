#!/bin/bash
if sed --version >/dev/null 2>&1; then
    SED_BIN=sed
elif command -v gsed >/dev/null 2>&1 && gsed --version >/dev/null 2>&1; then
    SED_BIN=gsed
else
    echo "GNU sed is required. Use a GNU 'sed' or make it available as 'gsed' in PATH."
    exit 1
fi

SED_INPLACE=(-i)

PAPERBACK="0"
EBOOK="0"
EPUB="0"
PDF_KINDLE="0"
PDF_BIG="0"
CHAPTERS="0"
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -b|--paperback) PAPERBACK="1" EXTRA_OPTIONS="-o nado-paperback.pdf --metadata-file meta-paperback.yaml --include-before-body copyright_paperback.tex --template=templates/pandoc.tex --toc-depth=1"; HEADER_INCLUDES="--include-in-header templates/header-includes.tex --include-in-header templates/header-includes-paperback.tex" ;;
        -e|--epub) EBOOK="1" EPUB="1" EXTRA_OPTIONS="-o nado-kindle.epub -t epub3 --css epub.css -V ebook -V epub --metadata-file meta-epub.yaml --toc-depth=2 --top-level-division=part --epub-cover-image=docs/front.jpg --webtex=https://latex.codecogs.com/svg.latex?";;
        -p|--pdfkindle) EBOOK="1" PDF_KINDLE="1" EXTRA_OPTIONS="-o nado-kindle.pdf -V ebook -M fontsize=12pt --metadata-file meta-ebook.yaml --include-before-body copyright_ebook.tex --template=templates/pandoc.tex --toc-depth=1"; HEADER_INCLUDES="--include-in-header templates/header-includes.tex --include-in-header templates/header-includes-pdf-kindle.tex" ;;
        -b|--pdfbig) EBOOK="1" PDF_BIG="1" EXTRA_OPTIONS="-o nado-kindle.pdf -V ebook -M papersize=a4 -M fontsize=14pt --metadata-file meta-ebook.yaml --include-before-body copyright_ebook.tex --template=templates/pandoc.tex --toc-depth=1"; HEADER_INCLUDES="--include-in-header templates/header-includes.tex --include-in-header templates/header-includes-pdf-big.tex" ;;
        -c|--chapters) CHAPTERS="1"; shift ;;
        -v|--verbose) EXTRA_OPTIONS="$EXTRA_OPTIONS --verbose"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

sedi() {
    "$SED_BIN" "${SED_INPLACE[@]}" "$@"
}

check_pdf_page_size() {
    local pdf="$1"
    local expected_width_mm="$2"
    local expected_height_mm="$3"
    local actual_width_pts actual_height_pts

    if ! command -v pdfinfo >/dev/null 2>&1; then
        echo "pdfinfo is required to verify PDF dimensions. Install it with: brew install poppler" >&2
        exit 1
    fi

    read -r actual_width_pts actual_height_pts < <(pdfinfo "$pdf" | awk '/Page size:/ {print $3, $5}')

    if [ -z "$actual_width_pts" ] || [ -z "$actual_height_pts" ]; then
        echo "Unable to read page size from $pdf" >&2
        exit 1
    fi

    if ! awk \
        -v actual_width_pts="$actual_width_pts" \
        -v actual_height_pts="$actual_height_pts" \
        -v expected_width_mm="$expected_width_mm" \
        -v expected_height_mm="$expected_height_mm" \
        'BEGIN {
            expected_width_pts = expected_width_mm * 72 / 25.4
            expected_height_pts = expected_height_mm * 72 / 25.4
            tolerance_pts = 0.2
            width_diff = actual_width_pts - expected_width_pts
            height_diff = actual_height_pts - expected_height_pts
            if (width_diff < 0) width_diff = -width_diff
            if (height_diff < 0) height_diff = -height_diff
            exit !((width_diff <= tolerance_pts) && (height_diff <= tolerance_pts))
        }'
    then
        echo "Unexpected page size for $pdf: got ${actual_width_pts} x ${actual_height_pts} pt, expected ${expected_width_mm} x ${expected_height_mm} mm" >&2
        exit 1
    fi

    echo "Verified $pdf page size: ${expected_width_mm} x ${expected_height_mm} mm"
}

check_pdf_trimbox() {
    local pdf="$1"
    local expected_left_pts="$2"
    local expected_bottom_pts="$3"
    local expected_right_pts="$4"
    local expected_top_pts="$5"
    local actual_left_pts actual_bottom_pts actual_right_pts actual_top_pts

    if ! command -v pdfinfo >/dev/null 2>&1; then
        echo "pdfinfo is required to verify PDF trim boxes. Install it with: brew install poppler" >&2
        exit 1
    fi

    read -r actual_left_pts actual_bottom_pts actual_right_pts actual_top_pts < <(pdfinfo -box "$pdf" | awk '/TrimBox:/ {print $2, $3, $4, $5; exit}')

    if [ -z "$actual_left_pts" ] || [ -z "$actual_top_pts" ]; then
        echo "Unable to read TrimBox from $pdf" >&2
        exit 1
    fi

    if ! awk \
        -v al="$actual_left_pts" \
        -v ab="$actual_bottom_pts" \
        -v ar="$actual_right_pts" \
        -v at="$actual_top_pts" \
        -v el="$expected_left_pts" \
        -v eb="$expected_bottom_pts" \
        -v er="$expected_right_pts" \
        -v et="$expected_top_pts" \
        'BEGIN {
            tolerance_pts = 0.2
            dl = al - el; if (dl < 0) dl = -dl
            db = ab - eb; if (db < 0) db = -db
            dr = ar - er; if (dr < 0) dr = -dr
            dt = at - et; if (dt < 0) dt = -dt
            exit !((dl <= tolerance_pts) && (db <= tolerance_pts) && (dr <= tolerance_pts) && (dt <= tolerance_pts))
        }'
    then
        echo "Unexpected TrimBox for $pdf: got [$actual_left_pts $actual_bottom_pts $actual_right_pts $actual_top_pts]" >&2
        exit 1
    fi

    echo "Verified $pdf TrimBox: [$expected_left_pts $expected_bottom_pts $expected_right_pts $expected_top_pts]"
}

mkdir -p tmp

if [ "$EBOOK" -eq "1" ]; then
  convert -density 180 -define pdf:use-trimbox=true meta/nado-cover-rgb.pdf -crop 52.25x100% +repage -delete 0  -reverse tmp/front.pdf
fi

# Generate .processed.md files:
find **/*processed* -exec rm -rf {} \;
find **/*.md -exec cp {} {}.processed \;
find . -name "*.md.processed" -exec sh -c 'mv "$1" "${1%.md.processed}.processed.md"' _ {} \;

# Process footnote QR codes:
# Collect URL's:
generated_urls_file="tmp/generated-urls.csv"
find **/*.md -print0 | xargs -0 perl -ne 'print "$1\n" while /<(http.*?)>/g' | LC_ALL=C sort | uniq > "$generated_urls_file"
if ! cmp -s "$generated_urls_file" qr/note/urls.csv; then
    echo "Please update short links for URLs:"
    git --no-pager diff --no-index -- qr/note/urls.csv "$generated_urls_file" || true
    rm -f "$generated_urls_file"
    exit 1
fi
rm -f "$generated_urls_file"

if ! [ "$(wc -l < qr/note/urls.csv)" -eq "$(wc -l < qr/note/shorts.txt)" ]; then
    echo "shorts.txt should have the same number of entries as urls.csv"
    exit 1
fi

count=`wc -l < qr/note/urls.csv`
echo -n "" > qr/sed
rm -f qr/note/*.png
for i in $(seq $count); do
    url=`sed -n ${i}p qr/note/urls.csv`
    short_url=`sed -n ${i}p qr/note/shorts.txt`
    if [ "$EPUB" -eq "1" ]; then
        # Number QR code files, because we can't rely on case-sensitive file system.
        qrencode -m 0 -s 3 -o qr/note/$i.png $short_url
        echo "s*<$url>*<$url> ![](qr/note/$i.png){.qr}*g;" >> qr/sed
    else
        echo "s*<$url>*<$url> \\\MiniQR{$short_url}*g;" >> qr/sed
    fi
done
find **/*.processed.md -print0 | while IFS= read -r -d '' file; do
    sedi -f qr/sed "$file"
done

# Process figures:
for file in taproot/*.dot; do
    dot -Tsvg $file > ${file%.dot}.svg
    # https://gitlab.com/graphviz/graphviz/-/issues/1863
    sedi 's/transparent/none/' "${file%.dot}.svg"
done

if [ "$EPUB" -ne "1" ]; then
    # Newer pandoc emits \includesvg for LaTeX output. Pre-convert to PDF so
    # xelatex can include stable assets without depending on extra TeX helpers.
    find resources taproot appendix whitepaper -name '*.svg' | while read -r file; do
        output="tmp/$(basename "${file%.svg}").pdf"
        rsvg-convert --format=pdf --output "$output" "$file"
        while IFS= read -r -d '' processed; do
            FILE="$file" OUTPUT="$output" perl -0pi -e 's/\Q($ENV{FILE})\E/($ENV{OUTPUT})/g' "$processed"
        done < <(find . -name '*.processed.md' -print0)
    done
fi

if [ "$EPUB" -eq "1" ]; then
    # Drop unlisted header (not supported for ePub)
    find **/*.processed.md -print0 | while IFS= read -r -d '' file; do
        sedi '/\.unlisted/d' "$file"
    done
    # Don't use short titles
    find **/*.processed.md -print0 | while IFS= read -r -d '' file; do
        sedi 's/{short=".*" link="sec:\(.*\)"}/{#sec:\1}/' "$file"
    done

    sedi 's/\.unnumbered //' appendix/appendix.processed.md

    # Fix episode QRs:
    mkdir -p qr/ep
    rm -f qr/ep/*.png
    # Just assume 60 episodes
    for i in $(seq 60); do
        qrencode -m 0 -s 3 -o qr/ep/$i.png HTTPS://BTCWIP.COM/nado$i
    done
    find **/*.processed.md -print0 | while IFS= read -r -d '' file; do
        sedi 's/\\EpisodeQR{\(.*\)}/![[Ep. \1](https:\/\/btcwip.com\/nado\1)](qr\/ep\/\1.png){.ep-qr}/' "$file"
    done

    # Replace SVG images with PNG (Kindle devices don't render SVG well, especially the whitepaper)
    find **/*.processed.md -print0 | while IFS= read -r -d '' file; do
        sedi 's/([a-zA-Z0-9_-]*\/\([a-zA-Z0-9_-]*\)\.svg)/(tmp\/\1.png)/' "$file"
    done
    mogrify -density 300 -format png -path tmp [^_]**/*.svg
    # Shrink huge images to below the iBook 400K pixel limit:
    convert -density 300 taproot/mast.svg -resize 2500 tmp/mast.png
    convert -density 300 resources/tree.svg -resize 2500 tmp/tree.png
    convert -density 300 appendix/performance.svg -resize x2500 tmp/performance.png


    # Rename ref
fi

if [ "$CHAPTERS" -eq "1" ]; then
    # For now this is best done by rebasing the 2022/05/pdf-tweaks branch
    # TODO to get rid of the seperate branch:
    # * wrap chapter title and if $chapter$
    # * make episode QR optional
    # * put link under episode QR, like in History of Soft Fork Activation
    # * script to hardcode chapter numbers (maybe with a manual mapping)
    echo "Render chapter PDFs"
    rm -f Chapter*.pdf
    declare -a paper_sizes=(a4 letter)
    declare -a chapter_numbers=(1 2 3 4 5 6 7 8 9 10 11 12)
    declare -a chapter_slugs=(
        basics/address
        basics/dns_and_tor
        basics/segwit
        basics/libsecp256k1
        resources/assume-utxo
        resources/utreexo
        attacks/eclipse
        attacks/fake_nodes
        attacks/guix
        wallets/miniscript
        taproot/basics
        taproot/activation
    )
    # TODO: Get title from document metadata
    declare -a titles=(
        "Bitcoin Addresses"
        "DNS Bootstrap and Tor V3"
        "SegWit"
        "libsecp256k1"
        "Sync Time and AssumeUTXO"
        "Utreexo"
        "Eclipse Attacks"
        "Fake Nodes"
        "Why Open Source Matters — GUIX"
        "Script, P2SH, and Miniscript"
        "Taproot and Schnorr"
        "A Short History of Soft Fork Activation"
    )

    for (( i=0; i<${#chapter_numbers[@]}; i++ ));
    do
        echo "Chapter ${chapter_numbers[i]} - ${titles[i]}"
        for p in "${paper_sizes[@]}"
        do
            # https://stackoverflow.com/a/12487465
            # In bash 4 you can simply do: paper_size="${p^}", but this works in bash 3:
            paper_size="$(tr '[:lower:]' '[:upper:]' <<< ${p:0:1})${p:1}"
            echo "$paper_size..."
            pandoc --pdf-engine=xelatex -o "Chapter ${chapter_numbers[i]} - ${titles[i]} ($paper_size).pdf" "${chapter_slugs[i]}.processed.md" -V chapter=${chapter_numbers[i]} -V paper=$p -V title="${titles[i]}" --template=templates/chapter.tex --top-level-division=chapter
        done
        echo "Render thumbnail..."
        convert -density 600 -flatten -resize 1000x1000^ -gravity North -extent 1000x1000 "Chapter ${chapter_numbers[i]} - ${titles[i]} (Letter).pdf"\[0\] "thumb-nado-chapter-${chapter_numbers[i]}.png"
    done
    exit 0
fi

# Generate document
# The short-title-for-toc filter ensures that the page
# header of appendix C fits on one line.
# short-title-for-toc must be run before secnos.
pandoc  --pdf-engine=xelatex\
        --table-of-contents --top-level-division=part\
        --strip-comments\
        --filter filters/short-title-for-toc.py\
        --filter filters/pandoc-secnos-wrapper.py\
        --filter filters/wrapfig.py\
        --lua-filter filters/center.lua\
        $EXTRA_OPTIONS\
        $HEADER_INCLUDES\
        basics/_part.processed.md\
        basics/address.processed.md\
        basics/dns_and_tor.processed.md\
        basics/segwit.processed.md\
        basics/libsecp256k1.processed.md\
        resources/_part.processed.md\
        resources/assume-utxo.processed.md\
        resources/utreexo.processed.md\
        attacks/_part.processed.md\
        attacks/eclipse.processed.md\
        attacks/fake_nodes.processed.md\
        attacks/guix_title.processed.md\
        attacks/guix.processed.md\
        wallets/_part.processed.md\
        wallets/miniscript.processed.md\
        taproot/_part.processed.md\
        taproot/basics.processed.md\
        taproot/activation.processed.md\
        appendix/appendix.processed.md\
        appendix/more_episodes.processed.md\
        appendix/crime-on-testnet.processed.md\
        appendix/whitepaper.processed.md\
        whitepaper/bitcoin.processed.md\

# Use - in title for Windows compatibility.
if [ "$PDF_KINDLE" -eq "1" ]; then
    mv nado-kindle.pdf "Bitcoin - A Work in Progress (Kindle).pdf"
fi

if [ "$PDF_BIG" -eq "1" ]; then
    mv nado-kindle.pdf "Bitcoin - A Work in Progress (A4).pdf"
fi

if [ "$EPUB" -eq "1" ]; then
    mv nado-kindle.epub "Bitcoin - A Work in Progress.epub"
fi

if [ "$PAPERBACK" -eq "1" ]; then
    # A5 without bleed
    check_pdf_page_size nado-paperback.pdf 148 210
    python3 scripts/add_paperback_bleed.py nado-paperback.pdf nado-paperback-bleed.pdf
    check_pdf_page_size nado-paperback-bleed.pdf 154 216
    check_pdf_trimbox nado-paperback-bleed.pdf 8.5 8.5 428.03 603.78
fi
