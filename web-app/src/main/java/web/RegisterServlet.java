package web;

import common.ExamResultService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Handles new student account registration.
 * GET  = show registration form
 * POST = process registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirmPassword");

        // Validation
        if (email == null || email.isBlank() ||
            password == null || password.isBlank() ||
            confirm == null || confirm.isBlank()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!email.contains("@")) {
            req.setAttribute("error", "Please enter a valid email address.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        try {
            ExamResultService service = RMIClientManager.getService();
            boolean success = service.registerStudent(email.trim(), password);

            if (success) {
                req.setAttribute("success", "Account created successfully. You can now login.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Email already registered. Please use a different email.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (RuntimeException e) {
            req.setAttribute("error", "Service unavailable. Please ensure the RMI server is running.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
