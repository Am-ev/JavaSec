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

