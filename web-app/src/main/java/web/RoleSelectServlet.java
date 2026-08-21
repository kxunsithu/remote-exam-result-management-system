package web;

import common.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Landing page: asks the user to pick a role (Admin / Student)
 * before going to login or register.
 */
@WebServlet("/welcome")
public class RoleSelectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, skip selection and go to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String ctx = req.getContextPath();
            if ("ADMIN".equals(user.getRole())) {
                resp.sendRedirect(ctx + "/admin/dashboard");
            } else {
                resp.sendRedirect(ctx + "/student/dashboard");
            }
            return;
        }
        req.getRequestDispatcher("/role-select.jsp").forward(req, resp);
    }
}
