<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "My Exam Results");
  common.Student student = (common.Student) request.getAttribute("student");
  java.util.List<common.ExamResult> results = (java.util.List<common.ExamResult>) request.getAttribute("results");
  Double totalObtained = (Double) request.getAttribute("totalObtained");
  Double totalPossible = (Double) request.getAttribute("totalPossible");
  Double avgObj        = (Double) request.getAttribute("average");
  String overallGrade  = (String) request.getAttribute("overallGrade");
  String overallStatus = (String) request.getAttribute("overallStatus");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Exam Results — RERMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body>
<div class="app-layout">
  <%@ include file="sidebar.jsp" %>
  <main class="main-content">
    <div class="page-body fade-in-up">

      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert"><%= request.getAttribute("rmiError") %></div>
      <% } %>

      <!-- Header -->
      <div class="page-header">
        <div>
          <h1>My Exam Results</h1>
          <p style="color:#64748b; font-size:.85rem; margin:0;">
            Official transcript of academic records for <%= student != null ? student.getName() : "Student" %> (<%= student != null ? student.getStudentId() : "" %>)
          </p>
        </div>
        <button onclick="window.print()" class="btn-primary-custom" style="background:linear-gradient(135deg,#64748b,#475569);">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
            <polyline points="6 9 6 2 18 2 18 9"/>
            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
            <rect x="6" y="14" width="12" height="8"/>
          </svg>
          Print Results
        </button>
      </div>

      <!-- Results Table -->
      <div class="card mb-4">
        <div class="card-header-custom">
          <h5>Enrolled Subject Marks</h5>
        </div>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Subject Code</th>
                <th>Subject Name</th>
                <th>Marks Obtained</th>
                <th>Total Marks</th>
                <th>Grade</th>
                <th>Status</th>
                <th>Semester</th>
                <th>Academic Year</th>
              </tr>
            </thead>
            <tbody>
              <% if (results != null && !results.isEmpty()) {
                 int idx = 1;
                 for (common.ExamResult r : results) {
                   String gCss = "grade-" + r.getGrade().toLowerCase().replace("+", "plus");
                   String sCss = "PASS".equals(r.getStatus()) ? "badge-pass" : "badge-fail";
              %>
              <tr>
                <td style="color:#94a3b8;"><%= idx++ %></td>
                <td><span style="font-weight:700;color:#4f46e5;font-family:monospace;"><%= r.getSubjectCode() %></span></td>
                <td style="font-weight:600;"><%= r.getSubjectName() %></td>
                <td style="font-weight:700;"><%= (int)r.getMarks() %></td>
                <td style="color:#64748b;"><%= (int)r.getTotalMarks() %></td>
                <td><span class="badge-grade <%= gCss %>"><%= r.getGrade() %></span></td>
                <td><span class="<%= sCss %>"><%= r.getStatus() %></span></td>
                <td style="color:#64748b;font-size:.82rem;">Semester <%= r.getSemester() %></td>
                <td style="color:#64748b;font-size:.82rem;"><%= r.getAcademicYear() %></td>
              </tr>
              <% } } else { %>
              <tr>
                <td colspan="9">
                  <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                      <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h5>No Exam Results Found</h5>
                    <p>No results have been published for your account yet.</p>
                  </div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Transcript Summary Card -->
      <% if (results != null && !results.isEmpty()) { %>
        <div class="result-summary-card">
          <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2" style="border-color:rgba(255,255,255,.15) !important;">
            <h5 style="margin:0;font-weight:700;">Academic Summary Transcript</h5>
            <span class="badge" style="background:rgba(255,255,255,.2);font-size:.8rem;">Official Record</span>
          </div>

          <div class="row g-3 text-center">
            <div class="col-md-3 col-6">
              <div class="result-summary-value"><%= String.format("%.0f / %.0f", totalObtained, totalPossible) %></div>
              <div class="result-summary-label">Total Marks</div>
            </div>
            <div class="col-md-3 col-6">
              <div class="result-summary-value"><%= String.format("%.2f%%", avgObj) %></div>
              <div class="result-summary-label">Average Score</div>
            </div>
            <div class="col-md-3 col-6">
              <div class="result-summary-value"><%= overallGrade %></div>
              <div class="result-summary-label">Overall Grade</div>
            </div>
            <div class="col-md-3 col-6">
              <div class="result-summary-value">
                <span class="<%= "PASS".equals(overallStatus) ? "badge-pass" : "badge-fail" %>" style="font-size:1rem;padding:.3rem .9rem;">
                  <%= overallStatus %>
                </span>
              </div>
              <div class="result-summary-label">Overall Status</div>
            </div>
          </div>
        </div>
      <% } %>

    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
