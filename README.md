# NADO book

## Build

Install [Pandoc](https://pandoc.org) version 3 to generate an epub file.
For PDF a LaTeX engine is required, see Pandoc documentation.

The following Pandoc filters are used:
* [pandoc-secnos](https://github.com/tomduck/pandoc-xnos)

In addition you need [Graphviz](https://www.graphviz.org), ImageMagick, Ghostscript, and Poppler.

The paperback build also expects the following LaTeX packages to be available:
`pstricks`, `pst-barcode`, `pst-tools`, `marginnote`, `wrapfig`, `mwe`, and `footmisc`.

On macOS, the following worked:

```sh
brew install imagemagick ghostscript poppler
brew install --cask basictex
pip3 install --user pandoc-secnos pikepdf
eval "$(/usr/libexec/path_helper)"
sudo tlmgr install pstricks pst-barcode pst-tools marginnote wrapfig mwe footmisc
sudo texhash
```

If `tlmgr install` fails with a checksum mismatch from a bad mirror, reset it to the CTAN redirector and retry:

```sh
sudo tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
sudo tlmgr update --self
```

To build the paperback version:

```sh
./make_book.sh --paperback
```

This produces:
- `nado-paperback.pdf`: A5 interior (`148 x 210 mm`)
- `nado-paperback-bleed.pdf`: `3 mm` bleed on all sides (`154 x 216 mm`) with an explicit A5 `TrimBox`

The paperback build verifies both output sizes with `pdfinfo`.

To build an ePub version (Latex math is rendered via [Codecogs](https://www.codecogs.com) - check section 11 of the whitepaper to ensure you didn't get rate limited):

```sh
./make_book.sh --epub
```


To build a PDF that roughly fits a Kindle:

```sh
./make_book.sh --pdfkindle
```


To build a PDF that roughly fits an iPad:

```sh
./make_book.sh --pdfbig
```

Note that `make_book.sh` builds the book interior. The cover PDF is still a separate manual export flow from the source files in `meta/`.


To generate the jpeg cover images, first export the cover PDF from Scribus. Then run:

```sh
scripts/export_cover_jpegs.sh
```

This regenerates `meta/front.jpg`, `meta/back.jpg`, and `meta/spine.jpg`, and
syncs `docs/front.jpg` for the website.

## Preview

Use Apple Books, [Kindle Previewer](https://kdp.amazon.com/en_US/help/topic/G202131170), etc to view the epub.

## Contribute

See [STYLE.md](STYLE.md) for the markdown style used, e.g. how to add links and footnotes.

To preview documentation:

```sh
bundle exec jekyll server --incremental --source docs
```
