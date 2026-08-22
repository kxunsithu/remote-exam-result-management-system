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
  .student-navbar-wrapper {
    width: 100%;
    background-color: #ffffff;
    border-bottom: 1px solid #e2e8f0;
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: 0 2px 8px rgba(15, 23, 42, 0.08);
  }
  .student-navbar-inner {
    max-width: 1400px;
    margin: 0 auto;
    height: 60px;
    padding: 0 1.5rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
  }
  .student-nav-brand {
    display: flex;
    align-items: center;
    gap: 0.65rem;
    min-width: 0;
    flex-shrink: 1;
    text-decoration: none;
  }
  .student-brand-icon {
    width: 34px;
    height: 34px;
    border-radius: 50%;
    background-color: #2563eb;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #ffffff;
    flex-shrink: 0;
  }
  .student-brand-text {
    display: flex;
    flex-direction: column;
    justify-content: center;
    min-width: 0;
  }
  .student-brand-title {
    margin: 0;
    font-size: 0.825rem;
    font-weight: 700;
    color: #0f172a;
    line-height: 1.2;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .student-brand-sub {
    margin: 0;
    font-size: 0.68rem;
    color: #94a3b8;
    line-height: 1.2;
    white-space: nowrap;
  }
  .student-nav-links {
    display: flex;
    align-items: center;
    gap: 0.35rem;
    margin-left: 1.5rem;
  }
  .student-nav-link {
    display: inline-flex;
    align-items: center;
    gap: 0.45rem;
    padding: 0.45rem 0.85rem;
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
    background-color: #eff6ff;
    color: #2563eb;
  }
  .student-nav-actions {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    flex-shrink: 0;
  }
  .student-user-pill {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.25rem 0.75rem 0.25rem 0.25rem;
    border-radius: 9999px;
    background-color: #f8fafc;
    border: 1px solid #e2e8f0;
  }
  .student-user-avatar {
    width: 26px;
    height: 26px;
    border-radius: 50%;
    background-color: #dbeafe;
    color: #1e40af;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.75rem;
    font-weight: 700;
    flex-shrink: 0;
  }
  .student-user-email {
    font-size: 0.8125rem;
    font-weight: 600;
    color: #334155;
    white-space: nowrap;
    max-width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .btn-student-logout {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.4rem 0.75rem;
    border-radius: 0.5rem;
    color: #64748b;
    font-size: 0.8125rem;
    font-weight: 500;
    text-decoration: none;
    border: 1px solid #e2e8f0;
    background-color: #ffffff;
    transition: all 0.15s ease;
  }
  .btn-student-logout:hover {
    background-color: #fee2e2;
    color: #dc2626;
    border-color: #fca5a5;
  }

  @media (max-width: 768px) {
    .student-navbar-inner { padding: 0 1rem; height: 54px; }
    .student-nav-links { margin-left: 0.5rem; }
    .student-nav-link { padding: 0.35rem 0.6rem; font-size: 0.78rem; }
    .student-nav-link span { display: none; }
  }

  @media (max-width: 580px) {
    .student-nav-links { display: none; }
    .student-user-email { display: none; }
    .student-brand-sub { display: none; }
    .student-user-pill { padding: 0.15rem; border: none; background: transparent; }
    .btn-student-logout span { display: none; }
    .btn-student-logout { padding: 0.4rem 0.5rem; }
  }
</style>

<div class="student-navbar-wrapper">
  <header class="student-navbar-inner">
    <div class="d-flex align-items-center" style="min-width: 0;">
      <!-- Brand -->
      <a href="${pageContext.request.contextPath}/student/dashboard" class="student-nav-brand">
        <div class="student-brand-icon">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
            <path d="M6 12v5c3 3 9 3 12 0v-5"/>
          </svg>
        </div>
        <div class="student-brand-text">
          <span class="student-brand-title">ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</span>
          <span class="student-brand-sub">Student Portal</span>
        </div>
      </a>

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

    <!-- Actions Right -->
    <div class="student-nav-actions">
      <!-- User Profile Pill -->
      <div class="student-user-pill">
        <div class="student-user-avatar">
          <%= userInitial %>
        </div>
        <span class="student-user-email"><%= userEmail %></span>
      </div>

      <!-- Logout -->
      <a href="${pageContext.request.contextPath}/logout" class="btn-student-logout" title="ထွက်မည်">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
          <polyline points="16 17 21 12 16 7"/>
          <line x1="21" y1="12" x2="9" y2="12"/>
        </svg>
        <span>ထွက်မည်</span>
      </a>
    </div>
  </header>
</div>

