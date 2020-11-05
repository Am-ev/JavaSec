# Tomcat 
-[Tomcat类加载机制](#Tomcat类加载机制)

-[如何破坏JAVA原有的类加载机制](#如何破坏JAVA原有的类加载机制)

### Tomcat类加载机制

由于传统的双亲委派机制并不适用于多个WebApp的情况，因而Tomcat的类加载机制并非传统的双亲委派机制。
当不同的Webapp需要加载版本不一致的依赖时，由于全限定名相同，无法同时加载，如果使用双亲委派机制，那么在加载一个类的时候，会先去父类加载器进行加载，因此需对各个Webapp进行隔离。
Tomcat实现隔离的方式是，每个Webapp拥有独立的ClassLoader实例，来优先处理加载，并不会传递给父加载器。这个定制的ClassLoader就是**WebappClassLoader**。



### 如何破坏JAVA原有的类加载机制

当上层的ClassLoader需要调用下层的ClassLoader时，需要使用**Thread Context ClassLoader**(线程上下文类加载器)。
在Thread类中有getContextClassLoader()以及setContextClassLoader(ClassLoader cl)方法，用以获取和设置上下文类加载器。
如果没有使用setContextClassLoader()方法来设置类加载器，那么线程将继承父线程的上下文类加载器；
如果在应用程序的全局范围内都没有设置类加载器的情况下，**那么该上下文类加载器默认就是应用程序的类加载器**。
对于Tomcat来说，ContextClassLoader被设置为WebAppClassLoader(在一些框架中可能是继承了Public abstract WebappClassLoaderBase的其他加载器)。



### Tomat组件间的联系

一个Server可启动多个Service，其中Service可由多个Connector与Engine包装而成。
Connector含有三个部分：
    Endpoint负责处理网络请求，读取字节码。
    Processor负责完成应用层的协议解析，如HTTP/1.1或AJP/1.3。
    Adaptor负责将解析后的Tomcat Request/Response对象转化为Servlet Request/Response对象。

而后，交由Container进行处理：Container可拥有多个Host：
    Host代表不同的虚拟主机，可承担处理多个域名的服务
    在Host中，Context代表不同的应用，与应用的/WEB-INF/web.xml相对应
    在Context中，不同的Wrapper代表不同的Servlet。
    
 
 ### 创建Context方式
 
 1.通过在appbase(默认为webapps)中新建目录完成
 2.通过Server.xml，增添Context元素创建
 
 
 ### 控制回显
 （寻找request、response对象、当前运行的代码与Tomcat上下文环境之间的关系）https://zhuanlan.zhihu.com/p/114625962
 WebappClassLoaderBase -->  StandardServer --> StandardService --> ApplicationContext --> Connectors --> AbstractProtocol$connector --> RequestGroupInfo --> req --> response
 
 
