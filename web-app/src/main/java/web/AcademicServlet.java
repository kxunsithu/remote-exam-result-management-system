package web;

import common.AcademicYear;
import common.ExamResultService;
import common.Semester;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * Admin Academic Year & Semester Management servlet.
 *
 * Workflow: Step 1 — create subjects (see /admin/subjects),
 * Step 2 — add academic year, Step 3 — add semesters to that year,
 * Step 4 — attach existing subjects to each semester.
 *
 * GET  /admin/academics                          — list years with nested semesters
 * POST /admin/academics?action=addYear           — add academic year
 * POST /admin/academics?action=updateYear        — rename academic year
 * POST /admin/academics?action=deleteYear        — delete academic year
 * POST /admin/academics?action=addSemester       — add semester to a year
 * POST /admin/academics?action=updateSemester    — change semester number
 * POST /admin/academics?action=deleteSemester    — delete semester
 * POST /admin/academics?action=attachSubjects    — assign existing subjects to a semester
 * POST /admin/academics?action=detachSubject     — remove a subject from its semester
 */
@WebServlet("/admin/academics")
public class AcademicServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ExamResultService service = RMIClientManager.getService();
            List<AcademicYear> years = service.getAllAcademicYears();
            List<Semester> semesters = service.getAllSemesters();

            // Group semesters under their academic year
            java.util.Map<Integer, java.util.List<Semester>> semsByYear = new java.util.LinkedHashMap<>();
            for (Semester s : semesters) {
                semsByYear.computeIfAbsent(s.getAcademicYearId(), k -> new java.util.ArrayList<>()).add(s);
            }

            // Group subjects under their semester + collect the unassigned pool
            java.util.List<common.Subject> allSubjects = service.getAllSubjects();
            java.util.Map<Integer, java.util.List<common.Subject>> subjectsBySemester = new java.util.LinkedHashMap<>();
            java.util.List<common.Subject> unassignedSubjects = new java.util.ArrayList<>();
            for (common.Subject sub : allSubjects) {
                if (sub.getSemesterId() > 0)
                    subjectsBySemester.computeIfAbsent(sub.getSemesterId(), k -> new java.util.ArrayList<>()).add(sub);
                else
                    unassignedSubjects.add(sub);
            }

            req.setAttribute("years", years);
            req.setAttribute("semsByYear", semsByYear);
            req.setAttribute("subjectsBySemester", subjectsBySemester);
            req.setAttribute("unassignedSubjects", unassignedSubjects);
            req.setAttribute("allSubjects", allSubjects);

        } catch (RuntimeException e) {
            req.setAttribute("rmiError", "RMI server unavailable.");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load academic years.");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/academics.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            ExamResultService service = RMIClientManager.getService();

            switch (action == null ? "" : action) {
                case "addYear" -> {
                    AcademicYear y = new AcademicYear();
                    y.setYearName(req.getParameter("yearName"));
                    boolean ok = service.addAcademicYear(y);
                    setFlash(req, ok, "ပညာသင်နှစ် အသစ် ထည့်သွင်းပြီးပါပြီ။", "ပညာသင်နှစ် ထည့်သွင်းမှု မအောင်မြင်ပါ။");
                }
                case "updateYear" -> {
                    AcademicYear y = new AcademicYear();
                    y.setId(Integer.parseInt(req.getParameter("id")));
                    y.setYearName(req.getParameter("yearName"));
                    boolean ok = service.updateAcademicYear(y);
                    setFlash(req, ok, "ပညာသင်နှစ် ပြင်ဆင်ပြီးပါပြီ။", "ပညာသင်နှစ် ပြင်ဆင်မှု မအောင်မြင်ပါ။");
                }
                case "deleteYear" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean ok = service.deleteAcademicYear(id);
                    setFlash(req, ok, "ပညာသင်နှစ် ဖျက်လိုက်ပါပြီ။", "ပညာသင်နှစ် ဖျက်မှု မအောင်မြင်ပါ။");
                }
                case "addSemester" -> {
                    Semester s = new Semester();
                    s.setAcademicYearId(Integer.parseInt(req.getParameter("academicYearId")));
                    s.setSemesterNumber(Integer.parseInt(req.getParameter("semesterNumber")));
                    boolean ok = service.addSemester(s);
                    setFlash(req, ok, "Semester အသစ် ထည့်သွင်းပြီးပါပြီ။", "Semester ထည့်သွင်းမှု မအောင်မြင်ပါ။");
                }
                case "updateSemester" -> {
                    Semester s = new Semester();
                    s.setId(Integer.parseInt(req.getParameter("id")));
                    s.setAcademicYearId(Integer.parseInt(req.getParameter("academicYearId")));
                    s.setSemesterNumber(Integer.parseInt(req.getParameter("semesterNumber")));
                    boolean ok = service.updateSemester(s);
                    setFlash(req, ok, "Semester ပြင်ဆင်ပြီးပါပြီ။", "Semester ပြင်ဆင်မှု မအောင်မြင်ပါ။");
                }
                case "deleteSemester" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean ok = service.deleteSemester(id);
                    setFlash(req, ok, "Semester ဖျက်လိုက်ပါပြီ။", "Semester ဖျက်မှု မအောင်မြင်ပါ။");
                }
                case "attachSubjects" -> {
                    int semesterId = Integer.parseInt(req.getParameter("semesterId"));
                    String[] ids = req.getParameterValues("subjectIds");
                    int count = 0;
                    if (ids != null && ids.length > 0) {
                        int[] subjectIds = java.util.Arrays.stream(ids)
                                .mapToInt(Integer::parseInt).toArray();
                        count = service.assignSubjectsToSemester(semesterId, subjectIds);
                        setFlash(req, true, "ဘာသာရပ် " + count + " ခု ထည့်သွင်းပြီးပါပြီ။",
                                "ဘာသာရပ် ထည့်သွင်းမှု မအောင်မြင်ပါ။");
                    } else {
                        setFlash(req, false, "", "ဘာသာရပ် အနည်းဆုံး တစ်ခု ရွေးချယ်ပါ။");
                    }
                }
                case "detachSubject" -> {
                    int subjectId = Integer.parseInt(req.getParameter("subjectId"));
                    boolean ok = service.detachSubjectFromSemester(subjectId);
                    setFlash(req, ok, "ဘာသာရပ်ကို Semester မှ ဖယ်ရှားလိုက်ပါပြီ။",
                            "ဘာသာရပ် ဖယ်ရှားမှု မအောင်မြင်ပါ။");
                }
                default -> setFlash(req, false, "", "Unknown action.");
            }

        } catch (RuntimeException e) {
            req.getSession().setAttribute("flashError", "RMI server unavailable: " + e.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage() != null ? e.getMessage() : "An error occurred.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/academics");
    }

    private void setFlash(HttpServletRequest req, boolean ok, String successMsg, String errorMsg) {
        HttpSession session = req.getSession();
        if (ok) session.setAttribute("flashSuccess", successMsg);
        else    session.setAttribute("flashError", errorMsg);
    }
}
