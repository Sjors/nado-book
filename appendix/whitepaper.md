## Bitcoin Whitepaper

The following pages contain the Bitcoin whitepaper. The layout has been modified slightly to be more suitable for a book.

If you prefer to the read the original, you can just download it,^[<https://bitcoin.org/bitcoin.pdf>] but there's a more interesting approach! In chapter @sec:assume we explained how the unspent transaction output (UTXO) set tracks every coin currently in existence. A coin consists of an amount plus the script that needs to be satisfied in order to spend the coin (see e.g. chapter @sec:miniscript).

Instead of a real script, it's also possible to stuff a UTXO with completely arbitrary data. In the past, when transaction fees were still very low, many things have been uploaded to the blockchain, including a picture of Nelson Mandela and: the Bitcoin whitepaper.^[Sward, A., Vecna, I., & Stonedahl, F. (2018). Data Insertion in Bitcoin’s Blockchain. Ledger, 3. <https://doi.org/10.5195/ledger.2018.101>]

\newpage

The following command extracts the whitepaper from the UTXO set:^[<https://www.reddit.com/r/Bitcoin/comments/l2yu4k/comment/gke25ve/>]

```
b=54e48e5f5c656b26c3bca14a8c95aa58\
3d07ebe84dde3b7dd4a78f4e4186e713
for ((o=0;o<946;++o))
do bitcoin-cli gettxout $b $o
done | jq -r '.scriptPubKey.asm' |
cut -d' ' -f2-4 |
xxd -r -p |
tail -c+9 |
head -c184292 > bitcoin.pdf
```

You can verify the checksum for this PDF:

```
shasum -a 256 bitcoin.pdf
```

The result should be:
```
b1674191a88ec5cdd733e4240a818031
05dc412d6c6708d53ab94fc248f4f553
```

Because the arbitrary data does not correspond to any real public key, this coins can never be spent. Although that follows from common sense, there's no way to mathematically prove it. This means that all nodes have to keep these coins, i.e. the whitepaper, in memory until the end of time. Or until a UtreeXO softfork (chapter @sec:utreexo) removes the need for nodes to store the UTXO set.
