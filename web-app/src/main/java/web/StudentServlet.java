package web;

import common.ExamResultService;
import common.Student;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;

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
            req.setAttribute("rmiError", "RMI server unavailable.");
        } catch (Exception e) {
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
                setFlash(req, ok, "Student deleted successfully.", "Failed to delete student.");
                resp.sendRedirect(req.getContextPath() + "/admin/students");
                return;
            }

            Student student = buildStudentFromRequest(req);

            if ("add".equals(action)) {
                boolean ok = service.addStudent(student);
                setFlash(req, ok, "Student added successfully.", "Failed to add student. Student ID or email may already exist.");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                student.setId(id);
                boolean ok = service.updateStudent(student);
                setFlash(req, ok, "Student updated successfully.", "Failed to update student.");
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
        String dob = req.getParameter("dateOfBirth");
        if (dob != null && !dob.isBlank()) {
            s.setDateOfBirth(LocalDate.parse(dob));
        }
        s.setDepartment(req.getParameter("department"));
        String yearStr = req.getParameter("year");
        if (yearStr != null && !yearStr.isBlank()) {
            s.setYear(Integer.parseInt(yearStr));
        }
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
