<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im"%>
<%@ taglib uri="http://flymine.org/imutil" prefix="imutil" %>

<!-- report.jsp -->
<html:xhtml/>

<link rel="stylesheet" type="text/css" href="css/960gs.css" />

<div id="header_wrap">
  <div id="object_header">
    <tiles:get name="objectTrail.tile" />
    <a name="summary"></a>
    <h1 class="title">
        ${object.type}: <strong>${object.titleMain}</strong> ${object.titleSub}
    </h1>

    <%-- summary short fields --%>
    <table class="fields">
      <c:set var="tableCount" value="0" scope="page" />

      <c:forEach var="field" items="${object.objectSummaryFields}">
          <c:if test="${tableCount %2 == 0}">
            <c:choose>
              <c:when test="${tableCount == 0}">
                <tr>
              </c:when>
              <c:otherwise>
                </tr><tr>
              </c:otherwise>
            </c:choose>
          </c:if>

          <c:choose>
            <c:when test="${field.valueHasDisplayer}">
              <td>${field.name} <im:typehelp type="${field.pathString}"/></td>
              <td><strong>
                <!-- pass value to displayer -->
                <c:set var="interMineObject" value="${object.object}" scope="request"/>
                  <tiles:insert page="${field.displayerPage}">
                    <tiles:put name="expr" value="${field.name}" />
                  </tiles:insert>
              </strong></td>
              <c:set var="tableCount" value="${tableCount+1}" scope="page" />
            </c:when>
            <c:otherwise>
              <c:if test="${!field.doNotTruncate}">
                <td>${field.name} <im:typehelp type="${field.pathString}"/></td>
                <td><strong>${field.value}</strong></td>
                <c:set var="tableCount" value="${tableCount+1}" scope="page" />
              </c:if>
            </c:otherwise>
          </c:choose>
      </c:forEach>
    </table>

    <%-- summary long fields --%>
    <table>
      <c:forEach var="field" items="${object.objectSummaryFields}">
        <c:if test="${field.doNotTruncate}">
          <tr>
            <td>${field.name} <im:typehelp type="${field.pathString}"/></td>
            <td><strong>${field.value}</strong></td>
          </tr>
        </c:if>
      </c:forEach>
    </table>

    <%-- header Inline Lists --%>
    <c:if test="${object.hasHeaderInlineLists}">
      <div class="box">
        <tiles:insert page="/reportHeaderInlineLists.jsp">
          <tiles:put name="object" beanName="object" />
        </tiles:insert>
      </div>
    </c:if>

  </div>
</div>

<div id="content">

<c:if test="${categories != null}">
  <div id="menu-target">&nbsp;</div>
  <div id="toc-menu-wrap">
    <tiles:insert name="reportMenu.jsp" />
  </div>
  <div id="fixed-menu">
    <tiles:insert name="reportMenu.jsp" />
  </div>
  <script type="text/javascript">
    jQuery('#fixed-menu').hide(); // hide for IE7
    jQuery(window).scroll(function() {
      if (jQuery('#menu-target').isInView('partial')) {
        jQuery('#fixed-menu').hide();
      } else {
        jQuery('#fixed-menu').show();
      }
    });

    if (jQuery(window).width() < '900') {
      jQuery('div.wrap').each(function(index) {
          jQuery(this).addClass('smallscreen');
      });
    }
  </script>
</c:if>

<div class="container_12">

 <c:set value="${fn:length(CATEGORIES)}" var="aspectCount" /> <c:set
  var="templateIdPrefix" value="reportTemplate${objectType}" /> <c:set
  var="miscId" value="reportMisc${objectType}" /> <%-- All other references and collections --%>
<script type="text/javascript">
      <!--//<![CDATA[
        var modifyDetailsURL = '<html:rewrite action="/modifyDetails"/>';
        var detailsType = 'object';
      //]]>-->
      </script> <script type="text/javascript" src="js/inlinetemplate.js"></script>

<div style="float:right;" class="box grid_3">
  <div id="in-lists">
    <tiles:insert name="reportInList.tile">
      <tiles:put name="object" beanName="object"/>
    </tiles:insert>
  </div>

  <c:set var="object_bk" value="${object}"/>
  <c:set var="object" value="${reportObject.object}" scope="request"/>
  <tiles:insert name="otherMinesLink.tile" />
  <tiles:insert name="attributeLinks.tile" />
  <c:set var="object" value="${object_bk}"/>
</div>

<div class="box grid_9">
  <tiles:insert page="/reportCustomDisplayers.jsp">
    <tiles:put name="placement" value="summary" />
    <tiles:put name="reportObject" beanName="object" />
  </tiles:insert>
<%--
  <tiles:insert
    page="/reportDisplayers.jsp">
    <tiles:put name="placement" value="" />
    <tiles:put name="reportObject" beanName="object" />
    <tiles:put name="heading" value="true" />
  </tiles:insert>
--%>
  <c:forEach items="${categories}" var="aspect" varStatus="status">
    <tiles:insert name="reportAspect.tile">
    <tiles:put name="mapOfInlineLists" beanName="mapOfInlineLists" />
    <tiles:put name="placement" value="im:aspect:${aspect}" />
    <tiles:put name="reportObject" beanName="object" />
    <tiles:put name="trail" value="${request.trail}" />
    <tiles:put name="aspectId" value="${templateIdPrefix}${status.index}" />
    <tiles:put name="opened" value="${status.index == 0}" />
  </tiles:insert>
  </c:forEach>

  <c:if test="${categories != null}">
    <c:if test="${fn:length(placementRefsAndCollections['im:aspect:Miscellaneous']) > 0 || fn:length(listOfUnplacedInlineLists) > 0}">
      <div class="clear">&nbsp;</div>
      <a name="other"><h2>Other</h2></a>
    </c:if>
  </c:if>
  <tiles:insert page="/reportUnplacedInlineLists.jsp">
    <tiles:put name="listOfUnplacedInlineLists" beanName="listOfUnplacedInlineLists" />
  </tiles:insert>

  <tiles:insert page="/reportRefsCols.jsp">
    <tiles:put name="object" beanName="object" />
    <tiles:put name="placement" value="im:aspect:Miscellaneous" />
  </tiles:insert>
</div>

</div>

</div>