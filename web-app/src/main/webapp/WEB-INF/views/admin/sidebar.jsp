<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  common.User sessionUser = (common.User) session.getAttribute("user");
  String userEmail = sessionUser != null ? sessionUser.getEmail() : "";
  String userInitial = (userEmail != null && !userEmail.isEmpty()) ? userEmail.substring(0, 1).toUpperCase() : "U";
  String currentPath = request.getServletPath();
%>
<!-- ── Sidebar ───────────────────────────────────────── -->
<aside class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <div class="sidebar-brand-icon">
      <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"
              stroke="white" stroke-width="2" fill="none" stroke-linecap="round"/>
      </svg>
    </div>
    <div class="sidebar-brand-text">
      RERMS
      <span>Exam Result System</span>
    </div>
  </div>

  <nav class="sidebar-nav">
    <div class="nav-section-label">Main</div>

    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="sidebar-link <%= "/admin/dashboard".equals(currentPath) ? "active" : "" %>">
      <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
        <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
      Dashboard
    </a>

    <div class="nav-section-label">Management</div>

    <a href="${pageContext.request.contextPath}/admin/students"
       class="sidebar-link <%= "/admin/students".equals(currentPath) ? "active" : "" %>">
      <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
        <circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
        <path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
      Students
    </a>

    <a href="${pageContext.request.contextPath}/admin/subjects"
       class="sidebar-link <%= "/admin/subjects".equals(currentPath) ? "active" : "" %>">
      <svg viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
      Subjects
    </a>

    <a href="${pageContext.request.contextPath}/admin/results"
       class="sidebar-link <%= "/admin/results".equals(currentPath) ? "active" : "" %>">
      <svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
      Exam Results
    </a>
  </nav>

  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-link" style="color:#ef4444;">
      <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/></svg>
      Logout
    </a>
  </div>
</aside>

<!-- ── Top Navbar ─────────────────────────────────────── -->
<header class="top-navbar">
  <div class="top-navbar-left">
    <button id="sidebar-toggle" style="background:none;border:none;cursor:pointer;display:none;"
            aria-label="Toggle sidebar">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2">
        <line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/>
        <line x1="3" y1="18" x2="21" y2="18"/>
      </svg>
    </button>
    <span class="page-title"><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Dashboard" %></span>
  </div>
  <div class="navbar-user">
    <div class="user-info">
      <div class="user-name"><%= userEmail %></div>
      <div class="user-role"><span class="badge-role">ADMIN</span></div>
    </div>
    <div class="user-avatar"><%= userInitial %></div>
  </div>
</header>
