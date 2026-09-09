<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% common.User sessionUser = (common.User) session.getAttribute("user");
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
      <div class="flex items-center gap-2.5 min-w-0 shrink">
        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="UCS Hpa-an Logo"
          class="w-9 h-9 sm:w-10 sm:h-10 rounded-full object-cover shrink-0 shadow-sm border border-slate-200" />
        <div class="min-w-0">
          <h1 class="text-xs sm:text-sm font-extrabold text-slate-900 leading-normal pb-0.5 truncate">
            ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)
          </h1>
        </div>
      </div>

      <!-- Middle: Navigation Links (Desktop) -->
      <nav class="hidden md:flex items-center gap-1">
        <a href="${pageContext.request.contextPath}/student/dashboard"
          class='px-3.5 py-2 rounded text-xs font-semibold flex items-center gap-2 transition-all <%= "/student/dashboard".equals(currentPath) ? "bg-blue-50 text-blue-700 border border-blue-200 shadow-sm" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>'>
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7" />
            <rect x="14" y="3" width="7" height="7" />
            <rect x="14" y="14" width="7" height="7" />
            <rect x="3" y="14" width="7" height="7" />
          </svg>
          <span>ပင်မစာမျက်နှာ</span>
        </a>
        <a href="${pageContext.request.contextPath}/student/results"
          class='px-3.5 py-2 rounded text-xs font-semibold flex items-center gap-2 transition-all <%= "/student/results".equals(currentPath) ? "bg-blue-50 text-blue-700 border border-blue-200 shadow-sm" : "text-slate-600 hover:text-slate-900 hover:bg-slate-100" %>'>
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
            <polyline points="14 2 14 8 20 8" />
            <line x1="16" y1="13" x2="8" y2="13" />
            <line x1="16" y1="17" x2="8" y2="17" />
          </svg>
          <span>စာမေးပွဲရလဒ်များ</span>
        </a>
      </nav>

      <!-- Right: Logout + Mobile Hamburger -->
      <div class="flex items-center gap-2 shrink-0">

        <!-- Logout button (always visible) -->
        <button type="button"
          class="flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5 rounded-full text-xs font-bold text-red-600 hover:bg-red-50 hover:border-red-200 border border-slate-200 bg-white shadow-sm transition-all cursor-pointer whitespace-nowrap"
          data-bs-toggle="modal" data-bs-target="#studentLogoutModal" title="ထွက်မည်">
          <svg class="w-4 h-4 text-red-500 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
            <polyline points="16 17 21 12 16 7" />
            <line x1="21" y1="12" x2="9" y2="12" />
          </svg>
          <span class="hidden sm:inline">ထွက်မည်</span>
        </button>

        <!-- Hamburger button (mobile only) -->
        <button type="button" id="mobileMenuToggle"
          class="md:hidden w-9 h-9 flex items-center justify-center rounded border border-slate-200 bg-white hover:bg-slate-50 text-slate-600 shadow-sm transition-all"
          aria-label="Toggle menu" aria-expanded="false" aria-controls="mobileMenu">
          <svg id="hamburgerIcon" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <line x1="3" y1="6" x2="21" y2="6" />
            <line x1="3" y1="12" x2="21" y2="12" />
            <line x1="3" y1="18" x2="21" y2="18" />
          </svg>
          <svg id="closeIcon" class="w-5 h-5 hidden" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
            <line x1="18" y1="6" x2="6" y2="18" />
            <line x1="6" y1="6" x2="18" y2="18" />
          </svg>
        </button>

      </div>
    </div>
  </div>

  <!-- Mobile Dropdown Menu -->
  <div id="mobileMenu" class="md:hidden hidden border-t border-slate-200 bg-white shadow-lg">
    <nav class="max-w-7xl mx-auto px-4 py-3 flex flex-col gap-1">
      <a href="${pageContext.request.contextPath}/student/dashboard"
        class='flex items-center gap-3 px-3.5 py-3 rounded text-sm font-semibold transition-all <%= "/student/dashboard".equals(currentPath) ? "bg-blue-50 text-blue-700 border border-blue-200" : "text-slate-700 hover:bg-slate-100 hover:text-slate-900" %>'>
        <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <rect x="3" y="3" width="7" height="7" />
          <rect x="14" y="3" width="7" height="7" />
          <rect x="14" y="14" width="7" height="7" />
          <rect x="3" y="14" width="7" height="7" />
        </svg>
        ပင်မစာမျက်နှာ
      </a>
      <a href="${pageContext.request.contextPath}/student/results"
        class='flex items-center gap-3 px-3.5 py-3 rounded text-sm font-semibold transition-all <%= "/student/results".equals(currentPath) ? "bg-blue-50 text-blue-700 border border-blue-200" : "text-slate-700 hover:bg-slate-100 hover:text-slate-900" %>'>
        <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
          <polyline points="14 2 14 8 20 8" />
          <line x1="16" y1="13" x2="8" y2="13" />
          <line x1="16" y1="17" x2="8" y2="17" />
        </svg>
        စာမေးပွဲရလဒ်များ
      </a>
    </nav>
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

<script>
  (function () {
    var btn = document.getElementById('mobileMenuToggle');
    var menu = document.getElementById('mobileMenu');
    var hamburger = document.getElementById('hamburgerIcon');
    var close = document.getElementById('closeIcon');
    if (!btn || !menu) return;
    btn.addEventListener('click', function () {
      var isOpen = !menu.classList.contains('hidden');
      if (isOpen) {
        menu.classList.add('hidden');
        hamburger.classList.remove('hidden');
        close.classList.add('hidden');
        btn.setAttribute('aria-expanded', 'false');
      } else {
        menu.classList.remove('hidden');
        hamburger.classList.add('hidden');
        close.classList.remove('hidden');
        btn.setAttribute('aria-expanded', 'true');
      }
    });
  })();
</script>