<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "Student Dashboard");
  common.Student student = (common.Student) request.getAttribute("student");
  Double avgObj = (Double) request.getAttribute("average");
  String overallGrade = (String) request.getAttribute("overallGrade");
  String overallStatus = (String) request.getAttribute("overallStatus");
  Integer totalResults = (Integer) request.getAttribute("totalResults");
  Double cgpaObj = (Double) request.getAttribute("cgpa");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Student Dashboard — RERMS</title>
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
      <div class="page-header-row mb-2">
        <div>
          <h1 class="page-title-heading">Student Dashboard</h1>
          <p class="page-title-subtext">
            Welcome back, <strong><%= student != null ? student.getName() : "Student" %></strong>! Here is your academic performance summary.
          </p>
        </div>
        <a href="${pageContext.request.contextPath}/student/results" class="btn-primary-custom">
          View Detailed Results →
        </a>
      </div>

      <!-- Student Profile Card & Academic Summary Grid -->
      <div class="row g-4">
        <!-- Student Profile Card -->
        <div class="col-lg-5">
          <div class="card-container h-100">
            <div class="card-header-bar">
              <h3 class="card-header-title">My Profile Information</h3>
            </div>
            <div class="card-body-padding">
              <% if (student != null) { %>
                <div class="d-flex align-items-center gap-3 mb-3 pb-3 border-bottom">
                  <div class="navbar-user-avatar" style="width: 48px; height: 48px; font-size: 1.1rem; background-color: #2563eb;">
                    <%= student.getName().substring(0, 1).toUpperCase() %>
                  </div>
                  <div>
                    <div style="font-weight: 700; font-size: 1.05rem; color: var(--foreground);"><%= student.getName() %></div>
                    <div style="font-size: 0.82rem; color: var(--primary); font-weight: 600;"><%= student.getStudentId() %></div>
                  </div>
                </div>

                <div class="row g-3">
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">Email</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getEmail() %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">Phone</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getPhone() != null ? student.getPhone() : "N/A" %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">Department</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getDepartment() %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">Academic Year</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);">Year <%= student.getYear() %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">Gender</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getGender() != null ? student.getGender() : "N/A" %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">Date of Birth</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getDateOfBirth() != null ? student.getDateOfBirth().toString() : "N/A" %></strong>
                  </div>
                </div>
              <% } else { %>
                <div class="alert-custom alert-warning-custom">
                  No matching student profile linked to this account. Contact your system administrator.
                </div>
              <% } %>
            </div>
          </div>
        </div>

        <!-- Academic Performance Banner Card -->
        <div class="col-lg-7">
          <div class="result-summary-card h-100 d-flex flex-column justify-content-between">
            <div>
              <div style="font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.06em; opacity: 0.85; font-weight: 700;">
                Overall Academic Performance
              </div>
              <div class="d-flex align-items-baseline gap-3 mt-1">
                <h2 style="font-size: 2.25rem; font-weight: 800; margin: 0;">
                  <%= overallGrade != null ? overallGrade : "N/A" %>
                </h2>
                <% if (cgpaObj != null && cgpaObj > 0) { %>
                <div style="display: flex; flex-direction: column;">
                  <span style="font-size: 1.35rem; font-weight: 800; color: #fbbf24; line-height: 1.1;">
                    <%= String.format("%.2f", cgpaObj) %>
                  </span>
                  <span style="font-size: 0.65rem; opacity: 0.8; font-weight: 600; letter-spacing: 0.04em;">CGPA / 4.0</span>
                </div>
                <% } %>
              </div>
            </div>

            <div class="result-summary-grid">
              <div class="result-summary-item">
                <div class="result-summary-value"><%= totalResults != null ? totalResults : 0 %></div>
                <div class="result-summary-label">Evaluated Subjects</div>
              </div>

              <div class="result-summary-item">
                <div class="result-summary-value"><%= avgObj != null ? String.format("%.2f%%", avgObj) : "0.00%" %></div>
                <div class="result-summary-label">Average Score</div>
              </div>

              <div class="result-summary-item">
                <div class="result-summary-value">
                  <span class="badge <%= "PASS".equals(overallStatus) ? "badge-pass" : "badge-fail" %>" style="font-size: 0.875rem; padding: 0.35rem 0.85rem;">
                    <%= overallStatus != null ? overallStatus : "N/A" %>
                  </span>
                </div>
                <div class="result-summary-label">Overall Status</div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </main>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
