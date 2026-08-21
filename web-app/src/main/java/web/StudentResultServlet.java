package web;

import common.ExamResult;
import common.ExamResultService;
import common.Student;
import common.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Student result view servlet.
 * SECURITY: Students can only view their OWN results.
 * The student identity is taken from the session — never from URL parameters.
 */
@WebServlet("/student/results")
public class StudentResultServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            ExamResultService service = RMIClientManager.getService();

            // Security: look up student by SESSION email — not by URL param
            Student student = service.getStudentByEmail(user.getEmail());
            req.setAttribute("student", student);

            if (student != null) {
                List<ExamResult> results = service.getStudentResults(student.getId());
                req.setAttribute("results", results);

                if (!results.isEmpty()) {
                    double totalObtained = results.stream()
                        .mapToDouble(ExamResult::getMarks).sum();
                    double totalPossible = results.stream()
                        .mapToDouble(ExamResult::getTotalMarks).sum();
                    double avg = service.calculateAverage(results);
                    String grade = service.calculateOverallGrade(avg);
                    double cgpa = service.calculateCGPA(results);

                    req.setAttribute("totalObtained", totalObtained);
                    req.setAttribute("totalPossible",  totalPossible);
                    req.setAttribute("average",        avg);
                    req.setAttribute("overallGrade",   grade);
                    req.setAttribute("overallStatus",  avg >= 50.0 ? "PASS" : "FAIL");
                    req.setAttribute("cgpa",           cgpa);
                }
            }

        } catch (RuntimeException e) {
            req.setAttribute("rmiError", "RMI server unavailable.");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load results.");
        }
        req.getRequestDispatcher("/WEB-INF/views/student/results.jsp").forward(req, resp);
    }
}
