<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "Exam Results");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
  java.util.List<common.ExamResult> results  = (java.util.List<common.ExamResult>) request.getAttribute("results");
  java.util.List<common.Student>    students = (java.util.List<common.Student>)    request.getAttribute("students");

  // Build a map: studentDbId -> list of results
  java.util.Map<Integer, java.util.List<common.ExamResult>> resultsByStudent = new java.util.HashMap<>();
  if (results != null) {
    for (common.ExamResult r : results) {
      resultsByStudent.computeIfAbsent(r.getStudentId(), k -> new java.util.ArrayList<>()).add(r);
    }
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Exam Results &#8212; RERMS Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body>
<div class="app-layout">
  <div class="admin-body-row">
    <%@ include file="sidebar.jsp" %>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <main class="main-content">
      <%@ include file="header.jsp" %>
      <div class="page-body">

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

      <!-- Breadcrumb Nav & History Controls Row -->
      <div class="d-flex align-items-center justify-content-between mb-3">
        <div class="d-flex align-items-center gap-2" style="font-size: 0.8125rem; color: #64748b;">
          <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #64748b; text-decoration: none;">ဒက်ရှ်ဘုတ်</a>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          <span style="color: #0f172a; font-weight: 500;">စာမေးပွဲရလဒ်များ</span>
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

      <!-- Toolbar Card with Search Form -->
      <div class="card-container p-3 mb-3">
        <form method="get" action="${pageContext.request.contextPath}/admin/results" class="d-flex flex-column gap-2">
          <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">
            <!-- Left: Search Box & Subtext -->
            <div class="d-flex flex-column" style="flex: 1; min-width: 280px; max-width: 480px;">
              <div class="search-input-wrap" style="max-width: 100%;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
                <input type="text" name="search" placeholder="ကျောင်းသား သို့မဟုတ် ခုံနံပါတ် ရှာဖွေရန်"
                       value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"/>
              </div>
              <span class="toolbar-subtext">
                ကျောင်းသားအမည်၊ ခုံနံပါတ် (Roll Number) သို့မဟုတ် အီးမေးလ်ဖြင့် ရှာဖွေနိုင်ပါသည်။
              </span>
            </div>
          </div>
        </form>
      </div>

      <!-- All Students List Table -->
      <div class="card-container">
        <div class="table-wrapper">
          <table class="data-table">
            <thead>
              <tr>
                <th style="width: 50px;">စဉ်</th>
                <th>ကျောင်းသား အမည်</th>
                <th>ခုံနံပါတ်</th>
                <th>အီးမေးလ်</th>
                <th style="text-align: center;">ဘာသာရပ် (စုစုပေါင်း)</th>
                <th style="text-align: center;">ရလဒ်ကြည့်ရန်</th>
              </tr>
            </thead>
            <tbody>
              <%
                if (students != null && !students.isEmpty()) {
                  int idx = 1;
                  for (common.Student s : students) {
                    java.util.List<common.ExamResult> sResults = resultsByStudent.getOrDefault(s.getId(), java.util.Collections.emptyList());
                    String detailUrl = request.getContextPath() + "/admin/results?action=studentDetail&studentId=" + s.getId();
              %>
              <tr style="cursor: pointer;" onclick="window.location='<%= detailUrl %>'">
                <td style="color: #64748b; font-weight: 500;"><%= idx++ %></td>
                <td>
                  <div style="font-weight: 700; color: #0f172a;"><%= s.getName() %></div>
                </td>
                <td>
                  <span style="font-weight: 600; color: #2563eb; font-family: monospace; font-size: 0.85rem;"><%= s.getStudentId() %></span>
                </td>
                <td style="color: #334155;"><%= s.getEmail() != null ? s.getEmail() : "-" %></td>
                <td style="text-align: center;">
                  <% if (sResults.isEmpty()) { %>
                    <span style="color: #94a3b8; font-size: 0.82rem;">မရှိသေးပါ</span>
                  <% } else { %>
                    <span style="font-weight: 700; color: #0f172a; font-size: 0.95rem;"><%= sResults.size() %></span>
                    <span style="color: #94a3b8; font-size: 0.8rem;"> ဘာသာ</span>
                  <% } %>
                </td>
                <td style="text-align: center;" onclick="event.stopPropagation()">
                  <div class="action-buttons-group justify-content-center">
                    <a href="<%= detailUrl %>" class="btn-action-icon detail" title="ရလဒ်အသေးစိတ်ကြည့်ရန်"
                       style="display:inline-flex; align-items:center; justify-content:center; text-decoration:none;">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                      </svg>
                    </a>
                  </div>
                </td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="6" style="text-align: center; padding: 2.5rem 1rem; color: var(--muted-foreground);">
                  <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-2 opacity-50">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>
                  </svg>
                  <div style="font-weight: 600; color: var(--foreground);">ကျောင်းသား မရှိသေးပါ</div>
                  <div style="font-size: 0.8rem;">ကျောင်းသားစာရင်း ထည့်သွင်းပါ။</div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>

        <!-- Pagination Footer Bar -->
        <div class="pagination-footer-bar">
          <div>
            Showing <%= students != null && !students.isEmpty() ? 1 : 0 %> to <%= students != null ? students.size() : 0 %> of <%= students != null ? students.size() : 0 %> Entries
          </div>
          <div class="pagination-controls-wrap">
            <select style="padding: 0.25rem 0.5rem; font-size: 0.78rem; border-radius: 0.375rem;">
              <option selected>5</option>
              <option>10</option>
              <option>25</option>
            </select>
            <span>Page 1 of 1</span>
            <div class="pagination-btn-group">
              <button type="button" class="btn-pagination-step" disabled>&laquo;</button>
              <button type="button" class="btn-pagination-step" disabled>&lt;</button>
              <button type="button" class="btn-pagination-step" disabled>&gt;</button>
              <button type="button" class="btn-pagination-step" disabled>&raquo;</button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </main>
  </div>
</div>

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
</body>
</html>
