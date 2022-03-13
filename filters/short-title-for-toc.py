#!/usr/bin/env python3

"""
Usage:
Copy this code to short-title-for-toc.py
pip3 install pandocfilters
pandoc --filter ./short-title-for-toc.py
"""

from pandocfilters import toJSONFilter, RawBlock, get_value, stringify

LEVEL2TAG = {
    1: 'part',
    2: 'chapter',
    3: 'section',
    4: 'subsection',
    5: 'subsubsection',
}

def f(key, value, format, meta):
    if not (format == 'latex' and key == 'Header'):
        return

    # get data

    level, (_, classes, keyvals), _ = value             # level, (ident, classes, keyvals), internal_pandoc
    short, _ = get_value(keyvals, 'short')
    link, _ = get_value(keyvals, 'link')

    if level not in LEVEL2TAG:
        raise Exception('short-title-for-toc.py: level %d not handled' % level)
    tag = LEVEL2TAG[level]

    # check if we should override pandoc default behavior

    if not short and not link:
        return

    if classes:
        raise Exception(
            'short-title-for-toc.py: If class "short" is used, I cant handle another one (Header="%s")'
            % (stringify(value))
        )

    # build overriden code

    if short:
        latextitle = '\\%s[%s]{%s}' % (tag, short, stringify(value))
    else:
        latextitle = '\\%s{%s}' % (tag, stringify(value))

    if link:
        latextitle = '\hypertarget{%s}{%s\label{%s}}' % (link, latextitle, link)

    # return

    return RawBlock('latex', latextitle)

if __name__ == '__main__':
    toJSONFilter(f)
