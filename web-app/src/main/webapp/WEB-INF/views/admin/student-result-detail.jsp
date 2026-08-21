<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "ရလဒ်အသေးစိတ်");
  java.util.List<common.ExamResult> results = (java.util.List<common.ExamResult>) request.getAttribute("studentResults");
  common.Student student = (common.Student) request.getAttribute("studentInfo");

  // Group by academic year, then semester
  java.util.LinkedHashMap<String, java.util.Map<Integer, java.util.List<common.ExamResult>>> byYear = new java.util.LinkedHashMap<>();
  if (results != null) {
    for (common.ExamResult r : results) {
      String year = r.getAcademicYear() != null ? r.getAcademicYear() : "Unknown";
      int sem = r.getSemester();
      byYear.computeIfAbsent(year, k -> new java.util.TreeMap<>())
            .computeIfAbsent(sem, k -> new java.util.ArrayList<>())
            .add(r);
    }
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ရလဒ်အသေးစိတ် &#8212; RERMS Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
  <style>
    .year-section {
      margin-bottom: 1.5rem;
    }
    .year-header {
      display: flex;
      align-items: center;
      gap: 0.6rem;
      padding: 0.65rem 1rem;
      background: #1e40af;
      border-radius: 0.5rem 0.5rem 0 0;
      color: #fff;
      font-weight: 700;
      font-size: 0.95rem;
      cursor: pointer;
      user-select: none;
      border: none;
      width: 100%;
      text-align: left;
      transition: opacity 0.15s;
    }
    .year-header:hover { opacity: 0.92; }
    .year-header .year-badge {
      background: rgba(255,255,255,0.18);
      border-radius: 999px;
      padding: 0.1rem 0.65rem;
      font-size: 0.78rem;
      margin-left: auto;
    }
    .year-body {
      border: 1px solid #e2e8f0;
      border-top: none;
      border-radius: 0 0 0.5rem 0.5rem;
      overflow: hidden;
    }
    .sem-block {
      border-bottom: 1px solid #f1f5f9;
    }
    .sem-block:last-child { border-bottom: none; }
    .sem-header {
      background: #f8fafc;
      padding: 0.45rem 1rem;
      font-size: 0.8125rem;
      font-weight: 600;
      color: #475569;
      border-bottom: 1px solid #e2e8f0;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    .sem-header .sem-dot {
      width: 6px; height: 6px;
      border-radius: 50%;
      background: #2563eb;
      display: inline-block;
    }
    .result-row {
      display: grid;
      grid-template-columns: 1fr 90px 80px 80px 90px;
      align-items: center;
      padding: 0.6rem 1rem;
      border-bottom: 1px solid #f1f5f9;
      font-size: 0.855rem;
      transition: background 0.1s;
    }
    .result-row:last-child { border-bottom: none; }
    .result-row:hover { background: #f8fafc; }
    .result-row .subj-name { font-weight: 600; color: #0f172a; }
    .result-row .subj-code { font-size: 0.75rem; color: #64748b; font-family: monospace; }
    .result-row .marks-cell { text-align: center; font-weight: 700; color: #0f172a; }
    .result-row .marks-total { color: #94a3b8; font-weight: 400; }
    .result-row .grade-cell { text-align: center; }
    .result-row .status-cell { text-align: center; }
    .result-row .col-header {
      font-size: 0.72rem; color: #94a3b8; font-weight: 600; text-transform: uppercase; letter-spacing: 0.04em;
    }
    .student-info-card {
      background: #1e40af;
      border-radius: 0.75rem;
      padding: 1.25rem 1.5rem;
      color: #fff;
      margin-bottom: 1.5rem;
      display: flex;
      align-items: center;
      gap: 1.25rem;
    }
    .student-avatar {
      width: 3rem; height: 3rem;
      border-radius: 50%;
      background: rgba(255,255,255,0.18);
      border: 2px solid rgba(255,255,255,0.3);
      display: flex; align-items: center; justify-content: center;
      font-weight: 800; font-size: 1.25rem; color: #fff;
      flex-shrink: 0;
    }
    .student-meta { display: flex; flex-direction: column; gap: 0.1rem; }
    .student-meta .s-name { font-size: 1.05rem; font-weight: 700; }
    .student-meta .s-code { font-size: 0.82rem; opacity: 0.8; font-family: monospace; }
    .stat-pill {
      margin-left: auto;
      display: flex; gap: 1rem; align-items: center; flex-wrap: wrap;
    }
    .stat-item { text-align: center; }
    .stat-item .stat-val { font-size: 1.4rem; font-weight: 800; display: block; }
    .stat-item .stat-label { font-size: 0.7rem; opacity: 0.75; text-transform: uppercase; letter-spacing: 0.04em; }
    .chevron-icon { transition: transform 0.2s; }
    .collapsed .chevron-icon { transform: rotate(-90deg); }
  </style>
</head>
<body>
<div class="app-layout">
  <div class="admin-body-row">
    <%@ include file="sidebar.jsp" %>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <main class="main-content">
      <%@ include file="header.jsp" %>
      <div class="page-body">

      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert"><%= request.getAttribute("rmiError") %></div>
      <% } %>

      <!-- Breadcrumb -->
      <div class="d-flex align-items-center justify-content-between mb-3">
        <div class="d-flex align-items-center gap-2" style="font-size: 0.8125rem; color: #64748b;">
          <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #64748b; text-decoration: none;">ဒက်ရှ်ဘုတ်</a>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          <a href="${pageContext.request.contextPath}/admin/results" style="color: #64748b; text-decoration: none;">စာမေးပွဲရလဒ်များ</a>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          <span style="color: #0f172a; font-weight: 500;">
            <%= student != null ? student.getName() : "ကျောင်းသား" %> ၏ ရလဒ်
          </span>
        </div>
        <div class="d-flex align-items-center gap-1">
          <a href="${pageContext.request.contextPath}/admin/results" class="btn-action-icon" style="width: 1.65rem; height: 1.65rem; display:inline-flex; align-items:center; justify-content:center; text-decoration:none;">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
          </a>
        </div>
      </div>

      <!-- Student Info Card -->
      <% if (student != null) {
           long totalSubj = results != null ? results.size() : 0;
           long passSubj  = results != null ? results.stream().filter(r -> "PASS".equals(r.getStatus())).count() : 0;
           String initial = student.getName() != null && !student.getName().isEmpty()
                            ? String.valueOf(student.getName().charAt(0)).toUpperCase() : "S";
      %>
      <div class="student-info-card">
        <div class="student-avatar"><%= initial %></div>
        <div class="student-meta">
          <span class="s-name"><%= student.getName() %></span>
          <span class="s-code"><%= student.getStudentId() %></span>
        </div>
        <div class="stat-pill">
          <div class="stat-item">
            <span class="stat-val"><%= totalSubj %></span>
            <span class="stat-label">စုစုပေါင်း ဘာသာ</span>
          </div>
          <div class="stat-item">
            <span class="stat-val"><%= totalSubj > 0 ? String.format("%.0f", (double)passSubj/totalSubj*100) : "0" %>%</span>
            <span class="stat-label">အောင်မြင်မှုနှုန်း</span>
          </div>
        </div>
      </div>
      <% } %>

      <!-- Search & Filter Toolbar Card -->
      <div class="card-container p-3 mb-3">
        <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">
          <!-- Left: Search Box & Subtext -->
          <div class="d-flex flex-column" style="flex: 1; min-width: 260px; max-width: 440px;">
            <div class="search-input-wrap" style="max-width: 100%;">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
              </svg>
              <input type="text" id="detailSearchInput" placeholder="ဘာသာရပ်အမည် သို့မဟုတ် သင်္ကေတဖြင့် ရှာဖွေရန်"
                     value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"/>
            </div>
            <span class="toolbar-subtext">ဘာသာရပ် အမည် သို့မဟုတ် သင်္ကေတ (Code) ဖြင့် ရှာဖွေနိုင်ပါသည်။</span>
          </div>

          <!-- Right: Academic Year Filter, Semester Filter & Add Result Button -->
          <div class="d-flex align-items-center gap-2 flex-wrap ms-auto">
            <select id="detailYearFilter" style="padding: 0.45rem 0.75rem; font-size: 0.8125rem; border-radius: var(--radius-md); border: 1px solid var(--border); background-color: #ffffff; color: var(--foreground); cursor: pointer;">
              <option value="">ပညာသင်နှစ် အားလုံး</option>
              <% for (String yr : byYear.keySet()) { %>
                <option value="<%= yr %>">ပညာသင်နှစ် <%= yr %></option>
              <% } %>
            </select>

            <select id="detailSemFilter" style="padding: 0.45rem 0.75rem; font-size: 0.8125rem; border-radius: var(--radius-md); border: 1px solid var(--border); background-color: #ffffff; color: var(--foreground); cursor: pointer;">
              <option value="">Semester အားလုံး</option>
              <% for (int i = 1; i <= 8; i++) { %>
                <option value="<%= i %>">Semester <%= i %></option>
              <% } %>
            </select>

            <button type="button" class="btn-add-record" data-bs-toggle="modal" data-bs-target="#addResultModal" style="font-size:0.8rem; padding: 0.45rem 0.85rem;">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
              <span>ရလဒ်ထည့်ရန်</span>
            </button>
          </div>
        </div>
      </div>

      <!-- Academic Year Sections -->
      <% if (byYear.isEmpty()) { %>
        <div class="card-container" style="text-align: center; padding: 3rem 1rem; color: #64748b;">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-2 opacity-40">
            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
          </svg>
          <div style="font-weight: 600; margin-top: 0.5rem;">ဤကျောင်းသားအတွက် ရလဒ် မရှိသေးပါ</div>
        </div>
      <% } else {
           int yearIdx = 0;
           for (java.util.Map.Entry<String, java.util.Map<Integer, java.util.List<common.ExamResult>>> yearEntry : byYear.entrySet()) {
             String year = yearEntry.getKey();
             java.util.Map<Integer, java.util.List<common.ExamResult>> bySem = yearEntry.getValue();
             long yearPassCount = bySem.values().stream().flatMap(java.util.Collection::stream).filter(r -> "PASS".equals(r.getStatus())).count();
             long yearTotalCount = bySem.values().stream().mapToLong(java.util.Collection::size).sum();
             String collapseId = "year-collapse-" + yearIdx;
      %>
        <div class="year-section card-container" data-year="<%= year %>" style="padding:0; overflow: hidden;">
          <button class="year-header" type="button" data-bs-toggle="collapse" data-bs-target="#<%= collapseId %>" aria-expanded="true">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
            <span>ပညာသင်နှစ် <%= year %></span>
            <svg class="chevron-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
            <span class="year-badge"><%= yearPassCount %> / <%= yearTotalCount %> အောင်မြင်</span>
          </button>
          <div class="collapse show" id="<%= collapseId %>">
            <div class="year-body">
              <!-- Table header row -->
              <div class="result-row" style="background:#fafafa; border-bottom: 1px solid #e2e8f0;">
                <div class="col-header">ဘာသာရပ်</div>
                <div class="col-header" style="text-align:center;">ရမှတ်</div>
                <div class="col-header" style="text-align:center;">Grade</div>
                <div class="col-header" style="text-align:center;">အခြေအနေ</div>
                <div class="col-header" style="text-align:center;">လုပ်ဆောင်ချက်</div>
              </div>
              <%
                for (java.util.Map.Entry<Integer, java.util.List<common.ExamResult>> semEntry : bySem.entrySet()) {
                  int sem = semEntry.getKey();
                  java.util.List<common.ExamResult> semResults = semEntry.getValue();
              %>
              <div class="sem-block">
                <div class="sem-header d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center gap-2">
                    <span class="sem-dot"></span>
                    <span>Semester <%= sem %></span>
                    <span style="font-size:0.75rem; color:#94a3b8; margin-left:0.4rem;"><%= semResults.size() %> ဘာသာ</span>
                  </div>
                  <button type="button" class="btn-print-sem"
                          onclick="printSemesterResult('<%= student != null ? student.getName().replace("'", "\\'") : "" %>', '<%= student != null ? student.getStudentId() : "" %>', '<%= year %>', '<%= sem %>', this)"
                          title="ဤ Semester ရလဒ် ပုံနှိပ်ထုတ်ယူရန်">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <polyline points="6 9 6 2 18 2 18 9"/>
                      <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
                      <rect x="6" y="14" width="12" height="8"/>
                    </svg>
                    <span>Print</span>
                  </button>
                </div>
                <% for (common.ExamResult r : semResults) {
                     boolean isPass = "PASS".equals(r.getStatus());
                     String gCss = "grade-" + (r.getGrade() != null ? r.getGrade().toLowerCase().replace("+","plus") : "f");
                %>
                <div class="result-row">
                  <div>
                    <div class="subj-name">
                      <%= r.getSubjectName() != null ? r.getSubjectName() : "-" %>
                      <% String et = r.getExamType();
                         if ("RE_EXAM".equals(et)) { %>
                           <span class="badge" style="font-size:0.65rem; padding:0.1rem 0.4rem; background:#ffedd5; color:#c2410c; border:1px solid #fed7aa; margin-left:0.3rem;">RE-EXAM</span>
                      <% } else if ("RETAKE".equals(et)) { %>
                           <span class="badge" style="font-size:0.65rem; padding:0.1rem 0.4rem; background:#f3e8ff; color:#6b21a8; border:1px solid #e9d5ff; margin-left:0.3rem;">RETAKE</span>
                      <% } %>
                    </div>
                    <div class="subj-code"><%= r.getSubjectCode() != null ? r.getSubjectCode() : "" %></div>
                  </div>
                  <div class="marks-cell">
                    <%= (int)r.getMarks() %><span class="marks-total">/<%= (int)r.getTotalMarks() %></span>
                  </div>
                  <div class="grade-cell">
                    <span class="badge-grade <%= gCss %>"><%= r.getGrade() != null ? r.getGrade() : "-" %></span>
                  </div>
                  <div class="status-cell">
                    <% if (isPass) { %>
                      <span class="badge-status-pill passed" style="font-size:0.72rem;">အောင်</span>
                    <% } else { %>
                      <span class="badge-status-pill" style="font-size:0.72rem; color:#dc2626; background:#fee2e2; border-color:#fca5a5;">ကျ</span>
                    <% } %>
                  </div>
                  <div style="text-align:center;">
                    <div class="action-buttons-group justify-content-center" style="display:flex; gap:0.25rem; justify-content:center;">
                      <!-- Edit Button -->
                      <button type="button" class="btn-action-icon edit" data-bs-toggle="modal" data-bs-target="#editResultModal"
                              data-id="<%= r.getId() %>"
                              data-subjectid="<%= r.getSubjectId() %>"
                              data-marks="<%= r.getMarks() %>"
                              data-totalmarks="<%= r.getTotalMarks() %>"
                              data-academicyear="<%= r.getAcademicYear() %>"
                              data-semester="<%= r.getSemester() %>"
                              data-examtype="<%= r.getExamType() %>"
                              title="ပြင်ဆင်ရန်">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                          <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                      </button>

                      <!-- Delete Button -->
                      <button type="button" class="btn-action-icon delete" data-bs-toggle="modal" data-bs-target="#deleteResultModal"
                              data-id="<%= r.getId() %>" data-name="<%= r.getSubjectName() %> (<%= r.getAcademicYear() %>, Sem <%= r.getSemester() %>) ရလဒ်" title="ဖျက်ရန်">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <polyline points="3 6 5 6 21 6"/>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
                <% } %>
              </div>
              <% } %>
            </div>
          </div>
        </div>
      <%   yearIdx++;
           }
         } %>

    </div>
  </main>
  </div>
</div>

<!-- Add Result Modal (pre-filled for this student) -->
<% java.util.List<common.Subject> allSubjects = (java.util.List<common.Subject>) request.getAttribute("subjects"); %>
<div class="modal fade" id="addResultModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 34rem;">
    <div class="modal-content" style="border: none; border-radius: 1rem; overflow: hidden; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);">

      <!-- Modal Header (Solid Color) -->
      <div style="background: #1e40af; padding: 1.25rem 1.5rem; display: flex; align-items: center; justify-content: space-between;">
        <div style="display:flex; align-items:center; gap: 0.75rem;">
          <div style="width:2rem; height:2rem; border-radius:0.5rem; background:rgba(255,255,255,0.15); display:flex; align-items:center; justify-content:center;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.2">
              <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
            </svg>
          </div>
          <div>
            <h5 class="modal-title" style="color:#fff; font-size:1rem; font-weight:700; margin:0;">ရလဒ်အသစ် ထည့်သွင်းရန်</h5>
            <span style="color:rgba(255,255,255,0.65); font-size:0.72rem;">Add Exam Result</span>
          </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" style="filter: invert(1) grayscale(1);"></button>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/admin/results" data-validate novalidate>
        <input type="hidden" name="action" value="add"/>
        <input type="hidden" name="studentId" value="<%= student != null ? student.getId() : 0 %>"/>

        <div class="modal-body" style="padding: 1.5rem; background:#fff;">

          <!-- Section: ကျောင်းသားအချက်အလက် -->
          <div style="margin-bottom: 1.25rem;">
            <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.75rem; padding-bottom:0.5rem; border-bottom:1px solid #f1f5f9;">
              <span style="font-size:0.72rem; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.06em;">ကျောင်းသား</span>
            </div>
            <div>
              <div style="padding: 0.5rem 0.75rem; background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-weight: 600; color: #0f172a; font-size: 0.875rem;">
                <%= student != null ? student.getName() + " (" + student.getStudentId() + ")" : "-" %>
              </div>
            </div>
          </div>

          <!-- Section: ပညာသင်နှစ် & Semester -->
          <div style="margin-bottom: 1.25rem;">
            <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.75rem; padding-bottom:0.5rem; border-bottom:1px solid #f1f5f9;">
              <span style="font-size:0.72rem; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.06em;">၁။ ပညာသင်နှစ်, Semester & Exam Type</span>
            </div>
            <div style="display:grid; grid-template-columns:1.5fr 1fr 1.2fr; gap:0.75rem;">
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem; display:flex; align-items:center; gap:0.4rem;">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2.2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                  ပညာသင်နှစ် <span style="color:#dc2626;">*</span>
                </label>
                <input type="text" name="academicYear" id="det-add-academicYear" placeholder="e.g. 2024-2025" required style="width:100%;"/>
              </div>
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem;">
                  Semester <span style="color:#dc2626;">*</span>
                </label>
                <select name="semester" id="det-add-semester" required style="width:100%;">
                  <option value="">— ရွေးပါ —</option>
                  <% for (int i = 1; i <= 8; i++) { %>
                    <option value="<%= i %>">Sem <%= i %></option>
                  <% } %>
                </select>
              </div>
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem;">
                  အမျိုးအစား <span style="color:#dc2626;">*</span>
                </label>
                <select name="examType" required style="width:100%;">
                  <option value="REGULAR">Regular</option>
                  <option value="RE_EXAM">Re-exam</option>
                  <option value="RETAKE">Retake</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Section: ဘာသာရပ် -->
          <div style="margin-bottom: 1.25rem;">
            <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.75rem; padding-bottom:0.5rem; border-bottom:1px solid #f1f5f9;">
              <span style="font-size:0.72rem; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.06em;">၂။ ဘာသာရပ်</span>
            </div>
            <div>
              <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem; display:flex; align-items:center; gap:0.4rem;">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2.2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                ဘာသာရပ် <span style="color:#dc2626;">*</span>
              </label>
              <select name="subjectId" required id="det-add-subjectId" style="width:100%;" disabled>
                <option value="">— Semester အရင်ရွေးချယ်ပါ —</option>
                <% if (allSubjects != null) for (common.Subject sub : allSubjects) { %>
                  <option value="<%= sub.getId() %>" data-semester="<%= sub.getSemester() %>"><%= sub.getSubjectName() %> (<%= sub.getSubjectCode() %>)</option>
                <% } %>
              </select>
            </div>
          </div>

          <!-- Section: ရမှတ် -->
          <div style="margin-bottom: 1.25rem;">
            <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.75rem; padding-bottom:0.5rem; border-bottom:1px solid #f1f5f9;">
              <span style="font-size:0.72rem; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.06em;">၃။ ရမှတ် & ရလဒ်</span>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.75rem; margin-bottom:0.75rem;">
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem; display:flex; align-items:center; gap:0.4rem;">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2.2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                  ရမှတ် <span style="color:#dc2626;">*</span>
                </label>
                <input type="number" id="det-add-marks" name="marks" placeholder="e.g. 85" min="0" step="0.5" required style="width:100%;"/>
              </div>
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem; display:flex; align-items:center; gap:0.4rem;">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2.2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                  စုစုပေါင်းမှတ် <span style="color:#dc2626;">*</span>
                </label>
                <input type="number" id="det-add-totalMarks" name="totalMarks" placeholder="e.g. 100" min="1" value="100" required style="width:100%;"/>
              </div>
            </div>
            <!-- Live marks preview bar -->
            <div id="det-marks-preview-wrap" style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:0.5rem; padding:0.65rem 0.85rem; display:none;">
              <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.4rem;">
                <span style="font-size:0.75rem; color:#64748b; font-weight:500;">ရမှတ် အချိုး</span>
                <span id="det-marks-preview-pct" style="font-size:0.82rem; font-weight:700; color:#0f172a;"></span>
              </div>
              <div style="height:6px; background:#e2e8f0; border-radius:999px; overflow:hidden;">
                <div id="det-marks-preview-bar" style="height:100%; width:0%; border-radius:999px; background:#2563eb; transition: width 0.3s, background 0.3s;"></div>
              </div>
              <div style="display:flex; justify-content:space-between; margin-top:0.35rem;">
                <span style="font-size:0.7rem; color:#94a3b8;">ကျ (0%)</span>
                <span id="det-marks-preview-grade" style="font-size:0.72rem; font-weight:700; padding:0.1rem 0.4rem; border-radius:0.25rem; background:#dbeafe; color:#1d4ed8;"></span>
                <span style="font-size:0.7rem; color:#94a3b8;">ထူးချွန် (100%)</span>
              </div>
            </div>
          </div>

        </div>

        <!-- Modal Footer -->
        <div class="modal-footer" style="background:#f8fafc; border-top:1px solid #e2e8f0; padding:1rem 1.5rem; gap:0.5rem;">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
          <button type="submit" class="btn-primary-custom" style="gap:0.5rem;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            ထည့်သွင်းမည်
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Result Modal -->
<div class="modal fade" id="editResultModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 34rem;">
    <div class="modal-content" style="border: none; border-radius: 1rem; overflow: hidden; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);">

      <!-- Modal Header (Solid Color) -->
      <div style="background: #1e40af; padding: 1.25rem 1.5rem; display: flex; align-items: center; justify-content: space-between;">
        <div style="display:flex; align-items:center; gap: 0.75rem;">
          <div style="width:2rem; height:2rem; border-radius:0.5rem; background:rgba(255,255,255,0.15); display:flex; align-items:center; justify-content:center;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.2">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
            </svg>
          </div>
          <div>
            <h5 class="modal-title" style="color:#fff; font-size:1rem; font-weight:700; margin:0;">ရလဒ် ပြင်ဆင်ရန်</h5>
            <span style="color:rgba(255,255,255,0.65); font-size:0.72rem;">Edit Exam Result</span>
          </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" style="filter: invert(1) grayscale(1);"></button>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/admin/results" data-validate novalidate>
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="edit-result-id"/>
        <input type="hidden" name="studentId" value="<%= student != null ? student.getId() : 0 %>"/>

        <div class="modal-body" style="padding: 1.5rem; background:#fff;">

          <!-- Section: ဘာသာရပ် -->
          <div style="margin-bottom: 1.25rem;">
            <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.75rem; padding-bottom:0.5rem; border-bottom:1px solid #f1f5f9;">
              <span style="font-size:0.72rem; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.06em;">ဘာသာရပ်</span>
            </div>
            <div>
              <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem; display:flex; align-items:center; gap:0.4rem;">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2.2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                ဘာသာရပ် <span style="color:#dc2626;">*</span>
              </label>
              <select name="subjectId" required id="edit-result-subjectId" style="width:100%;">
                <option value="">— ဘာသာရပ်ရွေးချယ်ပါ —</option>
                <% if (allSubjects != null) for (common.Subject sub : allSubjects) { %>
                  <option value="<%= sub.getId() %>"><%= sub.getSubjectName() %> (<%= sub.getSubjectCode() %>)</option>
                <% } %>
              </select>
            </div>
          </div>

          <!-- Section: ရမှတ် -->
          <div style="margin-bottom: 1.25rem;">
            <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.75rem; padding-bottom:0.5rem; border-bottom:1px solid #f1f5f9;">
              <span style="font-size:0.72rem; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.06em;">ရမှတ် & ရလဒ်</span>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.75rem; margin-bottom:0.75rem;">
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem; display:flex; align-items:center; gap:0.4rem;">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2.2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                  ရမှတ် <span style="color:#dc2626;">*</span>
                </label>
                <input type="number" id="edit-marks" name="marks" min="0" step="0.5" required style="width:100%;"/>
              </div>
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem; display:flex; align-items:center; gap:0.4rem;">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2.2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                  စုစုပေါင်းမှတ် <span style="color:#dc2626;">*</span>
                </label>
                <input type="number" id="edit-totalMarks" name="totalMarks" min="1" required style="width:100%;"/>
              </div>
            </div>
          </div>

          <!-- Section: ပညာသင်နှစ် & Semester -->
          <div>
            <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.75rem; padding-bottom:0.5rem; border-bottom:1px solid #f1f5f9;">
              <span style="font-size:0.72rem; font-weight:700; color:#64748b; text-transform:uppercase; letter-spacing:0.06em;">ပညာသင်နှစ်, Semester & Exam Type</span>
            </div>
            <div style="display:grid; grid-template-columns:1.5fr 1fr 1.2fr; gap:0.75rem;">
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem;">
                  ပညာသင်နှစ် <span style="color:#dc2626;">*</span>
                </label>
                <input type="text" id="edit-academicYear" name="academicYear" required style="width:100%;"/>
              </div>
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem;">
                  Semester <span style="color:#dc2626;">*</span>
                </label>
                <select name="semester" id="edit-result-semester" required style="width:100%;">
                  <% for (int i = 1; i <= 8; i++) { %>
                    <option value="<%= i %>">Sem <%= i %></option>
                  <% } %>
                </select>
              </div>
              <div>
                <label class="form-label" style="font-size:0.8rem; font-weight:600; color:#374151; margin-bottom:0.3rem;">
                  အမျိုးအစား <span style="color:#dc2626;">*</span>
                </label>
                <select name="examType" id="edit-result-examType" required style="width:100%;">
                  <option value="REGULAR">Regular</option>
                  <option value="RE_EXAM">Re-exam</option>
                  <option value="RETAKE">Retake</option>
                </select>
              </div>
            </div>
          </div>

        </div>

        <!-- Modal Footer -->
        <div class="modal-footer" style="background:#f8fafc; border-top:1px solid #e2e8f0; padding:1rem 1.5rem; gap:0.5rem;">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မပြင်ဆင်ပါ</button>
          <button type="submit" class="btn-primary-custom">ပြင်ဆင်မည်</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ── Delete Result Modal ─────────────────────────── -->
<div class="modal fade" id="deleteResultModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/results">
        <input type="hidden" name="action" value="delete"/>
        <input type="hidden" name="id" id="delete-result-id"/>
        <input type="hidden" name="studentId" value="<%= student != null ? student.getId() : 0 %>"/>
        <div class="modal-body d-flex flex-column align-items-center gap-3 pt-3">
          <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
            </svg>
          </div>
          <div class="d-flex flex-column gap-1">
            <h5 style="font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0;">စာမေးပွဲရလဒ် ပယ်ဖျက်ရန် အတည်ပြုပါ</h5>
            <p style="font-size: 0.85rem; color: #64748b; margin: 0;">
              <strong id="delete-result-name" style="color: #dc2626;"></strong> ကို ပယ်ဖျက်ရန် သေချာပါသလား။ ဤလုပ်ဆောင်ချက်ကို ပြန်လည်ပြင်ဆင်၍ မရနိုင်ပါ။
            </p>
          </div>
          <div class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
            <button type="button" class="btn-outline-custom" data-bs-dismiss="modal" style="flex: 1; padding: 0.6rem;">မဖျက်ပါ</button>
            <button type="submit" class="btn-primary-custom" style="flex: 1; padding: 0.6rem; background-color: #dc2626; border-color: #dc2626;">ဖျက်မည်</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<%
  // Build map of "semester_examType" -> academic_year for this student
  java.util.Map<String, String> semTypeToYearMap = new java.util.HashMap<>();
  if (results != null) {
    for (common.ExamResult r : results) {
      if (r.getAcademicYear() != null && !r.getAcademicYear().isBlank()) {
        String key = r.getSemester() + "_" + (r.getExamType() != null ? r.getExamType() : "REGULAR");
        semTypeToYearMap.putIfAbsent(key, r.getAcademicYear());
      }
    }
  }
%>
<script>
  var studentSemTypeToYear = {
    <%
      for (java.util.Map.Entry<String, String> entry : semTypeToYearMap.entrySet()) {
        out.print("'" + entry.getKey() + "': '" + entry.getValue().replace("'", "\\'") + "',");
      }
    %>
  };
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
(function(){
  var COLLAPSED_KEY = 'sidebarCollapsed';
  var btn = document.getElementById('sidebarToggleBtn');
  var overlay = document.getElementById('sidebarOverlay');
  if (localStorage.getItem(COLLAPSED_KEY) === '1') document.body.classList.add('sidebar-collapsed');
  if (btn) {
    btn.addEventListener('click', function(){
      if (window.innerWidth <= 768) {
        document.body.classList.toggle('sidebar-open');
      } else {
        var collapsed = document.body.classList.toggle('sidebar-collapsed');
        localStorage.setItem(COLLAPSED_KEY, collapsed ? '1' : '0');
      }
    });
  }
  if (overlay) overlay.addEventListener('click', function(){ document.body.classList.remove('sidebar-open'); });
})();
</script>
<script>
document.getElementById('deleteResultModal').addEventListener('show.bs.modal', function(e) {
  const btn = e.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('delete-result-id').value = d.id || '';
  document.getElementById('delete-result-name').textContent = d.name || '';
});

  // Accordion chevron sync
  document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(btn) {
    var target = document.querySelector(btn.getAttribute('data-bs-target'));
    if (!target) return;
    target.addEventListener('hide.bs.collapse', function() { btn.classList.add('collapsed'); });
    target.addEventListener('show.bs.collapse', function() { btn.classList.remove('collapsed'); });
  });

  // Pre-fill Edit Result Modal
  var editModalEl = document.getElementById('editResultModal');
  if (editModalEl) {
    editModalEl.addEventListener('show.bs.modal', function(e) {
      var btn = e.relatedTarget;
      if (!btn) return;
      var d = btn.dataset;
      document.getElementById('edit-result-id').value        = d.id || '';
      document.getElementById('edit-result-subjectId').value = d.subjectid || '';
      document.getElementById('edit-marks').value            = d.marks || '';
      document.getElementById('edit-totalMarks').value       = d.totalmarks || '';
      document.getElementById('edit-academicYear').value     = d.academicyear || '';
      document.getElementById('edit-result-semester').value  = d.semester || '';
      document.getElementById('edit-result-examType').value  = d.examtype || 'REGULAR';
    });
  }

  // Filter semester & subject dropdowns
  (function () {
    var yearInput      = document.getElementById('det-add-academicYear');
    var semSelect      = document.getElementById('det-add-semester');
    var examTypeSelect = document.querySelector('#addResultModal select[name="examType"]');
    var subjSelect     = document.getElementById('det-add-subjectId');
    if (!semSelect || !subjSelect) return;

    function filterSemesters() {
      var enteredYear = (yearInput ? yearInput.value : '').trim().toLowerCase();
      var etVal = (examTypeSelect ? examTypeSelect.value : 'REGULAR') || 'REGULAR';

      for (var i = 1; i < semSelect.options.length; i++) {
        var opt = semSelect.options[i];
        var semNum = parseInt(opt.value);
        var key = semNum + '_' + etVal;
        var assignedYear = studentSemTypeToYear[key];

        if (assignedYear) {
          if (enteredYear === '' || enteredYear === assignedYear.toLowerCase()) {
            opt.hidden = false;
            opt.disabled = false;
            opt.textContent = 'Sem ' + semNum + ' (' + assignedYear + ')';
          } else {
            opt.hidden = true;
            opt.disabled = true;
          }
        } else {
          opt.hidden = false;
          opt.disabled = false;
          opt.textContent = 'Sem ' + semNum;
        }
      }

      if (semSelect.selectedIndex > 0 && semSelect.options[semSelect.selectedIndex].hidden) {
        semSelect.value = '';
      }
      filterSubjects();
    }

    function filterSubjects() {
      var semVal = semSelect.value;
      if (!semVal) {
        subjSelect.disabled = true;
        subjSelect.value = '';
        subjSelect.options[0].textContent = '— Semester အရင်ရွေးချယ်ပါ —';
        for (var i = 1; i < subjSelect.options.length; i++) {
          subjSelect.options[i].hidden = true;
        }
        return;
      }

      subjSelect.disabled = false;
      subjSelect.options[0].textContent = '— ဘာသာရပ်ရွေးချယ်ပါ —';
      var hasValidMatch = false;

      for (var j = 1; j < subjSelect.options.length; j++) {
        var opt = subjSelect.options[j];
        var optSem = opt.getAttribute('data-semester');
        if (optSem === semVal) {
          opt.hidden = false;
          opt.disabled = false;
          hasValidMatch = true;
        } else {
          opt.hidden = true;
          opt.disabled = true;
        }
      }

      var selectedOpt = subjSelect.options[subjSelect.selectedIndex];
      if (selectedOpt && selectedOpt.hidden) {
        subjSelect.value = '';
      }

      if (!hasValidMatch) {
        subjSelect.options[0].textContent = '— ဤ Semester အတွက် ဘာသာရပ်မရှိပါ —';
      }
    }

    if (yearInput) {
      yearInput.addEventListener('input', filterSemesters);
    }
    if (examTypeSelect) {
      examTypeSelect.addEventListener('change', filterSemesters);
    }

    semSelect.addEventListener('change', function () {
      var semNum = parseInt(semSelect.value);
      var etVal = (examTypeSelect ? examTypeSelect.value : 'REGULAR') || 'REGULAR';
      var key = semNum + '_' + etVal;
      var assignedYear = studentSemTypeToYear[key];
      if (assignedYear && yearInput && !yearInput.value.trim()) {
        yearInput.value = assignedYear;
      }
      filterSubjects();
    });

    var modal = document.getElementById('addResultModal');
    if (modal) {
      modal.addEventListener('show.bs.modal', function () {
        if (yearInput) yearInput.value = '';
        semSelect.value = '';
        filterSemesters();
      });
    }
  })();

  // Live marks preview (detail page)
  (function () {
    function getGradeLabel(pct) {
      if (pct >= 90) return 'A+';
      if (pct >= 80) return 'A';
      if (pct >= 75) return 'A-';
      if (pct >= 70) return 'B+';
      if (pct >= 65) return 'B';
      if (pct >= 60) return 'B-';
      if (pct >= 55) return 'C+';
      if (pct >= 50) return 'C';
      if (pct >= 40) return 'D';
      return 'F';
    }
    function getBarColor(pct) {
      if (pct >= 70) return '#22c55e';
      if (pct >= 50) return '#f59e0b';
      return '#ef4444';
    }
    function updatePreview() {
      var marks      = parseFloat(document.getElementById('det-add-marks').value);
      var totalMarks = parseFloat(document.getElementById('det-add-totalMarks').value);
      var wrap = document.getElementById('det-marks-preview-wrap');
      if (!wrap) return;
      if (isNaN(marks) || isNaN(totalMarks) || totalMarks <= 0) { wrap.style.display = 'none'; return; }
      var pct = Math.min(100, Math.max(0, (marks / totalMarks) * 100));
      wrap.style.display = 'block';
      document.getElementById('det-marks-preview-pct').textContent = pct.toFixed(1) + '%';
      document.getElementById('det-marks-preview-bar').style.width = pct + '%';
      document.getElementById('det-marks-preview-bar').style.background = getBarColor(pct);
      var grade = getGradeLabel(pct);
      var gradeEl = document.getElementById('det-marks-preview-grade');
      gradeEl.textContent = grade;
      var colors = {'A+':['#dcfce7','#15803d'],'A':['#dbeafe','#1d4ed8'],'A-':['#dbeafe','#1d4ed8'],
        'B+':['#f3e8ff','#6b21a8'],'B':['#e0e7ff','#3730a3'],'B-':['#e0e7ff','#3730a3'],
        'C+':['#fef3c7','#92400e'],'C':['#fef9c3','#713f12'],'D':['#fee2e2','#b91c1c'],'F':['#fee2e2','#b91c1c']};
      var c = colors[grade] || ['#f1f5f9','#64748b'];
      gradeEl.style.background = c[0]; gradeEl.style.color = c[1];
    }
    document.addEventListener('DOMContentLoaded', function () {
      var mEl = document.getElementById('det-add-marks');
      var tEl = document.getElementById('det-add-totalMarks');
      if (mEl) mEl.addEventListener('input', updatePreview);
      if (tEl) tEl.addEventListener('input', updatePreview);
      var modal = document.getElementById('addResultModal');
      if (modal) modal.addEventListener('hidden.bs.modal', function () {
        var wrap = document.getElementById('det-marks-preview-wrap');
        if (wrap) wrap.style.display = 'none';
      });

      var sIn  = document.getElementById('detailSearchInput');
      var yrF  = document.getElementById('detailYearFilter');
      var semF = document.getElementById('detailSemFilter');

      function applyDetailFilter() {
        var q = (sIn ? sIn.value : '').toLowerCase().trim();
        var yrVal = yrF ? yrF.value.trim() : '';
        var sVal = semF ? semF.value : '';

        document.querySelectorAll('.year-section').forEach(function(sec) {
          var secYear = sec.getAttribute('data-year') || '';
          var yrMatch = !yrVal || secYear === yrVal;
          var secVisible = false;

          sec.querySelectorAll('.sem-block').forEach(function(blk) {
            var semH = blk.querySelector('.sem-header');
            var semTxt = semH ? semH.textContent.trim() : '';
            var semMatch = !sVal || semTxt.indexOf('Semester ' + sVal) !== -1;
            var blkVisible = false;

            var rows = blk.querySelectorAll('.result-row');
            for (var i = 0; i < rows.length; i++) {
              var r = rows[i];
              if (r.querySelector('.col-header')) continue; // skip header row
              var nameEl = r.querySelector('.subj-name');
              var codeEl = r.querySelector('.subj-code');
              var nameTxt = nameEl ? nameEl.textContent.toLowerCase() : '';
              var codeTxt = codeEl ? codeEl.textContent.toLowerCase() : '';
              var qMatch = !q || nameTxt.indexOf(q) !== -1 || codeTxt.indexOf(q) !== -1;

              if (yrMatch && semMatch && qMatch) {
                r.style.display = 'grid';
                blkVisible = true;
              } else {
                r.style.display = 'none';
              }
            }

            if (yrMatch && blkVisible) {
              blk.style.display = 'block';
              secVisible = true;
            } else {
              blk.style.display = 'none';
            }
          });

          sec.style.display = (yrMatch && secVisible) ? 'block' : 'none';
        });
      }

      if (sIn) sIn.addEventListener('input', applyDetailFilter);
      if (yrF) yrF.addEventListener('change', applyDetailFilter);
      if (semF) semF.addEventListener('change', applyDetailFilter);
      if (sIn && sIn.value) applyDetailFilter();
    });
  })();

  function printSemesterResult(studentName, rollNo, year, sem, btn) {
    var semBlock = btn.closest('.sem-block');
    if (!semBlock) return;

    var rows = semBlock.querySelectorAll('.result-row');
    var tableHtml = '';
    var sr = 1;

    for (var i = 0; i < rows.length; i++) {
      var r = rows[i];
      if (r.querySelector('.col-header')) continue;
      var nameEl = r.querySelector('.subj-name');
      var name = nameEl ? nameEl.childNodes[0].textContent.trim() : '-';
      var typeBadge = nameEl ? nameEl.querySelector('.badge') : null;
      var examType = typeBadge ? typeBadge.textContent.trim() : 'Regular';
      var code = r.querySelector('.subj-code') ? r.querySelector('.subj-code').textContent.trim() : '-';
      var marks = r.querySelector('.marks-cell') ? r.querySelector('.marks-cell').textContent.trim() : '-';
      var grade = r.querySelector('.grade-cell') ? r.querySelector('.grade-cell').textContent.trim() : '-';
      var status = r.querySelector('.status-cell') ? r.querySelector('.status-cell').textContent.trim() : '-';

      tableHtml += '<tr>' +
        '<td style="text-align:center; padding: 8px;">' + (sr++) + '</td>' +
        '<td style="padding: 8px; font-family: monospace; font-weight: bold;">' + code + '</td>' +
        '<td style="padding: 8px;">' + name + '</td>' +
        '<td style="text-align:center; padding: 8px; font-size: 0.85rem;">' + examType + '</td>' +
        '<td style="text-align:center; padding: 8px;">' + marks + '</td>' +
        '<td style="text-align:center; padding: 8px; font-weight: bold;">' + grade + '</td>' +
        '<td style="text-align:center; padding: 8px;">' + status + '</td>' +
        '</tr>';
    }

    var printWindow = window.open('', '_blank', 'width=900,height=750');
    var doc = printWindow.document;

    doc.write('<!DOCTYPE html><html><head><title>Semester Result - ' + studentName + '</title>');
    doc.write('<style>');
    doc.write('body { font-family: "Inter", system-ui, sans-serif; padding: 35px; color: #0f172a; line-height: 1.5; }');
    doc.write('.header-title { text-align: center; margin-bottom: 25px; border-bottom: 2px solid #0f172a; padding-bottom: 15px; }');
    doc.write('.header-title h2 { margin: 0 0 5px 0; font-size: 1.4rem; color: #1e3a8a; }');
    doc.write('.header-title h3 { margin: 0; font-size: 1.1rem; color: #334155; font-weight: 600; }');
    doc.write('.meta-table { width: 100%; margin-bottom: 20px; border-collapse: collapse; font-size: 0.95rem; }');
    doc.write('.meta-table td { padding: 6px 12px; }');
    doc.write('.result-table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 0.9rem; }');
    doc.write('.result-table th, .result-table td { border: 1px solid #cbd5e1; }');
    doc.write('.result-table th { background-color: #f1f5f9; padding: 10px; text-align: left; }');
    doc.write('.footer-sig { margin-top: 70px; display: flex; justify-content: space-between; text-align: center; font-size: 0.9rem; font-weight: 600; }');
    doc.write('.sig-box { width: 200px; border-top: 1px dashed #64748b; padding-top: 8px; }');
    doc.write('</style></head><body>');

    doc.write('<div class="header-title">');
    doc.write('<h2>ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</h2>');
    doc.write('<h3>University of Computer Studies (Hpa-an)</h3>');
    doc.write('<p style="margin: 8px 0 0 0; font-weight: bold; color: #2563eb; font-size: 1.05rem;">ကျောင်းသား စာမေးပွဲရလဒ် အမှတ်စာရင်း (Semester Transcript)</p>');
    doc.write('</div>');

    doc.write('<table class="meta-table">');
    doc.write('<tr><td><strong>ကျောင်းသားအမည်:</strong> ' + studentName + '</td><td><strong>ပညာသင်နှစ်:</strong> ' + year + '</td></tr>');
    doc.write('<tr><td><strong>ခုံနံပါတ်:</strong> ' + rollNo + '</td><td><strong>Semester:</strong> Semester ' + sem + '</td></tr>');
    doc.write('</table>');

    doc.write('<table class="result-table">');
    doc.write('<thead><tr><th style="text-align:center; width:50px;">စဉ်</th><th>ဘာသာရပ် သင်္ကေတ</th><th>ဘာသာရပ် အမည်</th><th style="text-align:center;">အမျိုးအစား</th><th style="text-align:center;">ရမှတ်</th><th style="text-align:center;">Grade</th><th style="text-align:center;">အခြေအနေ</th></tr></thead>');
    doc.write('<tbody>' + tableHtml + '</tbody>');
    doc.write('</table>');

    doc.write('<div class="footer-sig">');
    doc.write('<div class="sig-box">စိစစ်သူ</div>');
    doc.write('<div class="sig-box">ဌာနမှူး</div>');
    doc.write('<div class="sig-box">ပါမောက္ခချုပ် / ဒုတိယပါမောက္ခချုပ်</div>');
    doc.write('</div>');

    doc.write('</body></html>');
    doc.close();

    printWindow.onload = function() {
      printWindow.focus();
      printWindow.print();
    };
  }
</script>
</body>
</html>


