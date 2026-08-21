package server;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.ExportException;

/**
 * RMI Server main class.
 *
 * <p>Starts or connects to the RMI registry on port 1099, initializes the database,
 * and binds the ExamResultService implementation.</p>
 *
 * <p>Start command:
 * {@code cd rmi-server && mvn exec:java -Dexec.mainClass="server.RMIServer"}
 * </p>
 */
public class RMIServer {

    private static final int    RMI_PORT     = 1099;
    private static final String SERVICE_NAME = "ExamResultService";

    public static void main(String[] args) {
        System.out.println("=======================================================");
        System.out.println("  Remote Exam Result Management System — RMI Server    ");
        System.out.println("=======================================================");

        try {
            // Fix RMI hostname binding on Linux where the machine hostname often
            // resolves to 127.0.1.1 instead of 127.0.0.1, causing "Connection refused"
            // when clients try to invoke remote methods after a successful registry lookup.
            System.setProperty("java.rmi.server.hostname", "127.0.0.1");

            // 1. Initialize database (creates tables + sample data)
            DatabaseInitializer.initialize();

            // 2. Create or obtain RMI registry
            Registry registry;
            try {
                registry = LocateRegistry.createRegistry(RMI_PORT);
                System.out.println("RMI Registry started on port " + RMI_PORT + ".");
            } catch (ExportException e) {
                registry = LocateRegistry.getRegistry(RMI_PORT);
                System.out.println("Using existing RMI Registry on port " + RMI_PORT + ".");
            }

            // 3. Create and bind service implementation
            ExamResultServiceImpl service = new ExamResultServiceImpl();
            registry.rebind(SERVICE_NAME, service);
            System.out.println("ExamResultService bound successfully.");

            System.out.println("RMI Server is ready.");
            System.out.println("=======================================================");
            System.out.println("  Listening on port " + RMI_PORT + " — press Ctrl+C to stop");
            System.out.println("=======================================================");

            // Keep server alive
            Thread.currentThread().join();

        } catch (Exception e) {
            System.err.println("RMI Server failed to start: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
