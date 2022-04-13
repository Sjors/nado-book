#!/bin/bash
SKIP_QR="0"
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -b|--paperback) EXTRA_OPTIONS="-o nado-paperback.pdf --metadata-file meta-paperback.yaml --include-before-body copyright_paperback.tex --template=templates/pandoc.tex --toc-depth=1"; HEADER_INCLUDES="--include-in-header templates/header-includes.tex --include-in-header templates/header-includes-paperback.tex" ;;
        -k|--kindle) EXTRA_OPTIONS="-o nado-kindle.pdf --metadata-file meta-kindle.yaml --include-before-body copyright_kindle.tex --template=templates/pandoc.tex --toc-depth=1"; HEADER_INCLUDES="--include-in-header templates/header-includes.tex --include-in-header templates/header-includes-kindle.tex" ;;
        -e|--epub) EXTRA_OPTIONS="-t epub3 -o nado-book.epub --css epub.css --metadata-file meta-ebook.yaml --toc-depth=2" ;;
        -q|--skipqr) SKIP_QR="1"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Generate .processed.md files:
find **/*processed* -exec rm -rf {} \;
find **/*.md -exec cp {} {}.processed \;
find . -name "*.md.processed" -exec sh -c 'mv "$1" "${1%.md.processed}.processed.md"' _ {} \;

if [ "$SKIP_QR" -eq "0" ]; then

    # Process episode QR codes:
    pushd qr/ep
        for f in *.txt; do
            qrencode -o ${f%.txt}.png -r $f --level=M -d 300 -s 4
        done
    popd

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
        echo "s*<$url>*<$url> \\\qrcode[height=0.45cm,level=M]{$short_url}*g;" >> qr/sed
    done
    find **/*.processed.md -exec sed -i '' -f qr/sed {} \;

fi

# Process figures:
for file in taproot/*.dot; do
    dot -Tsvg $file > ${file%.dot}.svg
    # https://gitlab.com/graphviz/graphviz/-/issues/1863
    sed -i '' 's/transparent/none/' ${file%.dot}.svg
done

# Generate document
# The short-title-for-toc filter ensures that the page
# header of appendix C fits on one line.
pandoc --table-of-contents --top-level-division=part\
        --strip-comments\
        --filter pandoc-secnos\
        --filter filters/wrapfig.py\
        --filter filters/short-title-for-toc.py\
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
