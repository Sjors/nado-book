# NADO book

## Build

Install [Pandoc](https://pandoc.org) to generate an epub file.
For PDF a LaTeX engine is required, see Pandoc documentation.

The following Pandoc filters are used:
* [pandoc-secnos](https://github.com/tomduck/pandoc-xnos)

In addition you need [Graphviz](https://www.graphviz.org).

To build the paperback version:

```sh
./make_book.sh --paperback
```

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


To generate the jpeg cover images:

```sh
cd meta
convert -density 180 -define pdf:use-trimbox=true nado-cover.pdf -crop 52.25x100% +repage \( -clone 0 -crop 92x100% +repage -reverse \) -delete 0 -reverse slice.jpg
mv slice-2.jpg ../docs/front.jpg
mv slice-0.jpg ../docs/back.jpg
mv slice-1.jpg spine.jpg

```

## Preview

Use Apple Books, [Kindle Previewer](https://kdp.amazon.com/en_US/help/topic/G202131170), etc to view the epub.

## Contribute

See [STYLE.md](STYLE.md) for the markdown style used, e.g. how to add links and footnotes.

To preview documentation:

```sh
bundle exec jekyll server --incremental --source docs
```
