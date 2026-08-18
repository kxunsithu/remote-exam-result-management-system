package web;

import common.ExamResultService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Admin dashboard servlet — shows statistics and recent results.
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ExamResultService service = RMIClientManager.getService();
            req.setAttribute("totalStudents", service.getTotalStudents());
            req.setAttribute("totalSubjects", service.getTotalSubjects());
            req.setAttribute("totalResults",  service.getTotalResults());
            req.setAttribute("recentResults", service.getRecentResults(10));
        } catch (RuntimeException e) {
            req.setAttribute("rmiError", "RMI server unavailable: " + e.getMessage());
        } catch (Exception e) {
            req.setAttribute("rmiError", "Failed to load dashboard data.");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
