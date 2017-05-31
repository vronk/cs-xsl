<xsl:stylesheet xmlns:cr="http://aac.ac.at/content_repository" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xpath-default-namespace="http://explain.z3950.org/dtd/2.0/" exclude-result-prefixes="xs xd" version="2.0">    

    <xsl:import href="../../fcs/explain2view_v2.xsl"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Aug 12, 2014</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> Daniel</xd:p>
            <xd:p/>
            <xd:p>Overrides the default explain2view_v2.xsl to provide a full list of index terms for project abacus.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="index">
        <xsl:param name="only_scan" select="true()"/>
        <xsl:param name="format" select="if ($format='htmllist') then 'html' else $format"/>
        <!-- important! 
             we want to sort by 'text' everywhere except with 'pos' scan: there we want to use _default order_, 
             which is different for every facet top level (posType) by size, mid level (posSubtype)and terms (pos) by text
             setting $sort explicitly here would override the different default settings
        -->
        <xsl:variable name="sort" select="if (map/name = 'pos') then '' else 'text'" as="xs:string"/>
        <xsl:variable name="scan-index">
            <xsl:call-template name="formURL">
                <xsl:with-param name="action" select="'scan'"/>
                <xsl:with-param name="scanClause" select="map/name"/>
                <xsl:with-param name="maximumTerms" select="if (xs:string(@cr:type)='nested') then 0 else $maximumTerms"/>
                <xsl:with-param name="format" select="$format"/>
                <xsl:with-param name="sort" select="$sort"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@scan='true'">
                <li>
                    <a href="{$scan-index}">
                        <xsl:value-of select="(title[@lang=$lang],title)[1]"/>
                    </a>
                </li>
            </xsl:when>
            <xsl:when test="$only_scan=true()"/>
            <xsl:otherwise>
                <li>
                    <xsl:value-of select="(title[@lang=$lang],title)[1]"/>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>