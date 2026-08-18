<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  request.setAttribute("pageTitle", "Exam Results");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
  java.util.List<common.ExamResult> results = (java.util.List<common.ExamResult>) request.getAttribute("results");
  java.util.List<common.Student> students   = (java.util.List<common.Student>)   request.getAttribute("students");
  java.util.List<common.Subject> subjects   = (java.util.List<common.Subject>)   request.getAttribute("subjects");
  common.ExamResult editResult              = (common.ExamResult) request.getAttribute("editResult");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Exam Results — RERMS Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body>
<div class="app-layout">
  <%@ include file="sidebar.jsp" %>
  <main class="main-content">
    <div class="page-body fade-in-up">

      <% if (flashSuccess != null) { %><div class="alert-custom alert-success-custom flash-alert"><%= flashSuccess %></div><% } %>
      <% if (flashError != null) { %><div class="alert-custom alert-danger-custom flash-alert"><%= flashError %></div><% } %>
      <% if (request.getAttribute("rmiError") != null) { %><div class="alert-custom alert-warning-custom flash-alert"><%= request.getAttribute("rmiError") %></div><% } %>

      <div class="page-header">
        <h1>Exam Results</h1>
        <button type="button" class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addResultModal">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
          Add Result
        </button>
      </div>

      <!-- Filter bar -->
      <div class="card mb-3" style="padding:1rem;">
        <form method="get" action="${pageContext.request.contextPath}/admin/results" class="search-bar">
          <select name="studentId" class="search-input">
            <option value="">All Students</option>
            <% if (students != null) for (common.Student s : students) {
              String sel = String.valueOf(s.getId()).equals(request.getAttribute("filterStudentId")) ? "selected" : ""; %>
              <option value="<%= s.getId() %>" <%= sel %>><%= s.getName() %> (<%= s.getStudentId() %>)</option>
            <% } %>
          </select>
          <select name="subjectId" class="search-input">
            <option value="">All Subjects</option>
            <% if (subjects != null) for (common.Subject sub : subjects) {
              String sel = String.valueOf(sub.getId()).equals(request.getAttribute("filterSubjectId")) ? "selected" : ""; %>
              <option value="<%= sub.getId() %>" <%= sel %>><%= sub.getSubjectName() %></option>
            <% } %>
          </select>
          <select name="semester" class="search-input">
            <option value="">All Semesters</option>
            <% for (int i = 1; i <= 8; i++) {
              String sel = String.valueOf(i).equals(request.getAttribute("filterSemester")) ? "selected" : ""; %>
              <option value="<%= i %>" <%= sel %>>Semester <%= i %></option>
            <% } %>
          </select>
          <input type="text" name="academicYear" class="search-input"
                 placeholder="Academic Year (e.g. 2024-2025)"
                 value="<%= request.getAttribute("filterAcademicYear") != null ? request.getAttribute("filterAcademicYear") : "" %>"
                 style="min-width:200px;"/>
          <button type="submit" class="btn-primary-custom" style="font-size:.82rem;">Filter</button>
          <a href="${pageContext.request.contextPath}/admin/results"
             class="btn-primary-custom" style="background:linear-gradient(135deg,#64748b,#475569);font-size:.82rem;">Reset</a>
        </form>
      </div>

      <!-- Results Table -->
      <div class="card">
        <div class="card-header-custom">
          <h5>Results (<%= results != null ? results.size() : 0 %>)</h5>
        </div>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Student</th>
                <th>Subject</th>
                <th>Marks</th>
                <th>Grade</th>
                <th>Status</th>
                <th>Semester</th>
                <th>Year</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (results != null && !results.isEmpty()) {
                 int idx = 1;
                 for (common.ExamResult r : results) {
                   String gCss  = "grade-" + r.getGrade().toLowerCase().replace("+", "plus");
                   String sCss  = "PASS".equals(r.getStatus()) ? "badge-pass" : "badge-fail";
                   double pct   = r.getTotalMarks() > 0 ? (r.getMarks() / r.getTotalMarks()) * 100 : 0;
              %>
              <tr>
                <td style="color:#94a3b8;"><%= idx++ %></td>
                <td>
                  <div style="font-weight:600;"><%= r.getStudentName() %></div>
                  <div style="font-size:.75rem;color:#64748b;"><%= r.getStudentCode() %></div>
                </td>
                <td>
                  <div><%= r.getSubjectName() %></div>
                  <div style="font-size:.75rem;color:#64748b;"><%= r.getSubjectCode() %></div>
                </td>
                <td>
                  <span style="font-weight:600;"><%= (int)r.getMarks() %></span>
                  <span style="color:#94a3b8;">/<%= (int)r.getTotalMarks() %></span>
                </td>
                <td><span class="badge-grade <%= gCss %>"><%= r.getGrade() %></span></td>
                <td><span class="<%= sCss %>"><%= r.getStatus() %></span></td>
                <td style="color:#64748b;font-size:.82rem;">Sem <%= r.getSemester() %></td>
                <td style="color:#64748b;font-size:.82rem;"><%= r.getAcademicYear() %></td>
                <td>
                  <div style="display:flex;gap:.35rem;">
                    <button type="button" class="btn-icon btn-edit" data-bs-toggle="modal"
                            data-bs-target="#editResultModal"
                            data-id="<%= r.getId() %>"
                            data-studentid="<%= r.getStudentId() %>"
                            data-subjectid="<%= r.getSubjectId() %>"
                            data-marks="<%= r.getMarks() %>"
                            data-totalmarks="<%= r.getTotalMarks() %>"
                            data-academicyear="<%= r.getAcademicYear() %>"
                            data-semester="<%= r.getSemester() %>" title="Edit">
                      <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    </button>
                    <form method="post" action="${pageContext.request.contextPath}/admin/results" style="display:inline;">
                      <input type="hidden" name="action" value="delete"/>
                      <input type="hidden" name="id" value="<%= r.getId() %>"/>
                      <button type="submit" class="btn-icon btn-delete btn-confirm-delete"
                              data-name="this exam result" title="Delete">
                        <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
              <% } } else { %>
              <tr><td colspan="9">
                <div class="empty-state">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                  </svg>
                  <h5>No Results Found</h5>
                  <p>Add exam results or adjust the filter.</p>
                </div>
              </td></tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Add Result Modal -->
<div class="modal fade" id="addResultModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 20px 60px rgba(0,0,0,.2);">
      <div class="modal-header" style="border-bottom:1px solid #f1f5f9;padding:1.25rem 1.5rem;">
        <h5 class="modal-title" style="font-weight:700;">Add Exam Result</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/results" data-validate novalidate>
        <input type="hidden" name="action" value="add"/>
        <div class="modal-body" style="padding:1.5rem;">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label-custom">Student *</label>
              <select name="studentId" class="form-control-custom" required>
                <option value="">Select Student</option>
                <% if (students != null) for (common.Student s : students) { %>
                  <option value="<%= s.getId() %>"><%= s.getName() %> (<%= s.getStudentId() %>)</option>
                <% } %>
              </select>
            </div>
            <div class="col-12">
              <label class="form-label-custom">Subject *</label>
              <select name="subjectId" class="form-control-custom" required>
                <option value="">Select Subject</option>
                <% if (subjects != null) for (common.Subject sub : subjects) { %>
                  <option value="<%= sub.getId() %>"><%= sub.getSubjectName() %> (<%= sub.getSubjectCode() %>)</option>
                <% } %>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Marks Obtained *</label>
              <input type="number" id="marks" name="marks" class="form-control-custom"
                     placeholder="e.g. 85" min="0" step="0.5" required/>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Total Marks *</label>
              <input type="number" id="totalMarks" name="totalMarks" class="form-control-custom"
                     placeholder="e.g. 100" min="1" value="100" required/>
            </div>
            <div class="col-8">
              <label class="form-label-custom">Academic Year *</label>
              <input type="text" name="academicYear" class="form-control-custom"
                     placeholder="e.g. 2024-2025" required/>
            </div>
            <div class="col-4">
              <label class="form-label-custom">Semester *</label>
              <select name="semester" class="form-control-custom" required>
                <% for (int i = 1; i <= 8; i++) { %>
                  <option value="<%= i %>"><%= i %></option>
                <% } %>
              </select>
            </div>
            <div class="col-12">
              <div class="alert-custom alert-info-custom" style="margin:0;">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>
                </svg>
                Grade is automatically calculated by the server based on marks.
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid #f1f5f9;padding:1rem 1.5rem;">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn-primary-custom">Add Result</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Result Modal -->
<div class="modal fade" id="editResultModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 20px 60px rgba(0,0,0,.2);">
      <div class="modal-header" style="border-bottom:1px solid #f1f5f9;padding:1.25rem 1.5rem;">
        <h5 class="modal-title" style="font-weight:700;">Edit Result</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/results" data-validate novalidate>
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="edit-result-id"/>
        <div class="modal-body" style="padding:1.5rem;">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label-custom">Student *</label>
              <select name="studentId" id="edit-result-studentId" class="form-control-custom" required>
                <% if (students != null) for (common.Student s : students) { %>
                  <option value="<%= s.getId() %>"><%= s.getName() %> (<%= s.getStudentId() %>)</option>
                <% } %>
              </select>
            </div>
            <div class="col-12">
              <label class="form-label-custom">Subject *</label>
              <select name="subjectId" id="edit-result-subjectId" class="form-control-custom" required>
                <% if (subjects != null) for (common.Subject sub : subjects) { %>
                  <option value="<%= sub.getId() %>"><%= sub.getSubjectName() %></option>
                <% } %>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Marks *</label>
              <input type="number" id="edit-marks" name="marks" class="form-control-custom" min="0" step="0.5" required/>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Total Marks *</label>
              <input type="number" id="edit-totalMarks" name="totalMarks" class="form-control-custom" min="1" required/>
            </div>
            <div class="col-8">
              <label class="form-label-custom">Academic Year *</label>
              <input type="text" id="edit-academicYear" name="academicYear" class="form-control-custom" required/>
            </div>
            <div class="col-4">
              <label class="form-label-custom">Semester *</label>
              <select name="semester" id="edit-result-semester" class="form-control-custom" required>
                <% for (int i = 1; i <= 8; i++) { %>
                  <option value="<%= i %>"><%= i %></option>
                <% } %>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid #f1f5f9;padding:1rem 1.5rem;">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn-primary-custom">Update Result</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
document.getElementById('editResultModal').addEventListener('show.bs.modal', function(e) {
  const btn = e.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('edit-result-id').value        = d.id || '';
  document.getElementById('edit-result-studentId').value = d.studentid || '';
  document.getElementById('edit-result-subjectId').value = d.subjectid || '';
  document.getElementById('edit-marks').value            = d.marks || '';
  document.getElementById('edit-totalMarks').value       = d.totalmarks || '';
  document.getElementById('edit-academicYear').value     = d.academicyear || '';
  document.getElementById('edit-result-semester').value  = d.semester || '';
});
</script>
</body>
</html>
