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
  java.util.List<common.ExamResult> results = (java.util.List<common.ExamResult>) request.getAttribute("results");

  long passCount = results != null ? results.stream().filter(r -> "PASS".equalsIgnoreCase(r.getStatus())).count() : 0;
  long totalCount = results != null ? results.size() : 0;
  double passRate = totalCount > 0 ? ((double) passCount / totalCount) * 100 : 0;
%>

<!DOCTYPE html>
<html lang="my">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ကျောင်းသား ဒက်ရှ်ဘုတ် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body>
<div class="app-layout">
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

      <!-- Breadcrumb Row -->
      <div class="d-flex align-items-center justify-content-between mb-2">
        <div class="d-flex align-items-center gap-2" style="font-size: 0.8125rem; color: #64748b;">
          <span>Student Portal</span>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="9 18 15 12 9 6"/>
          </svg>
          <span style="color: #0f172a; font-weight: 600;">ဒက်ရှ်ဘုတ်</span>
        </div>
      </div>

      <!-- Hero Banner Card -->
      <div class="banner-card mb-3" style="background: linear-gradient(135deg, #1e40af 0%, #1d4ed8 50%, #2563eb 100%); color: #ffffff; border: none; border-left: 4px solid #3b82f6;">
        <div class="d-flex flex-column gap-3">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div class="d-flex align-items-center gap-3">
              <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background: rgba(255,255,255,0.15); border: 2px solid rgba(255,255,255,0.3); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; font-weight: 800; color: #ffffff; flex-shrink: 0;">
                <%= student != null && student.getName() != null && !student.getName().isEmpty() ? student.getName().substring(0, 1).toUpperCase() : "S" %>
              </div>
              <div>
                <div class="d-flex align-items-center gap-2 flex-wrap">
                  <span class="badge" style="background: rgba(255,255,255,0.2); color: #fff; font-weight: 600;">University of Computer Studies (Hpa-an)</span>
                </div>
                <h1 style="font-size: 1.35rem; font-weight: 800; color: #ffffff; margin: 0.25rem 0 0 0;">
                  မင်္ဂလာပါ၊ <%= student != null ? student.getName() : "Student" %>
                </h1>
                <p style="font-size: 0.8125rem; color: rgba(255,255,255,0.85); margin: 0.15rem 0 0 0;">
                  ခုံနံပါတ်: <strong><%= student != null ? student.getStudentId() : "-" %></strong>
                </p>
              </div>
            </div>

            <a href="${pageContext.request.contextPath}/student/results" class="btn-primary-custom" style="background: #ffffff; color: #1d4ed8; font-weight: 700; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                <polyline points="14 2 14 8 20 8"/>
              </svg>
              <span>ကျွန်ုပ်၏ ရလဒ်များ ကြည့်ရန် →</span>
            </a>
          </div>
        </div>
      </div>

      <!-- Quick Statistics Cards Grid -->
      <div class="stats-grid mb-3">
        <!-- Card 1: CGPA -->
        <div class="stat-card-item">
          <div class="stat-card-header">
            <span class="stat-card-label">CGPA (4.0 Scale)</span>
            <div class="stat-card-icon-wrap" style="background-color: #eff6ff; color: #2563eb;">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>
              </svg>
            </div>
          </div>
          <div class="d-flex align-items-baseline justify-content-between mt-2">
            <div class="stat-card-value" style="color: #2563eb;">
              <%= cgpaObj != null && cgpaObj > 0 ? String.format("%.2f", cgpaObj) : "0.00" %>
            </div>
            <span class="badge badge-primary">Overall CGPA</span>
          </div>
        </div>

        <!-- Card 2: Average Score -->
        <div class="stat-card-item">
          <div class="stat-card-header">
            <span class="stat-card-label">ပျမ်းမျှ အမှတ် (Average)</span>
            <div class="stat-card-icon-wrap" style="background-color: #eff6ff; color: #2563eb;">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>
              </svg>
            </div>
          </div>
          <div class="d-flex align-items-baseline justify-content-between mt-2">
            <div class="stat-card-value" style="color: #0f172a;">
              <%= avgObj != null ? String.format("%.1f%%", avgObj) : "0.0%" %>
            </div>
            <span class="badge" style="background: #f1f5f9; color: #475569;">Grade <%= overallGrade != null ? overallGrade : "-" %></span>
          </div>
        </div>

        <!-- Card 3: Passed Subjects -->
        <div class="stat-card-item">
          <div class="stat-card-header">
            <span class="stat-card-label">အောင်မြင်သည့် ဘာသာရပ်များ</span>
            <div class="stat-card-icon-wrap" style="background-color: #eff6ff; color: #2563eb;">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="20 6 9 17 4 12"/>
              </svg>
            </div>
          </div>
          <div class="d-flex align-items-baseline justify-content-between mt-2">
            <div class="stat-card-value" style="color: #0f172a;">
              <%= passCount %> / <%= totalCount %>
            </div>
            <span class="badge badge-pass" style="background: #dbeafe; color: #1e40af; border-color: #bfdbfe;">
              <%= String.format("%.0f%%", passRate) %> အောင်မြင်
            </span>
          </div>
        </div>
      </div>

      <!-- Content Layout Row -->
      <div class="row g-4">
        <!-- Left: Student Profile Card -->
        <div class="col-lg-5">
          <div class="card-container h-100">
            <div class="card-header-bar">
              <h3 class="card-header-title">ကိုယ်ရေး အချက်အလက် (Profile)</h3>
            </div>
            <div class="card-body-padding">
              <% if (student != null) { %>
                <div class="d-flex align-items-center gap-3 mb-3 pb-3 border-bottom">
                  <div class="navbar-user-avatar" style="width: 48px; height: 48px; font-size: 1.2rem; background-color: #2563eb; color: #fff; font-weight: 800;">
                    <%= student.getName().substring(0, 1).toUpperCase() %>
                  </div>
                  <div>
                    <div style="font-weight: 700; font-size: 1.05rem; color: var(--foreground);"><%= student.getName() %></div>
                    <div style="font-size: 0.82rem; color: var(--primary); font-weight: 600;"><%= student.getStudentId() %></div>
                  </div>
                </div>

                <div class="row g-3">
                  <div class="col-12 col-sm-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">အီးမေးလ်</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground); word-break: break-all;"><%= student.getEmail() %></strong>
                  </div>
                  <div class="col-12 col-sm-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">ဖုန်းနံပါတ်</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getPhone() != null ? student.getPhone() : "N/A" %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">ကျား / မ</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getGender() != null ? student.getGender() : "N/A" %></strong>
                  </div>
                  <div class="col-6">
                    <span style="font-size: 0.75rem; color: var(--muted-foreground); display: block;">စတင် ဝင်ရောက်သည့်နေ့</span>
                    <strong style="font-size: 0.85rem; color: var(--foreground);"><%= student.getCreatedAt() != null ? student.getCreatedAt().toLocalDate() : "N/A" %></strong>
                  </div>
                </div>
              <% } else { %>
                <div class="alert-custom alert-warning-custom">
                  ကျောင်းသား အချက်အလက် မတွေ့ရှိပါ။
                </div>
              <% } %>
            </div>
          </div>
        </div>

        <!-- Right: Recent Exam Results Preview -->
        <div class="col-lg-7">
          <div class="card-container h-100">
            <div class="card-header-bar d-flex align-items-center justify-content-between">
              <h3 class="card-header-title">လတ်တလော စာမေးပွဲရလဒ်များ</h3>
              <a href="${pageContext.request.contextPath}/student/results" style="font-size: 0.78rem; font-weight: 600; color: #2563eb;">
                အားလုံးကြည့်ရန် →
              </a>
            </div>

            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>သင်္ကေတ</th>
                    <th>ဘာသာရပ်</th>
                    <th style="text-align:center;">ရမှတ်</th>
                    <th style="text-align:center;">Grade</th>
                    <th style="text-align:center;">အခြေအနေ</th>
                  </tr>
                </thead>
                <tbody>
                  <% if (results != null && !results.isEmpty()) {
                       int count = 0;
                       for (common.ExamResult r : results) {
                         if (count++ >= 5) break; // Top 5 recent
                         boolean isPass = "PASS".equalsIgnoreCase(r.getStatus());
                         String gCss = "grade-" + (r.getGrade() != null ? r.getGrade().toLowerCase().replace("+","plus").replace("-","minus") : "f");
                  %>
                  <tr>
                    <td style="font-family: monospace; font-weight: bold; color: #2563eb;"><%= r.getSubjectCode() != null ? r.getSubjectCode() : "-" %></td>
                    <td style="font-weight: 600;"><%= r.getSubjectName() != null ? r.getSubjectName() : "-" %></td>
                    <td style="text-align:center; font-weight: bold;"><%= (int)r.getMarks() %> / <%= (int)r.getTotalMarks() %></td>
                    <td style="text-align:center;">
                      <span class="badge-grade <%= gCss %>"><%= r.getGrade() != null ? r.getGrade() : "-" %></span>
                    </td>
                    <td style="text-align:center;">
                      <% if (isPass) { %>
                        <span class="badge-status-pill passed">အောင်</span>
                      <% } else { %>
                        <span class="badge-status-pill" style="color:#dc2626; background:#fee2e2; border-color:#fca5a5;">ကျ</span>
                      <% } %>
                    </td>
                  </tr>
                  <%   }
                     } else { %>
                  <tr>
                    <td colspan="5" style="text-align: center; color: #94a3b8; padding: 2rem;">
                      ရလဒ် မရှိသေးပါ
                    </td>
                  </tr>
                  <% } %>
                </tbody>
              </table>
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

