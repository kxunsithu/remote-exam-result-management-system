<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%-- navbar.jsp: sessionUser, userEmail, userInitial, pageTitle are declared in sidebar.jsp which is always included first --%>
<!-- ── Top Header Navbar ──────────────────────── -->
<header class="top-navbar">
  <div class="d-flex align-items-center gap-3">
    <!-- Main Title in Myanmar -->
    <h2 class="m-0" style="font-size: 1.15rem; font-weight: 700; color: #0f172a;">
      <% if ("Student Management".equalsIgnoreCase(pageTitle) || "Students".equalsIgnoreCase(pageTitle)) { %>
        ဝင်ခွင့်ရကျောင်းသားများ စီမံခန့်ခွဲမှု
      <% } else if ("Subject Management".equalsIgnoreCase(pageTitle) || "Subjects".equalsIgnoreCase(pageTitle)) { %>
        ဘာသာရပ်များ စီမံခန့်ခွဲမှု
      <% } else if ("Exam Results".equalsIgnoreCase(pageTitle) || "Results".equalsIgnoreCase(pageTitle)) { %>
        စာမေးပွဲရလဒ်များ စီမံခန့်ခွဲမှု
      <% } else { %>
        ဒက်ရှ်ဘုတ် စီမံခန့်ခွဲမှု
      <% } %>
    </h2>
  </div>

  <div class="navbar-actions">
    <!-- User Profile Pill -->
    <div class="d-flex align-items-center gap-2 px-2 py-1 rounded-pill" style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
      <div style="width: 24px; height: 24px; border-radius: 50%; background-color: #e2e8f0; display: flex; align-items: center; justify-content: center; color: #475569;">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
        </svg>
      </div>
      <span style="font-size: 0.8125rem; font-weight: 600; color: #334155;">Admin</span>
    </div>
  </div>
</header>

