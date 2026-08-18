<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
  request.setAttribute("pageTitle", "Dashboard");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Dashboard — RERMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body>
<div class="app-layout">
  <%@ include file="sidebar.jsp" %>

  <main class="main-content">
    <div class="page-body fade-in-up">

      <!-- Flash messages -->
      <% if (flashSuccess != null) { %>
        <div class="alert-custom alert-success-custom flash-alert">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="20 6 9 17 4 12"/>
          </svg>
          <%= flashSuccess %>
        </div>
      <% } %>
      <% if (flashError != null) { %>
        <div class="alert-custom alert-danger-custom flash-alert">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/>
          </svg>
          <%= flashError %>
        </div>
      <% } %>

      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
          </svg>
          <%= request.getAttribute("rmiError") %>
        </div>
      <% } %>

      <!-- Page header -->
      <div class="page-header">
        <div>
          <h1>Dashboard</h1>
          <p style="color:#64748b; font-size:.85rem; margin:0;">
            Welcome back! Here's an overview of the system.
          </p>
        </div>
        <div style="display:flex;gap:.75rem;">
          <a href="${pageContext.request.contextPath}/admin/students?action=add_prompt"
             class="btn-primary-custom" style="font-size:.8rem;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Add Student
          </a>
          <a href="${pageContext.request.contextPath}/admin/subjects"
             class="btn-primary-custom" style="background:linear-gradient(135deg,#10b981,#059669); font-size:.8rem;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Add Subject
          </a>
          <a href="${pageContext.request.contextPath}/admin/results"
             class="btn-primary-custom" style="background:linear-gradient(135deg,#8b5cf6,#6d28d9); font-size:.8rem;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Add Result
          </a>
        </div>
      </div>

      <!-- Stat Cards -->
      <div class="stat-cards">
        <div class="stat-card">
          <div class="stat-icon blue">
            <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
              <circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
              <path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          </div>
          <div class="stat-info">
            <div class="stat-value"><%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : "—" %></div>
            <div class="stat-label">Total Students</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon green">
            <svg viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
              <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
          </div>
          <div class="stat-info">
            <div class="stat-value"><%= request.getAttribute("totalSubjects") != null ? request.getAttribute("totalSubjects") : "—" %></div>
            <div class="stat-label">Total Subjects</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon purple">
            <svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
          </div>
          <div class="stat-info">
            <div class="stat-value"><%= request.getAttribute("totalResults") != null ? request.getAttribute("totalResults") : "—" %></div>
            <div class="stat-label">Exam Results</div>
          </div>
        </div>
      </div>

      <!-- Recent Results -->
      <div class="card">
        <div class="card-header-custom">
          <h5>Recent Exam Results</h5>
          <a href="${pageContext.request.contextPath}/admin/results"
             style="font-size:.8rem; color:#4f46e5; font-weight:600;">View All →</a>
        </div>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Student</th>
                <th>Subject</th>
                <th>Marks</th>
                <th>Grade</th>
                <th>Status</th>
                <th>Year</th>
              </tr>
            </thead>
            <tbody>
              <%
                java.util.List<common.ExamResult> recentResults =
                  (java.util.List<common.ExamResult>) request.getAttribute("recentResults");
                if (recentResults != null && !recentResults.isEmpty()) {
                  for (common.ExamResult r : recentResults) {
                    String gradeCss = "grade-" + r.getGrade().toLowerCase().replace("+", "plus");
                    String statusCss = "PASS".equals(r.getStatus()) ? "badge-pass" : "badge-fail";
                    double pct = r.getTotalMarks() > 0 ? (r.getMarks() / r.getTotalMarks()) * 100 : 0;
              %>
              <tr>
                <td>
                  <div style="font-weight:600;"><%= r.getStudentName() != null ? r.getStudentName() : "-" %></div>
                  <div style="font-size:.75rem;color:#64748b;"><%= r.getStudentCode() != null ? r.getStudentCode() : "" %></div>
                </td>
                <td>
                  <div><%= r.getSubjectName() != null ? r.getSubjectName() : "-" %></div>
                  <div style="font-size:.75rem;color:#64748b;"><%= r.getSubjectCode() != null ? r.getSubjectCode() : "" %></div>
                </td>
                <td>
                  <div class="marks-bar-wrap">
                    <span style="font-weight:600;min-width:40px;"><%= (int)r.getMarks() %>/<%= (int)r.getTotalMarks() %></span>
                    <div class="marks-bar">
                      <div class="marks-bar-fill" data-pct="<%= pct %>"></div>
                    </div>
                  </div>
                </td>
                <td><span class="badge-grade <%= gradeCss %>"><%= r.getGrade() %></span></td>
                <td><span class="<%= statusCss %>"><%= r.getStatus() %></span></td>
                <td style="color:#64748b;font-size:.82rem;"><%= r.getAcademicYear() %></td>
              </tr>
              <%  } %>
              <% } else { %>
              <tr>
                <td colspan="6">
                  <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                      <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                      <line x1="8" y1="21" x2="16" y2="21"/>
                      <line x1="12" y1="17" x2="12" y2="21"/>
                    </svg>
                    <h5>No Results Yet</h5>
                    <p>Add exam results to see them here.</p>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
