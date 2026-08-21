package web;

import common.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Security filter that enforces authentication and role-based access control.
 *
 * <p>Protected paths:
 * <ul>
 *   <li>/admin/* — requires ADMIN role</li>
 *   <li>/student/* — requires STUDENT role</li>
 * </ul>
 * </p>
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();

        // Allow public resources
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Role-based access
        if (path.startsWith("/admin/") && !"ADMIN".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Access denied. Admin role required.");
            return;
        }

        if (path.startsWith("/student/") && !"STUDENT".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Access denied. Student role required.");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/login")
            || path.equals("/logout")
            || path.equals("/register")
            || path.equals("/welcome")
            || path.equals("/index.jsp")
            || path.equals("/")
            || path.startsWith("/assets/")
            || path.endsWith(".css")
            || path.endsWith(".js")
            || path.endsWith(".png")
            || path.endsWith(".ico")
            || path.endsWith(".jpg");
    }
}
