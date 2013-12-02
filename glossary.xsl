<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:exsl="http://exslt.org/common"
   xmlns:sru="http://www.loc.gov/zing/srw/"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl exsl xd tei sru">
   <xsl:import href="fcs/result2view_v1.xsl"/>
   <xsl:output method="html" media-type="text/xhtml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/> 

    <xsl:template match="/">
      <xsl:if test="contains($format, 'page')">
         <head>
            <title>A title</title>
         </head>
      </xsl:if>
      <div class="profiletext">
        <div style="text-align: center; border-top: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; margin: 10px 0px; padding: 5px 0px;">
        <xsl:text>Search results (</xsl:text>
        <xsl:value-of select="//sru:numberOfRecords"/>
        <xsl:text> found)</xsl:text></div>

        <xsl:if test="not(//tei:entry)">
            <xsl:text>No entries found!!</xsl:text>
        </xsl:if>

        <xsl:for-each select="//tei:entry">
            <div style="margin-top: 15px; background: rgb(222,232,254); border: 1px solid grey">
               <b>
                  <xsl:value-of select="tei:form/tei:orth[contains(@xml:lang,'Trans')]"/>
                  <xsl:if test="tei:form[@type='lemma']/tei:orth[contains(@xml:lang,'arabic')]"><xsl:text> </xsl:text>(<xsl:value-of select="tei:form[@type='lemma']/tei:orth[contains(@xml:lang,'arabic')]"/>)</xsl:if>
               </b>

               <xsl:if test="tei:gramGrp/tei:gram[@type='pos']">
                  <span style="color: rgb(247,15,9)"><xsl:text>           </xsl:text>[<xsl:value-of select="tei:gramGrp/tei:gram[@type='pos']"/>
                     <xsl:if test="tei:gramGrp/tei:gram[@type='subc']">; <xsl:value-of select="tei:gramGrp/tei:gram[@type='subc']"/></xsl:if>]</span></xsl:if>


               <xsl:for-each select="tei:form[@type='inflected']">
                  <div style="margin-left:30px">
                     <xsl:value-of select="orth[contains(@xml:lang,'Trans')]"/>
                     <xsl:if test="tei:orth[contains(@xml:lang,'arabic')]"><xsl:text> </xsl:text>(<xsl:value-of select="tei:orth[contains(@xml:lang,'arabic')]"/>)</xsl:if>

                     <xsl:choose>
                        <xsl:when test="@ana='#adj_f'"><b style="color: rgb(63,116,254)"><i> (f) </i></b></xsl:when>
                        <xsl:when test="@ana='#adj_pl'"><b style="color: rgb(63,116,254)"><i> (pl) </i></b></xsl:when>
                        <xsl:when test="@ana='#n_pl'"><b style="color: rgb(63,116,254)"><i> (pl) </i></b></xsl:when>
                        <xsl:when test="@ana='#v_pres_sg_p3'"><b style="color: rgb(63,116,254)"><i> (pres) </i></b></xsl:when>

                     </xsl:choose>
                  </div>
               </xsl:for-each>

               <xsl:for-each select="tei:sense">
                  <xsl:if test="tei:def">
                    <div style="margin-top: 5px; border-top:0.5px dotted grey;">
                       <xsl:if test="tei:def[@xml:lang='en']">
                          <xsl:value-of select="tei:def[@xml:lang='en']"/>
                       </xsl:if>

                       <xsl:if test="tei:def[@xml:lang='de']">
                          <xsl:text> </xsl:text><span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="tei:def[@xml:lang='de']"/>)</span>
                       </xsl:if>
                    </div>
                 </xsl:if>

                  <xsl:if test="tei:cit[@type='translation']">
                    <div style="margin-top: 5px; border-top:0.5px dotted grey;">
                       <xsl:if test="tei:cit[(@type='translation')and(@xml:lang='en')]">
                          <xsl:value-of select="tei:cit[(@type='translation')and(@xml:lang='en')]"/>
                       </xsl:if>

                       <xsl:if test="tei:cit[(@type='translation')and(@xml:lang='de')]">
                          <xsl:text> </xsl:text><span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="tei:cit[(@type='translation')and(@xml:lang='de')]"/>)</span>
                       </xsl:if>
                    </div>
                 </xsl:if>

                  <xsl:for-each select="tei:cit[@type='example']">
                     <div style="padding: 3px; margin-left:30px;color:green;border:1px solid rgb(97,137,1); background: rgb(250,255,183)">
                        <xsl:value-of select="tei:quote[contains(@xml:lang,'Trans')]"/>
                        <div style="margin-left: 20px;">
                           <xsl:if test="tei:cit[(@type='translation')and(@xml:lang='en')]">
                              <i style="color: rgb(193,97,0)"><xsl:value-of select="cit[(@type='translation')and(@xml:lang='en')]"/></i>
                           </xsl:if>

                           <xsl:if test="tei:cit[(@type='translation')and(@xml:lang='de')]">
                              <xsl:text> </xsl:text><span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="tei:cit[(@type='translation')and(@xml:lang='de')]"/>)</span>
                           </xsl:if>

                           <xsl:if test="tei:ef">
                              <div style="font-style: italic; color: rgb(36,53,208)"> [
                                 <xsl:if test="tei:def[@xml:lang='en']">
                                    <xsl:value-of select="tei:def[@xml:lang='en']"/>
                                 </xsl:if>

                                 <xsl:if test="tei:def[@xml:lang='de']">
                                    <xsl:text> </xsl:text><span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="tei:def[@xml:lang='de']"/>)</span>
                                 </xsl:if>]</div>
                           </xsl:if>
                        </div>
                     </div>
                 </xsl:for-each>
              </xsl:for-each>
            </div>
        </xsl:for-each>
      </div>
    </xsl:template>
</xsl:stylesheet>
