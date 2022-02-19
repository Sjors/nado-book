#!/bin/bash
SKIP_QR="0"
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--pdf) EXTRA_OPTIONS="-o nado-book.pdf --metadata-file meta-ebook.yaml"; shift ;;
        -e|--epub) EXTRA_OPTIONS="-t epub3 -o nado-book.epub --css epub.css --metadata-file meta-ebook.yaml --epub-chapter-level 2" ;;
        -b|--paperback) EXTRA_OPTIONS="-o nado-paperback.pdf --metadata-file meta-paperback.yaml --include-before-body copyright_paperback.tex" ;;
        -q|--skipqr) SKIP_QR="1"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Generate .processed.md files:
find **/*processed* -exec rm -rf {} \;
find intro.md **/*.md -exec cp {} {}.processed \;
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
    find intro.md **/*.md -print0 | xargs -0 perl -ne 'print "$1\n" while /<(http.*?)>/g' | sort | uniq > qr/note/urls.txt
    if ! git diff --quiet qr/note/urls.txt; then
        echo "Please update bit.ly links for URLs:"
        git diff qr/note/urls.txt
        exit 1
    fi

    if ! [ "$(wc -l < qr/note/urls.txt)" -eq "$(wc -l < qr/note/shorts.txt)" ]; then
        echo "shorts.txt should have the same number of entries as urls.txt"
        exit 1
    fi

    count=`wc -l < qr/note/urls.txt`
    for i in $(seq $count); do
        url=`sed -n ${i}p qr/note/urls.txt`
        short_url=`sed -n ${i}p qr/note/shorts.txt`
        # Skip URL's that haven't been shortened
        # Some domains are so short, they don't need shortening (unless we deep link to them)
        if echo $short_url | grep 'bit.ly\|nus.edu\|amzn.to\|gitian.org\|yhoo.it'; then
            # Add to processed markdown (might be macOS specific):
            find intro.processed.md **/*.processed.md -exec sed -i '' -e "s*<$url>*<$url> \\\qrcode[height=0.45cm,level=M]{$short_url}*g" {} \;
        fi
    done

fi

# Process figures:
dot -Tsvg taproot/bip8.dot > taproot/bip8.svg
dot -Tsvg taproot/bip9.dot > taproot/bip9.svg
dot -Tsvg taproot/flag.dot > taproot/flag.svg
dot -Tsvg taproot/speedy_trial.dot > taproot/speedy_trial.svg

echo "Generate PDF..."

# Generate document
pandoc --table-of-contents --toc-depth=2 --number-sections\
        --metadata-file meta.yaml\
        --template=templates/pandoc.tex\
        --strip-comments\
        --filter pandoc-secnos\
        --filter pandoc/wrapfig.py\
        $EXTRA_OPTIONS\
        header-includes.yaml\
        intro.processed.md\
        basics/_section.processed.md\
        basics/address.processed.md\
        basics/dns_and_tor.processed.md\
        basics/segwit.processed.md\
        basics/libsecp256k1.processed.md\
        resources/_section.processed.md\
        resources/assume-utxo.processed.md\
        resources/utreexo.processed.md\
        attacks/_section.processed.md\
        attacks/eclipse.processed.md\
        attacks/fake_nodes.processed.md\
        attacks/guix.processed.md\
        wallets/_section.processed.md\
        wallets/miniscript.processed.md\
        taproot/_section.processed.md\
        taproot/basics.processed.md\
        taproot/activation.processed.md\
        appendix/more_episodes.processed.md\
        appendix/crime-on-testnet.processed.md\
