package web;

import common.ExamResultService;
import common.Subject;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Admin Subject Management servlet.
 * Subjects are created standalone (no academic year / semester input).
 * They are attached to semesters later from the academic year page.
 *
 * GET  /admin/subjects            — list all subjects (with optional search / semester filter)
 * GET  /admin/subjects?action=edit&id=X — show edit form
 * POST /admin/subjects?action=add        — add subject
 * POST /admin/subjects?action=update     — update subject
 * POST /admin/subjects?action=delete     — delete subject
 */
@WebServlet("/admin/subjects")
public class SubjectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action    = req.getParameter("action");
        String keyword   = req.getParameter("search");
        String semFilter = req.getParameter("semesterId");

        try {
            ExamResultService service = RMIClientManager.getService();

            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Subject subject = service.getSubjectById(id);
                if (subject == null) {
                    req.setAttribute("error", "Subject not found.");
                } else {
                    req.setAttribute("editSubject", subject);
                }
            }

            java.util.List<Subject> subjects;
            if (keyword != null && !keyword.isBlank()) {
                subjects = service.searchSubjects(keyword);
                req.setAttribute("searchKeyword", keyword);
            } else if (semFilter != null && !semFilter.isBlank()) {
                subjects = service.getSubjectsBySemester(Integer.parseInt(semFilter));
                req.setAttribute("filterSemesterId", semFilter);
            } else {
                subjects = service.getAllSubjects();
            }
            req.setAttribute("subjects", subjects);

        } catch (RuntimeException e) {
            req.setAttribute("rmiError", "RMI server unavailable.");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load subjects.");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/subjects.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            ExamResultService service = RMIClientManager.getService();

            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                boolean ok = service.deleteSubject(id);
                setFlash(req, ok, "Subject deleted successfully.", "Failed to delete subject.");
                resp.sendRedirect(req.getContextPath() + "/admin/subjects");
                return;
            }

            Subject subject = buildSubjectFromRequest(req);

            if ("add".equals(action)) {
                boolean ok = service.addSubject(subject);
                setFlash(req, ok, "ဘာသာရပ် အသစ် ထည့်သွင်းပြီးပါပြီ။", "ဘာသာရပ် ထည့်သွင်းမှု မအောင်မြင်ပါ။");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                subject.setId(id);
                boolean ok = service.updateSubject(subject);
                setFlash(req, ok, "ဘာသာရပ် ပြင်ဆင်ပြီးပါပြီ။", "ဘာသာရပ် ပြင်ဆင်မှု မအောင်မြင်ပါ။");
            }

        } catch (RuntimeException e) {
            req.getSession().setAttribute("flashError", "RMI server unavailable: " + e.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage() != null ? e.getMessage() : "An error occurred.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/subjects");
    }

    private Subject buildSubjectFromRequest(HttpServletRequest req) {
        Subject s = new Subject();
        s.setSubjectCode(req.getParameter("subjectCode"));
        s.setSubjectName(req.getParameter("subjectName"));
        String credit = req.getParameter("credit");
        if (credit != null && !credit.isBlank()) s.setCredit(Integer.parseInt(credit));
        s.setDepartment(req.getParameter("department"));
        // No academic year / semester here — assignment happens on the academics page
        return s;
    }

    private void setFlash(HttpServletRequest req, boolean ok, String successMsg, String errorMsg) {
        HttpSession session = req.getSession();
        if (ok) session.setAttribute("flashSuccess", successMsg);
        else    session.setAttribute("flashError", errorMsg);
    }
}
