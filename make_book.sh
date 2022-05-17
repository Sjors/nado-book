#!/bin/bash
SKIP_QR="0"
PAPERBACK="0"
EBOOK="0"
ONLY_PROCESS="0"
CHAPTERS="0"
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -b|--paperback) PAPERBACK="1" EXTRA_OPTIONS="-o nado-paperback.pdf --metadata-file meta-paperback.yaml --include-before-body copyright_paperback.tex --template=templates/pandoc.tex --toc-depth=1"; HEADER_INCLUDES="--include-in-header templates/header-includes.tex --include-in-header templates/header-includes-paperback.tex" ;;
        -k|--ebook) EBOOK="1" EXTRA_OPTIONS="-o nado-ebook.pdf -V ebook --metadata-file meta-ebook.yaml --include-before-body copyright_ebook.tex --template=templates/pandoc.tex --toc-depth=1"; HEADER_INCLUDES="--include-in-header templates/header-includes.tex --include-in-header templates/header-includes-ebook.tex" ;;
        -q|--skipqr) SKIP_QR="1"; shift ;;
        -p|--process) ONLY_PROCESS="1"; shift ;;
        -c|--chapters) CHAPTERS="1"; shift ;;
        -v|--verbose) EXTRA_OPTIONS="$EXTRA_OPTIONS --verbose"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Generate .processed.md files:
find **/*processed* -exec rm -rf {} \;
find **/*.md -exec cp {} {}.processed \;
find . -name "*.md.processed" -exec sh -c 'mv "$1" "${1%.md.processed}.processed.md"' _ {} \;

if [ "$SKIP_QR" -eq "0" ]; then

    # Process footnote QR codes:
    # Collect URL's:
    find **/*.md -print0 | xargs -0 perl -ne 'print "$1\n" while /<(http.*?)>/g' | sort | uniq > qr/note/urls.csv
    if ! git diff --quiet qr/note/urls.csv; then
        echo "Please update bit.ly links for URLs:"
        git diff qr/note/urls.csv
        exit 1
    fi

    if ! [ "$(wc -l < qr/note/urls.csv)" -eq "$(wc -l < qr/note/shorts.txt)" ]; then
        echo "shorts.txt should have the same number of entries as urls.csv"
        exit 1
    fi

    count=`wc -l < qr/note/urls.csv`
    echo -n "" > qr/sed
    for i in $(seq $count); do
        url=`sed -n ${i}p qr/note/urls.csv`
        short_url=`sed -n ${i}p qr/note/shorts.txt`
        echo "s*<$url>*<$url> \\\MiniQR{$short_url}*g;" >> qr/sed
    done
    find **/*.processed.md -exec sed -i '' -f qr/sed {} \;

fi

# Process figures:
for file in taproot/*.dot; do
    dot -Tsvg $file > ${file%.dot}.svg
    # https://gitlab.com/graphviz/graphviz/-/issues/1863
    sed -i '' 's/transparent/none/' ${file%.dot}.svg
done

if [ "$ONLY_PROCESS" -eq "1" ]; then
    exit 0
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
        --filter pandoc-secnos\
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
        appendix/more_episodes.processed.md\
        appendix/crime-on-testnet.processed.md\
        appendix/whitepaper.processed.md\
        whitepaper/bitcoin.processed.md\

if [ "$EBOOK" -eq "1" ]; then
    # Use - in title for Windows compatibility.
    mv nado-ebook.pdf "Bitcoin - A Work in Progress.pdf"
fi
