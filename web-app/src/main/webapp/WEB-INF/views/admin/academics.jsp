<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "ပညာသင်နှစ်များ" ); java.util.List<common.AcademicYear> years = (java.util.List
      <common.AcademicYear>) request.getAttribute("years");
        java.util.Map<Integer, java.util.List<common.Semester>> semsByYear =
          (java.util.Map<Integer, java.util.List<common.Semester>>) request.getAttribute("semsByYear");
            java.util.Map<Integer, java.util.List<common.Subject>> subjectsBySemester =
              (java.util.Map<Integer, java.util.List<common.Subject>>) request.getAttribute("subjectsBySemester");
                java.util.List<common.Subject> unassignedSubjects =
                  (java.util.List<common.Subject>) request.getAttribute("unassignedSubjects");
                    java.util.List<common.Subject> allSubjects =
                      (java.util.List<common.Subject>) request.getAttribute("allSubjects");
                        java.util.Set<Integer> availableSemesterNumbers =
                          (java.util.Set<Integer>) request.getAttribute("availableSemesterNumbers");
                            if (availableSemesterNumbers == null) availableSemesterNumbers =
                            java.util.Collections.emptySet();
                            %>
                            <!DOCTYPE html>
                            <html lang="my">

                            <head>
                              <meta charset="UTF-8" />
                              <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                              <title>ပညာသင်နှစ်များ — RERMS Admin</title>
                              <%@ include file="../common/tailwind-setup.jsp" %>
                                <style>
                                  .year-card-body {
                                    display: block;
                                  }

                                  .year-card-body.collapsed-body {
                                    display: none;
                                  }
                                </style>
                            </head>

                            <body class="bg-slate-50 text-slate-800 min-h-screen font-sans antialiased">
                              <div class="flex min-h-screen">
                                <%@ include file="sidebar.jsp" %>

                                  <main class="flex-1 flex flex-col min-w-0">
                                    <%@ include file="header.jsp" %>

                                      <div class="p-4 sm:p-6 space-y-6 w-full max-w-7xl mx-auto">
                                        <!-- Breadcrumb Nav -->
                                        <div class="flex items-center justify-between text-xs text-slate-500">
                                          <div class="flex items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                                              class="hover:text-slate-900 transition-colors">ပင်မစာမျက်နှာ</a>
                                            <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none"
                                              stroke="currentColor" stroke-width="2">
                                              <polyline points="9 18 15 12 9 6" />
                                            </svg>
                                            <span class="text-slate-900 font-medium">ပညာသင်နှစ်များ</span>
                                          </div>

                                          <div class="flex items-center gap-1">
                                            <button onclick="history.back()" aria-label="Go back" type="button"
                                              class="w-7 h-7 rounded bg-white border border-slate-200 hover:bg-slate-100 text-slate-600 hover:text-slate-900 flex items-center justify-center transition-colors shadow-sm">
                                              <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
                                                <line x1="19" y1="12" x2="5" y2="12" />
                                                <polyline points="12 19 5 12 12 5" />
                                              </svg>
                                            </button>
                                            <button onclick="history.forward()" aria-label="Go forward" type="button"
                                              class="w-7 h-7 rounded bg-white border border-slate-200 hover:bg-slate-100 text-slate-600 hover:text-slate-900 flex items-center justify-center transition-colors shadow-sm">
                                              <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
                                                <line x1="5" y1="12" x2="19" y2="12" />
                                                <polyline points="12 5 19 12 12 19" />
                                              </svg>
                                            </button>
                                          </div>
                                        </div>

                                        <!-- Workflow hint + Add Year Button -->
                                        <div class="p-4 roundedl bg-white border border-slate-200 shadow-sm">
                                          <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
                                            <div class="flex items-center gap-3 text-xs text-slate-600 flex-wrap">
                                              <a href="${pageContext.request.contextPath}/admin/subjects"
                                                class="inline-flex items-center gap-1.5 text-blue-600 hover:text-blue-700 font-semibold transition-colors">
                                                <span
                                                  class="w-5 h-5 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center text-[10px] font-bold">၁</span>
                                                ဘာသာရပ်များ create (Semester ရွေး)
                                              </a>
                                              <svg class="w-3.5 h-3.5 text-slate-400" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <polyline points="9 18 15 12 9 6" />
                                              </svg>
                                              <span class="inline-flex items-center gap-1.5 text-slate-800 font-medium">
                                                <span
                                                  class="w-5 h-5 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center text-[10px] font-bold">၂</span>
                                                ပညာသင်နှစ် ထည့် (Semester auto-create + subjects auto-ချိတ်)
                                              </span>
                                            </div>

                                            <button type="button" data-bs-toggle="modal" data-bs-target="#addYearModal"
                                              class="w-full sm:w-auto px-4 py-2.5 rounded bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white text-xs font-bold shadow-md shadow-blue-600/20 flex items-center justify-center gap-2 transition-all transform active:scale-[0.98]">
                                              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                stroke-width="2.5">
                                                <line x1="12" y1="5" x2="12" y2="19" />
                                                <line x1="5" y1="12" x2="19" y2="12" />
                                              </svg>
                                              <span>ပညာသင်နှစ် ထည့်ရန်</span>
                                            </button>
                                          </div>
                                        </div>

                                        <!-- Academic Year Accordion -->
                                        <% if (years==null || years.isEmpty()) { %>
                                          <div
                                            class="roundedl bg-white border border-slate-200 shadow-sm text-center py-12 px-4 text-slate-500">
                                            <svg class="w-10 h-10 mx-auto mb-3 text-slate-300" viewBox="0 0 24 24"
                                              fill="none" stroke="currentColor" stroke-width="1.5">
                                              <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                                              <line x1="16" y1="2" x2="16" y2="6" />
                                              <line x1="8" y1="2" x2="8" y2="6" />
                                              <line x1="3" y1="10" x2="21" y2="10" />
                                            </svg>
                                            <div class="font-bold text-slate-700 text-sm mb-1">ပညာသင်နှစ် မရှိသေးပါ
                                            </div>
                                            <p class="text-xs">အဆင့် ၁ - <a
                                                href="${pageContext.request.contextPath}/admin/subjects"
                                                class="text-blue-600 hover:underline font-semibold">ဘာသာရပ်များ</a> အရင်
                                              create
                                              လုပ်ပါ၊ ပြီးမှ ပညာသင်နှစ် ထည့်သွင်းပါ။</p>
                                          </div>
                                          <% } else { int yearIdx=0; for (common.AcademicYear y : years) {
                                            java.util.List<common.Semester> sems = semsByYear != null ?
                                            semsByYear.getOrDefault(y.getId(), java.util.Collections.emptyList()) :
                                            java.util.Collections.emptyList();
                                            String collapseId = "year-collapse-" + yearIdx;
                                            %>
                                            <div
                                              class="rounded-lg bg-white border border-slate-200 shadow-sm overflow-hidden space-y-0"
                                              data-year-id="<%= y.getId() %>">
                                              <!-- Year Header -->
                                              <div
                                                class="w-full px-5 py-4 bg-slate-100/80 hover:bg-slate-200/60 border-b border-slate-200 flex items-center justify-between cursor-pointer transition-colors"
                                                 onclick="toggleYearCard(this)" aria-expanded='<%= yearIdx == 0 ? "true" : "false" %>'>
                                                <div class="flex items-center gap-3">
                                                  <svg class="w-4 h-4 text-blue-600 shrink-0" viewBox="0 0 24 24"
                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                                                    <line x1="16" y1="2" x2="16" y2="6" />
                                                    <line x1="8" y1="2" x2="8" y2="6" />
                                                    <line x1="3" y1="10" x2="21" y2="10" />
                                                  </svg>
                                                  <h3 class="text-sm font-extrabold text-slate-900">ပညာသင်နှစ် <%=
                                                      y.getYearName() %>
                                                  </h3>
                                                  <span
                                                    class="px-2.5 py-0.5 rounded-full bg-blue-50 border border-blue-200 text-[11px] font-bold text-blue-700">
                                                    <%= sems.size() %> Semester · <%= y.getSubjectCount() %> ဘာသာရပ်
                                                  </span>
                                                </div>

                                                <div class="flex items-center gap-2" onclick="event.stopPropagation()">
                                                  <button type="button"
                                                    class="w-7 h-7 rounded bg-blue-50 border border-blue-200 text-blue-600 hover:bg-blue-100 flex items-center justify-center transition-colors"
                                                    data-bs-toggle="modal" data-bs-target="#editYearModal"
                                                    data-id="<%= y.getId() %>" data-yearname="<%= y.getYearName() %>"
                                                    title="ပညာသင်နှစ် ပြင်ဆင်ရန်">
                                                    <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                      stroke="currentColor" stroke-width="2">
                                                      <path
                                                        d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                      <path
                                                        d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                  </button>
                                                  <button type="button"
                                                    class="w-7 h-7 rounded bg-red-50 border border-red-200 text-red-600 hover:bg-red-100 flex items-center justify-center transition-colors"
                                                    data-bs-toggle="modal" data-bs-target="#deleteYearModal"
                                                    data-id="<%= y.getId() %>"
                                                    data-name="ပညာသင်နှစ် <%= y.getYearName() %>"
                                                    title="ပညာသင်နှစ် ဖျက်ရန်">
                                                    <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                      stroke="currentColor" stroke-width="2">
                                                      <polyline points="3 6 5 6 21 6" />
                                                      <path
                                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                    </svg>
                                                  </button>
                                                </div>
                                              </div>

                                              <!-- Semesters Content -->
                                              <div class='year-card-body<%= yearIdx == 0 ? "" : " collapsed-body" %>'
                                                id="<%= collapseId %>">
                                                  <div class="divide-y divide-slate-200 bg-slate-50/50">
                                                    <% for (common.Semester s : sems) { java.util.List<common.Subject>
                                                      semSubjects = subjectsBySemester != null
                                                      ? subjectsBySemester.getOrDefault(s.getId(),
                                                      java.util.Collections.emptyList())
                                                      : java.util.Collections.emptyList();
                                                      %>
                                                      <div class="p-4 space-y-3">
                                                        <div class="flex items-center justify-between">
                                                          <div class="flex items-center gap-2.5">
                                                            <span class="w-2 h-2 rounded-full bg-blue-600"></span>
                                                            <h4 class="text-xs font-bold text-slate-900">Semester <%=
                                                                s.getSemesterNumber() %>
                                                            </h4>
                                                            <span class="text-[11px] text-slate-500">(<%=
                                                                semSubjects.size() %> ဘာသာရပ်)</span>
                                                          </div>

                                                          <div class="flex items-center gap-1.5">
                                                            <a href="${pageContext.request.contextPath}/admin/subjects?semesterId=<%= s.getId() %>"
                                                              class="w-7 h-7 rounded bg-slate-100 border border-slate-200 text-slate-700 hover:bg-slate-200 flex items-center justify-center transition-colors"
                                                              title="ဤ Semester ရဲ့ ဘာသာရပ်များကို ကြည့်ရန်">
                                                              <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                <path
                                                                  d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                              </svg>
                                                            </a>
                                                            <button type="button"
                                                              class="w-7 h-7 rounded bg-blue-50 border border-blue-200 text-blue-600 hover:bg-blue-100 flex items-center justify-center transition-colors"
                                                              data-bs-toggle="modal" data-bs-target="#editSemesterModal"
                                                              data-id="<%= s.getId() %>"
                                                              data-yearid="<%= s.getAcademicYearId() %>"
                                                              data-number="<%= s.getSemesterNumber() %>"
                                                              title="Semester ပြင်ဆင်ရန်">
                                                              <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path
                                                                  d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                <path
                                                                  d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                              </svg>
                                                            </button>
                                                            <button type="button"
                                                              class="w-7 h-7 rounded bg-red-50 border border-red-200 text-red-600 hover:bg-red-100 flex items-center justify-center transition-colors"
                                                              data-bs-toggle="modal"
                                                              data-bs-target="#deleteSemesterModal"
                                                              data-id="<%= s.getId() %>"
                                                              data-name="Semester <%= s.getSemesterNumber() %> (<%= y.getYearName() %>)"
                                                              title="ဖျက်ရန်">
                                                              <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="3 6 5 6 21 6" />
                                                                <path
                                                                  d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                              </svg>
                                                            </button>
                                                          </div>
                                                        </div>

                                                        <% if (!semSubjects.isEmpty()) { %>
                                                          <div class="flex flex-wrap gap-2 pl-4">
                                                            <% for (common.Subject sub : semSubjects) { %>
                                                              <span
                                                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white border border-slate-200 text-xs font-medium text-slate-700 shadow-sm">
                                                                <span class="font-mono font-bold text-blue-600">
                                                                  <%= sub.getSubjectCode() %>
                                                                </span>
                                                                <%= sub.getSubjectName() %>
                                                              </span>
                                                              <% } %>
                                                          </div>
                                                          <% } %>
                                                      </div>
                                                      <% } %>

                                                        <!-- Inline add-semester row -->
                                                        <div class="p-4 bg-slate-100/60 border-t border-slate-200">
                                                          <form method="post"
                                                            action="${pageContext.request.contextPath}/admin/academics"
                                                            class="flex items-center gap-3 flex-wrap">
                                                            <input type="hidden" name="action" value="addSemester" />
                                                            <input type="hidden" name="academicYearId"
                                                              value="<%= y.getId() %>" />
                                                            <span
                                                              class="w-5 h-5 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center text-[10px] font-bold">၂</span>
                                                            <select name="semesterNumber" required
                                                              class="px-3 py-1.5 rounded bg-white border border-slate-300 text-slate-800 text-xs focus:outline-none focus:border-blue-500">
                                                              <% if (availableSemesterNumbers.isEmpty()) { %>
                                                                <option value="">(ဘာသာရပ် မရှိသေးပါ - ဘာသာရပ်များ page
                                                                  မှ အရင်ထည့်ပါ)</option>
                                                                <% } else { %>
                                                                  <option value="">Semester ရွေးပါ —</option>
                                                                  <% for (Integer sn : availableSemesterNumbers) {
                                                                    boolean alreadyInYear=false; for (common.Semester
                                                                    existingSem : sems) { if
                                                                    (existingSem.getSemesterNumber()==sn) {
                                                                    alreadyInYear=true; break; } } if (!alreadyInYear) {
                                                                    %>
                                                                    <option value="<%= sn %>">Semester <%= sn %>
                                                                    </option>
                                                                    <% } } %>
                                                                      <% } %>
                                                            </select>
                                                            <button type="submit"
                                                              class="px-3 py-1.5 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 flex items-center gap-1.5 transition-all"
                                                              <%=availableSemesterNumbers.isEmpty() ? "disabled" : ""
                                                              %>>
                                                              <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2.5">
                                                                <line x1="12" y1="5" x2="12" y2="19" />
                                                                <line x1="5" y1="12" x2="19" y2="12" />
                                                              </svg>
                                                              Semester ထည့်ရန်
                                                            </button>
                                                            <span class="text-[11px] text-slate-500">ဘာသာရပ်ရှိသော
                                                              Semester သာ ရွေးချယ်နိုင်ပါမည်။</span>
                                                          </form>
                                                        </div>
                                                  </div>
                                              </div>

                                            </div>
                                            <% yearIdx++; } } %>

                                      </div>
                                  </main>
                              </div>

                              <!-- Add Academic Year Modal -->
                              <div class="modal fade" id="addYearModal" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" style="max-width: 28rem;">
                                  <div
                                    class="modal-content bg-white border border-slate-200 roundedl shadow-xl text-slate-800 p-0 overflow-hidden">
                                    <div class="px-6 py-4 border-b border-slate-200 flex items-center justify-between">
                                      <h5 class="text-sm font-bold text-slate-900">ပညာသင်နှစ် အသစ် ထည့်သွင်းရန်</h5>
                                      <button type="button" class="text-slate-400 hover:text-slate-600"
                                        data-bs-dismiss="modal">&times;</button>
                                    </div>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/academics"
                                      class="p-6 space-y-4">
                                      <input type="hidden" name="action" value="addYear" />

                                      <div>
                                        <label class="block text-xs font-semibold text-slate-700 mb-1.5"
                                          for="add-yearName">ပညာသင်နှစ် *</label>
                                        <input type="text" id="add-yearName" name="yearName"
                                          placeholder="e.g. 2024-2025" pattern="\d{4}\s*-\s*\d{4}" required
                                          class="w-full px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-xs focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500/15" />
                                      </div>

                                      <div>
                                        <label class="block text-xs font-semibold text-slate-700 mb-2">Semester
                                          Auto-create &amp; Subject Auto-link (Optional)</label>
                                        <div class="grid grid-cols-4 gap-2">
                                          <% if (availableSemesterNumbers.isEmpty()) { %>
                                            <div
                                              class="col-span-4 text-xs text-slate-500 p-3 bg-slate-50 rounded border border-slate-200 text-center">
                                              ဘာသာရပ် မရှိသေးပါ။ <a
                                                href="${pageContext.request.contextPath}/admin/subjects"
                                                class="text-blue-600 hover:underline font-semibold">ဘာသာရပ်များ page</a>
                                              မှ အရင်
                                              create လုပ်ပါ။
                                            </div>
                                            <% } else { %>
                                              <% for (Integer si : availableSemesterNumbers) { %>
                                                <label
                                                  class="flex items-center gap-2 p-2 rounded bg-slate-50 border border-slate-200 text-xs font-medium text-slate-700 cursor-pointer hover:border-slate-300">
                                                  <input type="checkbox" name="semesterNumbers" value="<%= si %>"
                                                    checked
                                                    class="w-4 h-4 rounded text-blue-600 bg-white border-slate-300 focus:ring-blue-500" />
                                                  Sem <%= si %>
                                                </label>
                                                <% } %>
                                                  <% } %>
                                        </div>
                                      </div>

                                      <div class="pt-4 border-t border-slate-200 flex items-center justify-end gap-2">
                                        <button type="button"
                                          class="px-4 py-2 rounded border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100"
                                          data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
                                        <button type="submit"
                                          class="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20">ထည့်သွင်းမည်</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>

                              <!-- Edit Academic Year Modal -->
                              <div class="modal fade" id="editYearModal" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
                                  <div
                                    class="modal-content bg-white border border-slate-200 roundedl shadow-xl text-slate-800 p-0 overflow-hidden">
                                    <div class="px-6 py-4 border-b border-slate-200 flex items-center justify-between">
                                      <h5 class="text-sm font-bold text-slate-900">ပညာသင်နှစ် ပြင်ဆင်ရန်</h5>
                                      <button type="button" class="text-slate-400 hover:text-slate-600"
                                        data-bs-dismiss="modal">&times;</button>
                                    </div>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/academics"
                                      class="p-6 space-y-4">
                                      <input type="hidden" name="action" value="updateYear" />
                                      <input type="hidden" name="id" id="edit-year-id" />

                                      <div>
                                        <label class="block text-xs font-semibold text-slate-700 mb-1.5"
                                          for="edit-year-name">ပညာသင်နှစ် *</label>
                                        <input type="text" name="yearName" id="edit-year-name"
                                          placeholder="e.g. 2024-2025" pattern="\d{4}\s*-\s*\d{4}" required
                                          class="w-full px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-xs focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500/15" />
                                      </div>

                                      <div class="pt-4 border-t border-slate-200 flex items-center justify-end gap-2">
                                        <button type="button"
                                          class="px-4 py-2 rounded border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100"
                                          data-bs-dismiss="modal">မပြင်ဆင်ပါ</button>
                                        <button type="submit"
                                          class="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20">ပြင်ဆင်မည်</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>

                              <!-- Delete Academic Year Modal -->
                              <div class="modal fade" id="deleteYearModal" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" style="max-width: 24rem;">
                                  <div
                                    class="modal-content bg-white border border-slate-200 roundedl shadow-xl text-slate-800 p-6 text-center">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/academics">
                                      <input type="hidden" name="action" value="deleteYear" />
                                      <input type="hidden" name="id" id="delete-year-id" />
                                      <div
                                        class="w-12 h-12 rounded-full bg-red-50 border border-red-200 text-red-600 flex items-center justify-center mx-auto mb-4">
                                        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                          stroke-width="2">
                                          <polyline points="3 6 5 6 21 6" />
                                          <path
                                            d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                        </svg>
                                      </div>
                                      <h5 class="text-base font-bold text-slate-900 mb-1">ပညာသင်နှစ် ပယ်ဖျက်ရန်
                                        အတည်ပြုပါ
                                      </h5>
                                      <p class="text-xs text-slate-500 mb-6">
                                        <strong id="delete-year-name" class="text-red-600"></strong> ကို ပယ်ဖျက်ပါက
                                        ၎င်း၏ Semester၊ ဘာသာရပ်နှင့် ရလဒ်များ အားလုံး ပျက်သွားမည်။ သေချာပါသလား။
                                      </p>
                                      <div class="flex items-center gap-3">
                                        <button type="button"
                                          class="flex-1 py-2.5 px-4 rounded border border-slate-300 hover:bg-slate-100 text-slate-700 text-xs font-semibold"
                                          data-bs-dismiss="modal">မဖျက်ပါ</button>
                                        <button type="submit"
                                          class="flex-1 py-2.5 px-4 rounded bg-red-600 hover:bg-red-700 text-white text-xs font-bold shadow-md shadow-red-600/20">ဖျက်မည်</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>

                              <!-- Edit Semester Modal -->
                              <div class="modal fade" id="editSemesterModal" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
                                  <div
                                    class="modal-content bg-white border border-slate-200 roundedl shadow-xl text-slate-800 p-0 overflow-hidden">
                                    <div class="px-6 py-4 border-b border-slate-200 flex items-center justify-between">
                                      <h5 class="text-sm font-bold text-slate-900">Semester ပြင်ဆင်ရန်</h5>
                                      <button type="button" class="text-slate-400 hover:text-slate-600"
                                        data-bs-dismiss="modal">&times;</button>
                                    </div>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/academics"
                                      class="p-6 space-y-4">
                                      <input type="hidden" name="action" value="updateSemester" />
                                      <input type="hidden" name="id" id="edit-sem-id" />
                                      <input type="hidden" name="academicYearId" id="edit-sem-yearid" />

                                      <div>
                                        <label class="block text-xs font-semibold text-slate-700 mb-1.5"
                                          for="edit-sem-number">Semester *</label>
                                        <select name="semesterNumber" id="edit-sem-number" required
                                          class="w-full px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-xs focus:outline-none focus:border-blue-500">
                                           <% if (availableSemesterNumbers.isEmpty()) { %>
                                             <option value="">(ဘာသာရပ် မရှိသေးပါ - ဘာသာရပ်များ page မှ အရင်ထည့်ပါ)</option>
                                             <% } else { %>
                                               <% for (Integer sn : availableSemesterNumbers) { %>
                                                 <option value="<%= sn %>">Semester <%= sn %></option>
                                                 <% } %>
                                                   <% } %>
                                        </select>
                                      </div>

                                      <div class="pt-4 border-t border-slate-200 flex items-center justify-end gap-2">
                                        <button type="button"
                                          class="px-4 py-2 rounded border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100"
                                          data-bs-dismiss="modal">မပြင်ဆင်ပါ</button>
                                        <button type="submit"
                                          class="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20">ပြင်ဆင်မည်</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>

                              <!-- Delete Semester Modal -->
                              <div class="modal fade" id="deleteSemesterModal" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" style="max-width: 24rem;">
                                  <div
                                    class="modal-content bg-white border border-slate-200 roundedl shadow-xl text-slate-800 p-6 text-center">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/academics">
                                      <input type="hidden" name="action" value="deleteSemester" />
                                      <input type="hidden" name="id" id="delete-sem-id" />
                                      <div
                                        class="w-12 h-12 rounded-full bg-red-50 border border-red-200 text-red-600 flex items-center justify-center mx-auto mb-4">
                                        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                          stroke-width="2">
                                          <polyline points="3 6 5 6 21 6" />
                                          <path
                                            d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                        </svg>
                                      </div>
                                      <h5 class="text-base font-bold text-slate-900 mb-1">Semester ပယ်ဖျက်ရန် အတည်ပြုပါ
                                      </h5>
                                      <p class="text-xs text-slate-500 mb-6">
                                        <strong id="delete-sem-name" class="text-red-600"></strong> ကို ပယ်ဖျက်ပါက ၎င်း၏
                                        ဘာသာရပ်နှင့် ရလဒ်များ ပျက်သွားမည်။ သေချာပါသလား။
                                      </p>
                                      <div class="flex items-center gap-3">
                                        <button type="button"
                                          class="flex-1 py-2.5 px-4 rounded border border-slate-300 hover:bg-slate-100 text-slate-700 text-xs font-semibold"
                                          data-bs-dismiss="modal">မဖျက်ပါ</button>
                                        <button type="submit"
                                          class="flex-1 py-2.5 px-4 rounded bg-red-600 hover:bg-red-700 text-white text-xs font-bold shadow-md shadow-red-600/20">ဖျက်မည်</button>
                                      </div>
                                    </form>
                                  </div>
                                </div>
                              </div>

                              <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                              <script>
                                document.getElementById('editYearModal').addEventListener('show.bs.modal', function (e) {
                                  const d = e.relatedTarget.dataset;
                                  document.getElementById('edit-year-id').value = d.id || '';
                                  document.getElementById('edit-year-name').value = d.yearname || '';
                                });
                                document.getElementById('deleteYearModal').addEventListener('show.bs.modal', function (e) {
                                  const d = e.relatedTarget.dataset;
                                  document.getElementById('delete-year-id').value = d.id || '';
                                  document.getElementById('delete-year-name').textContent = d.name || '';
                                });
                                document.getElementById('editSemesterModal').addEventListener('show.bs.modal', function (e) {
                                  const d = e.relatedTarget.dataset;
                                  document.getElementById('edit-sem-id').value = d.id || '';
                                  document.getElementById('edit-sem-yearid').value = d.yearid || '';
                                  document.getElementById('edit-sem-number').value = d.number || '';
                                });
                                document.getElementById('deleteSemesterModal').addEventListener('show.bs.modal', function (e) {
                                  const d = e.relatedTarget.dataset;
                                  document.getElementById('delete-sem-id').value = d.id || '';
                                  document.getElementById('delete-sem-name').textContent = d.name || '';
                                });
                                function toggleYearCard(header) {
                                  var card = header.closest('[data-year-id]');
                                  var body = card ? card.querySelector('.year-card-body') : null;
                                  if (!body) return;
                                  var isExpanded = header.getAttribute('aria-expanded') === 'true';
                                  if (isExpanded) {
                                    body.classList.add('collapsed-body');
                                    header.setAttribute('aria-expanded', 'false');
                                  } else {
                                    body.classList.remove('collapsed-body');
                                    header.setAttribute('aria-expanded', 'true');
                                  }
                                }
                              </script>
                            </body>

                            </html>