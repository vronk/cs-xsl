<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:exsl="http://exslt.org/common" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="#all">
    <xsl:import href="../../fcs/result2view_v1.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>Customization for abacus project. copied directly from /db/apps/cr-xq-mets/modules/cs-xsl/fcs/result2view.xsl</xd:desc>
    </xd:doc>
    <!--<xsl:output method="xhtml" media-type="text/html" indent="no" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>-->
    <xsl:output method="xhtml" omit-xml-declaration="yes" indent="no"/>
    <xsl:include href="../../commons_v2.xsl"/>
    <xsl:include href="../../fcs/data2view_v2.xsl"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="tei:entryFree" mode="record-data"><xsl:text>
</xsl:text>
        <div class="tei-entryFree">
            <xsl:apply-templates mode="#current"/>
        </div><xsl:text>
</xsl:text>
    </xsl:template>

    <xsl:template match="tei:form[@type = 'lemma']" mode="record-data">
        <span class="tei-form-type-lemma">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:head" mode="record-data">
        <div class="tei-head">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:lb" mode="record-data">
        <xsl:if test="not(ancestor::tei:entryFree)">
            <xsl:choose>
                <xsl:when test="@break = 'no'">
                    <xsl:choose>
                        <xsl:when test="@rend = 'd'">
                            <xsl:text>=</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>-</xsl:text> 
                        </xsl:otherwise> 
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <br/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="exist:match" mode="record-data">
        <span class="match" style="color:red;">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:publisher" mode="record-data">
        <span class="tei-publisher">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:q|tei:quote" mode="record-data">
        <xsl:text>„</xsl:text>
        <xsl:apply-templates mode="#current"/>        
        <xsl:text>‟</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:list" mode="record-data">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="tei:item" mode="record-data">
        <p>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:fs" mode="record-data"/>
        
    <xsl:template match="tei:hi[@rend]" mode="record-data">
        <span class="tei-hi rend-{@rend}">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:persName" mode="record-data">
        <span class="tei-persName">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:orth" mode="record-data">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="*[@orig]" mode="record-data">
        <xsl:value-of select="@orig"/>
    </xsl:template>
    
    <xsl:template match="tei:gramGrp" mode="record-data"/>
    
    <!-- probably not needed anymore -->
    <xsl:template match="tei:gramGrp[/tei:gram/@type='orig']" mode="record-data">
        <xsl:value-of select="tei:gram[@type='orig']"/>
    </xsl:template>
      
    <!-- maybe we need to do some more advanced styling here? -->
    <xsl:template match="tei:sense" mode="record-data">
        <span class="tei-sense">
            <xsl:choose>
                <xsl:when test="tei:def">            
                    <span class="tei-def">
                        <xsl:apply-templates select="tei:def/(*|text())" mode="record-data"/> 
                    </span>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates mode="record-data"/></xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lbl" mode="record-data"><span class="tei-lbl"><xsl:apply-templates mode="record-data"/></span></xsl:template>
    
    <xsl:template match="tei:cit" mode="record-data"><span class="tei-cit"><xsl:apply-templates mode="record-data"/></span></xsl:template>
    
</xsl:stylesheet>