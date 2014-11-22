<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:exsl="http://exslt.org/common"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="xs xd exsl tei"
    version="1.0">
    <xsl:import href="commons_v1.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 6, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> simar</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="langTranslate" select="'de'"/>
    <xsl:param name="unit">
        <xsl:variable name="withL" select="concat('L', substring-after(/sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:query, '=L'))"/>
        <xsl:choose>
            <xsl:when test="$withL != 'L'">
                <xsl:value-of select="$withL"/>        
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('L', substring-after(/sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:query, '='))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:output indent="no" method="text" media-type="text/csv" encoding="UTF-8"/>
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="sru:records">
        <xsl:choose>
            <xsl:when test="contains($format, '-anki')">
                <xsl:apply-templates select="//tei:entry"/>               
            </xsl:when>
            <xsl:when test="contains($format, '-fcdeluxe')">
                <xsl:text>*&#x9;name&#x9;</xsl:text><xsl:value-of select="normalize-space(//fcs:DataView[@type='title'])"/><xsl:text>&#xa;</xsl:text>
                <xsl:text>*&#x9;font&#x9;* Andika-R.ttf,* Andika-R.ttf,* Andika-R.ttf,* Andika-R.ttf,* Andika-R.ttf&#xa;</xsl:text>
                <xsl:text>*&#x9;deck-stats-1&#x9;&#xa;</xsl:text>
                <xsl:text>Text1&#x9;Text2&#x9;Text3&#x9;Text4&#x9;Text5&#xa;</xsl:text>
                <xsl:apply-templates select="//tei:entry"/>
            </xsl:when>           
            <xsl:otherwise>
                You need to specify a valid format for the csv export.
                E. g.: csv-anki or csv-fcdeluxe
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:entry">
        <xsl:variable name="firstInflected">
            <xsl:choose>
                <xsl:when test="tei:form[@type='inflected'][1]">
                    <xsl:value-of select="tei:form[@type='inflected'][1]/tei:orth[contains(@xml:lang, 'vicav')]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="secondInflected">
            <xsl:choose>
                <xsl:when test="tei:form[@type='inflected'][2]">
                    <xsl:value-of select="tei:form[@type='inflected'][2]/tei:orth[contains(@xml:lang, 'vicav')]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>        
        <xsl:variable name="lemmaForms" select="tei:form[(@type = 'lemma') or (@type = 'multiWordUnit') or (@type = 'example')]"/>
        <xsl:variable name="lemma">
            <xsl:choose>
                <xsl:when test="$lemmaForms/tei:orth[contains(@xml:lang, 'vicav')]">
                    <xsl:value-of select="$lemmaForms/tei:orth[contains(@xml:lang, 'vicav')]"/>
                </xsl:when>
                <xsl:when test="$lemmaForms/tei:orth[@xml:lang='ar']">
                    <xsl:value-of select="concat($lemmaForms/tei:orth[@xml:lang='ar'],' ', $lemmaForms/tei:orth[@xml:lang='ar-x-DMG'])"/>                    
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
       <xsl:choose>
           <xsl:when test="contains($format, '-anki')">
               <xsl:call-template name="forAnki">
                   <xsl:with-param name="lemma" select="$lemma"/>
                   <xsl:with-param name="firstInflected" select="$firstInflected"/>
                   <xsl:with-param name="secondInflected" select="$secondInflected"/>                       
               </xsl:call-template>
           </xsl:when>
           <xsl:when test="contains($format, '-fcdeluxe')">
               <xsl:call-template name="forFCDeluxe">
                   <xsl:with-param name="lemma" select="$lemma"/>
                   <xsl:with-param name="firstInflected" select="$firstInflected"/>
                   <xsl:with-param name="secondInflected" select="$secondInflected"/>                       
               </xsl:call-template>
           </xsl:when>
       </xsl:choose>
    </xsl:template>

    <xsl:template name="forAnki">
        <xsl:param name="lemma"/>
        <xsl:param name="firstInflected"/>
        <xsl:param name="secondInflected"/>
        <xsl:call-template name="getCell"><xsl:with-param name="word" select="$lemma"/></xsl:call-template><xsl:text>&#x9;</xsl:text>
        <xsl:call-template name="getCell"><xsl:with-param name="word" select="$firstInflected"/></xsl:call-template><xsl:text>&#x9;</xsl:text>
        <xsl:call-template name="getCell"><xsl:with-param name="word" select="$secondInflected"/></xsl:call-template><xsl:text>&#x9;</xsl:text>
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="tei:sense[1]/tei:cit[@xml:lang = $langTranslate]"/><xsl:text>&#x9;</xsl:text>                
        <xsl:call-template name="string-join">
            <xsl:with-param name="nodes-to-join" select="tei:gramGrp/tei:gram[@type='root']"/>
            <xsl:with-param name="join-with"> </xsl:with-param>
        </xsl:call-template><xsl:text>&#x9;</xsl:text>
        <xsl:text>&#x9;</xsl:text>
        <xsl:text>&#x9;</xsl:text>
        <xsl:value-of select="$unit"/>
        <xsl:text>&#xa;</xsl:text>          
    </xsl:template>

    <xsl:template name="getCell">
        <xsl:param name="word" select="''"/>
        <xsl:if test="$word != ''"><xsl:value-of select="concat($word, '')"/></xsl:if>
    </xsl:template>
    
<!--    <xsl:template name="getCell">
        <xsl:param name="word" select="''"/>
        <xsl:if test="$word != ''"><xsl:value-of select="concat($word, '[sound:', $word, '.mp4]')"/></xsl:if>
    </xsl:template>
-->    
    <xsl:template name="forFCDeluxe">
        <xsl:param name="lemma"/>
        <xsl:param name="firstInflected"/>
        <xsl:param name="secondInflected"/>
        <xsl:value-of select="tei:sense[1]/tei:cit[@xml:lang = $langTranslate]"/><xsl:text>&#x9;</xsl:text>        
        <xsl:call-template name="getCell"><xsl:with-param name="word" select="$lemma"/></xsl:call-template><xsl:text>&#x9;</xsl:text>
        <xsl:call-template name="getCell"><xsl:with-param name="word" select="$firstInflected"/></xsl:call-template><xsl:text>&#x9;</xsl:text>
        <xsl:call-template name="getCell"><xsl:with-param name="word" select="$secondInflected"/></xsl:call-template><xsl:text>&#x9;</xsl:text>
        <xsl:text>&#xa;</xsl:text>         
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//sru:records"/>
    </xsl:template>
    
    <xsl:template name="continue-root">
        <xsl:apply-templates select="//sru:records"/>
    </xsl:template>
    
</xsl:stylesheet>