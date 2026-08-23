<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "Student Dashboard" ); common.Student student=(common.Student)
      request.getAttribute("student"); Double avgObj=(Double) request.getAttribute("average"); String
      overallGrade=(String) request.getAttribute("overallGrade"); String overallStatus=(String)
      request.getAttribute("overallStatus"); Integer totalResults=(Integer) request.getAttribute("totalResults"); Double
      cgpaObj=(Double) request.getAttribute("cgpa"); java.util.List<common.ExamResult> results = (java.util.List
      <common.ExamResult>) request.getAttribute("results");

        long passCount = results != null ? results.stream().filter(r -> "PASS".equalsIgnoreCase(r.getStatus())).count()
        : 0;
        long totalCount = results != null ? results.size() : 0;
        double passRate = totalCount > 0 ? ((double) passCount / totalCount) * 100 : 0;
        %>

        <!DOCTYPE html>
        <html lang="my">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>ကျောင်းသား ဒက်ရှ်ဘုတ် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
          <%@ include file="../common/tailwind-setup.jsp" %>
        </head>

        <body class="bg-slate-50 text-slate-800 min-h-screen font-sans antialiased">
          <div class="min-h-screen flex flex-col">
            <%@ include file="navbar.jsp" %>

              <main class="flex-1 p-6 max-w-7xl w-full mx-auto space-y-6">

                <% if (request.getAttribute("rmiError") !=null) { %>
                  <div
                    class="p-4 rounded bg-amber-50 border border-amber-200 text-amber-800 text-xs flex items-center gap-2">
                    <svg class="w-4 h-4 text-amber-600 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2">
                      <circle cx="12" cy="12" r="10" />
                      <line x1="12" y1="8" x2="12" y2="12" />
                    </svg>
                    <span>
                      <%= request.getAttribute("rmiError") %>
                    </span>
                  </div>
                  <% } %>

                    <!-- Breadcrumb Row -->
                    <div class="flex items-center justify-between text-xs text-slate-500">
                      <div class="flex items-center gap-2">
                        <span class="text-slate-500">Student Portal</span>
                        <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <polyline points="9 18 15 12 9 6" />
                        </svg>
                        <span class="text-slate-900 font-medium">ဒက်ရှ်ဘုတ်</span>
                      </div>
                    </div>

                    <!-- Hero Banner Card -->
                    <div
                      class="p-6 sm:p-8 roundedl bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 border border-blue-500/20 shadow-md relative overflow-hidden">
                      <div
                        class="relative z-10 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6">
                        <div class="flex items-center gap-4">
                          <div
                            class="w-14 h-14 rounded-full bg-white/20 border-2 border-white/40 flex items-center justify-center text-xl font-extrabold text-white shadow-inner backdrop-blur-sm">
                            <%= student !=null && student.getName() !=null && !student.getName().isEmpty() ?
                              student.getName().substring(0, 1).toUpperCase() : "S" %>
                          </div>
                          <div>
                            <span
                              class="inline-block px-2.5 py-0.5 rounded-full bg-white/15 border border-white/20 text-[10px] font-bold text-blue-50 mb-1">
                              University of Computer Studies (Hpa-an)
                            </span>
                            <h1 class="text-xl sm:text-2xl font-extrabold text-white">
                              မင်္ဂလာပါ၊ <%= student !=null ? student.getName() : "Student" %>
                            </h1>
                            <p class="text-xs text-blue-100 mt-0.5">
                              ခုံနံပါတ်: <span class="font-mono font-bold text-white">
                                <%= student !=null ? student.getStudentId() : "-" %>
                              </span>
                            </p>
                          </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/student/results"
                          class="px-4 py-2.5 rounded bg-white hover:bg-slate-50 text-blue-700 text-xs font-bold shadow-md flex items-center gap-2 transition-all">
                          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                            <polyline points="14 2 14 8 20 8" />
                          </svg>
                          <span>ကျွန်ုပ်၏ ရလဒ်များ ကြည့်ရန် →</span>
                        </a>
                      </div>
                    </div>

                    <!-- Quick Statistics Cards Grid -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
                      <!-- Card 1: CGPA -->
                      <div class="p-5 roundedl bg-white border border-slate-200 shadow-sm space-y-3">
                        <div class="flex items-center justify-between">
                          <span class="text-xs font-semibold text-slate-500">CGPA (4.0 Scale)</span>
                          <div
                            class="w-8 h-8 rounded bg-blue-50 border border-blue-200 text-blue-600 flex items-center justify-center">
                            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <circle cx="12" cy="12" r="10" />
                              <path d="M12 6v6l4 2" />
                            </svg>
                          </div>
                        </div>
                        <div class="flex items-baseline justify-between">
                          <div class="text-2xl font-extrabold text-blue-600">
                            <%= cgpaObj !=null && cgpaObj> 0 ? String.format("%.2f", cgpaObj) : "0.00" %>
                          </div>
                          <span
                            class="px-2 py-0.5 rounded-full bg-blue-50 text-[10px] font-bold text-blue-700 border border-blue-200">Overall
                            CGPA</span>
                        </div>
                      </div>

                      <!-- Card 2: Average Score -->
                      <div class="p-5 roundedl bg-white border border-slate-200 shadow-sm space-y-3">
                        <div class="flex items-center justify-between">
                          <span class="text-xs font-semibold text-slate-500">ပျမ်းမျှ အမှတ် (Average)</span>
                          <div
                            class="w-8 h-8 rounded bg-blue-50 border border-blue-200 text-blue-600 flex items-center justify-center">
                            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <line x1="18" y1="20" x2="18" y2="10" />
                              <line x1="12" y1="20" x2="12" y2="4" />
                              <line x1="6" y1="20" x2="6" y2="14" />
                            </svg>
                          </div>
                        </div>
                        <div class="flex items-baseline justify-between">
                          <div class="text-2xl font-extrabold text-slate-900">
                            <%= avgObj !=null ? String.format("%.1f%%", avgObj) : "0.0%" %>
                          </div>
                          <span class="px-2 py-0.5 rounded-full bg-slate-100 border border-slate-200 text-[10px] font-bold text-slate-700">Grade
                            <%= overallGrade !=null ? overallGrade : "-" %>
                          </span>
                        </div>
                      </div>

                      <!-- Card 3: Passed Subjects -->
                      <div class="p-5 roundedl bg-white border border-slate-200 shadow-sm space-y-3">
                        <div class="flex items-center justify-between">
                          <span class="text-xs font-semibold text-slate-500">အောင်မြင်သည့် ဘာသာရပ်များ</span>
                          <div
                            class="w-8 h-8 rounded bg-emerald-50 border border-emerald-200 text-emerald-600 flex items-center justify-center">
                            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                              <polyline points="20 6 9 17 4 12" />
                            </svg>
                          </div>
                        </div>
                        <div class="flex items-baseline justify-between">
                          <div class="text-2xl font-extrabold text-slate-900">
                            <%= passCount %> / <%= totalCount %>
                          </div>
                          <span
                            class="px-2 py-0.5 rounded-full bg-emerald-50 border border-emerald-200 text-[10px] font-bold text-emerald-700">
                            <%= String.format("%.0f%%", passRate) %> အောင်မြင်
                          </span>
                        </div>
                      </div>
                    </div>

                    <!-- Content Layout Grid -->
                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                      <!-- Left: Student Profile Card -->
                      <div class="lg:col-span-5">
                        <div class="p-6 roundedl bg-white border border-slate-200 shadow-sm h-full space-y-4">
                          <h3 class="text-sm font-bold text-slate-900 border-b border-slate-200 pb-3">ကိုယ်ရေး အချက်အလက်
                            (Profile)</h3>
                          <% if (student !=null) { %>
                            <div class="flex items-center gap-3.5 pb-4 border-b border-slate-200">
                              <div
                                class="w-12 h-12 rounded-full bg-blue-600 text-white font-extrabold text-lg flex items-center justify-center shadow-md shadow-blue-600/20">
                                <%= student.getName().substring(0, 1).toUpperCase() %>
                              </div>
                              <div>
                                <h4 class="text-sm font-bold text-slate-900">
                                  <%= student.getName() %>
                                </h4>
                                <span class="text-xs font-mono font-bold text-blue-600">
                                  <%= student.getStudentId() %>
                                </span>
                              </div>
                            </div>

                            <div class="grid grid-cols-2 gap-4 text-xs">
                              <div class="col-span-2">
                                <span class="block text-[11px] text-slate-500 mb-0.5">အီးမေးလ်</span>
                                <span class="font-medium text-slate-800 break-all">
                                  <%= student.getEmail() %>
                                </span>
                              </div>
                              <div>
                                <span class="block text-[11px] text-slate-500 mb-0.5">ဖုန်းနံပါတ်</span>
                                <span class="font-medium text-slate-800">
                                  <%= student.getPhone() !=null ? student.getPhone() : "N/A" %>
                                </span>
                              </div>
                              <div>
                                <span class="block text-[11px] text-slate-500 mb-0.5">ကျား / မ</span>
                                <span class="font-medium text-slate-800">
                                  <%= student.getGender() !=null ? student.getGender() : "N/A" %>
                                </span>
                              </div>
                              <div class="col-span-2">
                                <span class="block text-[11px] text-slate-500 mb-0.5">စတင် ဝင်ရောက်သည့်နေ့</span>
                                <span class="font-medium text-slate-800">
                                  <%= student.getCreatedAt() !=null ? student.getCreatedAt().toLocalDate() : "N/A" %>
                                </span>
                              </div>
                            </div>
                            <% } else { %>
                              <div class="p-3 rounded bg-amber-50 text-amber-800 border border-amber-200 text-xs">
                                ကျောင်းသား အချက်အလက် မတွေ့ရှိပါ။
                              </div>
                              <% } %>
                        </div>
                      </div>

                      <!-- Right: Recent Exam Results Preview -->
                      <div class="lg:col-span-7">
                        <div
                          class="roundedl bg-white border border-slate-200 shadow-sm h-full overflow-hidden flex flex-col">
                          <div class="p-5 border-b border-slate-200 flex items-center justify-between">
                            <h3 class="text-sm font-bold text-slate-900">လတ်တလော စာမေးပွဲရလဒ်များ</h3>
                            <a href="${pageContext.request.contextPath}/student/results"
                              class="text-xs font-semibold text-blue-600 hover:text-blue-700 transition-colors">
                              အားလုံးကြည့်ရန် →
                            </a>
                          </div>

                          <div class="overflow-x-auto flex-1">
                            <table class="w-full text-left text-xs text-slate-700">
                              <thead
                                class="bg-slate-100/90 text-slate-700 uppercase font-bold text-[10px] tracking-wider border-b border-slate-200">
                                <tr>
                                  <th class="py-3 px-4">သင်္ကေတ</th>
                                  <th class="py-3 px-4">ဘာသာရပ်</th>
                                  <th class="py-3 px-4 text-center">ရမှတ်</th>
                                  <th class="py-3 px-4 text-center">Grade</th>
                                  <th class="py-3 px-4 text-center">အခြေအနေ</th>
                                </tr>
                              </thead>
                              <tbody class="divide-y divide-slate-200">
                                <% if (results !=null && !results.isEmpty()) { int count=0; for (common.ExamResult r :
                                  results) { if (count++>= 5) break;
                                  boolean isPass = "PASS".equalsIgnoreCase(r.getStatus());
                                  %>
                                  <tr class="hover:bg-slate-50 transition-colors">
                                    <td class="py-3 px-4 font-mono font-bold text-blue-600">
                                      <%= r.getSubjectCode() !=null ? r.getSubjectCode() : "-" %>
                                    </td>
                                    <td class="py-3 px-4 font-semibold text-slate-900">
                                      <%= r.getSubjectName() !=null ? r.getSubjectName() : "-" %>
                                    </td>
                                    <td class="py-3 px-4 text-center font-bold text-slate-900">
                                      <%= (int)r.getMarks() %> / <%= (int)r.getTotalMarks() %>
                                    </td>
                                    <td class="py-3 px-4 text-center">
                                      <span
                                        class="px-2 py-0.5 rounded-md font-mono font-bold text-xs bg-slate-100 text-slate-700 border border-slate-200">
                                        <%= r.getGrade() !=null ? r.getGrade() : "-" %>
                                      </span>
                                    </td>
                                    <td class="py-3 px-4 text-center">
                                      <% if (isPass) { %>
                                        <span
                                          class="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-50 border border-emerald-200 text-emerald-700">အောင်</span>
                                        <% } else { %>
                                          <span
                                            class="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-red-50 border border-red-200 text-red-700">ကျ</span>
                                          <% } %>
                                    </td>
                                  </tr>
                                  <% } } else { %>
                                    <tr>
                                      <td colspan="5" class="text-center py-8 text-slate-500">
                                        ရလဒ် မရှိသေးပါ
                                      </td>
                                    </tr>
                                    <% } %>
                              </tbody>
                            </table>
                          </div>
                        </div>
                      </div>
                    </div>

              </main>
          </div>

          <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        </body>

        </html>