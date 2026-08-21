<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "ကျွန်ုပ်၏ ရလဒ်များ");
  common.Student student = (common.Student) request.getAttribute("student");
  java.util.List<common.ExamResult> results = (java.util.List<common.ExamResult>) request.getAttribute("results");
  Double totalObtained = (Double) request.getAttribute("totalObtained");
  Double totalPossible = (Double) request.getAttribute("totalPossible");
  Double avgObj        = (Double) request.getAttribute("average");
  String overallGrade  = (String) request.getAttribute("overallGrade");
  String overallStatus = (String) request.getAttribute("overallStatus");
  Double cgpaObj       = (Double) request.getAttribute("cgpa");

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
  <title>ကျွန်ုပ်၏ ရလဒ်များ — RERMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
  <style>
    .year-section { margin-bottom: 1.5rem; }
    .year-header {
      display: flex;
      align-items: center;
      gap: 0.6rem;
      padding: 0.65rem 1rem;
      background: #10b981;
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
    .sem-block { border-bottom: 1px solid #f1f5f9; }
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
      background: #10b981;
      display: inline-block;
    }
    .result-row {
      display: grid;
      grid-template-columns: 1fr 90px 80px 90px;
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
      background: #059669;
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
      display: flex; gap: 1.25rem; align-items: center; flex-wrap: wrap;
    }
    .stat-item { text-align: center; }
    .stat-item .stat-val { font-size: 1.4rem; font-weight: 800; display: block; }
    .stat-item .stat-label { font-size: 0.7rem; opacity: 0.75; text-transform: uppercase; letter-spacing: 0.04em; }
    .chevron-icon { transition: transform 0.2s; }
    .collapsed .chevron-icon { transform: rotate(-90deg); }
    @media (max-width: 768px) {
      .student-info-card { flex-direction: column; text-align: center; }
      .stat-pill { margin-left: 0; justify-content: center; }
      .result-row { grid-template-columns: 1fr 70px 60px 70px; font-size: 0.8rem; }
    }
  </style>
</head>
<body>
<div class="app-layout">
  <main class="main-content">
    <%@ include file="navbar.jsp" %>
    <div class="page-body">

      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert"><%= request.getAttribute("rmiError") %></div>
      <% } %>

      <!-- Breadcrumb -->
      <div class="d-flex align-items-center justify-content-between mb-3">
        <div class="d-flex align-items-center gap-2" style="font-size: 0.8125rem; color: #64748b;">
          <a href="${pageContext.request.contextPath}/student/dashboard" style="color: #64748b; text-decoration: none;">ဒက်ရှ်ဘုတ်</a>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          <span style="color: #0f172a; font-weight: 500;">ကျွန်ုပ်၏ ရလဒ်များ</span>
        </div>
        <div class="d-flex align-items-center gap-1">
          <button onclick="history.back()" aria-label="Go back" type="button" class="btn-action-icon" style="width: 1.65rem; height: 1.65rem;">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
          </button>
          <button onclick="history.forward()" aria-label="Go forward" type="button" class="btn-action-icon" style="width: 1.65rem; height: 1.65rem;">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
          </button>
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
          <% if (avgObj != null) { %>
          <div class="stat-item">
            <span class="stat-val"><%= String.format("%.1f%%", avgObj) %></span>
            <span class="stat-label">ပျမ်းမျှ အမှတ်</span>
          </div>
          <% } %>
          <% if (cgpaObj != null && cgpaObj > 0) { %>
          <div class="stat-item">
            <span class="stat-val"><%= String.format("%.2f", cgpaObj) %></span>
            <span class="stat-label">CGPA / 4.0</span>
          </div>
          <% } %>
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
              <input type="text" id="detailSearchInput" placeholder="ဘာသာရပ်အမည် သို့မဟုတ် သင်္ကေတဖြင့် ရှာဖွေရန်"/>
            </div>
            <span class="toolbar-subtext">ဘာသာရပ် အမည် သို့မဟုတ် သင်္ကေတ (Code) ဖြင့် ရှာဖွေနိုင်ပါသည်။</span>
          </div>

          <!-- Right: Academic Year Filter & Semester Filter -->
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
          </div>
        </div>
      </div>

      <!-- Academic Year Sections -->
      <% if (byYear.isEmpty()) { %>
        <div class="card-container" style="text-align: center; padding: 3rem 1rem; color: #64748b;">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-2 opacity-40">
            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
          </svg>
          <div style="font-weight: 600; margin-top: 0.5rem;">ရလဒ် မရှိသေးပါ</div>
          <div style="font-size: 0.8rem;">သင့်အကောင့်အတွက် ရလဒ်များ ထုတ်ပြန်ခြင်း မရှိသေးပါ။</div>
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
          <button class="year-header" type="button" data-bs-toggle="collapse" data-bs-target="#<%= collapseId %>" aria-expanded="<%= yearIdx == 0 ? "true" : "false" %>">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
            <span>ပညာသင်နှစ် <%= year %></span>
            <svg class="chevron-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
            <span class="year-badge"><%= yearPassCount %> / <%= yearTotalCount %> အောင်မြင်</span>
          </button>
          <div class="collapse <%= yearIdx == 0 ? "show" : "" %>" id="<%= collapseId %>">
            <div class="year-body">
              <!-- Table header row -->
              <div class="result-row" style="background:#fafafa; border-bottom: 1px solid #e2e8f0;">
                <div class="col-header">ဘာသာရပ်</div>
                <div class="col-header" style="text-align:center;">ရမှတ်</div>
                <div class="col-header" style="text-align:center;">Grade</div>
                <div class="col-header" style="text-align:center;">အခြေအနေ</div>
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
                     String gCss = "grade-" + (r.getGrade() != null ? r.getGrade().toLowerCase().replace("+","plus").replace("-","minus") : "f");
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
// Accordion chevron sync
document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(btn) {
  var target = document.querySelector(btn.getAttribute('data-bs-target'));
  if (!target) return;
  target.addEventListener('hide.bs.collapse', function() { btn.classList.add('collapsed'); });
  target.addEventListener('show.bs.collapse', function() { btn.classList.remove('collapsed'); });
});

// Search & filter
document.addEventListener('DOMContentLoaded', function () {
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
