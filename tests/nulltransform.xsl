<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" version="2.0" exclude-result-prefixes="xsl">
<!--    <xsl:output omit-xml-declaration="yes" doctype-public="" doctype-system=""/>-->
    <xsl:output method="xhtml" media-type="text/html" encoding="UTF-8" indent="no" omit-xml-declaration="yes" doctype-public="" doctype-system=""/>
    <xsl:strip-space elements="*"/>

    <!-- IdentityTransform -->
    <xsl:template match="/">
        <xsl:sequence select="."/>
    </xsl:template>

</xsl:stylesheet>
