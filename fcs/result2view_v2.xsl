<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/" xmlns:utils="http://aac.ac.at/content_repository/utils" xmlns:saxon="http://saxon.sf.net/" xmlns:sru="http://www.loc.gov/zing/srw/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fcs="http://clarin.eu/fcs/1.0" xmlns:exsl="http://exslt.org/common" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0" exclude-result-prefixes="#all">
    <xsl:import href="result2view_v1.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>Generate html view of a sru-result-set (eventually in various formats)
            <xd:p>History:
                <xd:ul>
                    <xd:li>2011-12-06: created by:"vr": based on cmdi/scripts/mdset2view.xsl retrofitted for XSLT 1.0</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>Generate a valid XHTML 1 DOCTYPE and handle some HTML cornercasees.
            <xd:p>Note: method="xhtml" is saxon-specific! prevents collapsing empty &lt;script&gt; tags, that makes browsers choke (eg. not loading that script), but collapses &lt;br&gt; tags which might otherwise be interpreted as two.</xd:p>
            <xd:p>Note: saxon checks the namespace of the script and br tags so to make this magic work it's essential the tags to have xmlns="http://www.w3.org/1999/xhtml".
                This might be achieved by setting this as the default namespace like in this script or otherwise.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xhtml" media-type="text/html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
    <xsl:include href="../commons_v2.xsl"/>
    <xsl:include href="data2view_v2.xsl"/>
    <xd:doc>
        <xd:desc>Inserts the JavaScript funtions needed for displaying the representation
        of the unknown parts of the TEI encoding.</xd:desc>
    </xd:doc>
    <xsl:template name="callback-header">
        <script type="text/javascript">
            $(function()
            {
            $(".inline-wrap").live("mouseover", function(event) {
                $(this).find(".attributes").show();
                });
                $(".inline-wrap").live("mouseout", function(event) {
                $(this).find(".attributes").hide();
                });
            });
        </script>
    </xsl:template>
</xsl:stylesheet>