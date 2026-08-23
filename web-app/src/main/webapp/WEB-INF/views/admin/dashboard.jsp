<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
      <% request.setAttribute("pageTitle", "Dashboard" ); %>
        <!DOCTYPE html>
        <html lang="my">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Admin Dashboard — RERMS</title>
          <%@ include file="../common/tailwind-setup.jsp" %>
        </head>

        <body class="bg-slate-50 text-slate-800 min-h-screen font-sans antialiased">
          <div class="flex min-h-screen">
            <%@ include file="sidebar.jsp" %>

              <main class="flex-1 flex flex-col min-w-0">
                <%@ include file="header.jsp" %>

                  <div class="p-6 space-y-6 max-w-7xl w-full mx-auto">
                    <!-- Breadcrumb & Nav Row -->
                    <div class="flex items-center justify-between text-xs text-slate-500">
                      <div class="flex items-center gap-2">
                        <span>ဒက်ရှ်ဘုတ်</span>
                        <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <polyline points="9 18 15 12 9 6" />
                        </svg>
                        <span class="text-slate-900 font-medium">ပင်မအကျဉ်းချုပ်</span>
                      </div>
                      <div class="flex items-center gap-1">
                        <button onclick="history.back()" aria-label="Go back" type="button"
                          class="w-7 h-7 rounded bg-white border border-slate-200 hover:bg-slate-100 text-slate-600 hover:text-slate-900 flex items-center justify-center transition-colors shadow-sm">
                          <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5">
                            <line x1="19" y1="12" x2="5" y2="12" />
                            <polyline points="12 19 5 12 12 5" />
                          </svg>
                        </button>
                        <button onclick="history.forward()" aria-label="Go forward" type="button"
                          class="w-7 h-7 rounded bg-white border border-slate-200 hover:bg-slate-100 text-slate-600 hover:text-slate-900 flex items-center justify-center transition-colors shadow-sm">
                          <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2.5">
                            <line x1="5" y1="12" x2="19" y2="12" />
                            <polyline points="12 5 19 12 12 19" />
                          </svg>
                        </button>
                      </div>
                    </div>

                    <!-- Welcome Banner -->
                    <div
                      class="p-6 roundedl bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 text-white shadow-md space-y-4">
                      <div class="flex items-start gap-4">
                        <div
                          class="w-14 h-14 roundedl bg-white/20 border border-white/30 flex items-center justify-center text-white shrink-0 shadow-inner">
                          <svg class="w-8 h-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                            <path d="M6 12v5c3 3 9 3 12 0v-5" />
                          </svg>
                        </div>
                        <div class="space-y-1">
                          <div class="flex items-center gap-2 flex-wrap">
                            <span
                              class="px-2.5 py-0.5 rounded-full bg-white/20 border border-white/30 text-[10px] font-bold text-white">UCS
                              (Hpa-an)</span>
                            <span class="text-xs text-blue-100">University of Computer Studies (Hpa-an)</span>
                          </div>
                          <h1 class="text-xl sm:text-2xl font-black text-white tracking-tight">
                            ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ) — စာမေးပွဲရလဒ် စီမံခန့်ခွဲမှု စနစ်
                          </h1>
                        </div>
                      </div>

                      <p class="text-xs sm:text-sm text-blue-100 leading-relaxed max-w-3xl">
                        ကြိုဆိုပါသည်၊ <strong class="text-white font-bold">Administrator</strong>။
                        ကျောင်းသားအချက်အလက်များ၊ ဘာသာရပ်များ၊ သင်ရိုးညွှန်းတမ်းနှင့် စာမေးပွဲရလဒ်များကို
                        အချိန်နှင့်တပြေးညီ လွယ်ကူစွာ စီမံခန့်ခွဲနိုင်ပါသည်။
                      </p>

                      <div class="flex items-center gap-3 flex-wrap pt-3 border-t border-white/20">
                        <span
                          class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/15 border border-white/20 text-xs font-semibold text-white">
                          <svg class="w-3.5 h-3.5 text-blue-200" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                            <polyline points="22,6 12,13 2,6" />
                          </svg>
                          admin@example.com
                        </span>
                        <span
                          class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-500/20 border border-emerald-300/30 text-xs font-semibold text-white">
                          <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                          Java RMI Server Connected
                        </span>
                      </div>
                    </div>

                    <!-- Overview Statistics Grid -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
                      <!-- Card 1: Total Students -->
                      <a href="${pageContext.request.contextPath}/admin/students"
                        class="group p-5 roundedl bg-white border border-slate-200 hover:border-blue-500 transition-all duration-200 shadow-sm hover:shadow-md">
                        <div class="flex items-center justify-between mb-3">
                          <span class="text-xs font-semibold text-slate-500">ကျောင်းသား/သူ ဦးရေ</span>
                          <div
                            class="w-9 h-9 rounded bg-blue-50 border border-blue-200 text-blue-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                              <circle cx="9" cy="7" r="4" />
                            </svg>
                          </div>
                        </div>
                        <div class="flex items-baseline justify-between">
                          <span class="text-2xl font-black text-slate-900">
                            <%= request.getAttribute("totalStudents") !=null ? request.getAttribute("totalStudents") : "0" %>
                          </span>
                          <span
                            class="text-xs font-semibold text-blue-600 group-hover:translate-x-1 transition-transform">ကြည့်ရန်
                            &rarr;</span>
                        </div>
                      </a>

                      <!-- Card 2: Total Subjects -->
                      <a href="${pageContext.request.contextPath}/admin/subjects"
                        class="group p-5 roundedl bg-white border border-slate-200 hover:border-purple-500 transition-all duration-200 shadow-sm hover:shadow-md">
                        <div class="flex items-center justify-between mb-3">
                          <span class="text-xs font-semibold text-slate-500">ဘာသာရပ် အရေအတွက်</span>
                          <div
                            class="w-9 h-9 rounded bg-purple-50 border border-purple-200 text-purple-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                              <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                            </svg>
                          </div>
                        </div>
                        <div class="flex items-baseline justify-between">
                          <span class="text-2xl font-black text-slate-900">
                            <%= request.getAttribute("totalSubjects") !=null ? request.getAttribute("totalSubjects") : "0" %>
                          </span>
                          <span
                            class="text-xs font-semibold text-purple-600 group-hover:translate-x-1 transition-transform">ကြည့်ရန်
                            &rarr;</span>
                        </div>
                      </a>

                      <!-- Card 3: Exam Results -->
                      <a href="${pageContext.request.contextPath}/admin/results"
                        class="group p-5 roundedl bg-white border border-slate-200 hover:border-emerald-500 transition-all duration-200 shadow-sm hover:shadow-md">
                        <div class="flex items-center justify-between mb-3">
                          <span class="text-xs font-semibold text-slate-500">စာမေးပွဲ ရလဒ်များ</span>
                          <div
                            class="w-9 h-9 rounded bg-emerald-50 border border-emerald-200 text-emerald-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                            </svg>
                          </div>
                        </div>
                        <div class="flex items-baseline justify-between">
                          <span class="text-2xl font-black text-slate-900">
                            <%= request.getAttribute("totalResults") !=null ? request.getAttribute("totalResults") : "0" %>
                          </span>
                          <span
                            class="text-xs font-semibold text-emerald-600 group-hover:translate-x-1 transition-transform">ကြည့်ရန်
                            &rarr;</span>
                        </div>
                      </a>
                    </div>

                    <!-- Quick Actions Grid -->
                    <div class="space-y-4">
                      <h2 class="text-sm font-bold text-slate-900">လျင်မြန်စွာ ဆောင်ရွက်ရန်</h2>
                      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <a href="${pageContext.request.contextPath}/admin/students"
                          class="group p-4 roundedl bg-white border border-slate-200 hover:border-blue-500 hover:bg-blue-50/30 transition-all flex items-center gap-3.5 shadow-sm">
                          <div
                            class="w-10 h-10 rounded bg-blue-50 border border-blue-200 text-blue-600 flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                              <circle cx="9" cy="7" r="4" />
                            </svg>
                          </div>
                          <div>
                            <h3 class="text-xs font-bold text-slate-900 group-hover:text-blue-700 transition-colors">
                              ကျောင်းသား/သူ စီမံခန့်ခွဲမှု</h3>
                            <p class="text-[11px] text-slate-500">ကျောင်းသားအချက်အလက်များ ထည့်သွင်းခြင်း၊ ပြင်ဆင်ခြင်း
                            </p>
                          </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/subjects"
                          class="group p-4 roundedl bg-white border border-slate-200 hover:border-purple-500 hover:bg-purple-50/30 transition-all flex items-center gap-3.5 shadow-sm">
                          <div
                            class="w-10 h-10 rounded bg-purple-50 border border-purple-200 text-purple-600 flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <line x1="12" y1="5" x2="12" y2="19" />
                              <line x1="5" y1="12" x2="19" y2="12" />
                            </svg>
                          </div>
                          <div>
                            <h3 class="text-xs font-bold text-slate-900 group-hover:text-purple-700 transition-colors">
                              ဘာသာရပ် စီမံခန့်ခွဲမှု</h3>
                            <p class="text-[11px] text-slate-500">သင်ရိုးညွှန်းတမ်း ဘာသာရပ်များနှင့် Credit
                              သတ်မှတ်ချက်များ</p>
                          </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/results"
                          class="group p-4 roundedl bg-white border border-slate-200 hover:border-emerald-500 hover:bg-emerald-50/30 transition-all flex items-center gap-3.5 shadow-sm">
                          <div
                            class="w-10 h-10 rounded bg-emerald-50 border border-emerald-200 text-emerald-600 flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            </svg>
                          </div>
                          <div>
                            <h3 class="text-xs font-bold text-slate-900 group-hover:text-emerald-700 transition-colors">
                              စာမေးပွဲ ရလဒ် ထည့်သွင်းရန်</h3>
                            <p class="text-[11px] text-slate-500">အမှတ်များ စိစစ်ခြင်းနှင့် Grade တွက်ချက်ခြင်း</p>
                          </div>
                        </a>
                      </div>
                    </div>

                  </div>
              </main>
          </div>

          <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        </body>

        </html>