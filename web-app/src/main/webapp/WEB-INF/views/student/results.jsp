<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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
  Double cgpaObj       = (Double) request.getAttribute("cgpa");
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
    <%@ include file="navbar.jsp" %>
    <div class="page-body">

      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/>
          </svg>
          <%= request.getAttribute("rmiError") %>
        </div>
      <% } %>

      <!-- Page Header Row -->
      <div class="page-header-row mb-3">
        <div>
          <h1 class="page-title-heading">My Exam Results</h1>
          <p class="page-title-subtext">
            Official transcript of academic records for <strong><%= student != null ? student.getName() : "Student" %></strong> (<%= student != null ? student.getStudentId() : "" %>)
          </p>
        </div>
        <button onclick="window.print()" class="btn-outline-custom" type="button">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="6 9 6 2 18 2 18 9"/>
            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
            <rect x="6" y="14" width="12" height="8"/>
          </svg>
          Print Results
        </button>
      </div>

      <!-- Enrolled Subject Marks Table Card -->
      <div class="card-container mb-4">
        <div class="card-header-bar">
          <h3 class="card-header-title">Enrolled Subject Marks</h3>
        </div>
        <div class="table-wrapper">
          <table class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Subject Code</th>
                <th>Subject Name</th>
                <th>Credits</th>
                <th>Marks Obtained</th>
                <th>Total Marks</th>
                <th>Grade</th>
                <th>Grade Score</th>
                <th>Status</th>
                <th>Semester</th>
                <th>Academic Year</th>
              </tr>

            </thead>
            <tbody>
              <% if (results != null && !results.isEmpty()) {
                 int idx = 1;
                 for (common.ExamResult r : results) {
                   String gCss = "grade-" + r.getGrade().toLowerCase().replace("+", "plus").replace("-", "minus");
                   String sCss = "PASS".equals(r.getStatus()) ? "badge-pass" : "badge-fail";
                   double pts = common.ExamResult.gradeToPoints(r.getGrade());
              %>
              <tr>
                <td style="color: var(--muted-foreground);"><%= idx++ %></td>
                <td><span style="font-weight: 700; color: var(--primary); font-family: monospace;"><%= r.getSubjectCode() %></span></td>
                <td style="font-weight: 600;"><%= r.getSubjectName() %></td>
                <td style="text-align: center;">
                  <span style="background: var(--primary-soft); color: var(--primary); font-weight: 700; border-radius: 0.375rem; padding: 0.15rem 0.55rem; font-size: 0.8rem;">
                    <%= r.getSubjectCredit() %>
                  </span>
                </td>
                <td style="font-weight: 700;"><%= (int)r.getMarks() %></td>
                <td style="color: var(--muted-foreground);"><%= (int)r.getTotalMarks() %></td>
                <td><span class="badge-grade <%= gCss %>"><%= r.getGrade() %></span></td>
                <td style="font-weight: 600; color: var(--foreground); font-size: 0.9rem;"><%= String.format("%.2f", pts) %></td>
                <td><span class="badge <%= sCss %>"><%= r.getStatus() %></span></td>
                <td style="color: var(--muted-foreground); font-size: 0.82rem;">Semester <%= r.getSemester() %></td>
                <td style="color: var(--muted-foreground); font-size: 0.82rem;"><%= r.getAcademicYear() %></td>
              </tr>

              <% } } else { %>
              <tr>
                <td colspan="11" style="text-align: center; padding: 2.5rem 1rem; color: var(--muted-foreground);">

                  <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-2 opacity-50">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                  </svg>
                  <div style="font-weight: 600; color: var(--foreground);">No Exam Results Found</div>
                  <div style="font-size: 0.8rem;">No results have been published for your student account yet.</div>
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
          <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2" style="border-color: rgba(255, 255, 255, 0.2) !important;">
            <h3 style="margin: 0; font-weight: 700; font-size: 1.125rem;">Academic Summary Transcript</h3>
            <span class="badge" style="background-color: rgba(255, 255, 255, 0.2); color: #ffffff; font-size: 0.75rem;">Official Record</span>
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
              <div class="result-summary-value" style="font-size: 1.5rem; font-weight: 800; color: #fbbf24;">
                <%= cgpaObj != null ? String.format("%.2f", cgpaObj) : "N/A" %>
                <span style="font-size: 0.7rem; font-weight: 500; opacity: 0.85;"> / 4.0</span>
              </div>
              <div class="result-summary-label">CGPA (4-pt Scale)</div>
            </div>
            <div class="col-md-3 col-6">
              <div class="result-summary-value"><%= overallGrade %></div>
              <div class="result-summary-label">Overall Grade</div>
            </div>
            <div class="col-md-3 col-6 mx-auto">
              <div class="result-summary-value">
                <span class="badge <%= "PASS".equals(overallStatus) ? "badge-pass" : "badge-fail" %>" style="font-size: 0.875rem; padding: 0.35rem 0.85rem;">
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
