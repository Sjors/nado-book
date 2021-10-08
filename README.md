# NADO book

## Build

Install [Pandoc](https://pandoc.org) to generate an epub file.
For PDF a LaTeX engine is required, see Pandoc documentation.

The following Pandoc filters are used:
* [pandoc-xnos](https://github.com/tomduck/pandoc-xnos)

In addition you need [Graphviz](https://www.graphviz.org).

```sh
./make_book.sh --epub
./make_book.sh --pdf
./make_book.sh --paperback
```

The paperback uses PDF, the Kindle version uses epub.

## Preview

Use Apple Books, [Kindle Previewer](https://kdp.amazon.com/en_US/help/topic/G202131170), etc to view the epub.

## Contribute

See [STYLE.md](STYLE.md) for the markdown style used, e.g. how to add links and footnotes.
