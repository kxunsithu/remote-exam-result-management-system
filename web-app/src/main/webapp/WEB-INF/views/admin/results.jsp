<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "Exam Results" ); java.util.List<common.ExamResult> results = (java.util.List
      <common.ExamResult>) request.getAttribute("results");
        java.util.List<common.Student> students = (java.util.List<common.Student>) request.getAttribute("students");

            java.util.Map<Integer, java.util.List<common.ExamResult>> resultsByStudent = new java.util.HashMap<>();
                if (results != null) {
                for (common.ExamResult r : results) {
                resultsByStudent.computeIfAbsent(r.getStudentId(), k -> new java.util.ArrayList<>()).add(r);
                  }
                  }
                  %>
                  <!DOCTYPE html>
                  <html lang="my">

                  <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Exam Results &#8212; RERMS Admin</title>
                    <%@ include file="../common/tailwind-setup.jsp" %>
                  </head>

                  <body class="bg-slate-50 text-slate-800 min-h-screen font-sans antialiased">
                    <div class="flex min-h-screen">
                      <%@ include file="sidebar.jsp" %>

                        <main class="flex-1 flex flex-col min-w-0">
                          <%@ include file="header.jsp" %>

                            <div class="p-6 space-y-6 max-w-7xl w-full mx-auto">
                              <!-- Breadcrumb Nav -->
                              <div class="flex items-center justify-between text-xs text-slate-500">
                                <div class="flex items-center gap-2">
                                  <a href="${pageContext.request.contextPath}/admin/dashboard"
                                    class="hover:text-slate-900 transition-colors">ဒက်ရှ်ဘုတ်</a>
                                  <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <polyline points="9 18 15 12 9 6" />
                                  </svg>
                                  <span class="text-slate-900 font-medium">စာမေးပွဲရလဒ်များ</span>
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

                              <!-- Toolbar Card with Search Form -->
                              <div class="p-4 roundedl bg-white border border-slate-200 shadow-sm">
                                <form method="get" action="${pageContext.request.contextPath}/admin/results"
                                  class="flex flex-col sm:flex-row items-center justify-between gap-4">
                                  <div class="w-full sm:max-w-md space-y-1">
                                    <div class="relative">
                                      <svg class="w-4 h-4 text-slate-400 absolute left-3.5 top-3" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="11" cy="11" r="8" />
                                        <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                      </svg>
                                      <input type="text" name="search"
                                        placeholder="ကျောင်းသား သို့မဟုတ် ခုံနံပါတ် ရှာဖွေရန်..."
                                        value="<%= request.getAttribute("searchKeyword") !=null ? request.getAttribute("searchKeyword") : "" %>"
                                      class="w-full pl-10 pr-4 py-2.5 rounded bg-slate-50 border border-slate-300
                                      text-slate-900 text-xs placeholder-slate-400 focus:outline-none focus:border-blue-500
                                      focus:ring-2 focus:ring-blue-500/15 transition-all"/>
                                    </div>
                                    <p class="text-[11px] text-slate-500">
                                      ကျောင်းသားအမည်၊ ခုံနံပါတ် (Roll Number) သို့မဟုတ် အီးမေးလ်ဖြင့် ရှာဖွေနိုင်ပါသည်။
                                    </p>
                                  </div>
                                </form>
                              </div>

                              <!-- All Students List Table -->
                              <div
                                class="roundedl bg-white border border-slate-200 shadow-sm overflow-hidden">
                                <div class="overflow-x-auto">
                                  <table class="w-full text-left text-xs text-slate-700">
                                    <thead
                                      class="bg-slate-100/90 text-slate-700 uppercase font-bold text-[10px] tracking-wider border-b border-slate-200">
                                      <tr>
                                        <th class="py-3.5 px-4 w-12 text-center">စဉ်</th>
                                        <th class="py-3.5 px-4">ကျောင်းသား အမည်</th>
                                        <th class="py-3.5 px-4">ခုံနံပါတ်</th>
                                        <th class="py-3.5 px-4">အီးမေးလ်</th>
                                        <th class="py-3.5 px-4 text-center">ဘာသာရပ် (စုစုပေါင်း)</th>
                                        <th class="py-3.5 px-4 text-center">ရလဒ်ကြည့်ရန်</th>
                                      </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-200">
                                      <% if (students !=null && !students.isEmpty()) { int idx=1; for (common.Student s
                                        : students) { java.util.List<common.ExamResult> sResults =
                                        resultsByStudent.getOrDefault(s.getId(), java.util.Collections.emptyList());
                                        String detailUrl = request.getContextPath() +
                                        "/admin/results?action=studentDetail&studentId=" + s.getId();
                                        %>
                                        <tr class="hover:bg-slate-50 cursor-pointer transition-colors"
                                          onclick="window.location='<%= detailUrl %>'">
                                          <td class="py-3 px-4 text-center text-slate-400 font-medium">
                                            <%= idx++ %>
                                          </td>
                                          <td class="py-3 px-4 font-bold text-slate-900">
                                            <%= s.getName() %>
                                          </td>
                                          <td class="py-3 px-4"><span class="font-mono font-bold text-blue-600">
                                              <%= s.getStudentId() %>
                                            </span></td>
                                          <td class="py-3 px-4 text-slate-700">
                                            <%= s.getEmail() !=null ? s.getEmail() : "-" %>
                                          </td>
                                          <td class="py-3 px-4 text-center">
                                            <% if (sResults.isEmpty()) { %>
                                              <span class="text-slate-400">မရှိသေးပါ</span>
                                              <% } else { %>
                                                <span class="font-extrabold text-slate-900 text-sm">
                                                  <%= sResults.size() %>
                                                </span>
                                                <span class="text-slate-500"> ဘာသာ</span>
                                                <% } %>
                                          </td>
                                          <td class="py-3 px-4 text-center" onclick="event.stopPropagation()">
                                            <div class="flex items-center justify-center">
                                              <a href="<%= detailUrl %>"
                                                class="w-7 h-7 rounded bg-slate-100 border border-slate-200 text-slate-700 hover:bg-slate-200 flex items-center justify-center transition-colors"
                                                title="ရလဒ်အသေးစိတ်ကြည့်ရန်">
                                                <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                  stroke="currentColor" stroke-width="2">
                                                  <line x1="5" y1="12" x2="19" y2="12" />
                                                  <polyline points="12 5 19 12 12 19" />
                                                </svg>
                                              </a>
                                            </div>
                                          </td>
                                        </tr>
                                        <% } } else { %>
                                          <tr>
                                            <td colspan="6" class="text-center py-12 px-4 text-slate-500">
                                              <svg class="w-10 h-10 mx-auto mb-3 text-slate-300" viewBox="0 0 24 24"
                                                fill="none" stroke="currentColor" stroke-width="1.5">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                <circle cx="9" cy="7" r="4" />
                                              </svg>
                                              <div class="font-bold text-slate-700 text-sm mb-1">ကျောင်းသား မရှိသေးပါ
                                              </div>
                                              <p class="text-xs">ကျောင်းသားစာရင်း ထည့်သွင်းပါ။</p>
                                            </td>
                                          </tr>
                                          <% } %>
                                    </tbody>
                                  </table>
                                </div>

                                <!-- Pagination Footer Bar -->
                                <div
                                  class="px-4 py-3 bg-slate-50 border-t border-slate-200 flex items-center justify-between text-xs text-slate-500">
                                  <div>
                                    Showing <%= students !=null && !students.isEmpty() ? 1 : 0 %> to <%= students !=null
                                        ? students.size() : 0 %> of <%= students !=null ? students.size() : 0 %> Entries
                                  </div>
                                  <div class="flex items-center gap-3">
                                    <select
                                      class="px-2 py-1 rounded bg-white border border-slate-300 text-slate-700 text-xs">
                                      <option selected>5</option>
                                      <option>10</option>
                                      <option>25</option>
                                    </select>
                                    <span>Page 1 of 1</span>
                                  </div>
                                </div>
                              </div>

                            </div>
                        </main>
                    </div>

                    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                  </body>

                  </html>