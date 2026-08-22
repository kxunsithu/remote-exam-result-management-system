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
      background: #2563eb;
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
  var tableRows = '';
  var sr = 1;
  var totalCredits = 0;
  var totalGradePoint = 0;

  // Grade → Grade Score mapping
  function gradeToScore(grade) {
    var map = {'A+':4.00,'A':4.00,'A-':3.67,'B+':3.33,'B':3.00,'B-':2.67,'C+':2.33,'C':2.00,'D':1.00,'F':0,'F/Abs/I':0};
    return map[grade] !== undefined ? map[grade] : 0;
  }

  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    if (r.querySelector('.col-header')) continue;
    var nameEl = r.querySelector('.subj-name');
    var name = nameEl ? nameEl.childNodes[0].textContent.trim() : '-';
    var code = r.querySelector('.subj-code') ? r.querySelector('.subj-code').textContent.trim() : '-';
    var gradeEl = r.querySelector('.grade-cell');
    var grade = gradeEl ? gradeEl.textContent.trim() : '-';
    var marksEl = r.querySelector('.marks-cell');
    var marksText = marksEl ? marksEl.textContent.trim() : '0/100';
    var marksParts = marksText.split('/');
    var obtained = parseFloat(marksParts[0]) || 0;
    var total    = parseFloat(marksParts[1]) || 100;
    var pct      = total > 0 ? (obtained / total * 100) : 0;

    // Derive grade from percentage if missing
    var gradeObtained = grade && grade !== '-' ? grade : (function(p){
      if(p>=90)return'A+'; if(p>=80)return'A'; if(p>=75)return'A-';
      if(p>=70)return'B+'; if(p>=65)return'B'; if(p>=60)return'B-';
      if(p>=55)return'C+'; if(p>=50)return'C'; if(p>=40)return'D'; return'F';
    })(pct);

    var credit     = 3; // default credit unit
    var gradeScore = gradeToScore(gradeObtained);
    var gradePoint = gradeScore * credit;

    totalCredits    += credit;
    totalGradePoint += gradePoint;

    tableRows +=
      '<tr>' +
      '<td style="text-align:center; padding:7px 8px; border:1px solid #000;">' + (sr++) + '</td>' +
      '<td style="padding:7px 8px; font-family:monospace; font-weight:bold; border:1px solid #000;">' + code + '</td>' +
      '<td style="padding:7px 8px; border:1px solid #000;">' + name + '</td>' +
      '<td style="text-align:center; padding:7px 8px; border:1px solid #000;">' + credit + '</td>' +
      '<td style="text-align:center; padding:7px 8px; font-weight:bold; border:1px solid #000;">' + gradeObtained + '</td>' +
      '<td style="text-align:center; padding:7px 8px; border:1px solid #000;">' + gradeScore.toFixed(2) + '</td>' +
      '<td style="text-align:center; padding:7px 8px; font-weight:bold; border:1px solid #000;">' + gradePoint.toFixed(2) + '</td>' +
      '</tr>';
  }

  var semesterGPA = totalCredits > 0 ? (totalGradePoint / totalCredits).toFixed(2) : '0.00';
  var issueDate = new Date();
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  var issueDateStr = issueDate.getDate() + '-' + months[issueDate.getMonth()] + '-' + issueDate.getFullYear();

  var printWindow = window.open('', '_blank', 'width=820,height=1100');
  var doc = printWindow.document;

  doc.write('<!DOCTYPE html><html><head>');
  doc.write('<meta charset="UTF-8">');
  doc.write('<title>Academic Record - ' + studentName + '</title>');
  doc.write('<style>');
  doc.write('* { box-sizing: border-box; margin: 0; padding: 0; }');
  doc.write('body { font-family: "Times New Roman", Times, serif; font-size: 13px; color: #000; padding: 30px 45px; background: #fff; line-height: 1.5; }');
  doc.write('.page-header { text-align: center; margin-bottom: 18px; }');
  doc.write('.page-header .univ-name { font-size: 16px; font-weight: bold; margin-bottom: 3px; }');
  doc.write('.page-header .acad-year { font-size: 13px; font-weight: bold; margin-bottom: 2px; }');
  doc.write('.page-header .doc-title { font-size: 14px; font-weight: bold; text-decoration: underline; margin-top: 4px; }');
  doc.write('.divider { border: none; border-top: 1px solid #000; margin: 8px 0; }');
  doc.write('.student-info { width: 100%; margin-bottom: 16px; border-collapse: collapse; font-size: 13px; }');
  doc.write('.student-info td { padding: 3px 6px; vertical-align: top; }');
  doc.write('.student-info td.label { font-weight: normal; white-space: nowrap; }');
  doc.write('.student-info td.colon { width: 8px; padding: 3px 2px; }');
  doc.write('.student-info td.value { font-weight: bold; }');
  doc.write('.result-table { width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 12.5px; }');
  doc.write('.result-table th, .result-table td { border: 1px solid #000; padding: 6px 8px; }');
  doc.write('.result-table th { background: #fff; font-weight: bold; text-align: center; vertical-align: middle; }');
  doc.write('.result-table td.num { text-align: center; }');
  doc.write('.grading-section { margin-top: 22px; }');
  doc.write('.grading-title { font-weight: bold; text-decoration: underline; margin-bottom: 6px; font-size: 12.5px; }');
  doc.write('.grading-grid { display: grid; grid-template-columns: repeat(6, auto); gap: 2px 18px; font-size: 12px; width: fit-content; }');
  doc.write('.grading-grid .gp { display: flex; gap: 6px; }');
  doc.write('.grading-grid .gv { font-weight: bold; }');
  doc.write('.issue-date { margin-top: 20px; font-size: 12.5px; font-weight: bold; }');
  doc.write('.signature-block { margin-top: 55px; text-align: right; font-size: 12.5px; }');
  doc.write('.signature-block .sig-role { font-weight: bold; }');
  doc.write('.signature-block .sig-title { font-size: 12px; }');
  doc.write('@media print { body { padding: 20px 35px; } @page { margin: 1.2cm; size: A4; } }');
  doc.write('</style></head><body>');

  // ── Header ──────────────────────────────────────────────────
  doc.write('<div class="page-header">');
  doc.write('<div class="univ-name">University of Computer Studies (Hpa-an)</div>');
  doc.write('<div class="acad-year">' + year + ' Academic Year</div>');
  doc.write('<div class="doc-title">Academic Record</div>');
  doc.write('</div>');
  doc.write('<hr class="divider">');

  // ── Student Info ─────────────────────────────────────────────
  doc.write('<table class="student-info">');
  doc.write('<tr>');
  doc.write('<td class="label" style="width:140px;">Roll Number</td>');
  doc.write('<td class="colon">:</td>');
  doc.write('<td class="value" style="width:220px;">' + rollNo + '</td>');
  doc.write('<td class="label" style="width:120px; padding-left:30px;">Academic Year</td>');
  doc.write('<td class="colon">:</td>');
  doc.write('<td class="value">' + year + '</td>');
  doc.write('</tr>');
  doc.write('<tr>');
  doc.write('<td class="label">Student Name</td>');
  doc.write('<td class="colon">:</td>');
  doc.write('<td class="value">' + studentName + '</td>');
  doc.write('<td class="label" style="padding-left:30px;">Semester</td>');
  doc.write('<td class="colon">:</td>');
  doc.write('<td class="value">' + sem + '</td>');
  doc.write('</tr>');
  doc.write('<tr>');
  doc.write('<td class="label">Degree Program</td>');
  doc.write('<td class="colon">:</td>');
  doc.write('<td class="value">(B.C.Sc.)</td>');
  doc.write('<td></td><td></td><td></td>');
  doc.write('</tr>');
  doc.write('<tr>');
  doc.write('<td class="label">Specialization</td>');
  doc.write('<td class="colon">:</td>');
  doc.write('<td class="value">Computer Science</td>');
  doc.write('<td></td><td></td><td></td>');
  doc.write('</tr>');
  doc.write('</table>');

  // ── Results Table ────────────────────────────────────────────
  doc.write('<table class="result-table">');
  doc.write('<thead><tr>');
  doc.write('<th style="width:38px;">No.</th>');
  doc.write('<th style="width:100px;">Course Code</th>');
  doc.write('<th>Course Name</th>');
  doc.write('<th style="width:70px;">Academic Credit Unit</th>');
  doc.write('<th style="width:62px;">Grade Obtained</th>');
  doc.write('<th style="width:58px;">Grade Score</th>');
  doc.write('<th style="width:58px;">Grade Point</th>');
  doc.write('</tr></thead>');
  doc.write('<tbody>');
  doc.write(tableRows);

  // Total row
  doc.write('<tr>');
  doc.write('<td colspan="3" style="text-align:right; padding:7px 8px; border:1px solid #000; font-weight:bold;">Total Credit Units</td>');
  doc.write('<td class="num" style="border:1px solid #000; font-weight:bold;">' + totalCredits + '</td>');
  doc.write('<td colspan="2" style="text-align:right; padding:7px 8px; border:1px solid #000; font-weight:bold;">Total Grade Point</td>');
  doc.write('<td class="num" style="border:1px solid #000; font-weight:bold;">' + totalGradePoint.toFixed(2) + '</td>');
  doc.write('</tr>');

  // Cumulative GPA
  doc.write('<tr>');
  doc.write('<td colspan="5" style="border:none;"></td>');
  doc.write('<td style="border:1px solid #000; font-weight:bold; text-align:right; padding:5px 8px;">Cumulative GPA</td>');
  doc.write('<td style="border:1px solid #000; text-align:center; font-weight:bold;">' + semesterGPA + '</td>');
  doc.write('</tr>');

  // Overall GPA
  doc.write('<tr>');
  doc.write('<td colspan="5" style="border:none;"></td>');
  doc.write('<td style="border:1px solid #000; font-weight:bold; text-align:right; padding:5px 8px;">Overall GPA</td>');
  doc.write('<td style="border:1px solid #000; text-align:center; font-weight:bold;">' + semesterGPA + '</td>');
  doc.write('</tr>');

  doc.write('</tbody></table>');

  // ── Grading Scale ────────────────────────────────────────────
  doc.write('<div class="grading-section">');
  doc.write('<div class="grading-title">GRADING SCALE</div>');
  doc.write('<div class="grading-grid">');
  var grades = [['>=90','A+'],['80-89','A'],['75-79','A-'],['70-74','B+'],['65-69','B'],['60-64','B-'],
                ['55-59','C+'],['50-54','C'],['40-49','D'],['0-39','F/Abs/I']];
  grades.forEach(function(g) {
    doc.write('<div class="gp"><span>' + g[0] + '</span><span class="gv">' + g[1] + '</span></div>');
  });
  doc.write('</div></div>');

  // ── Issue Date ───────────────────────────────────────────────
  doc.write('<div class="issue-date">ISSUE DATE &nbsp;: &nbsp;' + issueDateStr + '</div>');

  // ── Registrar Signature ──────────────────────────────────────
  doc.write('<div class="signature-block">');
  doc.write('<div style="margin-bottom:45px;"></div>');
  doc.write('<div class="sig-role">REGISTRAR</div>');
  doc.write('<div class="sig-title">Academic Department</div>');
  doc.write('<div class="sig-title">University of Computer Studies(Hpa-an)</div>');
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
