# Style guide

## Links

Write the full URL or use an (inline) footnote.
The URL needs wrapped it in `<>`, so that it's interpreted correctly on all platforms.
A footnote may contain additional text.

* `you can download it at <https://bitcoincore.org/>`
* `... Bitcoin Core^[<https://bitcoincore.org/>]`
* `... Bitcoin Core^[Download at <https://bitcoincore.org/>]`

## Chapter references

To refer to a chapter use `@sec:label`, e.g. `as explained in chapter @sec:schnorr`.
If a chapter doesn't have a label yet, add `{#sec:label}` after its title, e.g. `## Schnorr Signatures {#sec:schnorr}`.
