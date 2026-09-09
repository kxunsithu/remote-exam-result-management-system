<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "Exam Results" ); java.util.List<common.ExamResult> results = (java.util.List
      <common.ExamResult>) request.getAttribute("results");
        java.util.List<common.Student> students = (java.util.List<common.Student>) request.getAttribute("students");
            java.util.List<common.Subject> allSubjects = (java.util.List<common.Subject>)
                request.getAttribute("subjects");
                java.util.List<common.Semester> allSemesters = (java.util.List<common.Semester>)
                    request.getAttribute("semesters");
                    java.util.List<common.AcademicYear> academicYears = (java.util.List<common.AcademicYear>)
                        request.getAttribute("academicYears");

                        java.util.Map<Integer, java.util.List<common.ExamResult>> resultsByStudent = new
                          java.util.HashMap<>();
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
                                              <span class="text-slate-900 font-medium">စာမေးပွဲရလဒ်များ</span>
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

                                          <!-- Toolbar Card with Search Form & Add Result Button -->
                                          <div class="p-4 roundedl bg-white border border-slate-200 shadow-sm">
                                            <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
                                              <form method="get"
                                                action="${pageContext.request.contextPath}/admin/results"
                                                class="w-full sm:max-w-md space-y-1">
                                                <div class="relative">
                                                  <svg class="w-4 h-4 text-slate-400 absolute left-3.5 top-3"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <circle cx="11" cy="11" r="8" />
                                                    <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                                  </svg>
                                                  <input type="text" name="search"
                                                    placeholder="ကျောင်းသား သို့မဟုတ် ခုံနံပါတ် ရှာဖွေရန်..."
                                                    value="<%= request.getAttribute(" searchKeyword") !=null ?
                                                    request.getAttribute("searchKeyword") : "" %>"
                                                  class="w-full pl-10 pr-4 py-2.5 rounded bg-slate-50 border
                                                  border-slate-300 text-slate-900 text-xs placeholder-slate-400
                                                  focus:outline-none focus:border-blue-500 focus:ring-2
                                                  focus:ring-blue-500/15 transition-all"/>
                                                </div>
                                                <p class="text-[11px] text-slate-500">
                                                  ကျောင်းသားအမည်၊ ခုံနံပါတ် (Roll Number) သို့မဟုတ် အီးမေးလ်ဖြင့်
                                                  ရှာဖွေနိုင်ပါသည်။
                                                </p>
                                              </form>
                                              <div>
                                                <button type="button" data-bs-toggle="modal"
                                                  data-bs-target="#addResultModal"
                                                  onclick="openAddResultModalForStudent('')"
                                                  class="inline-flex items-center gap-2 px-4 py-2.5 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 transition-all shrink-0">
                                                  <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5">
                                                    <line x1="12" y1="5" x2="12" y2="19" />
                                                    <line x1="5" y1="12" x2="19" y2="12" />
                                                  </svg>
                                                  ရလဒ်ထည့်ရန်
                                                </button>
                                              </div>
                                            </div>
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
                                                    <th class="py-3.5 px-4 text-center">လုပ်ဆောင်ချက်</th>
                                                  </tr>
                                                </thead>
                                                <tbody class="divide-y divide-slate-200">
                                                  <% if (students !=null && !students.isEmpty()) { int idx=1; for
                                                    (common.Student s : students) { java.util.List<common.ExamResult>
                                                    sResults = resultsByStudent.getOrDefault(s.getId(),
                                                    java.util.Collections.emptyList());
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
                                                      <td class="py-3 px-4"><span
                                                          class="font-mono font-bold text-blue-600">
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
                                                      <td class="py-3 px-4 text-center"
                                                        onclick="event.stopPropagation()">
                                                        <div class="flex items-center justify-center gap-2">
                                                          <button type="button" data-bs-toggle="modal"
                                                            data-bs-target="#addResultModal"
                                                            onclick="openAddResultModalForStudent('<%= s.getId() %>')"
                                                            class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded bg-blue-50 border border-blue-200 text-blue-700 hover:bg-blue-100 text-xs font-semibold transition-colors"
                                                            title="ရလဒ်ထည့်သွင်းရန်">
                                                            <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                              stroke="currentColor" stroke-width="2.5">
                                                              <line x1="12" y1="5" x2="12" y2="19" />
                                                              <line x1="5" y1="12" x2="19" y2="12" />
                                                            </svg>
                                                            ရလဒ်ထည့်ရန်
                                                          </button>
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
                                                          <svg class="w-10 h-10 mx-auto mb-3 text-slate-300"
                                                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="1.5">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                            <circle cx="9" cy="7" r="4" />
                                                          </svg>
                                                          <div class="font-bold text-slate-700 text-sm mb-1">ကျောင်းသား
                                                            မရှိသေးပါ
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
                                                Showing <%= students !=null && !students.isEmpty() ? 1 : 0 %> to <%=
                                                    students !=null ? students.size() : 0 %> of <%= students !=null ?
                                                      students.size() : 0 %> Entries
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

                                <!-- Add Result Modal -->
                                <div class="modal fade" id="addResultModal" tabindex="-1" aria-hidden="true">
                                  <div class="modal-dialog modal-dialog-centered" style="max-width: 32rem;">
                                    <div class="modal-content">
                                      <div class="modal-accent"></div>
                                      <div class="modal-header-custom">
                                        <div class="modal-header-icon">
                                          <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.2">
                                            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                          </svg>
                                        </div>
                                        <div class="modal-title-group">
                                          <h5 class="modal-title">ရလဒ်အသစ် ထည့်သွင်းရန်</h5>
                                          <p class="modal-subtitle">Add Exam Result</p>
                                        </div>
                                        <button type="button" class="modal-close-btn" data-bs-dismiss="modal">
                                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <line x1="18" y1="6" x2="6" y2="18" />
                                            <line x1="6" y1="6" x2="18" y2="18" />
                                          </svg>
                                        </button>
                                      </div>

                                      <form method="post" action="${pageContext.request.contextPath}/admin/results"
                                        data-validate novalidate>
                                        <input type="hidden" name="action" value="add" />

                                        <div class="modal-body space-y-4">
                                          <div class="space-y-3">
                                            <div>
                                              <label class="form-label" for="add-studentId">ကျောင်းသား <span
                                                  class="text-red-500">*</span></label>
                                              <div id="add-student-display-box"
                                                class="p-3 bg-slate-50 border border-slate-200 rounded-lg flex items-center justify-between hidden">
                                                <span class="text-xs text-slate-500 font-medium">ကျောင်းသား</span>
                                                <strong id="add-student-display-name"
                                                  class="text-xs text-slate-900 font-bold"></strong>
                                              </div>
                                              <select id="add-studentId" name="studentId" required>
                                                <option value="">-- ကျောင်းသား ရွေးချယ်ပါ --</option>
                                                <% if (students !=null) { for (common.Student st : students) { %>
                                                  <option value="<%= st.getId() %>"
                                                    data-name="<%= st.getName() %> (<%= st.getStudentId() %>)">
                                                    <%= st.getName() %> (<%= st.getStudentId() %>)
                                                  </option>
                                                  <% } } %>
                                              </select>
                                            </div>

                                            <div>
                                              <label class="form-label" for="add-semesterId">Semester <span
                                                  class="text-red-500">*</span></label>
                                              <select id="add-semesterId" name="semesterId" required
                                                onchange="filterSubjectsBySemester()">
                                                <option value="">-- Semester ရွေးချယ်ပါ --</option>
                                                <% if (allSemesters !=null) { for (common.Semester sm : allSemesters) {
                                                  String yrName="" ; if (academicYears !=null) { for
                                                  (common.AcademicYear y : academicYears) { if
                                                  (y.getId()==sm.getAcademicYearId()) { yrName=y.getYearName(); break; }
                                                  } } %>
                                                  <option value="<%= sm.getId() %>"
                                                    data-sem-number="<%= sm.getSemesterNumber() %>"
                                                    data-sem-id="<%= sm.getId() %>">
                                                    <%= yrName !=null && !yrName.isEmpty() ? yrName + " — " : "" %>
                                                      Semester <%= sm.getSemesterNumber() %>
                                                  </option>
                                                  <% } } %>
                                              </select>
                                            </div>

                                            <div>
                                              <label class="form-label" for="add-subjectId">ဘာသာရပ် <span
                                                  class="text-red-500">*</span></label>
                                              <select id="add-subjectId" name="subjectId" required>
                                                <option value="">-- ဘာသာရပ် ရွေးချယ်ပါ --</option>
                                                <% if (allSubjects !=null) { java.util.Set<String> seenSubj = new
                                                  java.util.HashSet<>();
                                                    for (common.Subject sj : allSubjects) {
                                                    String key = (sj.getSubjectCode() != null ?
                                                    sj.getSubjectCode().trim() : "") + "|" + (sj.getSemesterNumber() !=
                                                    null ? sj.getSemesterNumber() : 0);
                                                    if (seenSubj.contains(key)) continue;
                                                    seenSubj.add(key);
                                                    %>
                                                    <option value="<%= sj.getId() %>"
                                                      data-sem-id="<%= sj.getSemesterId() %>"
                                                      data-sem-number="<%= sj.getSemesterNumber() != null ? sj.getSemesterNumber() : 0 %>">
                                                      <%= sj.getSubjectCode() %> — <%= sj.getSubjectName() %>
                                                          <%= sj.getSemesterNumber() !=null && sj.getSemesterNumber()> 0
                                                            ? "(Semester " + sj.getSemesterNumber() + ")" : "" %>
                                                    </option>
                                                    <% } } %>
                                              </select>
                                            </div>

                                            <div class="grid grid-cols-2 gap-3">
                                              <div>
                                                <label class="form-label" for="add-marks">ရရှိမှတ် <span
                                                    class="text-red-500">*</span></label>
                                                <input type="number" id="add-marks" name="marks" step="0.5" min="0"
                                                  max="100" placeholder="e.g. 75" required />
                                              </div>
                                              <div>
                                                <label class="form-label" for="add-totalMarks">စုစုပေါင်းမှတ် <span
                                                    class="text-red-500">*</span></label>
                                                <input type="number" id="add-totalMarks" name="totalMarks" min="1"
                                                  value="100" required />
                                              </div>
                                            </div>

                                            <div>
                                              <label class="form-label" for="add-examType">စာမေးပွဲ အမျိုးအစား</label>
                                              <select id="add-examType" name="examType">
                                                <option value="REGULAR">ပုံမှန် စာမေးပွဲ (Regular)</option>
                                                <option value="RE_EXAM">ပြန်လည် ဖြေဆို စာမေးပွဲ (Re-Exam)</option>
                                                <option value="RETAKE">ပြန်လည် သင်ယူ (Retake)</option>
                                              </select>
                                            </div>
                                          </div>
                                        </div>

                                        <div class="modal-footer">
                                          <button type="button" class="btn-outline-custom"
                                            data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
                                          <button type="submit" class="btn-primary-custom">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                              stroke="currentColor" stroke-width="2.5">
                                              <line x1="12" y1="5" x2="12" y2="19" />
                                              <line x1="5" y1="12" x2="19" y2="12" />
                                            </svg>
                                            ထည့်သွင်းမည်
                                          </button>
                                        </div>
                                      </form>
                                    </div>
                                  </div>
                                </div>

                                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                                <script>
                                  function openAddResultModalForStudent(studentId) {
                                    const studentSelect = document.getElementById('add-studentId');
                                    const displayBox = document.getElementById('add-student-display-box');
                                    const displayName = document.getElementById('add-student-display-name');

                                    if (!studentSelect) return;

                                    if (studentId) {
                                      studentSelect.value = studentId;
                                      const opt = studentSelect.options[studentSelect.selectedIndex];
                                      const name = opt ? (opt.getAttribute('data-name') || opt.text) : '';
                                      if (displayName) displayName.textContent = name;
                                      if (displayBox) displayBox.classList.remove('hidden');
                                      studentSelect.classList.add('hidden');
                                    } else {
                                      studentSelect.value = '';
                                      if (displayBox) displayBox.classList.add('hidden');
                                      studentSelect.classList.remove('hidden');
                                    }
                                  }

                                  function filterSubjectsBySemester() {
                                    const semSelect = document.getElementById('add-semesterId');
                                    const subjSelect = document.getElementById('add-subjectId');
                                    if (!semSelect || !subjSelect) return;

                                    const selectedOpt = semSelect.options[semSelect.selectedIndex];
                                    const semId = selectedOpt ? selectedOpt.getAttribute('data-sem-id') : null;
                                    const semNumber = selectedOpt ? selectedOpt.getAttribute('data-sem-number') : null;

                                    Array.from(subjSelect.options).forEach(opt => {
                                      if (!opt.value) return;
                                      const optSemId = opt.getAttribute('data-sem-id');
                                      const optSemNum = opt.getAttribute('data-sem-number');

                                      if (!semId && !semNumber) {
                                        opt.style.display = '';
                                      } else if (optSemId && semId && optSemId === semId) {
                                        opt.style.display = '';
                                      } else if (optSemNum && semNumber && optSemNum === semNumber) {
                                        opt.style.display = '';
                                      } else {
                                        opt.style.display = 'none';
                                      }
                                    });

                                    subjSelect.value = '';
                                  }
                                </script>
                              </body>

                              </html>