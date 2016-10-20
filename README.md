cs-xsl: A framework for transforming TEI to HTML
================================================

This is an XSL framwork used in [PHP corpus_shell](https://github.com/acdh-oeaw/fcs-aggregator)
and [cr-xq-mets](https://github.com/acdh-oeaw/cr-xq-mets) to transform TEI to HTML.

Therefore it is usable as XSL 1.0 and XSL 2.0 library with the majority of the functionality
implementerd in XSL 1.0

Entry point files
-----------------

The XSL used as entry points are named after the SRU operations they belong to
* explain: [v1](fcs/explain2view_v1.xsl), [v2](fcs/explain2view_v2.xsl) and [json](fcs/explain2json.xsl)
* scan: [v1](fcs/scan2view_v1.xsl), [v2](fcs/scan2view_v2.xsl) and [json](fcs/scan2json.xsl)
* searchRetrieve: [v1](fcs/result2view_v1.xsl), [v2](fcs/result2view_v2.xsl)

They are meant to be customized by superseding templates as needed:
* Example for XSL 1.0 based sites
 * [Glossaries](glossary.xsl)
 * [Bibliographies](bibliography.xsl)
* Examples for XSL 2.0 based sites
 * [Customized explain](custom-xsl/abacus/explain2view_custom.xsl)
 * [Customized result rendering](custom-xsl/abacus/result2view_custom.xsl)
 
Tests
-----

There is a [test infrastructure](tests) based on XSL processors for 1.0 and 2.0 and ant.

More docs
---------

* [TODO](docs/TODO.md)
* [Design](docs/Design.md): A document about design decissions.