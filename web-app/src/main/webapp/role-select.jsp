<!DOCTYPE html>
<html lang="my">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ဘက်ရွေးချယ်ရန် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
  <meta name="description" content="Select your role to continue" />
  <%@ include file="WEB-INF/views/common/tailwind-setup.jsp" %>
</head>

<body
  class="bg-slate-50 text-slate-800 min-h-screen flex items-center justify-center p-4 font-sans antialiased bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-blue-50 via-slate-50 to-slate-100">

  <div class="w-full max-w-lg bg-white border border-slate-200 roundedl p-8 shadow-xl">

    <!-- Role Cards -->
    <div class="space-y-3.5">
      <!-- Admin Card -->
      <a href="${pageContext.request.contextPath}/login?role=ADMIN"
        class="group flex items-center gap-4 p-4 rounded bg-slate-50 border border-slate-200 hover:border-blue-500 hover:bg-blue-50/60 transition-all duration-200 shadow-sm hover:shadow-md transform hover:-translate-y-0.5">
        <div
          class="w-12 h-12 rounded-full bg-blue-100 border border-blue-200 flex items-center justify-center text-blue-600 shrink-0 group-hover:scale-105 transition-transform">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
            <circle cx="12" cy="7" r="4" />
            <line x1="19" y1="8" x2="19" y2="14" />
            <line x1="22" y1="11" x2="16" y2="11" />
          </svg>
        </div>
        <div class="flex flex-col">
          <strong class="text-base font-bold text-slate-900 group-hover:text-blue-700 transition-colors">Admin</strong>
          <span class="text-xs text-slate-500">ဆရာ / စီမံခန့်ခွဲသူ ဘက် — ဝင်ရောက်မည်</span>
        </div>
        <div class="ml-auto text-slate-400 group-hover:text-blue-600 group-hover:translate-x-1 transition-all">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12" />
            <polyline points="12 5 19 12 12 19" />
          </svg>
        </div>
      </a>

      <!-- Student Card -->
      <a href="${pageContext.request.contextPath}/login?role=STUDENT"
        class="group flex items-center gap-4 p-4 rounded bg-slate-50 border border-slate-200 hover:border-emerald-500 hover:bg-emerald-50/60 transition-all duration-200 shadow-sm hover:shadow-md transform hover:-translate-y-0.5">
        <div
          class="w-12 h-12 rounded-full bg-emerald-100 border border-emerald-200 flex items-center justify-center text-emerald-600 shrink-0 group-hover:scale-105 transition-transform">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
            <path d="M6 12v5c3 3 9 3 12 0v-5" />
          </svg>
        </div>
        <div class="flex flex-col">
          <strong
            class="text-base font-bold text-slate-900 group-hover:text-emerald-700 transition-colors">Student</strong>
          <span class="text-xs text-slate-500">ကျောင်းသား / သူ ဘက် — ဝင်ရောက်မည်</span>
        </div>
        <div class="ml-auto text-slate-400 group-hover:text-emerald-600 group-hover:translate-x-1 transition-all">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
            stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12" />
            <polyline points="12 5 19 12 12 19" />
          </svg>
        </div>
      </a>
    </div>

  </div>

  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>

</html>