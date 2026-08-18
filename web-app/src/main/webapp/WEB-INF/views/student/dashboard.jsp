<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "Student Dashboard");
  common.Student student = (common.Student) request.getAttribute("student");
  Double avgObj = (Double) request.getAttribute("average");
  String overallGrade = (String) request.getAttribute("overallGrade");
  String overallStatus = (String) request.getAttribute("overallStatus");
  Integer totalResults = (Integer) request.getAttribute("totalResults");
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
    <div class="page-body fade-in-up">

      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert"><%= request.getAttribute("rmiError") %></div>
      <% } %>

      <!-- Header -->
      <div class="page-header">
        <div>
          <h1>Student Dashboard</h1>
          <p style="color:#64748b; font-size:.85rem; margin:0;">
            Welcome, <%= student != null ? student.getName() : "Student" %>! Here is your academic summary.
          </p>
        </div>
        <a href="${pageContext.request.contextPath}/student/results" class="btn-primary-custom">
          View Detailed Results →
        </a>
      </div>

      <!-- Student Profile Card & Academic Summary -->
      <div class="row g-4 mb-4">
        <!-- Profile Card -->
        <div class="col-md-5">
          <div class="card h-100">
            <div class="card-header-custom">
              <h5>My Profile Information</h5>
            </div>
            <div class="card-body-custom">
              <% if (student != null) { %>
                <div class="d-flex align-items-center gap-3 mb-3 pb-3 border-bottom">
                  <div class="user-avatar" style="width:48px;height:48px;font-size:1.1rem;background:linear-gradient(135deg,#4f46e5,#06b6d4);">
                    <%= student.getName().substring(0, 1).toUpperCase() %>
                  </div>
                  <div>
                    <div style="font-weight:700;font-size:1.05rem;"><%= student.getName() %></div>
                    <div style="font-size:.82rem;color:#4f46e5;font-weight:600;"><%= student.getStudentId() %></div>
                  </div>
                </div>
                <div class="row g-2 style-details">
                  <div class="col-6">
                    <span style="font-size:.75rem;color:#64748b;display:block;">Email</span>
                    <strong style="font-size:.85rem;"><%= student.getEmail() %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size:.75rem;color:#64748b;display:block;">Phone</span>
                    <strong style="font-size:.85rem;"><%= student.getPhone() != null ? student.getPhone() : "N/A" %></strong>
                  </div>
                  <div class="col-6 mt-2">
                    <span style="font-size:.75rem;color:#64748b;display:block;">Department</span>
                    <strong style="font-size:.85rem;"><%= student.getDepartment() %></strong>
                  </div>
                  <div class="col-6 mt-2">
                    <span style="font-size:.75rem;color:#64748b;display:block;">Academic Year</span>
                    <strong style="font-size:.85rem;">Year <%= student.getYear() %></strong>
                  </div>
                  <div class="col-6 mt-2">
                    <span style="font-size:.75rem;color:#64748b;display:block;">Gender</span>
                    <strong style="font-size:.85rem;"><%= student.getGender() != null ? student.getGender() : "N/A" %></strong>
                  </div>
                  <div class="col-6 mt-2">
                    <span style="font-size:.75rem;color:#64748b;display:block;">Date of Birth</span>
                    <strong style="font-size:.85rem;"><%= student.getDateOfBirth() != null ? student.getDateOfBirth().toString() : "N/A" %></strong>
                  </div>
                </div>
              <% } else { %>
                <div class="alert-custom alert-warning-custom">
                  No matching student profile linked to this account. Contact your administrator.
                </div>
              <% } %>
            </div>
          </div>
        </div>

        <!-- Academic Performance Banner -->
        <div class="col-md-7">
          <div class="result-summary-card h-100 d-flex flex-column justify-content-between">
            <div>
              <div style="font-size:.8rem;text-transform:uppercase;letter-spacing:.06em;opacity:.8;font-weight:600;">Overall Academic Performance</div>
              <h2 style="font-size:2rem;font-weight:800;margin-top:.25rem;">
                <%= overallGrade != null ? overallGrade : "N/A" %>
              </h2>
            </div>

            <div class="result-summary-grid">
              <div class="result-summary-item">
                <div class="result-summary-value"><%= totalResults != null ? totalResults : 0 %></div>
                <div class="result-summary-label">Subjects Evaluated</div>
              </div>
              <div class="result-summary-item">
                <div class="result-summary-value"><%= avgObj != null ? String.format("%.2f%%", avgObj) : "0.00%" %></div>
                <div class="result-summary-label">Average Score</div>
              </div>
              <div class="result-summary-item">
                <div class="result-summary-value">
                  <span class="<%= "PASS".equals(overallStatus) ? "badge-pass" : "badge-fail" %>" style="font-size:.9rem;padding:.3rem .8rem;">
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
