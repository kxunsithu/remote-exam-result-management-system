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

                  <div class="p-4 sm:p-6 space-y-6 w-full max-w-7xl mx-auto">
                    <!-- Breadcrumb & Nav Row -->
                    <div class="flex items-center justify-between text-xs text-slate-500">
                      <div class="flex items-center gap-2">
                        <span>ပင်မစာမျက်နှာ</span>
                        <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <polyline points="9 18 15 12 9 6" />
                        </svg>
                        <span class="text-slate-900 font-medium">ပင်မအကျဉ်းချုပ်</span>
                      </div>

                    </div>

                    <!-- Hero Banner — Full-size Signboard Image -->
                    <div class="roundedl overflow-hidden shadow-xl border border-slate-800 relative"
                      style="min-height: 320px; max-height: 820px;">
                      <!-- Full-size signboard image -->
                      <img src="${pageContext.request.contextPath}/assets/images/uni.jpg"
                        alt="ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ) Signboard" class="w-full h-full object-cover object-center"
                        style="min-height: 320px; max-height: 820px;" />

                      <!-- Gradient overlay — only at bottom for text legibility -->
                      <div class="absolute inset-0 bg-gradient-to-t from-slate-950/95 via-slate-900/40 to-transparent">
                      </div>

                      <!-- Text content anchored at the bottom -->
                      <div class="absolute bottom-0 left-0 right-0 px-6 py-5 z-10">
                        <div class="flex flex-col sm:flex-row items-start sm:items-end justify-between gap-4">
                          <div class="flex items-center gap-4">
                            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="UCS Hpa-an Logo"
                              class="w-12 h-12 sm:w-14 sm:h-14 rounded-full object-cover border-2 border-white/50 shadow-lg shrink-0" />
                            <div>
                              <span
                                class="inline-block px-2.5 py-0.5 rounded-full bg-white/15 border border-white/25 text-[10px] font-bold text-blue-100 mb-1 backdrop-blur-sm">
                                University of Computer Studies (Hpa-an) — Admin Portal
                              </span>
                              <h1 class="text-xl sm:text-2xl font-extrabold text-white drop-shadow-lg">
                                ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)
                              </h1>
                              <p class="text-xs text-blue-200 mt-0.5">
                                စာမေးပွဲရလဒ် စီမံခန့်ခွဲမှု စနစ်
                              </p>
                            </div>
                          </div>

                          <a href="${pageContext.request.contextPath}/admin/results"
                            class="px-4 py-2.5 rounded-lg bg-white hover:bg-blue-50 text-blue-700 text-xs font-bold shadow-lg flex items-center gap-2 transition-all shrink-0 border border-white/80">
                            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                              stroke-width="2.5">
                              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                              <polyline points="14 2 14 8 20 8" />
                            </svg>
                            <span>ရလဒ်များ စီမံရန်</span>
                          </a>
                        </div>
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
                            <%= request.getAttribute("totalStudents") !=null ? request.getAttribute("totalStudents")
                              : "0" %>
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
                            <%= request.getAttribute("totalSubjects") !=null ? request.getAttribute("totalSubjects")
                              : "0" %>
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
                            <%= request.getAttribute("totalResults") !=null ? request.getAttribute("totalResults") : "0"
                              %>
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