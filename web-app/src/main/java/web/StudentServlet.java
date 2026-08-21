package web;

import common.ExamResultService;
import common.Student;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Admin Student Management servlet.
 * GET  /admin/students           — list all students (with optional search)
 * GET  /admin/students?action=edit&id=X   — show edit form
 * POST /admin/students?action=add         — add student
 * POST /admin/students?action=update      — update student
 * POST /admin/students?action=delete      — delete student
 */
@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action  = req.getParameter("action");
        String keyword = req.getParameter("search");

        try {
            ExamResultService service = RMIClientManager.getService();

            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Student student = service.getStudentById(id);
                if (student == null) {
                    req.setAttribute("error", "Student not found.");
                } else {
                    req.setAttribute("editStudent", student);
                }
            }

            // Always load student list
            if (keyword != null && !keyword.isBlank()) {
                req.setAttribute("students", service.searchStudents(keyword));
                req.setAttribute("searchKeyword", keyword);
            } else {
                req.setAttribute("students", service.getAllStudents());
            }

        } catch (RuntimeException e) {
            System.err.println("StudentServlet RMI error: " + e.getMessage());
            req.setAttribute("rmiError", "RMI server unavailable.");
        } catch (Exception e) {
            System.err.println("StudentServlet doGet error: " + e.getMessage());
            req.setAttribute("error", "Failed to load students.");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/students.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            ExamResultService service = RMIClientManager.getService();

            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                boolean ok = service.deleteStudent(id);
                setFlash(req, ok, "ကျောင်းသား ပယ်ဖျက်ပြီးပါပြီ။", "ကျောင်းသား ပယ်ဖျက်၍ မရပါ။");
                resp.sendRedirect(req.getContextPath() + "/admin/students");
                return;
            }

            Student student = buildStudentFromRequest(req);

            if ("add".equals(action)) {
                boolean ok = service.addStudent(student);
                setFlash(req, ok, "ကျောင်းသားအချက်အလက် အသစ် ထည့်သွင်းပြီးပါပြီ။", "ကျောင်းသား ထည့်သွင်း၍ မရပါ။ ခုံနံပါတ် (Roll Number) သို့မဟုတ် အီးမေးလ် ရှိနှင့်ပြီးဖြစ်ပါသည်။");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                student.setId(id);
                boolean ok = service.updateStudent(student);
                setFlash(req, ok, "ကျောင်းသားအချက်အလက် ပြင်ဆင်ပြီးပါပြီ။", "ကျောင်းသား ပြင်ဆင်၍ မရပါ။");
            }

        } catch (RuntimeException e) {
            req.getSession().setAttribute("flashError", "RMI server unavailable: " + e.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage() != null ? e.getMessage() : "An error occurred.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/students");
    }

    private Student buildStudentFromRequest(HttpServletRequest req) {
        Student s = new Student();
        s.setStudentId(req.getParameter("studentId"));
        s.setName(req.getParameter("name"));
        s.setEmail(req.getParameter("email"));
        s.setPhone(req.getParameter("phone"));
        s.setGender(req.getParameter("gender"));
        return s;
    }

    private void setFlash(HttpServletRequest req, boolean ok, String successMsg, String errorMsg) {
        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("flashSuccess", successMsg);
        } else {
            session.setAttribute("flashError", errorMsg);
        }
    }
}
