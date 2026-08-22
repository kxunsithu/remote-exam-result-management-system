package web;

import org.apache.catalina.Context;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

/**
 * Embedded Tomcat server launcher for running the web application.
 *
 * <p>Start command:
 * {@code cd web-app && mvn exec:java}
 * </p>
 */
public class WebRunner {

    private static final int PORT = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));
    private static final String CONTEXT_PATH = "";

    public static void main(String[] args) {
        System.setProperty("file.encoding", "UTF-8");

        System.out.println("=======================================================");
        System.out.println("  Remote Exam Result Management System — Web Server    ");
        System.out.println("=======================================================");

        try {
            // Determine webapp directory
            String webappDir = "web-app/src/main/webapp";
            if (!new File(webappDir).exists()) {
                webappDir = "src/main/webapp";
            }
            File webappFile = new File(webappDir);
            if (!webappFile.exists()) {
                throw new RuntimeException("Webapp directory not found at: " + webappFile.getAbsolutePath());
            }

            // Create temp base directory
            String baseDir = "target/tomcat";
            new File(baseDir).mkdirs();

            Tomcat tomcat = new Tomcat();
            tomcat.setPort(PORT);
            tomcat.setBaseDir(baseDir);

            // Initialize default HTTP connector with UTF-8
            tomcat.getConnector().setURIEncoding("UTF-8");

            // Add web application context
            Context ctx = tomcat.addWebapp(CONTEXT_PATH, webappFile.getAbsolutePath());
            ctx.setParentClassLoader(WebRunner.class.getClassLoader());

            // Mount compiled classes to WEB-INF/classes so Tomcat can find @WebServlet annotations
            String classesDir = "web-app/target/classes";
            if (!new File(classesDir).exists()) {
                classesDir = "target/classes";
            }
            File additionWebInfClasses = new File(classesDir);
            if (additionWebInfClasses.exists()) {
                WebResourceRoot resources = new StandardRoot(ctx);
                resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                        additionWebInfClasses.getAbsolutePath(), "/"));
                ctx.setResources(resources);
            }

            System.out.println("Starting Apache Tomcat 11 on port " + PORT + "...");
            System.out.println("Web App URL: http://localhost:" + PORT + "/");
            System.out.println("=======================================================");

            tomcat.start();
            System.out.println("Web Application is ready!");
            tomcat.getServer().await();

        } catch (Exception e) {
            System.err.println("Failed to start Embedded Tomcat: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
