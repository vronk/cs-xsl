<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" version="2.0" xpath-default-namespace="http://explain.z3950.org/dtd/2.0/">
    <xsl:import href="explain2view_v1.xsl"/>
    <xsl:import href="../commons_v2.xsl"/>
    <xsl:output method="html"/>
    <xsl:param name="lang" select="'en'"/>
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xsl:variable name="title" select="concat('explain: ', (//databaseInfo/title[@lang=$lang]/text(), //databaseInfo/title/text(), $site_name)[1])"/>

</xsl:stylesheet>