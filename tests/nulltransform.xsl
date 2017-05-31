<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
<!--    <xsl:output omit-xml-declaration="yes" doctype-public="" doctype-system=""/>-->
    <xsl:output method="xhtml" media-type="text/html" encoding="UTF-8" indent="no" omit-xml-declaration="yes" doctype-public="" doctype-system=""/>
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="force-normalize-space" as="xs:boolean" select="false()"/>

    <!-- IdentityTransform -->
    <xsl:template match="/ | @* | node()">
         <xsl:copy>
               <xsl:apply-templates select="@* | node()" />
         </xsl:copy>
    </xsl:template>
    
    <!-- but forcibly ignore differences in the number or kind of whitspace -->
    <xsl:template match="text()" priority="10">
        <xsl:value-of select="if ($force-normalize-space) then normalize-space(.) else ."/>
    </xsl:template>
    
    <!-- ignore the profiling information that is contained in some respones -->
    <xsl:template match="html:span[matches(., '^\s*PT.*S\s*PT.*S\s*$')]">
        <span>PT0.000S PT0.000S</span>        
    </xsl:template>
    
</xsl:stylesheet>
