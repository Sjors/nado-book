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

# Process QR codes:
pushd qr
    for f in *.txt; do
        qrencode -o ${f%.txt}.png -r $f --level=M -d 300 -s 6
    done
popd

# Process figures:
dot -Tsvg taproot/speedy_trial.dot > taproot/speedy_trial.svg

# Generate document
pandoc --table-of-contents --toc-depth=2 --number-sections\
        --metadata-file meta.yaml\
        --strip-comments\
        --filter pandoc-secnos\
        --filter pandoc/wrapfig.py\
        $EXTRA_OPTIONS\
        header-includes.yaml\
        intro.md\
        basics/_section.md\
        basics/rbf.md\
        basics/address.md\
        basics/xpub.md\
        basics/dns_and_tor.md\
        basics/mempool_and_package_relay.md\
        basics/segwit.md\
        basics/libsecp256k1.md\
        blockchain/_section.md\
        blockchain/assume-utxo.md\
        blockchain/utreexo.md\
        blockchain/neutrino.md\
        blockchain/erlay.md\
        blockchain/timestamps.md\
        blockchain/rgb.md\
        attacks/_section.md\
        attacks/timewarp.md\
        attacks/psbt_rbf.md\
        attacks/eclipse.md\
        attacks/fake_nodes.md\
        attacks/erebus.md\
        attacks/pool_censorship\.md\
        wallets/_section.md\
        wallets/hwi.md\
        wallets/accounts.md\
        wallets/miniscript.md\
        wallets/bitcoin_beach.md\
        wallets/hardware_jade.md\
        taproot/_section.md\
        taproot/basics.md\
        taproot/payment_pools.md\
        taproot/activation_options.md\
        taproot/activation_options_2.md\
        taproot/speedy_trial.md\
        taproot/lot_true.md\
        taproot/locked_in.md\
        development/_section.md\
        development/signet.md\
        development/bip.md\
        development/guix.md\
        development/core_0_21.md\
        development/core_22_0.md\
        sidechains/_section.md\
        sidechains/statechains.md\
        sidechains/one-way-peg.md\
        sidechains/rsk.md\
        sidechains/drivechain.md\
        sidechains/softchains.md\
        lightning/_section.md\
        lightning/basics.md\
        lightning/routing.md\
        lightning/bolt12.md\
        lightning/eltoo.md\
        lightning/rbf_bug.md\
        acknowledgments.md\
