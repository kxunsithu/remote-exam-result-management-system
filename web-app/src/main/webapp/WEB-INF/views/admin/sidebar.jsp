<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% String currentPath=request.getServletPath(); %>
      <!-- Sidebar -->
      <aside class="w-60 bg-white border-r border-slate-200 flex flex-col shrink-0 h-screen sticky top-0 z-40"
        id="sidebar">

        <!-- Brand Header -->
        <div class="p-4 border-b border-slate-200 flex items-center gap-3">
<img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="UCS Hpa-an Logo" class="w-9 h-9 rounded-full object-cover shrink-0 shadow-sm border border-slate-200" />
          <div>
            <p class="text-xs font-bold text-slate-900 leading-normal pb-0.5">ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</p>
            <span class="text-[10px] text-slate-500 font-medium">UCSHPAAN</span>
          </div>
        </div>

        <!-- Navigation Links -->
        <nav class="flex-1 p-3 space-y-1.5 overflow-y-auto">
          <a href="${pageContext.request.contextPath}/admin/dashboard"
            class='flex items-center gap-3 px-3.5 py-2.5 rounded text-xs font-medium transition-all <%= "/admin/dashboard".equals(currentPath) ? "bg-blue-50 border border-blue-200 text-blue-700 font-bold" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>'
            title="ပင်မစာမျက်နှာ">
            <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="3" width="7" height="7" />
              <rect x="14" y="3" width="7" height="7" />
              <rect x="14" y="14" width="7" height="7" />
              <rect x="3" y="14" width="7" height="7" />
            </svg>
            <span>ပင်မစာမျက်နှာ</span>
          </a>

          <a href="${pageContext.request.contextPath}/admin/students"
            class='flex items-center gap-3 px-3.5 py-2.5 rounded text-xs font-medium transition-all <%= "/admin/students".equals(currentPath) ? "bg-blue-50 border border-blue-200 text-blue-700 font-bold" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>'
            title="ကျောင်းသား/သူများ">
            <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            <span>ကျောင်းသား/သူများ</span>
          </a>

          <a href="${pageContext.request.contextPath}/admin/subjects"
            class='flex items-center gap-3 px-3.5 py-2.5 rounded text-xs font-medium transition-all <%= "/admin/subjects".equals(currentPath) ? "bg-blue-50 border border-blue-200 text-blue-700 font-bold" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>'
            title="ဘာသာရပ်များ">
            <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
              <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
            </svg>
            <span>ဘာသာရပ်များ</span>
          </a>

          <a href="${pageContext.request.contextPath}/admin/academics"
            class='flex items-center gap-3 px-3.5 py-2.5 rounded text-xs font-medium transition-all <%= "/admin/academics".equals(currentPath) ? "bg-blue-50 border border-blue-200 text-blue-700 font-bold" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>'
            title="ပညာသင်နှစ်များ">
            <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
              <line x1="16" y1="2" x2="16" y2="6" />
              <line x1="8" y1="2" x2="8" y2="6" />
              <line x1="3" y1="10" x2="21" y2="10" />
            </svg>
            <span>ပညာသင်နှစ်များ</span>
          </a>

          <a href="${pageContext.request.contextPath}/admin/results"
            class='flex items-center gap-3 px-3.5 py-2.5 rounded text-xs font-medium transition-all <%= ("/admin/results".equals(currentPath) || (currentPath != null && currentPath.startsWith("/admin/results"))) ? "bg-blue-50 border border-blue-200 text-blue-700 font-bold" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>'
            title="စာမေးပွဲရလဒ်များ">
            <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
              <polyline points="14 2 14 8 20 8" />
              <line x1="16" y1="13" x2="8" y2="13" />
              <line x1="16" y1="17" x2="8" y2="17" />
            </svg>
            <span>စာမေးပွဲရလဒ်များ</span>
          </a>
        </nav>

        <!-- User & Logout Footer -->
        <div class="p-3 border-t border-slate-200">
          <a href="#"
            class="flex items-center gap-2.5 px-3 py-2 rounded text-xs font-semibold text-red-600 hover:bg-red-50 hover:border-red-200 border border-transparent transition-all"
            data-bs-toggle="modal" data-bs-target="#globalLogoutModal" title="ထွက်မည်">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
              <polyline points="16 17 21 12 16 7" />
              <line x1="21" y1="12" x2="9" y2="12" />
            </svg>
            <span>ထွက်မည်</span>
          </a>
        </div>
      </aside>

      <!-- Logout Confirmation Modal -->
      <div class="modal fade" id="globalLogoutModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 22rem;">
          <div class="modal-content">
            <div class="modal-accent modal-accent-red"></div>
            <div class="modal-body text-center" style="padding: 2rem 1.5rem 1.25rem;">
              <div
                class="w-14 h-14 rounded-full bg-red-50 border-2 border-red-100 flex items-center justify-center mx-auto mb-4">
                <svg class="w-7 h-7 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                  stroke-width="2">
                  <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                  <polyline points="16 17 21 12 16 7" />
                  <line x1="21" y1="12" x2="9" y2="12" />
                </svg>
              </div>
              <h5 class="text-base font-bold text-slate-900 mb-1.5">အကောင့်မှ ထွက်ရန် သေချာပါသလား။</h5>
              <p class="text-xs text-slate-500 leading-relaxed">
                အကောင့်မှ ထွက်ပါက လက်ရှိ Admin Session ပိတ်သွားမည် ဖြစ်ပါသည်။
              </p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn-outline-custom flex-1 justify-center"
                data-bs-dismiss="modal">မထွက်ပါ</button>
              <a href="${pageContext.request.contextPath}/logout" class="btn-danger-custom flex-1 justify-center">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                  <polyline points="16 17 21 12 16 7" />
                  <line x1="21" y1="12" x2="9" y2="12" />
                </svg>
                ထွက်မည်
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Global Delete Confirmation Modal -->
      <div class="modal fade" id="globalDeleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 22rem;">
          <div class="modal-content">
            <div class="modal-accent modal-accent-red"></div>
            <div class="modal-body text-center" style="padding: 2rem 1.5rem 1.25rem;">
              <div
                class="w-14 h-14 rounded-full bg-red-50 border-2 border-red-100 flex items-center justify-center mx-auto mb-4">
                <svg class="w-7 h-7 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                  stroke-width="2">
                  <polyline points="3 6 5 6 21 6" />
                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                </svg>
              </div>
              <h5 class="text-base font-bold text-slate-900 mb-1.5">အချက်အလက် ပယ်ဖျက်ရန် အတည်ပြုပါ</h5>
              <p class="text-xs text-slate-500 leading-relaxed">
                <strong id="globalDeleteTargetName" class="text-red-600 font-semibold"></strong> ကို ပယ်ဖျက်ရန်
                သေချာပါသလား။ ဤလုပ်ဆောင်ချက်ကို ပြန်လည်ပြင်ဆင်၍ မရနိုင်ပါ။
              </p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn-outline-custom flex-1 justify-center"
                data-bs-dismiss="modal">မဖျက်ပါ</button>
              <button type="button" id="globalConfirmDeleteBtn" class="btn-danger-custom flex-1 justify-center">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <polyline points="3 6 5 6 21 6" />
                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6" />
                </svg>
                ဖျက်မည်
              </button>
            </div>
          </div>
        </div>
      </div>