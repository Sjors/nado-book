#!/bin/bash
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--pdf) EXTRA_OPTIONS="-o nado-book.pdf --metadata-file meta-ebook.yaml"; shift ;;
        -e|--epub) EXTRA_OPTIONS="-t epub3 -o nado-book.epub --css epub.css --metadata-file meta-ebook.yaml --epub-chapter-level 2" ;;
        -b|--paperback) EXTRA_OPTIONS="-o nado-paperback.pdf --metadata-file meta-paperback.yaml --include-before-body copyright_paperback.tex" ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Process episode QR codes:
pushd qr/ep
    for f in *.txt; do
        qrencode -o ${f%.txt}.png -r $f --level=M -d 300 -s 6
    done
popd

# Process figures:
dot -Tsvg taproot/speedy_trial.dot > taproot/speedy_trial.svg
dot -Tsvg taproot/bip8.dot > taproot/bip8.svg

# Generate document
pandoc --table-of-contents --toc-depth=2 --number-sections\
        --metadata-file meta.yaml\
        --template=templates/pandoc.tex\
        --strip-comments\
        --filter pandoc-secnos\
        --filter pandoc/wrapfig.py\
        $EXTRA_OPTIONS\
        header-includes.yaml\
        intro.md\
        basics/_section.md\
        basics/address.md\
        basics/dns_and_tor.md\
        basics/segwit.md\
        basics/libsecp256k1.md\
        resources/_section.md\
        resources/assume-utxo.md\
        resources/utreexo.md\
        resources/erlay.md\
        attacks/_section.md\
        attacks/eclipse.md\
        attacks/fake_nodes.md\
        attacks/guix.md\
        wallets/_section.md\
        wallets/hwi.md\
        wallets/miniscript.md\
        taproot/_section.md\
        taproot/basics.md\
        taproot/activation.md\
        appendix/more_episodes.md\
        appendix/crime-on-testnet.md\
