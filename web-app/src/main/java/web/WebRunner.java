package web;

import org.apache.catalina.startup.Tomcat;

import java.io.File;

/**
 * Embedded Tomcat server launcher for running the web application.
 *
 * <p>Start command:
 * {@code cd web-app && mvn exec:java -Dexec.mainClass="web.WebRunner"}
 * or from root:
 * {@code mvn exec:java -pl web-app}
 * </p>
 */
public class WebRunner {

    private static final int PORT = 8080;
    private static final String CONTEXT_PATH = "/remote-exam-result-management-system";

    public static void main(String[] args) {
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

            // Initialize default HTTP connector
            tomcat.getConnector();

            // Add web application context
            tomcat.addWebapp(CONTEXT_PATH, webappFile.getAbsolutePath());

            System.out.println("Starting Apache Tomcat 10 on port " + PORT + "...");
            System.out.println("Context URL: http://localhost:" + PORT + CONTEXT_PATH + "/");
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
