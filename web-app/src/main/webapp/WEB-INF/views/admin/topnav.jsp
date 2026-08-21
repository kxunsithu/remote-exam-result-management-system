<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  common.User sessionUser = (common.User) session.getAttribute("user");
  String userEmail = sessionUser != null ? sessionUser.getEmail() : "";
  String userInitial = (userEmail != null && !userEmail.isEmpty()) ? userEmail.substring(0, 1).toUpperCase() : "A";
  String currentPath = request.getServletPath();
  String pageTitle = (String) request.getAttribute("pageTitle");
  if (pageTitle == null) pageTitle = "Dashboard";
%>
<!-- ── Admin Top Navigation Bar ─────────────────────────────── -->
<header class="admin-topnav">
  <div class="admin-topnav-inner">

    <!-- Sidebar Toggle (Hamburger) -->
    <button class="sidebar-toggle-btn" id="sidebarToggleBtn" aria-label="Toggle Sidebar" type="button">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="3" y1="6" x2="21" y2="6"/>
        <line x1="3" y1="12" x2="21" y2="12"/>
        <line x1="3" y1="18" x2="21" y2="18"/>
      </svg>
    </button>

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-brand">
      <div class="admin-brand-icon">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
          <path d="M6 12v5c3 3 9 3 12 0v-5"/>
        </svg>
      </div>
      <div class="admin-brand-text">
        <span class="admin-brand-title">UCS (Hpa-an)</span>
        <span class="admin-brand-sub">ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</span>
      </div>
    </a>



    <!-- Right: User + Logout -->
    <div class="admin-nav-right">
      <div class="admin-user-pill">
        <div class="admin-user-avatar"><%= userInitial %></div>
        <span class="admin-user-label">Admin</span>
      </div>
      <a href="${pageContext.request.contextPath}/logout" class="admin-logout-btn" title="ထွက်မည်">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
          <polyline points="16 17 21 12 16 7"/>
          <line x1="21" y1="12" x2="9" y2="12"/>
        </svg>
        ထွက်မည်
      </a>
    </div>

  </div>
</header>
