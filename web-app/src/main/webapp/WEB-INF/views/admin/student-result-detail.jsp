<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "ရလဒ်အသေးစိတ်" ); java.util.List<common.ExamResult> results = (java.util.List
      <common.ExamResult>) request.getAttribute("studentResults");
        common.Student student = (common.Student) request.getAttribute("studentInfo");
        java.util.List<common.AcademicYear> academicYears = (java.util.List<common.AcademicYear>)
            request.getAttribute("academicYears");
            java.util.List<common.Semester> allSemesters = (java.util.List<common.Semester>)
                request.getAttribute("semesters");
            java.util.List<common.Subject> allSubjects = (java.util.List<common.Subject>)
                request.getAttribute("subjects");

                // Group by academic year, then semester
                java.util.LinkedHashMap<String, java.util.Map<Integer, java.util.List<common.ExamResult>>> byYear = new
                  java.util.LinkedHashMap<>();
                    if (results != null) {
                    for (common.ExamResult r : results) {
                    String year = r.getAcademicYear() != null ? r.getAcademicYear() : "Unknown";
                    int sem = r.getSemester();
                    byYear.computeIfAbsent(year, k -> new java.util.TreeMap<>())
                      .computeIfAbsent(sem, k -> new java.util.ArrayList<>())
                        .add(r);
                        }
                        }
                        %>
                        <!DOCTYPE html>
                        <html lang="my">

                        <head>
                          <meta charset="UTF-8" />
                          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                          <title>ရလဒ်အသေးစိတ် &#8212; RERMS Admin</title>
                          <%@ include file="../common/tailwind-setup.jsp" %>
                            <style>
                              .result-grid { display: grid; grid-template-columns: 1fr 90px 80px 80px 90px; align-items: center; }
                              .chevron-icon { transition: transform 0.2s; }
                              [aria-expanded="false"] .chevron-icon { transform: rotate(-90deg); }
                              /* year-card-body: always block, toggled by JS */
                              .year-card-body { display: block; }
                              .year-card-body.collapsed-body { display: none; }
                              /* Modal light-theme */
                              .modal-body   { background: #ffffff !important; color: #1e293b !important; }
                              .modal-footer { background: #ffffff !important; border-top: 1px solid #e2e8f0 !important; }
                              .form-label   { color: #475569 !important; font-size: 0.8rem; font-weight: 600; display: block; margin-bottom: 0.3rem; }
                              .btn-primary-custom  { display:inline-flex; align-items:center; gap:0.5rem; padding:0.55rem 1.25rem; border-radius:0.5rem; background:rgb(37 99 235); color:#fff; font-weight:700; font-size:0.85rem; border:none; cursor:pointer; transition:background 0.15s; }
                              .btn-primary-custom:hover { background:rgb(29 78 216); }
                              .btn-outline-custom  { display:inline-flex; align-items:center; gap:0.5rem; padding:0.55rem 1.25rem; border-radius:0.5rem; background:transparent; color:#64748b; font-weight:600; font-size:0.85rem; border:1px solid #cbd5e1; cursor:pointer; transition:all 0.15s; }
                              .btn-outline-custom:hover { background:#f1f5f9; color:#0f172a; }
                            </style>

                        </head>

                        <body class="bg-slate-50 text-slate-800 min-h-screen font-sans antialiased">
                          <div class="flex min-h-screen">
                            <%@ include file="sidebar.jsp" %>

                              <main class="flex-1 flex flex-col min-w-0">
                                <%@ include file="header.jsp" %>

                                  <div class="p-6 space-y-5 max-w-7xl w-full mx-auto">

                                    <!-- Breadcrumb Row -->
                                    <div class="flex items-center justify-between text-xs text-slate-500">
                                      <div class="flex items-center gap-2">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                                          class="hover:text-slate-900 transition-colors">ဒက်ရှ်ဘုတ်</a>
                                        <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none"
                                          stroke="currentColor" stroke-width="2">
                                          <polyline points="9 18 15 12 9 6" />
                                        </svg>
                                        <a href="${pageContext.request.contextPath}/admin/results"
                                          class="hover:text-slate-900 transition-colors">စာမေးပွဲရလဒ်များ</a>
                                        <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none"
                                          stroke="currentColor" stroke-width="2">
                                          <polyline points="9 18 15 12 9 6" />
                                        </svg>
                                        <span class="text-slate-900 font-medium">
                                          <%= student !=null ? student.getName() : "ကျောင်းသား" %> ၏ ရလဒ်
                                        </span>
                                      </div>
                                      <div class="flex items-center gap-1">
                                        <a href="${pageContext.request.contextPath}/admin/results"
                                          class="w-7 h-7 rounded bg-white border border-slate-200 hover:bg-slate-100 text-slate-600 hover:text-slate-900 flex items-center justify-center transition-colors shadow-sm">
                                          <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                            stroke-width="2.5">
                                            <line x1="19" y1="12" x2="5" y2="12" />
                                            <polyline points="12 19 5 12 12 5" />
                                          </svg>
                                        </a>
                                      </div>
                                    </div>

                                    <!-- Student Info Banner -->
                                    <% if (student !=null) { long totalSubj=results !=null ? results.size() : 0; long
                                      passSubj=results !=null ? results.stream().filter(r ->
                                      "PASS".equals(r.getStatus())).count() : 0;
                                      String initial = student.getName() != null && !student.getName().isEmpty()
                                      ? String.valueOf(student.getName().charAt(0)).toUpperCase() : "S";
                                      %>
                                      <div
                                        class="p-5 roundedl bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 text-white border border-blue-500/20 flex items-center gap-4 shadow-md">
                                        <div
                                          class="w-14 h-14 roundedl bg-white/20 border border-white/30 backdrop-blur-sm flex items-center justify-center font-black text-xl text-white shrink-0">
                                          <%= initial %>
                                        </div>
                                        <div class="flex-1 min-w-0">
                                          <p class="text-base font-bold text-white truncate">
                                            <%= student.getName() %>
                                          </p>
                                          <p class="text-xs text-blue-100 font-mono">
                                            <%= student.getStudentId() %>
                                          </p>
                                        </div>
                                        <div class="flex items-center gap-6 shrink-0">
                                          <div class="text-center">
                                            <span class="block text-2xl font-black text-white">
                                              <%= totalSubj %>
                                            </span>
                                            <span class="text-[10px] text-blue-100 uppercase tracking-wide">စုစုပေါင်း
                                              ဘာသာ</span>
                                          </div>
                                          <div class="text-center">
                                            <span class="block text-2xl font-black text-emerald-300">
                                              <%= totalSubj> 0 ? String.format("%.0f", (double)passSubj/totalSubj*100) :
                                                "0" %>%
                                            </span>
                                            <span
                                              class="text-[10px] text-blue-100 uppercase tracking-wide">အောင်မြင်မှုနှုန်း</span>
                                          </div>
                                        </div>
                                      </div>
                                      <% } %>

                                        <!-- Search & Filter Toolbar -->
                                        <div class="p-4 roundedl bg-white border border-slate-200 shadow-sm">
                                          <div
                                            class="flex flex-col sm:flex-row items-center justify-between gap-3 flex-wrap">
                                            <div class="relative w-full sm:max-w-xs">
                                              <svg class="w-4 h-4 text-slate-400 absolute left-3.5 top-3"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <circle cx="11" cy="11" r="8" />
                                                <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                              </svg>
                                              <input type="text" id="detailSearchInput"
                                                placeholder="ဘာသာရပ် ရှာဖွေရန်..." value="<%= request.getAttribute("searchKeyword") !=null ? request.getAttribute("searchKeyword") : "" %>"
                                              class="w-full pl-10 pr-4 py-2.5 rounded bg-slate-50 border
                                              border-slate-300 text-sm text-slate-900 placeholder-slate-400
                                              focus:border-blue-500 focus:outline-none focus:ring-2
                                              focus:ring-blue-500/15 transition"/>
                                            </div>
                                            <div class="flex items-center gap-2 flex-wrap ms-auto">
                                              <select id="detailYearFilter"
                                                class="px-3 py-2 rounded bg-slate-50 border border-slate-300 text-xs text-slate-700 focus:border-blue-500 focus:outline-none cursor-pointer">
                                                <option value="">ပညာသင်နှစ် အားလုံး</option>
                                                <% for (String yr : byYear.keySet()) { %>
                                                  <option value="<%= yr %>">ပညာသင်နှစ် <%= yr %>
                                                  </option>
                                                  <% } %>
                                              </select>
                                              <select id="detailSemFilter"
                                                class="px-3 py-2 rounded bg-slate-50 border border-slate-300 text-xs text-slate-700 focus:border-blue-500 focus:outline-none cursor-pointer">
                                                <option value="">Semester အားလုံး</option>
                                                <% for (int i=1; i <=8; i++) { %>
                                                  <option value="<%= i %>">Semester <%= i %>
                                                  </option>
                                                  <% } %>
                                              </select>
                                              <button type="button" data-bs-toggle="modal"
                                                data-bs-target="#addResultModal"
                                                class="inline-flex items-center gap-2 px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 transition-all">
                                                <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                  stroke="currentColor" stroke-width="3">
                                                  <line x1="12" y1="5" x2="12" y2="19" />
                                                  <line x1="5" y1="12" x2="19" y2="12" />
                                                </svg>
                                                ရလဒ်ထည့်ရန်
                                              </button>
                                            </div>
                                          </div>
                                        </div>

                                        <!-- Academic Year Sections -->
                                        <% if (byYear.isEmpty()) { %>
                                          <div
                                            class="roundedl bg-white border border-slate-200 p-12 text-center shadow-sm">
                                            <div
                                              class="w-14 h-14 roundedl bg-slate-100 border border-slate-200 flex items-center justify-center mx-auto mb-4">
                                              <svg class="w-7 h-7 text-slate-400" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="1.5">
                                                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                              </svg>
                                            </div>
                                            <p class="text-sm font-semibold text-slate-600">ဤကျောင်းသားအတွက် ရလဒ်
                                              မရှိသေးပါ</p>
                                          </div>
                                          <% } else { int yearIdx=0; for (java.util.Map.Entry<String,
                                            java.util.Map<Integer, java.util.List<common.ExamResult>>> yearEntry :
                                            byYear.entrySet()) {
                                            String year = yearEntry.getKey();
                                            java.util.Map<Integer, java.util.List<common.ExamResult>> bySem =
                                              yearEntry.getValue();
                                              long yearPassCount =
                                              bySem.values().stream().flatMap(java.util.Collection::stream).filter(r ->
                                              "PASS".equals(r.getStatus())).count();
                                              long yearTotalCount =
                                              bySem.values().stream().mapToLong(java.util.Collection::size).sum();
                                              String collapseId = "year-collapse-" + yearIdx;
                                              %>
                                              <!-- Academic Year Card -->
                                              <div class="year-section rounded-lg overflow-hidden border border-slate-200 shadow-sm bg-white"
                                                data-year="<%= year %>">
                                                <!-- Year Header Toggle -->
                                                <button
                                                  class="w-full flex items-center gap-3 px-5 py-3.5 bg-blue-50/80 hover:bg-blue-100/60 border-b border-blue-100 text-left transition-all"
                                                  type="button" onclick="toggleYearCard(this)"
                                                  aria-expanded="true">
                                                  <svg class="w-4 h-4 text-blue-600 shrink-0" viewBox="0 0 24 24"
                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                                                    <line x1="16" y1="2" x2="16" y2="6" />
                                                    <line x1="8" y1="2" x2="8" y2="6" />
                                                    <line x1="3" y1="10" x2="21" y2="10" />
                                                  </svg>
                                                  <span class="text-sm font-bold text-slate-900 flex-1">ပညာသင်နှစ် <%= year
                                                      %></span>
                                                  <span
                                                    class="px-2.5 py-0.5 rounded-full bg-blue-100 border border-blue-200 text-[10px] font-bold text-blue-700">
                                                    <%= yearPassCount %> / <%= yearTotalCount %> အောင်မြင်
                                                  </span>
                                                  <svg class="chevron-icon w-4 h-4 text-slate-400 shrink-0"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2.5">
                                                    <polyline points="6 9 12 15 18 9" />
                                                  </svg>
                                                </button>

                                                <!-- Card Content -->
                                                <div class="year-card-body" id="<%= collapseId %>">
                                                  <div class="bg-white">
                                                    <!-- Table header -->
                                                    <div
                                                      class="result-grid px-5 py-2.5 bg-slate-100/90 border-b border-slate-200">
                                                      <div
                                                        class="text-[10px] font-bold text-slate-600 uppercase tracking-wider">
                                                        ဘာသာရပ်</div>
                                                      <div
                                                        class="text-[10px] font-bold text-slate-600 uppercase tracking-wider text-center">
                                                        ရမှတ်</div>
                                                      <div
                                                        class="text-[10px] font-bold text-slate-600 uppercase tracking-wider text-center">
                                                        Grade</div>
                                                      <div
                                                        class="text-[10px] font-bold text-slate-600 uppercase tracking-wider text-center">
                                                        အခြေအနေ</div>
                                                      <div
                                                        class="text-[10px] font-bold text-slate-600 uppercase tracking-wider text-center">
                                                        လုပ်ဆောင်ချက်</div>
                                                    </div>
                                                    <% for (java.util.Map.Entry<Integer,
                                                      java.util.List<common.ExamResult>> semEntry : bySem.entrySet()) {
                                                      int sem = semEntry.getKey();
                                                      java.util.List<common.ExamResult> semResults =
                                                        semEntry.getValue();
                                                        %>
                                                        <!-- Semester Block -->
                                                        <div class="sem-block border-b border-slate-200 last:border-b-0"
                                                          data-sem="<%= sem %>">
                                                          <div
                                                            class="sem-header flex items-center justify-between px-5 py-2 bg-slate-50 border-b border-slate-200">
                                                            <div class="flex items-center gap-2">
                                                              <span class="w-2 h-2 rounded-full bg-blue-600"></span>
                                                              <span class="text-xs font-bold text-slate-900">Semester
                                                                <%= sem %>
                                                              </span>
                                                              <span class="text-[10px] text-slate-500">
                                                                <%= semResults.size() %> ဘာသာ
                                                              </span>
                                                            </div>
                                                            <button type="button"
                                                              onclick="printSemesterResult('<%= student != null ? student.getName().replace("'", "\\'") : "" %>', '<%= student != null ? student.getStudentId() : "" %>', '<%= year %>', '<%= sem %>', this)"
                                                              class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded bg-slate-100 hover:bg-slate-200 border border-slate-300 text-xs text-slate-700 hover:text-slate-900 transition-all">
                                                              <svg class="w-3 h-3" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <polyline points="6 9 6 2 18 2 18 9" />
                                                                <path
                                                                  d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2" />
                                                                <rect x="6" y="14" width="12" height="8" />
                                                              </svg>
                                                              Print
                                                            </button>
                                                          </div>
                                                          <% for (common.ExamResult r : semResults) { boolean
                                                            isPass="PASS" .equals(r.getStatus()); int
                                                            sCredit=r.getSubjectCredit()> 0 ? r.getSubjectCredit() : 3;
                                                            String gradeColor = "A+".equals(r.getGrade()) || "A".equals(r.getGrade()) ? "bg-emerald-50 text-emerald-700 border-emerald-300"
                                                            : "A-".equals(r.getGrade()) || "B+".equals(r.getGrade()) ? "bg-blue-50 text-blue-700 border-blue-300"
                                                            : "B".equals(r.getGrade()) || "B-".equals(r.getGrade()) ? "bg-cyan-50 text-cyan-700 border-cyan-300"
                                                            : "C+".equals(r.getGrade()) || "C".equals(r.getGrade()) ? "bg-amber-50 text-amber-700 border-amber-300"
                                                            : "D".equals(r.getGrade()) ? "bg-orange-50 text-orange-700 border-orange-300"
                                                            : "bg-red-50 text-red-700 border-red-300";
                                                            %>
                                                            <div
                                                              class="result-grid px-5 py-3 border-b border-slate-200 hover:bg-slate-50 transition-colors result-row"
                                                              data-credit="<%= sCredit %>">
                                                              <div>
                                                                <div
                                                                  class="text-sm font-semibold text-slate-900 subj-name">
                                                                  <%= r.getSubjectName() !=null ? r.getSubjectName()
                                                                    : "-" %>
                                                                    <% String et=r.getExamType(); if
                                                                      ("RE_EXAM".equals(et)) { %>
                                                                      <span
                                                                        class="inline-block text-[10px] px-1.5 py-0.5 rounded bg-orange-50 border border-orange-200 text-orange-700 ml-1 font-semibold">RE-EXAM</span>
                                                                      <% } else if ("RETAKE".equals(et)) { %>
                                                                        <span
                                                                          class="inline-block text-[10px] px-1.5 py-0.5 rounded bg-purple-50 border border-purple-200 text-purple-700 ml-1 font-semibold">RETAKE</span>
                                                                        <% } %>
                                                                </div>
                                                                <div
                                                                  class="text-[11px] text-slate-500 font-mono subj-code">
                                                                  <%= r.getSubjectCode() !=null ? r.getSubjectCode()
                                                                    : "" %>
                                                                </div>
                                                              </div>
                                                              <div class="text-center">
                                                                <span class="text-sm font-bold text-slate-900">
                                                                  <%= (int)r.getMarks() %>
                                                                </span>
                                                                <span class="text-xs text-slate-400">/<%=
                                                                    (int)r.getTotalMarks() %></span>
                                                              </div>
                                                              <div class="text-center">
                                                                <span
                                                                  class="inline-block px-2 py-0.5 rounded border text-xs font-bold <%= gradeColor %>">
                                                                  <%= r.getGrade() !=null ? r.getGrade() : "-" %>
                                                                </span>
                                                              </div>
                                                              <div class="text-center">
                                                                <% if (isPass) { %>
                                                                  <span
                                                                    class="inline-block px-2 py-0.5 rounded-full bg-emerald-50 border border-emerald-200 text-[11px] font-bold text-emerald-700">အောင်</span>
                                                                  <% } else { %>
                                                                    <span
                                                                      class="inline-block px-2 py-0.5 rounded-full bg-red-50 border border-red-200 text-[11px] font-bold text-red-700">ကျ</span>
                                                                    <% } %>
                                                              </div>
                                                              <div class="flex items-center justify-center gap-1.5">
                                                                <button type="button"
                                                                  class="w-7 h-7 rounded bg-blue-50 border border-blue-200 text-blue-600 hover:bg-blue-100 flex items-center justify-center transition-colors"
                                                                  data-bs-toggle="modal"
                                                                  data-bs-target="#editResultModal"
                                                                  data-id="<%= r.getId() %>"
                                                                  data-subjectid="<%= r.getSubjectId() %>"
                                                                  data-academicyearid="<%= r.getAcademicYearId() %>"
                                                                  data-semesterid="<%= r.getSemesterId() %>"
                                                                  data-marks="<%= r.getMarks() %>"
                                                                  data-totalmarks="<%= r.getTotalMarks() %>"
                                                                  data-examtype="<%= r.getExamType() %>"
                                                                  title="ပြင်ဆင်ရန်">
                                                                  <svg class="w-3.5 h-3.5" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                      d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                    <path
                                                                      d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                                  </svg>
                                                                </button>
                                                                <button type="button"
                                                                  class="w-7 h-7 rounded bg-red-50 border border-red-200 text-red-600 hover:bg-red-100 flex items-center justify-center transition-colors"
                                                                  data-bs-toggle="modal"
                                                                  data-bs-target="#deleteResultModal"
                                                                  data-id="<%= r.getId() %>"
                                                                  data-name="<%= r.getSubjectName() %> (<%= r.getAcademicYear() %>, Sem <%= r.getSemester() %>) ရလဒ်"
                                                                  title="ဖျက်ရန်">
                                                                  <svg class="w-3.5 h-3.5" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <polyline points="3 6 5 6 21 6" />
                                                                    <path
                                                                      d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                                  </svg>
                                                                </button>
                                                              </div>
                                                            </div>
                                                            <% } %>
                                                        </div>
                                                        <% } %>
                                                  </div>
                                                </div>
                                              </div>
                                              <% yearIdx++; } } %>

                                  </div><!-- /page body -->
                              </main>
                          </div>

                                      <!-- Add Result Modal -->
                                          <div class="modal fade" id="addResultModal" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered" style="max-width: 32rem;">
                                              <div class="modal-content">
                                                <div class="modal-accent"></div>
                                                <div class="modal-header-custom">
                                                  <div class="modal-header-icon">
                                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                      <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                                    </svg>
                                                  </div>
                                                  <div class="modal-title-group">
                                                    <h5 class="modal-title">ရလဒ်အသစ် ထည့်သွင်းရန်</h5>
                                                    <p class="modal-subtitle">Add Exam Result</p>
                                                  </div>
                                                  <button type="button" class="modal-close-btn" data-bs-dismiss="modal">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                      <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                                                    </svg>
                                                  </button>
                                                </div>

                                                <form method="post" action="${pageContext.request.contextPath}/admin/results" data-validate novalidate>
                                                  <input type="hidden" name="action" value="add" />
                                                  <input type="hidden" name="studentId" value="<%= student != null ? student.getId() : 0 %>" />

                                                  <div class="modal-body space-y-4">
                                                    <div class="p-3 bg-slate-50 border border-slate-200 rounded-lg flex items-center justify-between">
                                                      <span class="text-xs text-slate-500 font-medium">ကျောင်းသား</span>
                                                      <strong class="text-xs text-slate-900 font-bold"><%= student != null ? student.getName() + " (" + student.getStudentId() + ")" : "-" %></strong>
                                                    </div>

                                                    <div class="space-y-3">
                                                      <div>
                                                        <label class="form-label" for="add-semesterId">Semester <span class="text-red-500">*</span></label>
                                                        <select id="add-semesterId" name="semesterId" required>
                                                          <option value="">-- Semester ရွေးချယ်ပါ --</option>
                                                          <% if (allSemesters != null) {
                                                               for (common.Semester sm : allSemesters) {
                                                                 String yrName = "";
                                                                 if (academicYears != null) {
                                                                   for (common.AcademicYear y : academicYears) {
                                                                     if (y.getId() == sm.getAcademicYearId()) { yrName = y.getYearName(); break; }
                                                                   }
                                                                 } %>
                                                          <option value="<%= sm.getId() %>" data-sem-number="<%= sm.getSemesterNumber() %>" data-sem-id="<%= sm.getId() %>"><%= yrName %> — Semester <%= sm.getSemesterNumber() %></option>
                                                          <%   }
                                                             } %>
                                                        </select>
                                                      </div>

                                                      <div>
                                                        <label class="form-label" for="add-subjectId">ဘာသာရပ် <span class="text-red-500">*</span></label>
                                                        <select id="add-subjectId" name="subjectId" required>
                                                          <option value="">-- ဘာသာရပ် ရွေးချယ်ပါ --</option>
                                                          <% if (allSubjects != null) {
                                                               for (common.Subject sj : allSubjects) { %>
                                                          <option value="<%= sj.getId() %>" data-sem-id="<%= sj.getSemesterId() %>" data-sem-number="<%= sj.getSemesterNumber() != null ? sj.getSemesterNumber() : 0 %>">
                                                            <%= sj.getSubjectCode() %> — <%= sj.getSubjectName() %> (Semester <%= sj.getSemesterNumber() != null ? sj.getSemesterNumber() : "-" %>)
                                                          </option>
                                                          <%   }
                                                             } %>
                                                        </select>
                                                      </div>

                                                      <div class="grid grid-cols-2 gap-3">
                                                        <div>
                                                          <label class="form-label" for="add-marks">ရရှိမှတ် <span class="text-red-500">*</span></label>
                                                          <input type="number" id="add-marks" name="marks" step="0.5" min="0" max="100" placeholder="e.g. 75" required />
                                                        </div>
                                                        <div>
                                                          <label class="form-label" for="add-totalMarks">စုစုပေါင်းမှတ် <span class="text-red-500">*</span></label>
                                                          <input type="number" id="add-totalMarks" name="totalMarks" min="1" value="100" required />
                                                        </div>
                                                      </div>
                                                    </div>
                                                  </div>

                                                  <div class="modal-footer">
                                                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
                                                    <button type="submit" class="btn-primary-custom">
                                                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                                                      </svg>
                                                      ထည့်သွင်းမည်
                                                    </button>
                                                  </div>
                                                </form>
                                              </div>
                                            </div>
                                          </div>

                                          <!-- Edit Result Modal -->
                                          <div class="modal fade" id="editResultModal" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered" style="max-width: 32rem;">
                                              <div class="modal-content">
                                                <div class="modal-accent" style="background: linear-gradient(90deg, rgb(99 102 241), rgb(168 85 247));"></div>
                                                <div class="modal-header-custom">
                                                  <div class="modal-header-icon" style="background: rgb(245 243 255); color: rgb(99 102 241); border-color: rgb(221 214 254);">
                                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                    </svg>
                                                  </div>
                                                  <div class="modal-title-group">
                                                    <h5 class="modal-title">ရလဒ် ပြင်ဆင်ရန်</h5>
                                                    <p class="modal-subtitle">Edit Exam Result</p>
                                                  </div>
                                                  <button type="button" class="modal-close-btn" data-bs-dismiss="modal">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                      <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                                                    </svg>
                                                  </button>
                                                </div>

                                                <form method="post" action="${pageContext.request.contextPath}/admin/results" data-validate novalidate>
                                                  <input type="hidden" name="action" value="update" />
                                                  <input type="hidden" name="id" id="edit-result-id" />
                                                  <input type="hidden" name="studentId" value="<%= student != null ? student.getId() : 0 %>" />

                                                  <div class="modal-body space-y-4">
                                                    <div class="p-3 bg-slate-50 border border-slate-200 rounded-lg flex items-center justify-between">
                                                      <span class="text-xs text-slate-500 font-medium">ကျောင်းသား</span>
                                                      <strong class="text-xs text-slate-900 font-bold"><%= student != null ? student.getName() + " (" + student.getStudentId() + ")" : "-" %></strong>
                                                    </div>

                                                    <div class="space-y-3">
                                                      <div>
                                                        <label class="form-label" for="edit-semesterId">Semester <span class="text-red-500">*</span></label>
                                                        <select id="edit-semesterId" name="semesterId" required>
                                                          <option value="">-- Semester ရွေးချယ်ပါ --</option>
                                                          <% if (allSemesters != null) {
                                                               for (common.Semester sm : allSemesters) {
                                                                 String yrName = "";
                                                                 if (academicYears != null) {
                                                                   for (common.AcademicYear y : academicYears) {
                                                                     if (y.getId() == sm.getAcademicYearId()) { yrName = y.getYearName(); break; }
                                                                   }
                                                                 } %>
                                                          <option value="<%= sm.getId() %>" data-sem-number="<%= sm.getSemesterNumber() %>" data-sem-id="<%= sm.getId() %>"><%= yrName %> — Semester <%= sm.getSemesterNumber() %></option>
                                                          <%   }
                                                             } %>
                                                        </select>
                                                      </div>

                                                      <div>
                                                        <label class="form-label" for="edit-subjectId">ဘာသာရပ် <span class="text-red-500">*</span></label>
                                                        <select id="edit-subjectId" name="subjectId" required>
                                                          <option value="">-- ဘာသာရပ် ရွေးချယ်ပါ --</option>
                                                          <% if (allSubjects != null) {
                                                               for (common.Subject sj : allSubjects) { %>
                                                          <option value="<%= sj.getId() %>" data-sem-id="<%= sj.getSemesterId() %>" data-sem-number="<%= sj.getSemesterNumber() != null ? sj.getSemesterNumber() : 0 %>">
                                                            <%= sj.getSubjectCode() %> — <%= sj.getSubjectName() %> (Semester <%= sj.getSemesterNumber() != null ? sj.getSemesterNumber() : "-" %>)
                                                          </option>
                                                          <%   }
                                                             } %>
                                                        </select>
                                                      </div>

                                                      <div class="grid grid-cols-2 gap-3">
                                                        <div>
                                                          <label class="form-label" for="edit-marks">ရရှိမှတ် <span class="text-red-500">*</span></label>
                                                          <input type="number" id="edit-marks" name="marks" step="0.5" min="0" max="100" required />
                                                        </div>
                                                        <div>
                                                          <label class="form-label" for="edit-totalMarks">စုစုပေါင်းမှတ် <span class="text-red-500">*</span></label>
                                                          <input type="number" id="edit-totalMarks" name="totalMarks" min="1" required />
                                                        </div>
                                                      </div>
                                                    </div>
                                                  </div>

                                                  <div class="modal-footer">
                                                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မပြင်ဆင်ပါ</button>
                                                    <button type="submit" class="btn-primary-custom" style="background: rgb(99 102 241); box-shadow: 0 2px 6px rgba(99,102,241,0.3);">
                                                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                                                        <polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/>
                                                      </svg>
                                                      ပြင်ဆင်မည်
                                                    </button>
                                                  </div>
                                                </form>
                                              </div>
                                            </div>
                                          </div>

                                          <!-- Delete Result Modal -->
                                          <div class="modal fade" id="deleteResultModal" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered" style="max-width: 22rem;">
                                              <div class="modal-content">
                                                <div class="modal-accent modal-accent-red"></div>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/results">
                                                  <input type="hidden" name="action" value="delete" />
                                                  <input type="hidden" name="id" id="delete-result-id" />
                                                  <input type="hidden" name="studentId" value="<%= student != null ? student.getId() : 0 %>" />

                                                  <div class="modal-body text-center" style="padding: 2rem 1.5rem 1.25rem;">
                                                    <div class="w-14 h-14 rounded-full bg-red-50 border-2 border-red-100 flex items-center justify-center mx-auto mb-4">
                                                      <svg class="w-7 h-7 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                        <polyline points="3 6 5 6 21 6" />
                                                      class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
                                                      <button type="button" class="btn-outline-custom"
                                                        data-bs-dismiss="modal"
                                                        style="flex: 1; padding: 0.6rem;">မဖျက်ပါ</button>
                                                      <button type="submit" class="btn-primary-custom"
                                                        style="flex: 1; padding: 0.6rem; background-color: #dc2626; border-color: #dc2626;">ဖျက်မည်</button>
                                                    </div>
                                                  </div>
                                                </form>
                                              </div>
                                            </div>
                                          </div>

                                          <% // Semester data for cascading dropdowns (id -> academic year + number)
                                            // rendered by AcademicServlet data; subjects carry data-semester-id
                                            %>
                                            <script>
                                              var SEMESTER_DATA = [
    <%
      if (allSemesters != null) {
                                                for (common.Semester sm : allSemesters) {
                                                  out.print("{ id: " + sm.getId() +
                                                    ", yearId: " + sm.getAcademicYearId() +
                                                    ", number: " + sm.getSemesterNumber() + " },");
                                                }
                                              }
    %>
  ];
                                            </script>

                                            <script
                                              src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                                            <script>
                                              (function () {
                                                var COLLAPSED_KEY = 'sidebarCollapsed';
                                                var btn = document.getElementById('sidebarToggleBtn');
                                                var overlay = document.getElementById('sidebarOverlay');
                                                if (localStorage.getItem(COLLAPSED_KEY) === '1') document.body.classList.add('sidebar-collapsed');
                                                if (btn) {
                                                  btn.addEventListener('click', function () {
                                                    if (window.innerWidth <= 768) {
                                                      document.body.classList.toggle('sidebar-open');
                                                    } else {
                                                      var collapsed = document.body.classList.toggle('sidebar-collapsed');
                                                      localStorage.setItem(COLLAPSED_KEY, collapsed ? '1' : '0');
                                                    }
                                                  });
                                                }
                                                if (overlay) overlay.addEventListener('click', function () { document.body.classList.remove('sidebar-open'); });
                                              })();
                                            </script>
                                            <script>
                                              document.getElementById('deleteResultModal').addEventListener('show.bs.modal', function (e) {
                                                const btn = e.relatedTarget;
                                                if (!btn) return;
                                                const d = btn.dataset;
                                                document.getElementById('delete-result-id').value = d.id || '';
                                                document.getElementById('delete-result-name').textContent = d.name || '';
                                              });

                                              // Custom accordion toggle (replaces Bootstrap collapse)
                                              function toggleYearCard(btn) {
                                                var expanded = btn.getAttribute('aria-expanded') === 'true';
                                                var card = btn.closest('.year-section');
                                                var body = card ? card.querySelector('.year-card-body') : null;
                                                if (!body) return;
                                                if (expanded) {
                                                  // collapse it
                                                  body.classList.add('collapsed-body');
                                                  btn.setAttribute('aria-expanded', 'false');
                                                } else {
                                                  // expand it
                                                  body.classList.remove('collapsed-body');
                                                  btn.setAttribute('aria-expanded', 'true');
                                                }
                                              }

                                              // Filter subject dropdown when semester is selected in result modal
                                              function filterSubjectsBySemester(semSelect, subjSelect) {
                                                if (!semSelect || !subjSelect) return;
                                                var selectedSemId = semSelect.value;
                                                var selectedSemOption = semSelect.options[semSelect.selectedIndex];
                                                var selectedSemNumber = selectedSemOption ? selectedSemOption.getAttribute('data-sem-number') : null;

                                                for (var i = 0; i < subjSelect.options.length; i++) {
                                                  var opt = subjSelect.options[i];
                                                  if (i === 0) {
                                                    opt.hidden = false;
                                                    continue;
                                                  }

                                                  if (!selectedSemId) {
                                                    opt.hidden = false;
                                                    opt.disabled = false;
                                                    continue;
                                                  }

                                                  var subjSemId = opt.getAttribute('data-sem-id');
                                                  var subjSemNumber = opt.getAttribute('data-sem-number');

                                                  var isMatch = (subjSemId && String(subjSemId) === String(selectedSemId)) ||
                                                                (selectedSemNumber && subjSemNumber && String(subjSemNumber) === String(selectedSemNumber));

                                                  if (isMatch) {
                                                    opt.hidden = false;
                                                    opt.disabled = false;
                                                  } else {
                                                    opt.hidden = true;
                                                    opt.disabled = true;
                                                  }
                                                }

                                                var currentOpt = subjSelect.options[subjSelect.selectedIndex];
                                                if (currentOpt && currentOpt.hidden) {
                                                  subjSelect.value = '';
                                                }
                                              }

                                              // Pre-fill & filter Edit Result Modal
                                              var editModalEl = document.getElementById('editResultModal');
                                              if (editModalEl) {
                                                editModalEl.addEventListener('show.bs.modal', function (e) {
                                                  var btn = e.relatedTarget;
                                                  if (!btn) return;
                                                  var d = btn.dataset;
                                                  document.getElementById('edit-result-id').value = d.id || '';
                                                  document.getElementById('edit-marks').value = d.marks || '';
                                                  document.getElementById('edit-totalMarks').value = d.totalmarks || '';
                                                  
                                                  var semSel = document.getElementById('edit-semesterId');
                                                  var subjSel = document.getElementById('edit-subjectId');
                                                  if (semSel && subjSel) {
                                                    semSel.value = d.semesterid || '';
                                                    filterSubjectsBySemester(semSel, subjSel);
                                                    subjSel.value = d.subjectid || '';
                                                  }
                                                });
                                              }

                                              // Wire up change listeners for Add & Edit Result modals
                                              (function () {
                                                var addSem = document.getElementById('add-semesterId');
                                                var addSubj = document.getElementById('add-subjectId');
                                                if (addSem && addSubj) {
                                                  addSem.addEventListener('change', function () {
                                                    filterSubjectsBySemester(addSem, addSubj);
                                                  });
                                                }

                                                var editSem = document.getElementById('edit-semesterId');
                                                var editSubj = document.getElementById('edit-subjectId');
                                                if (editSem && editSubj) {
                                                  editSem.addEventListener('change', function () {
                                                    filterSubjectsBySemester(editSem, editSubj);
                                                  });
                                                }

                                                var addModal = document.getElementById('addResultModal');
                                                if (addModal && addSem && addSubj) {
                                                  addModal.addEventListener('show.bs.modal', function () {
                                                    addSem.value = '';
                                                    filterSubjectsBySemester(addSem, addSubj);
                                                  });
                                                }
                                              })();

                                              // Live marks preview (detail page)
                                              (function () {
                                                function getGradeLabel(pct) {
                                                  if (pct >= 90) return 'A+';
                                                  if (pct >= 80) return 'A';
                                                  if (pct >= 75) return 'A-';
                                                  if (pct >= 70) return 'B+';
                                                  if (pct >= 65) return 'B';
                                                  if (pct >= 60) return 'B-';
                                                  if (pct >= 55) return 'C+';
                                                  if (pct >= 50) return 'C';
                                                  if (pct >= 40) return 'D';
                                                  return 'F';
                                                }
                                                function getBarColor(pct) {
                                                  if (pct >= 70) return '#22c55e';
                                                  if (pct >= 50) return '#f59e0b';
                                                  return '#ef4444';
                                                }
                                                function updatePreview() {
                                                  var marks = parseFloat(document.getElementById('det-add-marks').value);
                                                  var totalMarks = parseFloat(document.getElementById('det-add-totalMarks').value);
                                                  var wrap = document.getElementById('det-marks-preview-wrap');
                                                  if (!wrap) return;
                                                  if (isNaN(marks) || isNaN(totalMarks) || totalMarks <= 0) { wrap.style.display = 'none'; return; }
                                                  var pct = Math.min(100, Math.max(0, (marks / totalMarks) * 100));
                                                  wrap.style.display = 'block';
                                                  document.getElementById('det-marks-preview-pct').textContent = pct.toFixed(1) + '%';
                                                  document.getElementById('det-marks-preview-bar').style.width = pct + '%';
                                                  document.getElementById('det-marks-preview-bar').style.background = getBarColor(pct);
                                                  var grade = getGradeLabel(pct);
                                                  var gradeEl = document.getElementById('det-marks-preview-grade');
                                                  gradeEl.textContent = grade;
                                                  var colors = {
                                                    'A+': ['#dcfce7', '#15803d'], 'A': ['#dbeafe', '#1d4ed8'], 'A-': ['#dbeafe', '#1d4ed8'],
                                                    'B+': ['#f3e8ff', '#6b21a8'], 'B': ['#e0e7ff', '#3730a3'], 'B-': ['#e0e7ff', '#3730a3'],
                                                    'C+': ['#fef3c7', '#92400e'], 'C': ['#fef9c3', '#713f12'], 'D': ['#fee2e2', '#b91c1c'], 'F': ['#fee2e2', '#b91c1c']
                                                  };
                                                  var c = colors[grade] || ['#f1f5f9', '#64748b'];
                                                  gradeEl.style.background = c[0]; gradeEl.style.color = c[1];
                                                }
                                                document.addEventListener('DOMContentLoaded', function () {
                                                  var mEl = document.getElementById('det-add-marks');
                                                  var tEl = document.getElementById('det-add-totalMarks');
                                                  if (mEl) mEl.addEventListener('input', updatePreview);
                                                  if (tEl) tEl.addEventListener('input', updatePreview);
                                                  var modal = document.getElementById('addResultModal');
                                                  if (modal) modal.addEventListener('hidden.bs.modal', function () {
                                                    var wrap = document.getElementById('det-marks-preview-wrap');
                                                    if (wrap) wrap.style.display = 'none';
                                                  });

                                                  var sIn = document.getElementById('detailSearchInput');
                                                  var yrF = document.getElementById('detailYearFilter');
                                                  var semF = document.getElementById('detailSemFilter');

                                                  function applyDetailFilter() {
                                                    var q = (sIn ? sIn.value : '').toLowerCase().trim();
                                                    var yrVal = yrF ? yrF.value.trim() : '';
                                                    var sVal = semF ? semF.value : '';

                                                    document.querySelectorAll('.year-section').forEach(function (sec) {
                                                      var secYear = sec.getAttribute('data-year') || '';
                                                      var yrMatch = !yrVal || secYear === yrVal;
                                                      var secVisible = false;

                                                      sec.querySelectorAll('.sem-block').forEach(function (blk) {
                                                        var semH = blk.querySelector('.sem-header');
                                                        var semTxt = semH ? semH.textContent.trim() : '';
                                                        var semMatch = !sVal || semTxt.indexOf('Semester ' + sVal) !== -1;
                                                        var blkVisible = false;

                                                        var rows = blk.querySelectorAll('.result-row');
                                                        for (var i = 0; i < rows.length; i++) {
                                                          var r = rows[i];
                                                          if (r.querySelector('.col-header')) continue; // skip header row
                                                          var nameEl = r.querySelector('.subj-name');
                                                          var codeEl = r.querySelector('.subj-code');
                                                          var nameTxt = nameEl ? nameEl.textContent.toLowerCase() : '';
                                                          var codeTxt = codeEl ? codeEl.textContent.toLowerCase() : '';
                                                          var qMatch = !q || nameTxt.indexOf(q) !== -1 || codeTxt.indexOf(q) !== -1;

                                                          if (yrMatch && semMatch && qMatch) {
                                                            r.style.display = 'grid';
                                                            blkVisible = true;
                                                          } else {
                                                            r.style.display = 'none';
                                                          }
                                                        }

                                                        if (yrMatch && blkVisible) {
                                                          blk.style.display = 'block';
                                                          secVisible = true;
                                                        } else {
                                                          blk.style.display = 'none';
                                                        }
                                                      });

                                                      sec.style.display = (yrMatch && secVisible) ? 'block' : 'none';
                                                    });
                                                  }

                                                  if (sIn) sIn.addEventListener('input', applyDetailFilter);
                                                  if (yrF) yrF.addEventListener('change', applyDetailFilter);
                                                  if (semF) semF.addEventListener('change', applyDetailFilter);
                                                  applyDetailFilter(); // run on load
                                                });
                                              })();

                                              function printSemesterResult(studentName, rollNo, year, sem, btn) {
                                                var semBlock = btn.closest('.sem-block');
                                                if (!semBlock) return;

                                                var rows = semBlock.querySelectorAll('.result-row');
                                                var tableRows = '';
                                                var sr = 1;
                                                var totalCredits = 0;
                                                var totalGradePoint = 0;

                                                // Grade → Grade Score mapping (matching result.png scale)
                                                function gradeToScore(grade) {
                                                  var map = { 'A+': 4.00, 'A': 4.00, 'A-': 3.67, 'B+': 3.33, 'B': 3.00, 'B-': 2.67, 'C+': 2.33, 'C': 2.00, 'D': 1.00, 'F': 0, 'F/Abs/I': 0 };
                                                  return map[grade] !== undefined ? map[grade] : 0;
                                                }

                                                // Determine credit unit from marks (default 3 unless stored)
                                                var subjectCredits = [];

                                                for (var i = 0; i < rows.length; i++) {
                                                  var r = rows[i];
                                                  if (r.querySelector('.col-header')) continue;
                                                  var nameEl = r.querySelector('.subj-name');
                                                  var name = nameEl ? nameEl.childNodes[0].textContent.trim() : '-';
                                                  var code = r.querySelector('.subj-code') ? r.querySelector('.subj-code').textContent.trim() : '-';
                                                  var gradeEl = r.querySelector('.grade-cell');
                                                  var grade = gradeEl ? gradeEl.textContent.trim() : '-';
                                                  var marksEl = r.querySelector('.marks-cell');
                                                  var marksText = marksEl ? marksEl.textContent.trim() : '0/100';
                                                  var marksParts = marksText.split('/');
                                                  var obtained = parseFloat(marksParts[0]) || 0;
                                                  var total = parseFloat(marksParts[1]) || 100;
                                                  var pct = total > 0 ? (obtained / total * 100) : 0;

                                                  // Derive grade obtained from percentage if grade is missing
                                                  var gradeObtained = grade && grade !== '-' ? grade : (function (p) {
                                                    if (p >= 90) return 'A+'; if (p >= 80) return 'A'; if (p >= 75) return 'A-';
                                                    if (p >= 70) return 'B+'; if (p >= 65) return 'B'; if (p >= 60) return 'B-';
                                                    if (p >= 55) return 'C+'; if (p >= 50) return 'C'; if (p >= 40) return 'D'; return 'F';
                                                  })(pct);

                                                  var creditAttr = r.getAttribute('data-credit');
                                                  var credit = (creditAttr && parseInt(creditAttr, 10) > 0) ? parseInt(creditAttr, 10) : 3;
                                                  var gradeScore = gradeToScore(gradeObtained);
                                                  var gradePoint = gradeScore * credit;

                                                  totalCredits += credit;
                                                  totalGradePoint += gradePoint;
                                                  subjectCredits.push(credit);

                                                  tableRows +=
                                                    '<tr>' +
                                                    '<td style="text-align:center; padding:7px 8px; border:1px solid #000;">' + (sr++) + '</td>' +
                                                    '<td style="padding:7px 8px; font-family:monospace; font-weight:bold; border:1px solid #000;">' + code + '</td>' +
                                                    '<td style="padding:7px 8px; border:1px solid #000;">' + name + '</td>' +
                                                    '<td style="text-align:center; padding:7px 8px; border:1px solid #000;">' + credit + '</td>' +
                                                    '<td style="text-align:center; padding:7px 8px; font-weight:bold; border:1px solid #000;">' + gradeObtained + '</td>' +
                                                    '<td style="text-align:center; padding:7px 8px; border:1px solid #000;">' + gradeScore.toFixed(2) + '</td>' +
                                                    '<td style="text-align:center; padding:7px 8px; font-weight:bold; border:1px solid #000;">' + gradePoint.toFixed(2) + '</td>' +
                                                    '</tr>';
                                                }

                                                var semesterGPA = totalCredits > 0 ? (totalGradePoint / totalCredits).toFixed(2) : '0.00';
                                                var issueDate = new Date();
                                                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                                var issueDateStr = issueDate.getDate() + '-' + months[issueDate.getMonth()] + '-' + issueDate.getFullYear();

                                                var printWindow = window.open('', '_blank', 'width=820,height=1100');
                                                var doc = printWindow.document;

                                                doc.write('<!DOCTYPE html><html><head>');
                                                doc.write('<meta charset="UTF-8">');
                                                doc.write('<title>Academic Record - ' + studentName + '</title>');
                                                doc.write('<style>');
                                                doc.write('@import url("https://fonts.googleapis.com/css2?family=Times+New+Roman&family=Georgia&display=swap");');
                                                doc.write('* { box-sizing: border-box; margin: 0; padding: 0; }');
                                                doc.write('body {');
                                                doc.write('  font-family: "Times New Roman", Times, serif;');
                                                doc.write('  font-size: 13px;');
                                                doc.write('  color: #000;');
                                                doc.write('  padding: 30px 45px;');
                                                doc.write('  background: #fff;');
                                                doc.write('  line-height: 1.5;');
                                                doc.write('}');
                                                // University header
                                                doc.write('.page-header { text-align: center; margin-bottom: 18px; }');
                                                doc.write('.page-header .univ-name { font-size: 16px; font-weight: bold; margin-bottom: 3px; }');
                                                doc.write('.page-header .acad-year { font-size: 13px; font-weight: bold; margin-bottom: 2px; }');
                                                doc.write('.page-header .doc-title { font-size: 14px; font-weight: bold; text-decoration: underline; margin-top: 4px; }');
                                                // Student info
                                                doc.write('.student-info { width: 100%; margin-bottom: 16px; border-collapse: collapse; font-size: 13px; }');
                                                doc.write('.student-info td { padding: 3px 6px; vertical-align: top; }');
                                                doc.write('.student-info td.label { font-weight: normal; white-space: nowrap; }');
                                                doc.write('.student-info td.colon { width: 8px; padding: 3px 2px; }');
                                                doc.write('.student-info td.value { font-weight: bold; }');
                                                // Divider
                                                doc.write('.divider { border: none; border-top: 1px solid #000; margin: 8px 0; }');
                                                // Results table
                                                doc.write('.result-table { width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 12.5px; }');
                                                doc.write('.result-table th, .result-table td { border: 1px solid #000; padding: 6px 8px; }');
                                                doc.write('.result-table th { background: #fff; font-weight: bold; text-align: center; vertical-align: middle; }');
                                                doc.write('.result-table td.no { text-align: center; }');
                                                doc.write('.result-table td.num { text-align: center; }');
                                                doc.write('.result-table .total-row td { font-weight: bold; background: #fff; }');
                                                doc.write('.result-table .summary-row td { font-weight: bold; text-align: right; padding: 5px 8px; }');
                                                doc.write('.result-table .summary-row td.summary-label { border-left: 1px solid #000; font-weight: bold; text-align: right; }');
                                                doc.write('.result-table .summary-row td.summary-val { text-align: center; font-weight: bold; }');
                                                // Grading scale
                                                doc.write('.grading-section { margin-top: 22px; }');
                                                doc.write('.grading-title { font-weight: bold; text-decoration: underline; margin-bottom: 6px; font-size: 12.5px; }');
                                                doc.write('.grading-grid { display: grid; grid-template-columns: repeat(6, auto); gap: 2px 18px; font-size: 12px; width: fit-content; }');
                                                doc.write('.grading-grid .gp { display: flex; gap: 6px; }');
                                                doc.write('.grading-grid .gv { font-weight: bold; }');
                                                // Issue date & signature
                                                doc.write('.issue-date { margin-top: 20px; font-size: 12.5px; font-weight: bold; }');
                                                doc.write('.signature-block { margin-top: 55px; text-align: right; font-size: 12.5px; }');
                                                doc.write('.signature-block .sig-role { font-weight: bold; }');
                                                doc.write('.signature-block .sig-title { font-size: 12px; }');
                                                doc.write('@media print {');
                                                doc.write('  body { padding: 20px 35px; }');
                                                doc.write('  @page { margin: 1.2cm; size: A4; }');
                                                doc.write('}');
                                                doc.write('</style></head><body>');

                                                // ── Header ──────────────────────────────────────────────────
                                                doc.write('<div class="page-header">');
                                                doc.write('<div class="univ-name">University of Computer Studies (Hpa-an)</div>');
                                                doc.write('<div class="acad-year">' + year + ' Academic Year</div>');
                                                doc.write('<div class="doc-title">Academic Record</div>');
                                                doc.write('</div>');

                                                doc.write('<hr class="divider">');

                                                // ── Student Info ─────────────────────────────────────────────
                                                doc.write('<table class="student-info">');
                                                doc.write('<tr>');
                                                doc.write('<td class="label" style="width:140px;">Roll Number</td>');
                                                doc.write('<td class="colon">:</td>');
                                                doc.write('<td class="value" style="width:220px;">' + rollNo + '</td>');
                                                doc.write('<td class="label" style="width:120px; padding-left:30px;">Academic Year</td>');
                                                doc.write('<td class="colon">:</td>');
                                                doc.write('<td class="value">' + year + '</td>');
                                                doc.write('</tr>');
                                                doc.write('<tr>');
                                                doc.write('<td class="label">Student Name</td>');
                                                doc.write('<td class="colon">:</td>');
                                                doc.write('<td class="value">' + studentName + '</td>');
                                                doc.write('<td class="label" style="padding-left:30px;">Semester</td>');
                                                doc.write('<td class="colon">:</td>');
                                                doc.write('<td class="value">' + sem + '</td>');
                                                doc.write('</tr>');
                                                doc.write('<tr>');
                                                doc.write('<td class="label">Degree Program</td>');
                                                doc.write('<td class="colon">:</td>');
                                                doc.write('<td class="value">(B.C.Sc.)</td>');
                                                doc.write('<td></td><td></td><td></td>');
                                                doc.write('</tr>');
                                                doc.write('<tr>');
                                                doc.write('<td class="label">Specialization</td>');
                                                doc.write('<td class="colon">:</td>');
                                                doc.write('<td class="value">Computer Science</td>');
                                                doc.write('<td></td><td></td><td></td>');
                                                doc.write('</tr>');
                                                doc.write('</table>');

                                                // ── Results Table ────────────────────────────────────────────
                                                doc.write('<table class="result-table">');
                                                doc.write('<thead>');
                                                doc.write('<tr>');
                                                doc.write('<th style="width:38px;">No.</th>');
                                                doc.write('<th style="width:100px;">Course Code</th>');
                                                doc.write('<th>Course Name</th>');
                                                doc.write('<th style="width:70px;">Academic Credit Unit</th>');
                                                doc.write('<th style="width:62px;">Grade Obtained</th>');
                                                doc.write('<th style="width:58px;">Grade Score</th>');
                                                doc.write('<th style="width:58px;">Grade Point</th>');
                                                doc.write('</tr>');
                                                doc.write('</thead>');
                                                doc.write('<tbody>');
                                                doc.write(tableRows);

                                                // Total row
                                                doc.write('<tr class="total-row">');
                                                doc.write('<td colspan="3" style="text-align:right; padding:7px 8px; border:1px solid #000; font-weight:bold;">Total Credit Units</td>');
                                                doc.write('<td class="num" style="border:1px solid #000; font-weight:bold;">' + totalCredits + '</td>');
                                                doc.write('<td colspan="2" style="text-align:right; padding:7px 8px; border:1px solid #000; font-weight:bold;">Total Grade Point</td>');
                                                doc.write('<td class="num" style="border:1px solid #000; font-weight:bold;">' + totalGradePoint.toFixed(2) + '</td>');
                                                doc.write('</tr>');

                                                // Cumulative GPA (semester GPA)
                                                doc.write('<tr class="summary-row">');
                                                doc.write('<td colspan="5" style="border:none;"></td>');
                                                doc.write('<td class="summary-label" style="border:1px solid #000; font-weight:bold; text-align:right;">Cumulative GPA</td>');
                                                doc.write('<td class="summary-val" style="border:1px solid #000;">' + semesterGPA + '</td>');
                                                doc.write('</tr>');

                                                // Overall GPA (same for single semester)
                                                doc.write('<tr class="summary-row">');
                                                doc.write('<td colspan="5" style="border:none;"></td>');
                                                doc.write('<td class="summary-label" style="border:1px solid #000; font-weight:bold; text-align:right;">Overall GPA</td>');
                                                doc.write('<td class="summary-val" style="border:1px solid #000;">' + semesterGPA + '</td>');
                                                doc.write('</tr>');

                                                doc.write('</tbody></table>');

                                                // ── Grading Scale ────────────────────────────────────────────
                                                doc.write('<div class="grading-section">');
                                                doc.write('<div class="grading-title">GRADING SCALE</div>');
                                                doc.write('<div class="grading-grid">');
                                                var grades = [['>=90', 'A+'], ['80-89', 'A'], ['75-79', 'A-'], ['70-74', 'B+'], ['65-69', 'B'], ['60-64', 'B-'],
                                                ['55-59', 'C+'], ['50-54', 'C'], ['40-49', 'D'], ['0-39', 'F/Abs/I']];
                                                grades.forEach(function (g) {
                                                  doc.write('<div class="gp"><span>' + g[0] + '</span><span class="gv">' + g[1] + '</span></div>');
                                                });
                                                doc.write('</div>');
                                                doc.write('</div>');

                                                // ── Issue Date ───────────────────────────────────────────────
                                                doc.write('<div class="issue-date">ISSUE DATE &nbsp;: &nbsp;' + issueDateStr + '</div>');

                                                // ── Registrar Signature ──────────────────────────────────────
                                                doc.write('<div class="signature-block">');
                                                doc.write('<div style="margin-bottom:45px;"></div>');
                                                doc.write('<div class="sig-role">REGISTRAR</div>');
                                                doc.write('<div class="sig-title">Academic Department</div>');
                                                doc.write('<div class="sig-title">University of Computer Studies(Hpa-an)</div>');
                                                doc.write('</div>');

                                                doc.write('</body></html>');
                                                doc.close();

                                                printWindow.onload = function () {
                                                  printWindow.focus();
                                                  printWindow.print();
                                                };
                                              }
                                            </script>
                        </body>

                        </html>