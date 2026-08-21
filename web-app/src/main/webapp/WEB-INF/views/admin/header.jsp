<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
  common.User headerUser = (common.User) session.getAttribute("user");
  String headerEmail = headerUser != null ? headerUser.getEmail() : "";
  String headerInitial = (headerEmail != null && !headerEmail.isEmpty()) ? headerEmail.substring(0, 1).toUpperCase() : "A";
  String headerTitle = (String) request.getAttribute("headerTitle");
  if (headerTitle == null) {
    String pTitle = (String) request.getAttribute("pageTitle");
    if ("Student Management".equalsIgnoreCase(pTitle)) {
      headerTitle = "ဝင်ခွင့်ရကျောင်းသားများ စီမံခန့်ခွဲမှု";
    } else if ("Subject Management".equalsIgnoreCase(pTitle)) {
      headerTitle = "ဘာသာရပ်များ စီမံခန့်ခွဲမှု";
    } else if ("Exam Results".equalsIgnoreCase(pTitle) || "ရလဒ်အသေးစိတ်".equalsIgnoreCase(pTitle)) {
      headerTitle = "စာမေးပွဲရလဒ်များ စီမံခန့်ခွဲမှု";
    } else {
      headerTitle = "ဒက်ရှ်ဘုတ်";
    }
  }
%>
<!-- ── Top Header Bar ────────────────────────────────────────── -->
<header class="admin-topbar">
  <div class="d-flex align-items-center gap-3">
    <h1 class="topbar-title-heading"><%= headerTitle %></h1>
  </div>

  <div class="d-flex align-items-center gap-2">
    <div class="topbar-user-pill" data-bs-toggle="modal" data-bs-target="#globalLogoutModal" style="cursor: pointer;" title="ထွက်မည်">
      <div class="topbar-avatar"><%= headerInitial %></div>
      <span class="topbar-user-role">Admin</span>
    </div>
  </div>
</header>
