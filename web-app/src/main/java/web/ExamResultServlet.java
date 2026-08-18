package web;

import common.ExamResult;
import common.ExamResultService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Admin Exam Result Management servlet.
 * GET  /admin/results             — list/search results
 * GET  /admin/results?action=edit&id=X — show edit form
 * POST /admin/results?action=add         — add result
 * POST /admin/results?action=update      — update result
 * POST /admin/results?action=delete      — delete result
 */
@WebServlet("/admin/results")
public class ExamResultServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action      = req.getParameter("action");
        String studentId   = req.getParameter("studentId");
        String subjectId   = req.getParameter("subjectId");
        String semester    = req.getParameter("semester");
        String academicYear = req.getParameter("academicYear");

        try {
            ExamResultService service = RMIClientManager.getService();

            // Always load drop-down data for forms
            req.setAttribute("students", service.getAllStudents());
            req.setAttribute("subjects", service.getAllSubjects());

            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                ExamResult result = service.getResultById(id);
                if (result == null) {
                    req.setAttribute("error", "Result not found.");
                } else {
                    req.setAttribute("editResult", result);
                }
            }

            // Filter or list all
            boolean hasFilter = (studentId != null && !studentId.isBlank())
                             || (subjectId != null && !subjectId.isBlank())
                             || (semester != null && !semester.isBlank())
                             || (academicYear != null && !academicYear.isBlank());

            if (hasFilter) {
                req.setAttribute("results", service.searchResults(studentId, subjectId, semester, academicYear));
                req.setAttribute("filterStudentId", studentId);
                req.setAttribute("filterSubjectId", subjectId);
                req.setAttribute("filterSemester", semester);
                req.setAttribute("filterAcademicYear", academicYear);
            } else {
                req.setAttribute("results", service.getAllResults());
            }

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

        try {
            ExamResultService service = RMIClientManager.getService();

            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                boolean ok = service.deleteExamResult(id);
                setFlash(req, ok, "Result deleted successfully.", "Failed to delete result.");
                resp.sendRedirect(req.getContextPath() + "/admin/results");
                return;
            }

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

        } catch (RuntimeException e) {
            req.getSession().setAttribute("flashError", "RMI server unavailable: " + e.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage() != null ? e.getMessage() : "An error occurred.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/results");
    }

    private ExamResult buildResultFromRequest(HttpServletRequest req) {
        ExamResult r = new ExamResult();
        String sId = req.getParameter("studentId");
        String subjId = req.getParameter("subjectId");
        String marks = req.getParameter("marks");
        String totalMarks = req.getParameter("totalMarks");
        String semester = req.getParameter("semester");

        if (sId != null && !sId.isBlank())     r.setStudentId(Integer.parseInt(sId));
        if (subjId != null && !subjId.isBlank()) r.setSubjectId(Integer.parseInt(subjId));
        if (marks != null && !marks.isBlank())  r.setMarks(Double.parseDouble(marks));
        if (totalMarks != null && !totalMarks.isBlank()) r.setTotalMarks(Double.parseDouble(totalMarks));
        r.setAcademicYear(req.getParameter("academicYear"));
        if (semester != null && !semester.isBlank()) r.setSemester(Integer.parseInt(semester));
        // Grade is calculated server-side; leave it null here
        return r;
    }

    private void setFlash(HttpServletRequest req, boolean ok, String successMsg, String errorMsg) {
        HttpSession session = req.getSession();
        if (ok) session.setAttribute("flashSuccess", successMsg);
        else     session.setAttribute("flashError", errorMsg);
    }
}
