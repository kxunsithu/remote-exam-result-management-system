package web;

import common.ExamResultService;
import common.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles user login (GET = show form, POST = process login).
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, redirect to appropriate dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectAfterLogin(user, resp);
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        // Basic input validation
        if (email == null || email.isBlank() ||
            password == null || password.isBlank() ||
            role == null || role.isBlank()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            ExamResultService service = RMIClientManager.getService();
            User user = service.login(email.trim(), password, role.toUpperCase().trim());

            if (user == null) {
                req.setAttribute("error", "Invalid email, password, or role.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // Create session
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            redirectAfterLogin(user, resp);

        } catch (RuntimeException e) {
            req.setAttribute("error", "Service unavailable. Please ensure the RMI server is running.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "An unexpected error occurred. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void redirectAfterLogin(User user, HttpServletResponse resp) throws IOException {
        String ctx = "";
        if ("ADMIN".equals(user.getRole())) {
            resp.sendRedirect(ctx + "/admin/dashboard");
        } else {
            resp.sendRedirect(ctx + "/student/dashboard");
        }
    }
}
