<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String currentPath = request.getServletPath();
%>
<!-- ── Sidebar ────────────────────────────────────────────────── -->
<aside class="sidebar" id="sidebar">

  <!-- Brand Header -->
  <div class="sidebar-brand">
    <div class="sidebar-logo">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
      </svg>
    </div>
    <div class="sidebar-brand-info">
      <p class="sidebar-brand-title">ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</p>
    </div>
  </div>

  <!-- Navigation Links -->
  <nav class="sidebar-nav">
    <ul class="sidebar-nav-list">
      <li>
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="sidebar-link <%= "/admin/dashboard".equals(currentPath) ? "active" : "" %>"
           title="ဒက်ရှ်ဘုတ်">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
            <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
          </svg>
          <span class="sidebar-link-text">ဒက်ရှ်ဘုတ်</span>
        </a>
      </li>

      <li>
        <a href="${pageContext.request.contextPath}/admin/students"
           class="sidebar-link <%= "/admin/students".equals(currentPath) ? "active" : "" %>"
           title="ဝင်ခွင့်ရကျောင်းသားများ">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
          <span class="sidebar-link-text">ဝင်ခွင့်ရကျောင်းသားများ</span>
        </a>
      </li>

      <li>
        <a href="${pageContext.request.contextPath}/admin/academics"
           class="sidebar-link <%= "/admin/academics".equals(currentPath) ? "active" : "" %>"
           title="ပညာသင်နှစ်များ">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
            <line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
          <span class="sidebar-link-text">ပညာသင်နှစ်များ</span>
        </a>
      </li>

      <li>
        <a href="${pageContext.request.contextPath}/admin/subjects"
           class="sidebar-link <%= "/admin/subjects".equals(currentPath) ? "active" : "" %>"
           title="ဘာသာရပ်များ">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
          </svg>
          <span class="sidebar-link-text">ဘာသာရပ်များ</span>
        </a>
      </li>

      <li>
        <a href="${pageContext.request.contextPath}/admin/results"
           class="sidebar-link <%= ("/admin/results".equals(currentPath) || currentPath.startsWith("/admin/results")) ? "active" : "" %>"
           title="စာမေးပွဲရလဒ်များ">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
            <polyline points="14 2 14 8 20 8"/>
            <line x1="16" y1="13" x2="8" y2="13"/>
            <line x1="16" y1="17" x2="8" y2="17"/>
          </svg>
          <span class="sidebar-link-text">စာမေးပွဲရလဒ်များ</span>
        </a>
      </li>
    </ul>
  </nav>

  <!-- User & Logout Footer -->
  <div class="sidebar-footer">
    <a href="#" class="btn-logout" data-bs-toggle="modal" data-bs-target="#globalLogoutModal" title="ထွက်မည်">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      <span>ထွက်မည်</span>
    </a>
  </div>
</aside>

<!-- ── Logout Confirmation Modal ─────────────────────────────── -->
<div class="modal fade" id="globalLogoutModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 25rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <div class="modal-body d-flex flex-column align-items-center gap-3 pt-4">
        <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <polyline points="16 17 21 12 16 7"/>
            <line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
        </div>
        <div class="d-flex flex-column gap-1">
          <h5 style="font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0;">အကောင့်မှ ထွက်ရန် သေချာပါသလား။</h5>
          <p style="font-size: 0.85rem; color: #64748b; margin: 0;">အကောင့်မှ ထွက်ပါက လက်ရှိ Admin Session ပိတ်သွားမည် ဖြစ်ပါသည်။</p>
        </div>
        <div class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal" style="flex: 1; padding: 0.6rem;">မထွက်ပါ</button>
          <a href="${pageContext.request.contextPath}/logout" class="btn-primary-custom" style="flex: 1; padding: 0.6rem; background-color: #dc2626; border-color: #dc2626;">ထွက်မည်</a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ── Global Delete Confirmation Modal ───────────────────────── -->
<div class="modal fade" id="globalDeleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <div class="modal-body d-flex flex-column align-items-center gap-3 pt-3">
        <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="3 6 5 6 21 6"/>
            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
            <line x1="10" y1="11" x2="10" y2="17"/>
            <line x1="14" y1="11" x2="14" y2="17"/>
          </svg>
        </div>
        <div class="d-flex flex-column gap-1">
          <h5 style="font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0;">အချက်အလက် ပယ်ဖျက်ရန် အတည်ပြုပါ</h5>
          <p style="font-size: 0.85rem; color: #64748b; margin: 0;">
            <strong id="globalDeleteTargetName" style="color: #dc2626;"></strong> ကို ပယ်ဖျက်ရန် သေချာပါသလား။ ဤလုပ်ဆောင်ချက်ကို ပြန်လည်ပြင်ဆင်၍ မရနိုင်ပါ။
          </p>
        </div>
        <div class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal" style="flex: 1; padding: 0.6rem;">မဖျက်ပါ</button>
          <button type="button" id="globalConfirmDeleteBtn" class="btn-primary-custom" style="flex: 1; padding: 0.6rem; background-color: #dc2626; border-color: #dc2626;">ဖျက်မည်</button>
        </div>
      </div>
    </div>
  </div>
</div>
