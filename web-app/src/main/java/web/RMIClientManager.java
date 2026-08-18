package web;

import common.ExamResultService;

import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.NotBoundException;
import java.net.MalformedURLException;

/**
 * Singleton manager for the RMI client connection.
 *
 * <p>The web application uses this class to obtain the remote ExamResultService
 * stub. The stub is looked up from the RMI registry running on localhost:1099.</p>
 */
public class RMIClientManager {

    private static final String RMI_URL = "rmi://localhost:1099/ExamResultService";
    private static ExamResultService serviceStub = null;

    private RMIClientManager() {}

    /**
     * Returns a cached or freshly looked-up ExamResultService stub.
     * Reconnects automatically if the stub becomes stale.
     *
     * @return the remote ExamResultService stub
     * @throws RuntimeException if the RMI server is unreachable
     */
    public static synchronized ExamResultService getService() {
        if (serviceStub == null) {
            serviceStub = lookupService();
        }
        return serviceStub;
    }

    /**
     * Forces a fresh lookup — useful after RMI server restarts.
     */
    public static synchronized void reset() {
        serviceStub = null;
    }

    private static ExamResultService lookupService() {
        try {
            return (ExamResultService) Naming.lookup(RMI_URL);
        } catch (NotBoundException e) {
            throw new RuntimeException("ExamResultService is not bound in RMI registry. " +
                "Please start the RMI server first.", e);
        } catch (MalformedURLException e) {
            throw new RuntimeException("Invalid RMI URL: " + RMI_URL, e);
        } catch (RemoteException e) {
            throw new RuntimeException("Cannot connect to RMI server at " + RMI_URL +
                ". Please ensure the RMI server is running.", e);
        }
    }
}
