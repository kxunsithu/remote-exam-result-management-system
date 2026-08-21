package web;

import common.ExamResult;
import common.ExamResultService;
import common.Student;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Admin Exam Result Management servlet.
 * GET  /admin/results                          — list all results (student-grouped)
 * GET  /admin/results?action=studentDetail&studentId=X — show per-student detail page
 * POST /admin/results?action=add               — add result
 * POST /admin/results?action=update            — update result
 * POST /admin/results?action=delete            — delete result
 */
@WebServlet("/admin/results")
public class ExamResultServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action      = req.getParameter("action");
        String studentId   = req.getParameter("studentId");

        try {
            ExamResultService service = RMIClientManager.getService();

            // ── Student Detail View ────────────────────────────────────────
            if ("studentDetail".equals(action) && studentId != null && !studentId.isBlank()) {
                int sDbId = Integer.parseInt(studentId);
                Student student = service.getStudentById(sDbId);
                List<ExamResult> studentResults = service.getStudentResults(sDbId);
                req.setAttribute("studentInfo", student);
                req.setAttribute("studentResults", studentResults);
                // Dropdown data for the add-result modal (Academic Year -> Semester -> Subject)
                req.setAttribute("students", service.getAllStudents());
                req.setAttribute("subjects", service.getAllSubjects());
                req.setAttribute("academicYears", service.getAllAcademicYears());
                req.setAttribute("semesters", service.getAllSemesters());
                req.getRequestDispatcher("/WEB-INF/views/admin/student-result-detail.jsp").forward(req, resp);
                return;
            }

            // ── Default: Student-Grouped Results List ──────────────────────
            String keyword = req.getParameter("search");
            if (keyword != null && !keyword.isBlank()) {
                req.setAttribute("students", service.searchStudents(keyword));
                req.setAttribute("searchKeyword", keyword);
            } else {
                req.setAttribute("students", service.getAllStudents());
            }

            req.setAttribute("subjects", service.getAllSubjects());
            req.setAttribute("results", service.getAllResults());

        } catch (RuntimeException e) {
            req.setAttribute("rmiError", "RMI server unavailable.");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load results.");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/results.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String studentIdParam = req.getParameter("studentId");

        try {
            ExamResultService service = RMIClientManager.getService();

            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                boolean ok = service.deleteExamResult(id);
                setFlash(req, ok, "Result deleted successfully.", "Failed to delete result.");
            } else {
                ExamResult result = buildResultFromRequest(req);

                if ("add".equals(action)) {
                    boolean ok = service.addExamResult(result);
                    setFlash(req, ok, "Exam result added successfully.", "Failed to add result. Check marks and input values.");
                } else if ("update".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    result.setId(id);
                    boolean ok = service.updateExamResult(result);
                    setFlash(req, ok, "Exam result updated successfully.", "Failed to update result.");
                }
            }

        } catch (RuntimeException e) {
            req.getSession().setAttribute("flashError", "RMI server unavailable: " + e.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage() != null ? e.getMessage() : "An error occurred.");
        }

        if (studentIdParam != null && !studentIdParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin/results?action=studentDetail&studentId=" + studentIdParam);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/results");
        }
    }

    private ExamResult buildResultFromRequest(HttpServletRequest req) {
        ExamResult r = new ExamResult();
        String sId = req.getParameter("studentId");
        String subjId = req.getParameter("subjectId");
        String marks = req.getParameter("marks");
        String totalMarks = req.getParameter("totalMarks");

        if (sId != null && !sId.isBlank())     r.setStudentId(Integer.parseInt(sId));
        if (subjId != null && !subjId.isBlank()) r.setSubjectId(Integer.parseInt(subjId));
        if (marks != null && !marks.isBlank())  r.setMarks(Double.parseDouble(marks));
        if (totalMarks != null && !totalMarks.isBlank()) r.setTotalMarks(Double.parseDouble(totalMarks));
        // Academic year & semester are derived from the subject on the server
        String examType = req.getParameter("examType");
        if (examType != null && !examType.isBlank()) r.setExamType(examType.trim());
        // Grade is calculated server-side; leave it null here
        return r;
    }

    private void setFlash(HttpServletRequest req, boolean ok, String successMsg, String errorMsg) {
        HttpSession session = req.getSession();
        if (ok) session.setAttribute("flashSuccess", successMsg);
        else     session.setAttribute("flashError", errorMsg);
    }
}
