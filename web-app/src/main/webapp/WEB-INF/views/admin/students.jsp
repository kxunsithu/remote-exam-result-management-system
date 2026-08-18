<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "Student Management");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
  common.Student editStudent = (common.Student) request.getAttribute("editStudent");
  java.util.List<common.Student> students = (java.util.List<common.Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Students — RERMS Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body>
<div class="app-layout">
  <%@ include file="sidebar.jsp" %>
  <main class="main-content">
    <div class="page-body fade-in-up">

      <!-- Alerts -->
      <% if (flashSuccess != null) { %>
        <div class="alert-custom alert-success-custom flash-alert"><%= flashSuccess %></div>
      <% } %>
      <% if (flashError != null) { %>
        <div class="alert-custom alert-danger-custom flash-alert"><%= flashError %></div>
      <% } %>
      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert"><%= request.getAttribute("rmiError") %></div>
      <% } %>

      <!-- Page Header -->
      <div class="page-header">
        <h1>Student Management</h1>
        <button type="button" class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addStudentModal">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
            <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
          Add Student
        </button>
      </div>

      <!-- Search -->
      <div class="card mb-3" style="padding:1rem;">
        <form method="get" action="${pageContext.request.contextPath}/admin/students" class="search-bar">
          <input type="text" name="search" class="search-input" placeholder="Search by name, ID, email, department..."
                 value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                 style="min-width:280px;"/>
          <button type="submit" class="btn-primary-custom" style="font-size:.82rem;">Search</button>
          <% if (request.getAttribute("searchKeyword") != null) { %>
            <a href="${pageContext.request.contextPath}/admin/students" class="btn-primary-custom"
               style="background:linear-gradient(135deg,#64748b,#475569);font-size:.82rem;">Clear</a>
          <% } %>
        </form>
      </div>

      <!-- Students Table -->
      <div class="card">
        <div class="card-header-custom">
          <h5>Students (<%= students != null ? students.size() : 0 %>)</h5>
        </div>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Student ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Department</th>
                <th>Year</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (students != null && !students.isEmpty()) {
                 int idx = 1;
                 for (common.Student s : students) { %>
              <tr>
                <td style="color:#94a3b8;"><%= idx++ %></td>
                <td><span style="font-weight:600;color:#4f46e5;"><%= s.getStudentId() %></span></td>
                <td><span style="font-weight:500;"><%= s.getName() %></span></td>
                <td style="color:#64748b;font-size:.82rem;"><%= s.getEmail() %></td>
                <td style="color:#64748b;font-size:.82rem;"><%= s.getPhone() != null ? s.getPhone() : "—" %></td>
                <td><span style="font-size:.82rem;background:#eff6ff;color:#1d4ed8;padding:.2rem .6rem;border-radius:20px;"><%= s.getDepartment() %></span></td>
                <td style="font-weight:600;">Year <%= s.getYear() %></td>
                <td>
                  <div style="display:flex;gap:.35rem;">
                    <!-- Edit -->
                    <button type="button" class="btn-icon btn-edit" data-bs-toggle="modal"
                            data-bs-target="#editStudentModal"
                            data-id="<%= s.getId() %>"
                            data-studentid="<%= s.getStudentId() %>"
                            data-name="<%= s.getName() %>"
                            data-email="<%= s.getEmail() %>"
                            data-phone="<%= s.getPhone() != null ? s.getPhone() : "" %>"
                            data-gender="<%= s.getGender() != null ? s.getGender() : "" %>"
                            data-dob="<%= s.getDateOfBirth() != null ? s.getDateOfBirth().toString() : "" %>"
                            data-department="<%= s.getDepartment() %>"
                            data-year="<%= s.getYear() %>"
                            title="Edit">
                      <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    </button>
                    <!-- Delete -->
                    <form method="post" action="${pageContext.request.contextPath}/admin/students" style="display:inline;">
                      <input type="hidden" name="action" value="delete"/>
                      <input type="hidden" name="id" value="<%= s.getId() %>"/>
                      <button type="submit" class="btn-icon btn-delete btn-confirm-delete"
                              data-name="<%= s.getName() %>" title="Delete">
                        <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
              <% } } else { %>
              <tr>
                <td colspan="8">
                  <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                      <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                      <circle cx="9" cy="7" r="4"/>
                    </svg>
                    <h5>No Students Found</h5>
                    <p>Add a student or clear the search filter.</p>
                  </div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- ── Add Student Modal ─────────────────────────────── -->
<div class="modal fade" id="addStudentModal" tabindex="-1" aria-labelledby="addStudentLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 20px 60px rgba(0,0,0,.2);">
      <div class="modal-header" style="border-bottom:1px solid #f1f5f9;padding:1.25rem 1.5rem;">
        <h5 class="modal-title" id="addStudentLabel" style="font-weight:700;">Add New Student</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/students" data-validate novalidate>
        <input type="hidden" name="action" value="add"/>
        <div class="modal-body" style="padding:1.5rem;">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label-custom" for="add-studentId">Student ID *</label>
              <input type="text" id="add-studentId" name="studentId" class="form-control-custom"
                     placeholder="e.g. ST006" required/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="add-name">Full Name *</label>
              <input type="text" id="add-name" name="name" class="form-control-custom"
                     placeholder="Full name" required/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="add-email">Email *</label>
              <input type="email" id="add-email" name="email" class="form-control-custom"
                     placeholder="student@university.edu" required/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="add-phone">Phone</label>
              <input type="text" id="add-phone" name="phone" class="form-control-custom" placeholder="555-XXXX"/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="add-gender">Gender</label>
              <select id="add-gender" name="gender" class="form-control-custom">
                <option value="">Select gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="add-dob">Date of Birth</label>
              <input type="date" id="add-dob" name="dateOfBirth" class="form-control-custom"/>
            </div>
            <div class="col-md-8">
              <label class="form-label-custom" for="add-department">Department *</label>
              <input type="text" id="add-department" name="department" class="form-control-custom"
                     placeholder="e.g. Computer Science" required/>
            </div>
            <div class="col-md-4">
              <label class="form-label-custom" for="add-year">Year *</label>
              <select id="add-year" name="year" class="form-control-custom" required>
                <option value="">Year</option>
                <option value="1">Year 1</option>
                <option value="2">Year 2</option>
                <option value="3">Year 3</option>
                <option value="4">Year 4</option>
                <option value="5">Year 5</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid #f1f5f9;padding:1rem 1.5rem;">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn-primary-custom">Add Student</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ── Edit Student Modal ─────────────────────────────── -->
<div class="modal fade" id="editStudentModal" tabindex="-1" aria-labelledby="editStudentLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 20px 60px rgba(0,0,0,.2);">
      <div class="modal-header" style="border-bottom:1px solid #f1f5f9;padding:1.25rem 1.5rem;">
        <h5 class="modal-title" id="editStudentLabel" style="font-weight:700;">Edit Student</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/students" data-validate novalidate>
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="edit-id" data-field="id"/>
        <div class="modal-body" style="padding:1.5rem;">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label-custom" for="edit-studentId">Student ID *</label>
              <input type="text" id="edit-studentId" name="studentId" class="form-control-custom" data-field="studentid" required/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="edit-name">Full Name *</label>
              <input type="text" id="edit-name" name="name" class="form-control-custom" data-field="name" required/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="edit-email">Email *</label>
              <input type="email" id="edit-email" name="email" class="form-control-custom" data-field="email" required/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="edit-phone">Phone</label>
              <input type="text" id="edit-phone" name="phone" class="form-control-custom" data-field="phone"/>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="edit-gender">Gender</label>
              <select id="edit-gender" name="gender" class="form-control-custom" data-field="gender">
                <option value="">Select gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label-custom" for="edit-dob">Date of Birth</label>
              <input type="date" id="edit-dob" name="dateOfBirth" class="form-control-custom" data-field="dob"/>
            </div>
            <div class="col-md-8">
              <label class="form-label-custom" for="edit-department">Department *</label>
              <input type="text" id="edit-department" name="department" class="form-control-custom" data-field="department" required/>
            </div>
            <div class="col-md-4">
              <label class="form-label-custom" for="edit-year">Year *</label>
              <select id="edit-year" name="year" class="form-control-custom" data-field="year" required>
                <option value="">Year</option>
                <option value="1">Year 1</option>
                <option value="2">Year 2</option>
                <option value="3">Year 3</option>
                <option value="4">Year 4</option>
                <option value="5">Year 5</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid #f1f5f9;padding:1rem 1.5rem;">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn-primary-custom">Update Student</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
// Edit modal pre-fill
document.getElementById('editStudentModal').addEventListener('show.bs.modal', function(event) {
  const btn = event.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('edit-id').value         = d.id || '';
  document.getElementById('edit-studentId').value  = d.studentid || '';
  document.getElementById('edit-name').value        = d.name || '';
  document.getElementById('edit-email').value       = d.email || '';
  document.getElementById('edit-phone').value       = d.phone || '';
  document.getElementById('edit-dob').value         = d.dob || '';
  document.getElementById('edit-department').value  = d.department || '';
  document.getElementById('edit-year').value        = d.year || '';
  const genderSel = document.getElementById('edit-gender');
  for (let opt of genderSel.options) {
    opt.selected = (opt.value === d.gender);
  }
});
</script>
</body>
</html>
