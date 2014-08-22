<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cmd="http://www.clarin.eu/cmd/" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mets="http://www.loc.gov/METS/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="mods xlink xd utils">
    <xsl:import href="../commons_v2.xsl"/>
    <xsl:include href="../fcs/data2view_v2.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc> generate a generic html-view for individual parts of the project-mets file:  mods:projectDmd mets:structMap                
        </xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" indent="yes"/>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>preferred language to select for description etc.</xd:p>
            <xd:p>fallback to any available language</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="lang" select="'de'"/>
    <xsl:variable name="title" select="''"/>
    <xsl:variable name="internal-structure" select="//mets:structMap[@TYPE='internal']"/>
    <xsl:key name="mets-div" match="mets:div" use="@ID"/>
    <xsl:template name="continue-root">
        <!--    <xsl:template match="/">-->
        <xsl:apply-templates>
            <xsl:with-param name="strict" select="true()"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="cmd:CMD">
        <div class="projectDMD mdtype-cmd record">
            <div class="header">
                <h2>
                    <!--<xsl:value-of select=".//sourceDesc/bibl[@type='short']"/>-->
                    <xsl:call-template name="getTitle"/>
                </h2>
                <div class="links">
                    <xsl:variable name="resource-id" select=".//cmd:ResourceProxy[1]/data(@id)"/>
                    <xsl:variable name="md-link-cmdi">
                        <xsl:call-template name="formURL">
                            <xsl:with-param name="action" select="'get-metadata'"/>
                            <xsl:with-param name="format" select="'htmlpage'"/>
                            <xsl:with-param name="q" select="$resource-id"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="link-explain">
                        <xsl:call-template name="formURL">
                            <xsl:with-param name="action" select="'explain'"/>
                            <xsl:with-param name="format" select="'htmllist'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <a class="link-info" href="#">Info</a>
                    <a class="link-cmdi" href="{$md-link-cmdi}">CMD</a>
                    <a class="link-explain" href="{$link-explain}">Register</a>                    
                    <!--                    <div class="div-after"/>-->
                </div>
            </div>
            <div class="data-view metadata">
                <xsl:choose>
                    <xsl:when test="exists(.//cmd:Description[@xml:lang=$lang])">
                        <xsl:apply-templates select=".//cmd:Description[@xml:lang=$lang]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="(.//cmd:Description)[1]"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                <p>
                    <xsl:apply-templates select=".//cmd:License" mode="record-data">
                        <xsl:with-param name="strict" select="true()"/>
                    </xsl:apply-templates>
                </p>
                <p>
                    <xsl:apply-templates select=".//cmd:Contact" mode="record-data">
                        <xsl:with-param name="strict" select="true()"/>
                    </xsl:apply-templates>
                </p>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="mods:mods">
        <div class="projectDMD mdtype-mods">
            <xsl:apply-templates select="*[not(local-name()='name')]"/>
            <xsl:if test="mods:name">
                <div class="authors">
                    <h3>Authors:</h3>
                    <ul>
                        <xsl:apply-templates select="mods:name"/>
                    </ul>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="mods:language|mods:typeOfResource"/>
    <xsl:template match="mods:titleInfo">
        <h2>
            <xsl:value-of select="mods:title"/>
        </h2>
    </xsl:template>
    <xsl:template match="mods:abstract">
        <p>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    <xsl:template match="mods:name">
        <li>
            <xsl:value-of select="concat(mods:namePart[@type='given'], ' ', mods:namePart[@type='family'], ' (', mods:role, ') ' )"/>
        </li>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p/>
            <xd:pre>
                <structMap TYPE="internal" ID="cr-data">
                    <div>
                        <mets:div TYPE="resource" ID="abacus.res21b4ce57ff094ba79b55" LABEL="Mercks Wien" DMDID="projectDMD">
                            <mets:fptr FILEID="res21b4ce57ff094ba79b55_master"/>
                            <mets:fptr FILEID="res21b4ce57ff094ba79b55_wc"/>
                            <mets:div TYPE="resourcefragment" ID="res21b4ce57ff094ba79b55_frag00000001">
                                <mets:fptr>
                                    <mets:area FILEID="res21b4ce57ff094ba79b55_fragments" BEGIN="res21b4ce57ff094ba79b55_frag00000001" END="res21b4ce57ff094ba79b55_frag00000001" BETYPE="IDREF"/>
                                </mets:fptr>
                                <mets:fptr/>
                            </mets:div>
                        </mets:div>
                    </div>
                </structMap>
            </xd:pre>
        </xd:desc>
    </xd:doc>
    <xsl:template match="mets:structMap">
        <div class="structMap">
            <!--<h3>Resources</h3>-->
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:pre>
                <mets:div TYPE="chapter" ID="d1e63354" LABEL="Ostium pandit Hostia.">
                    <mets:fptr>
                        <mets:area FILEID="abacus.54f3e9376b1e3ebc9b31cdc8e011e23e_fragments" BEGIN="abacus.54f3e9376b1e3ebc9b31cdc8e011e23e_fragments00000082" END="abacus.54f3e9376b1e3ebc9b31cdc8e011e23e_fragments00000089" BETYPE="IDREF"/>
                    </mets:fptr>
                </mets:div>
            </xd:pre>
        </xd:desc>
    </xd:doc>
    <xsl:template match="mets:div">
        <xsl:variable name="type" select="@TYPE"/>
        <xsl:choose>
            <xsl:when test="$type='resource'">
                <xsl:variable name="link" select="utils:formURL('get-data','html',@CONTENTIDS)"/>
                <div class="{$type}">
                    <h3>
                        <a href="{$link}">
                            <xsl:value-of select="@LABEL"/>
                        </a>
                    </h3>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="$type='chapter'">
                <!-- take resource-id + the id of the starting fragment as link -->
                <xsl:variable name="link" select="utils:formURL('get-data','html',mets:fptr/mets:area/@BEGIN)"/>
                <div class="{$type}">
                    <a href="{$link}">
                        <xsl:value-of select="@LABEL"/>
                    </a>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="$type='resourcefragment'">
                <xsl:variable name="link" select="utils:formURL('get-data','html',@ID)"/>
                <div class="{$type}">
                    <a href="{$link}">
                        <xsl:value-of select="@LABEL"/>
                    </a>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>overriding default template to get titles - specific for CMD</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="getTitle">
        <xsl:value-of select="(.//cmd:Title,.//cmd:Name)[1]"/>
    </xsl:template>
</xsl:stylesheet>