<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  common.User sessionUser = (common.User) session.getAttribute("user");
  String userEmail = sessionUser != null ? sessionUser.getEmail() : "";
  String userInitial = (userEmail != null && !userEmail.isEmpty()) ? userEmail.substring(0, 1).toUpperCase() : "S";
  String currentPath = request.getServletPath();
  String pageTitle = (String) request.getAttribute("pageTitle");
  if (pageTitle == null) pageTitle = "Student Dashboard";
%>
<!-- ── White Sidebar Navigation ────────────────────────────── -->
<aside class="sidebar" id="sidebar">
  <!-- Brand Header -->
  <div class="sidebar-brand">
    <div class="sidebar-logo" style="background-color: #10b981; border-radius: 50%;">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
      </svg>
    </div>
    <div class="sidebar-brand-info">
      <p class="sidebar-brand-title" style="font-size: 0.82rem; font-weight: 700; color: var(--foreground);">ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</p>
      <p class="sidebar-brand-subtitle" style="font-size: 0.7rem; color: var(--muted-foreground);">Student Portal</p>
    </div>
  </div>

  <!-- Navigation Links -->
  <nav class="sidebar-nav">
    <ul class="sidebar-nav-list">
      <li class="sidebar-section-label">ပင်မ မီနူး</li>

      <li>
        <a href="${pageContext.request.contextPath}/student/dashboard"
           class="sidebar-link <%= "/student/dashboard".equals(currentPath) ? "active" : "" %>"
           title="ဒက်ရှ်ဘုတ်">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
            <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
          </svg>
          <span class="sidebar-link-text">ဒက်ရှ်ဘုတ်</span>
        </a>
      </li>

      <li>
        <a href="${pageContext.request.contextPath}/student/results"
           class="sidebar-link <%= "/student/results".equals(currentPath) ? "active" : "" %>"
           title="ကျွန်ုပ်၏ ရလဒ်များ">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
            <polyline points="14 2 14 8 20 8"/>
            <line x1="16" y1="13" x2="8" y2="13"/>
            <line x1="16" y1="17" x2="8" y2="17"/>
            <polyline points="10 9 9 9 8 9"/>
          </svg>
          <span class="sidebar-link-text">ကျွန်ုပ်၏ ရလဒ်များ</span>
        </a>
      </li>
    </ul>
  </nav>

  <!-- Sidebar Footer & Logout -->
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout" title="ထွက်မည်">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      <span>ထွက်မည်</span>
    </a>
  </div>
</aside>
