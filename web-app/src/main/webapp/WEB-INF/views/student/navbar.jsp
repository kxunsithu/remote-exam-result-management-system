<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%
      common.User sessionUser = (common.User) session.getAttribute("user");
      common.Student navStudent = (common.Student) request.getAttribute("student");
      String userEmail = sessionUser != null ? sessionUser.getEmail() : "";
      String navName = navStudent != null ? navStudent.getName() : (sessionUser != null ? sessionUser.getEmail() : "Student");
      String navRollNo = navStudent != null ? navStudent.getStudentId() : "";
      String navInitial = (navName != null && !navName.isEmpty()) ? navName.substring(0, 1).toUpperCase() : "S";
      String currentPath = request.getServletPath();
    %>
      <header class="bg-white/90 backdrop-blur-md border-b border-slate-200 sticky top-0 z-40 shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <!-- Left: Brand Logo & Title -->
          <div class="flex items-center gap-3">
            <div
              class="w-10 h-10 rounded bg-blue-50 border border-blue-200 text-blue-600 flex items-center justify-center shrink-0 shadow-sm">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                <path d="M6 12v5c3 3 9 3 12 0v-5" />
              </svg>
            </div>
            <div>
              <h1 class="text-sm sm:text-base font-extrabold text-slate-900 leading-tight">
                ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)
              </h1>
              <p class="text-[11px] text-slate-500 font-medium">Remote Exam Result Management System</p>
            </div>
          </div>

          <!-- Middle: Navigation Links -->
          <nav class="hidden md:flex items-center gap-1">
            <a href="${pageContext.request.contextPath}/student/dashboard"
              class="px-3.5 py-2 rounded text-xs font-semibold flex items-center gap-2 transition-all <%= "/student/dashboard".equals(currentPath) ? "bg-blue-50 text-blue-700 border border-blue-200 shadow-sm" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="3" width="7" height="7" />
                <rect x="14" y="3" width="7" height="7" />
                <rect x="14" y="14" width="7" height="7" />
                <rect x="3" y="14" width="7" height="7" />
              </svg>
              <span>ဒက်ရှ်ဘုတ်</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/results"
              class="px-3.5 py-2 rounded text-xs font-semibold flex items-center gap-2 transition-all <%= "/student/results".equals(currentPath) ? "bg-blue-50 text-blue-700 border border-blue-200 shadow-sm" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                <polyline points="14 2 14 8 20 8" />
                <line x1="16" y1="13" x2="8" y2="13" />
                <line x1="16" y1="17" x2="8" y2="17" />
              </svg>
              <span>စာမေးပွဲရလဒ်များ</span>
            </a>
          </nav>

          <!-- Right: Profile Info & Logout -->
          <div class="flex items-center gap-3">
            <div
              class="flex items-center gap-2.5 px-3 py-1.5 rounded-full bg-slate-100 border border-slate-200 hover:bg-slate-200/70 transition-all">
              <div
                class="w-7 h-7 rounded-full bg-emerald-600 flex items-center justify-center font-bold text-xs text-white shadow-sm">
                <%= navInitial %>
              </div>
              <div class="hidden sm:block text-left">
                <p class="text-xs font-bold text-slate-800 leading-tight">
                  <%= navName %>
                </p>
                <span class="text-[10px] text-slate-500 font-medium">
                  <%= navRollNo %>
                </span>
              </div>
            </div>

            <a href="#"
              class="p-2 rounded-full text-red-600 hover:bg-red-50 hover:border-red-200 border border-transparent transition-all"
              data-bs-toggle="modal" data-bs-target="#studentLogoutModal" title="ထွက်မည်">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                <polyline points="16 17 21 12 16 7" />
                <line x1="21" y1="12" x2="9" y2="12" />
              </svg>
              <span class="hidden sm:inline">ထွက်မည်</span>
            </a>
          </div>
        </div>
      </div>
    </header>

    <!-- Student Logout Confirmation Modal -->
    <div class="modal fade" id="studentLogoutModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered" style="max-width: 22rem;">
        <div class="modal-content">
          <div class="modal-accent modal-accent-red"></div>
          <div class="modal-body text-center" style="padding: 2rem 1.5rem 1.25rem;">
            <div class="w-14 h-14 rounded-full bg-red-50 border-2 border-red-100 flex items-center justify-center mx-auto mb-4">
              <svg class="w-7 h-7 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                <polyline points="16 17 21 12 16 7" />
                <line x1="21" y1="12" x2="9" y2="12" />
              </svg>
            </div>
            <h5 class="text-base font-bold text-slate-900 mb-1.5">အကောင့်မှ ထွက်ရန် သေချာပါသလား။</h5>
            <p class="text-xs text-slate-500 leading-relaxed">အကောင့်မှ ထွက်ပါက လက်ရှိ ကျောင်းသား Session ပိတ်သွားမည် ဖြစ်ပါသည်။</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn-outline-custom flex-1 justify-center" data-bs-dismiss="modal">မထွက်ပါ</button>
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