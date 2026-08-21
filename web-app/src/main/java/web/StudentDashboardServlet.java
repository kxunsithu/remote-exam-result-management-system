package web;

import common.ExamResultService;
import common.Student;
import common.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Student dashboard servlet.
 * Shows student profile info and summary statistics.
 */
@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            ExamResultService service = RMIClientManager.getService();
            // Find the student record by email (session-bound)
            Student student = service.getStudentByEmail(user.getEmail());
            req.setAttribute("student", student);

            if (student != null) {
                var results = service.getStudentResults(student.getId());
                req.setAttribute("results", results);
                req.setAttribute("totalResults", results.size());

                if (!results.isEmpty()) {
                    double avg  = service.calculateAverage(results);
                    String grade = service.calculateOverallGrade(avg);
                    double cgpa  = service.calculateCGPA(results);
                    req.setAttribute("average",      avg);
                    req.setAttribute("overallGrade", grade);
                    req.setAttribute("overallStatus", avg >= 50.0 ? "PASS" : "FAIL");
                    req.setAttribute("cgpa",         cgpa);
                }
            }

        } catch (RuntimeException e) {
            req.setAttribute("rmiError", "RMI server unavailable.");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load dashboard data.");
        }
        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }
}
