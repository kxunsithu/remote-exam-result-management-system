<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  common.User sessionUser = (common.User) session.getAttribute("user");
  String userEmail = sessionUser != null ? sessionUser.getEmail() : "";
  String userInitial = (userEmail != null && !userEmail.isEmpty()) ? userEmail.substring(0, 1).toUpperCase() : "S";
  String currentPath = request.getServletPath();
%>
<!-- ── Student Sidebar ───────────────────────────────────── -->
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
      <span>Student Portal</span>
    </div>
  </div>

  <nav class="sidebar-nav">
    <div class="nav-section-label">Menu</div>

    <a href="${pageContext.request.contextPath}/student/dashboard"
       class="sidebar-link <%= "/student/dashboard".equals(currentPath) ? "active" : "" %>">
      <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
        <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
      Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/student/results"
       class="sidebar-link <%= "/student/results".equals(currentPath) ? "active" : "" %>">
      <svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
      My Results
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
    <span class="page-title"><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Student Dashboard" %></span>
  </div>
  <div class="navbar-user">
    <div class="user-info">
      <div class="user-name"><%= userEmail %></div>
      <div class="user-role"><span class="badge-role" style="background:#e0e7ff;color:#3730a3;">STUDENT</span></div>
    </div>
    <div class="user-avatar" style="background:linear-gradient(135deg, #10b981, #059669);"><%= userInitial %></div>
  </div>
</header>
