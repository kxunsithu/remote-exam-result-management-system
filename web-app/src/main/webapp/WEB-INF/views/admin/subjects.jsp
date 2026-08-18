<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  request.setAttribute("pageTitle", "Subject Management");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
  java.util.List<common.Subject> subjects = (java.util.List<common.Subject>) request.getAttribute("subjects");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Subjects — RERMS Admin</title>
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
        <h1>Subject Management</h1>
        <button type="button" class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
          Add Subject
        </button>
      </div>

      <!-- Search -->
      <div class="card mb-3" style="padding:1rem;">
        <form method="get" action="${pageContext.request.contextPath}/admin/subjects" class="search-bar">
          <input type="text" name="search" class="search-input"
                 placeholder="Search by code, name, or department..."
                 value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                 style="min-width:280px;"/>
          <button type="submit" class="btn-primary-custom" style="font-size:.82rem;">Search</button>
          <% if (request.getAttribute("searchKeyword") != null) { %>
            <a href="${pageContext.request.contextPath}/admin/subjects"
               class="btn-primary-custom" style="background:linear-gradient(135deg,#64748b,#475569);font-size:.82rem;">Clear</a>
          <% } %>
        </form>
      </div>

      <!-- Subjects Table -->
      <div class="card">
        <div class="card-header-custom">
          <h5>Subjects (<%= subjects != null ? subjects.size() : 0 %>)</h5>
        </div>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Subject Code</th>
                <th>Subject Name</th>
                <th>Credit</th>
                <th>Department</th>
                <th>Semester</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (subjects != null && !subjects.isEmpty()) {
                 int idx = 1;
                 for (common.Subject s : subjects) { %>
              <tr>
                <td style="color:#94a3b8;"><%= idx++ %></td>
                <td><span style="font-weight:700;color:#4f46e5;font-family:monospace;"><%= s.getSubjectCode() %></span></td>
                <td style="font-weight:500;"><%= s.getSubjectName() %></td>
                <td><span style="background:#e0e7ff;color:#3730a3;padding:.2rem .7rem;border-radius:20px;font-size:.82rem;font-weight:600;"><%= s.getCredit() %> Credits</span></td>
                <td style="font-size:.82rem;color:#64748b;"><%= s.getDepartment() %></td>
                <td><span style="background:#fef3c7;color:#92400e;padding:.2rem .6rem;border-radius:20px;font-size:.82rem;">Sem <%= s.getSemester() %></span></td>
                <td>
                  <div style="display:flex;gap:.35rem;">
                    <button type="button" class="btn-icon btn-edit" data-bs-toggle="modal"
                            data-bs-target="#editSubjectModal"
                            data-id="<%= s.getId() %>"
                            data-subjectcode="<%= s.getSubjectCode() %>"
                            data-subjectname="<%= s.getSubjectName() %>"
                            data-credit="<%= s.getCredit() %>"
                            data-department="<%= s.getDepartment() %>"
                            data-semester="<%= s.getSemester() %>"
                            title="Edit">
                      <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    </button>
                    <form method="post" action="${pageContext.request.contextPath}/admin/subjects" style="display:inline;">
                      <input type="hidden" name="action" value="delete"/>
                      <input type="hidden" name="id" value="<%= s.getId() %>"/>
                      <button type="submit" class="btn-icon btn-delete btn-confirm-delete"
                              data-name="<%= s.getSubjectName() %>" title="Delete">
                        <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
              <% } } else { %>
              <tr><td colspan="7"><div class="empty-state">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                  <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                  <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                </svg>
                <h5>No Subjects Found</h5>
                <p>Add a subject to get started.</p>
              </div></td></tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Add Subject Modal -->
<div class="modal fade" id="addSubjectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 20px 60px rgba(0,0,0,.2);">
      <div class="modal-header" style="border-bottom:1px solid #f1f5f9;padding:1.25rem 1.5rem;">
        <h5 class="modal-title" style="font-weight:700;">Add New Subject</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/subjects" data-validate novalidate>
        <input type="hidden" name="action" value="add"/>
        <div class="modal-body" style="padding:1.5rem;">
          <div class="row g-3">
            <div class="col-6">
              <label class="form-label-custom">Subject Code *</label>
              <input type="text" name="subjectCode" class="form-control-custom" placeholder="e.g. CS106" required/>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Credits *</label>
              <select name="credit" class="form-control-custom" required>
                <option value="">Select</option>
                <option value="1">1</option><option value="2">2</option>
                <option value="3">3</option><option value="4">4</option>
                <option value="5">5</option><option value="6">6</option>
              </select>
            </div>
            <div class="col-12">
              <label class="form-label-custom">Subject Name *</label>
              <input type="text" name="subjectName" class="form-control-custom" placeholder="Subject full name" required/>
            </div>
            <div class="col-8">
              <label class="form-label-custom">Department *</label>
              <input type="text" name="department" class="form-control-custom" placeholder="Computer Science" required/>
            </div>
            <div class="col-4">
              <label class="form-label-custom">Semester *</label>
              <select name="semester" class="form-control-custom" required>
                <option value="">Sem</option>
                <% for (int i = 1; i <= 8; i++) { %>
                  <option value="<%= i %>"><%= i %></option>
                <% } %>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid #f1f5f9;padding:1rem 1.5rem;">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn-primary-custom">Add Subject</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Subject Modal -->
<div class="modal fade" id="editSubjectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 20px 60px rgba(0,0,0,.2);">
      <div class="modal-header" style="border-bottom:1px solid #f1f5f9;padding:1.25rem 1.5rem;">
        <h5 class="modal-title" style="font-weight:700;">Edit Subject</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/subjects" data-validate novalidate>
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="edit-subj-id"/>
        <div class="modal-body" style="padding:1.5rem;">
          <div class="row g-3">
            <div class="col-6">
              <label class="form-label-custom">Subject Code *</label>
              <input type="text" name="subjectCode" id="edit-subjectCode" class="form-control-custom" required/>
            </div>
            <div class="col-6">
              <label class="form-label-custom">Credits *</label>
              <select name="credit" id="edit-credit" class="form-control-custom" required>
                <option value="">Select</option>
                <% for (int i = 1; i <= 6; i++) { %>
                  <option value="<%= i %>"><%= i %></option>
                <% } %>
              </select>
            </div>
            <div class="col-12">
              <label class="form-label-custom">Subject Name *</label>
              <input type="text" name="subjectName" id="edit-subjectName" class="form-control-custom" required/>
            </div>
            <div class="col-8">
              <label class="form-label-custom">Department *</label>
              <input type="text" name="department" id="edit-subj-department" class="form-control-custom" required/>
            </div>
            <div class="col-4">
              <label class="form-label-custom">Semester *</label>
              <select name="semester" id="edit-semester" class="form-control-custom" required>
                <% for (int i = 1; i <= 8; i++) { %>
                  <option value="<%= i %>"><%= i %></option>
                <% } %>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid #f1f5f9;padding:1rem 1.5rem;">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn-primary-custom">Update Subject</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
document.getElementById('editSubjectModal').addEventListener('show.bs.modal', function(e) {
  const btn = e.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('edit-subj-id').value        = d.id || '';
  document.getElementById('edit-subjectCode').value    = d.subjectcode || '';
  document.getElementById('edit-subjectName').value    = d.subjectname || '';
  document.getElementById('edit-credit').value         = d.credit || '';
  document.getElementById('edit-subj-department').value = d.department || '';
  document.getElementById('edit-semester').value       = d.semester || '';
});
</script>
</body>
</html>
