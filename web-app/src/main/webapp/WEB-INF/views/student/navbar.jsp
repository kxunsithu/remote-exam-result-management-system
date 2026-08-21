<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  common.User sessionUser = (common.User) session.getAttribute("user");
  String userEmail = sessionUser != null ? sessionUser.getEmail() : "";
  String userInitial = (userEmail != null && !userEmail.isEmpty()) ? userEmail.substring(0, 1).toUpperCase() : "S";
  String currentPath = request.getServletPath();
%>
<!-- ── Student Top Navbar ─────────────────────────── -->
<style>
  /* Full-width sticky navbar (student side only) */
  .top-navbar {
    max-width: 100%;
    height: 58px;
    padding: 0 2rem;
    position: sticky;
    top: 0;
    z-index: 500;
    background-color: #ffffff;
    border-bottom: 1px solid #e2e8f0;
    box-shadow: 0 1px 4px rgba(15, 23, 42, 0.06);
  }
  .student-nav-links {
    display: flex;
    align-items: center;
    gap: 0.3rem;
    margin-left: 2rem;
  }
  .student-nav-link {
    display: inline-flex;
    align-items: center;
    gap: 0.45rem;
    padding: 0.5rem 1rem;
    border-radius: 0.55rem;
    font-size: 0.8125rem;
    font-weight: 600;
    color: #475569;
    text-decoration: none;
    transition: background-color 0.15s, color 0.15s;
    white-space: nowrap;
  }
  .student-nav-link:hover {
    background-color: #f1f5f9;
    color: #0f172a;
  }
  .student-nav-link.active {
    background-color: #dcfce7;
    color: #047857;
  }
  .student-nav-actions {
    display: flex;
    align-items: center;
    gap: 0.75rem;
  }
  @media (max-width: 640px) {
    .top-navbar { padding: 0 1rem; }
    .student-nav-links { display: none; }
  }
</style>
<header class="top-navbar">
  <div class="d-flex align-items-center">
    <!-- Brand -->
    <div class="d-flex align-items-center gap-2">
      <div style="width: 32px; height: 32px; border-radius: 50%; background-color: #10b981; display: flex; align-items: center; justify-content: center; color: #fff; flex-shrink: 0;">
        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
          <path d="M6 12v5c3 3 9 3 12 0v-5"/>
        </svg>
      </div>
      <div style="line-height: 1.2;">
        <p style="margin: 0; font-size: 0.82rem; font-weight: 700; color: #0f172a;">ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</p>
        <p style="margin: 0; font-size: 0.68rem; color: #94a3b8;">Student Portal</p>
      </div>
    </div>

    <!-- Navigation Links -->
    <nav class="student-nav-links">
      <a href="${pageContext.request.contextPath}/student/dashboard"
         class="student-nav-link <%= "/student/dashboard".equals(currentPath) ? "active" : "" %>"
         title="ဒက်ရှ်ဘုတ်">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
          <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
        </svg>
        <span>ဒက်ရှ်ဘုတ်</span>
      </a>
      <a href="${pageContext.request.contextPath}/student/results"
         class="student-nav-link <%= "/student/results".equals(currentPath) ? "active" : "" %>"
         title="ကျွန်ုပ်၏ ရလဒ်များ">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
          <line x1="16" y1="13" x2="8" y2="13"/>
          <line x1="16" y1="17" x2="8" y2="17"/>
          <polyline points="10 9 9 9 8 9"/>
        </svg>
        <span>ကျွန်ုပ်၏ ရလဒ်များ</span>
      </a>
    </nav>
  </div>

  <div class="student-nav-actions">
    <!-- User Profile Pill -->
    <div class="d-flex align-items-center gap-2 px-2 py-1 rounded-pill" style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
      <div class="navbar-user-avatar" style="width: 24px; height: 24px; font-size: 0.75rem; background-color: #dcfce7; color: #166534;">
        <%= userInitial %>
      </div>
      <span style="font-size: 0.8125rem; font-weight: 600; color: #334155;"><%= userEmail %></span>
    </div>

    <!-- Logout -->
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout" title="ထွက်မည်"
       style="display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.4rem 0.75rem;">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      <span>ထွက်မည်</span>
    </a>
  </div>
</header>
