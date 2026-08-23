<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "ကျွန်ုပ်၏ ရလဒ်များ" ); common.Student student=(common.Student)
      request.getAttribute("student"); java.util.List<common.ExamResult> results = (java.util.List<common.ExamResult>)
        request.getAttribute("results");
        Double totalObtained = (Double) request.getAttribute("totalObtained");
        Double totalPossible = (Double) request.getAttribute("totalPossible");
        Double avgObj = (Double) request.getAttribute("average");
        String overallGrade = (String) request.getAttribute("overallGrade");
        String overallStatus = (String) request.getAttribute("overallStatus");
        Double cgpaObj = (Double) request.getAttribute("cgpa");

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
                  <title>ကျွန်ုပ်၏ ရလဒ်များ — RERMS</title>
                  <%@ include file="../common/tailwind-setup.jsp" %>
                  <style>
                    .year-card-body { display: block; }
                    .year-card-body.collapsed-body { display: none; }
                  </style>
                </head>

                <body class="bg-slate-50 text-slate-800 min-h-screen font-sans antialiased">
                  <div class="min-h-screen flex flex-col">
                    <%@ include file="navbar.jsp" %>

                      <main class="flex-1 p-6 max-w-7xl w-full mx-auto space-y-6">

                        <% if (request.getAttribute("rmiError") !=null) { %>
                          <div
                            class="p-4 rounded bg-amber-50 border border-amber-200 text-amber-800 text-xs font-semibold flex items-center gap-2">
                            <svg class="w-4 h-4 text-amber-600 shrink-0" viewBox="0 0 24 24" fill="none"
                              stroke="currentColor" stroke-width="2">
                              <circle cx="12" cy="12" r="10" />
                              <line x1="12" y1="8" x2="12" y2="12" />
                            </svg>
                            <span>
                              <%= request.getAttribute("rmiError") %>
                            </span>
                          </div>
                          <% } %>

                            <!-- Breadcrumb Nav -->
                            <div class="flex items-center justify-between text-xs text-slate-500">
                              <div class="flex items-center gap-2">
                                <a href="${pageContext.request.contextPath}/student/dashboard"
                                  class="hover:text-slate-900 transition-colors">ဒက်ရှ်ဘုတ်</a>
                                <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none"
                                  stroke="currentColor" stroke-width="2">
                                  <polyline points="9 18 15 12 9 6" />
                                </svg>
                                <span class="text-slate-900 font-medium">ကျွန်ုပ်၏ ရလဒ်များ</span>
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

                            <!-- Student Info Header Card -->
                            <% if (student !=null) { long totalSubj=results !=null ? results.size() : 0; long
                              passSubj=results !=null ? results.stream().filter(r ->
                              "PASS".equals(r.getStatus())).count() : 0;
                              String initial = student.getName() != null && !student.getName().isEmpty()
                              ? String.valueOf(student.getName().charAt(0)).toUpperCase() : "S";
                              %>
                              <div
                                class="p-6 roundedl bg-gradient-to-r from-blue-600 via-indigo-600 to-blue-700 border border-blue-500/20 shadow-md flex flex-col sm:flex-row items-center justify-between gap-6">
                                <div class="flex items-center gap-4">
                                  <div
                                    class="w-12 h-12 rounded-full bg-white/20 border-2 border-white/40 flex items-center justify-center text-lg font-extrabold text-white shadow-inner shrink-0 backdrop-blur-sm">
                                    <%= initial %>
                                  </div>
                                  <div>
                                    <h2 class="text-base font-extrabold text-white">
                                      <%= student.getName() %>
                                    </h2>
                                    <span class="text-xs font-mono font-bold text-blue-100">
                                      <%= student.getStudentId() %>
                                    </span>
                                  </div>
                                </div>

                                <div class="flex items-center gap-6 text-center flex-wrap sm:flex-nowrap">
                                  <div>
                                    <span class="block text-lg font-extrabold text-white">
                                      <%= totalSubj %>
                                    </span>
                                    <span
                                      class="block text-[10px] text-blue-100 uppercase tracking-wider font-semibold">စုစုပေါင်း
                                      ဘာသာ</span>
                                  </div>
                                  <div class="w-px h-8 bg-blue-400/40 hidden sm:block"></div>
                                  <div>
                                    <span class="block text-lg font-extrabold text-emerald-300">
                                      <%= totalSubj> 0 ? String.format("%.0f", (double)passSubj/totalSubj*100) : "0" %>%
                                    </span>
                                    <span
                                      class="block text-[10px] text-blue-100 uppercase tracking-wider font-semibold">အောင်မြင်မှုနှုန်း</span>
                                  </div>
                                  <% if (avgObj !=null) { %>
                                    <div class="w-px h-8 bg-blue-400/40 hidden sm:block"></div>
                                    <div>
                                      <span class="block text-lg font-extrabold text-white">
                                        <%= String.format("%.1f%%", avgObj) %>
                                      </span>
                                      <span
                                        class="block text-[10px] text-blue-100 uppercase tracking-wider font-semibold">ပျမ်းမျှ
                                        အမှတ်</span>
                                    </div>
                                    <% } %>
                                      <% if (cgpaObj !=null && cgpaObj> 0) { %>
                                        <div class="w-px h-8 bg-blue-400/40 hidden sm:block"></div>
                                        <div>
                                          <span class="block text-lg font-extrabold text-white">
                                            <%= String.format("%.2f", cgpaObj) %>
                                          </span>
                                          <span
                                            class="block text-[10px] text-blue-100 uppercase tracking-wider font-semibold">CGPA
                                            / 4.0</span>
                                        </div>
                                        <% } %>
                                </div>
                              </div>
                              <% } %>

                                <!-- Search & Filter Toolbar Card -->
                                <div class="p-4 roundedl bg-white border border-slate-200 shadow-sm">
                                  <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
                                    <div class="w-full sm:max-w-md space-y-1">
                                      <div class="relative">
                                        <svg class="w-4 h-4 text-slate-400 absolute left-3.5 top-3" viewBox="0 0 24 24"
                                          fill="none" stroke="currentColor" stroke-width="2">
                                          <circle cx="11" cy="11" r="8" />
                                          <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                        </svg>
                                        <input type="text" id="detailSearchInput"
                                          placeholder="ဘာသာရပ်အမည် သို့မဟုတ် သင်္ကေတဖြင့် ရှာဖွေရန်..."
                                          class="w-full pl-10 pr-4 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-xs placeholder-slate-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/15 transition-all" />
                                      </div>
                                      <p class="text-[11px] text-slate-500">ဘာသာရပ် အမည် သို့မဟုတ် သင်္ကေတ (Code) ဖြင့်
                                        ရှာဖွေနိုင်ပါသည်။</p>
                                    </div>

                                    <div class="flex items-center gap-2 flex-wrap w-full sm:w-auto">
                                      <select id="detailYearFilter"
                                        class="px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-700 text-xs focus:outline-none focus:border-blue-500">
                                        <option value="">ပညာသင်နှစ် အားလုံး</option>
                                        <% for (String yr : byYear.keySet()) { %>
                                          <option value="<%= yr %>">ပညာသင်နှစ် <%= yr %>
                                          </option>
                                          <% } %>
                                      </select>

                                      <select id="detailSemFilter"
                                        class="px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-700 text-xs focus:outline-none focus:border-blue-500">
                                        <option value="">Semester အားလုံး</option>
                                        <% for (int i=1; i <=8; i++) { %>
                                          <option value="<%= i %>">Semester <%= i %>
                                          </option>
                                          <% } %>
                                      </select>
                                    </div>
                                  </div>
                                </div>

                                <!-- Academic Year Sections Accordion -->
                                <% if (byYear.isEmpty()) { %>
                                  <div
                                    class="roundedl bg-white border border-slate-200 shadow-sm text-center py-12 px-4 text-slate-500">
                                    <svg class="w-10 h-10 mx-auto mb-3 text-slate-300" viewBox="0 0 24 24" fill="none"
                                      stroke="currentColor" stroke-width="1.5">
                                      <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                    </svg>
                                    <div class="font-bold text-slate-700 text-sm mb-1">ရလဒ် မရှိသေးပါ</div>
                                    <p class="text-xs">သင့်အကောင့်အတွက် ရလဒ်များ ထုတ်ပြန်ခြင်း မရှိသေးပါ။</p>
                                  </div>
                                  <% } else { int yearIdx=0; for (java.util.Map.Entry<String, java.util.Map<Integer,
                                    java.util.List<common.ExamResult>>> yearEntry : byYear.entrySet()) {
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
                                      <div
                                        class="year-section roundedl bg-white border border-slate-200 shadow-sm overflow-hidden space-y-0"
                                        data-year="<%= year %>">
                                        <!-- Year Header -->
                                        <button
                                          class="w-full px-5 py-4 bg-slate-100/80 hover:bg-slate-200/60 border-b border-slate-200 flex items-center justify-between cursor-pointer transition-colors text-left"
                                          type="button" onclick="toggleYearCard(this)"
                                          aria-expanded="<%= yearIdx == 0 ? "true" : "false" %>">
                                          <div class="flex items-center gap-3">
                                            <svg class="w-4 h-4 text-blue-600 shrink-0" viewBox="0 0 24 24" fill="none"
                                              stroke="currentColor" stroke-width="2.5">
                                              <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                                              <line x1="16" y1="2" x2="16" y2="6" />
                                              <line x1="8" y1="2" x2="8" y2="6" />
                                              <line x1="3" y1="10" x2="21" y2="10" />
                                            </svg>
                                            <h3 class="text-sm font-extrabold text-slate-900">ပညာသင်နှစ် <%= year %>
                                            </h3>
                                          </div>
                                          <span
                                            class="px-2.5 py-0.5 rounded-full bg-blue-50 border border-blue-200 text-[11px] font-bold text-blue-700">
                                            <%= yearPassCount %> / <%= yearTotalCount %> အောင်မြင်
                                          </span>
                                        </button>

                                        <div class="year-card-body <%= yearIdx == 0 ? "" : "collapsed-body" %>" id="<%= collapseId %>">
                                            <div class="divide-y divide-slate-200 bg-slate-50/50">
                                              <% for (java.util.Map.Entry<Integer, java.util.List<common.ExamResult>>
                                                semEntry : bySem.entrySet()) {
                                                int sem = semEntry.getKey();
                                                java.util.List<common.ExamResult> semResults = semEntry.getValue();
                                                  %>
                                                  <div class="sem-block">
                                                    <!-- Semester Header Bar -->
                                                    <div
                                                      class="sem-header px-5 py-3 bg-slate-100/90 flex items-center justify-between border-b border-slate-200">
                                                      <div class="flex items-center gap-2">
                                                        <span class="w-2 h-2 rounded-full bg-blue-600"></span>
                                                        <h4 class="text-xs font-bold text-slate-900">Semester <%= sem %>
                                                        </h4>
                                                        <span class="text-[11px] text-slate-500">(<%= semResults.size()
                                                            %> ဘာသာ)</span>
                                                      </div>

                                                      <button type="button"
                                                        class="px-3 py-1 rounded bg-blue-50 hover:bg-blue-100 border border-blue-200 text-blue-700 text-xs font-semibold flex items-center gap-1.5 transition-colors"
                                                        onclick="printSemesterResult('<%= student != null ? student.getName().replace("'", "\\'") : "" %>', '<%= student != null ? student.getStudentId() : "" %>', '<%= year %>', '<%= sem %>', this)"
                                                        title="ဤ Semester ရလဒ် ပုံနှိပ်ထုတ်ယူရန်">
                                                        <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                          stroke="currentColor" stroke-width="2">
                                                          <polyline points="6 9 6 2 18 2 18 9" />
                                                          <path
                                                            d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2" />
                                                          <rect x="6" y="14" width="12" height="8" />
                                                        </svg>
                                                        <span>Print</span>
                                                      </button>
                                                    </div>

                                                    <!-- Result Table Header Row -->
                                                    <div
                                                      class="grid grid-cols-12 px-5 py-2.5 bg-slate-100 border-b border-slate-200 text-[10px] font-bold uppercase tracking-wider text-slate-600">
                                                      <div class="col-span-5 sm:col-span-6">ဘာသာရပ်</div>
                                                      <div class="col-span-3 sm:col-span-2 text-center">ရမှတ်</div>
                                                      <div class="col-span-2 text-center">Grade</div>
                                                      <div class="col-span-2 text-center">အခြေအနေ</div>
                                                    </div>

                                                    <!-- Result Items -->
                                                    <div class="divide-y divide-slate-200">
                                                      <% for (common.ExamResult r : semResults) { boolean isPass="PASS".equals(r.getStatus()); int sCredit=r.getSubjectCredit()> 0 ?
                                                        r.getSubjectCredit() : 3;
                                                        %>
                                                        <div
                                                          class="result-row grid grid-cols-12 px-5 py-3 items-center hover:bg-slate-50 transition-colors"
                                                          data-credit="<%= sCredit %>">
                                                          <div class="col-span-5 sm:col-span-6 pr-2">
                                                            <div
                                                              class="subj-name text-xs font-semibold text-slate-900 flex items-center gap-1.5 flex-wrap">
                                                              <span>
                                                                <%= r.getSubjectName() !=null ? r.getSubjectName() : "-"
                                                                  %>
                                                              </span>
                                                              <% String et=r.getExamType(); if ("RE_EXAM".equals(et)) {
                                                                %>
                                                                <span
                                                                  class="px-1.5 py-0.5 rounded text-[9px] font-semibold bg-amber-50 border border-amber-200 text-amber-700">RE-EXAM</span>
                                                                <% } else if ("RETAKE".equals(et)) { %>
                                                                  <span
                                                                    class="px-1.5 py-0.5 rounded text-[9px] font-semibold bg-purple-50 border border-purple-200 text-purple-700">RETAKE</span>
                                                                  <% } %>
                                                            </div>
                                                            <div
                                                              class="subj-code text-[11px] font-mono text-blue-600 mt-0.5">
                                                              <%= r.getSubjectCode() !=null ? r.getSubjectCode() : "" %>
                                                            </div>
                                                          </div>

                                                          <div
                                                            class="col-span-3 sm:col-span-2 text-center text-xs font-bold text-slate-900">
                                                            <%= (int)r.getMarks() %><span
                                                                class="text-slate-400 font-normal">/<%=
                                                                  (int)r.getTotalMarks() %></span>
                                                          </div>

                                                          <div class="col-span-2 text-center grade-cell">
                                                            <span
                                                              class="px-2 py-0.5 rounded font-mono font-bold text-xs bg-slate-100 text-slate-700 border border-slate-200">
                                                              <%= r.getGrade() !=null ? r.getGrade() : "-" %>
                                                            </span>
                                                          </div>

                                                          <div class="col-span-2 text-center status-cell">
                                                            <% if (isPass) { %>
                                                              <span
                                                                class="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-50 border border-emerald-200 text-emerald-700">အောင်</span>
                                                              <% } else { %>
                                                                <span
                                                                  class="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-red-50 border border-red-200 text-red-700">ကျ</span>
                                                                <% } %>
                                                          </div>
                                                        </div>
                                                        <% } %>
                                                    </div>
                                                  </div>
                                                  <% } %>
                                            </div>
                                        </div>
                                      </div>
                                      <% yearIdx++; } } %>

                      </main>
                  </div>

                  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                  <script>
                    document.addEventListener('DOMContentLoaded', function () {
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

                    function toggleYearCard(header) {
                      var card = header.closest('.year-section');
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

                    function printSemesterResult(studentName, rollNo, year, sem, btn) {
                      var semBlock = btn.closest('.sem-block');
                      if (!semBlock) return;

                      var rows = semBlock.querySelectorAll('.result-row');
                      var tableRows = '';
                      var sr = 1;
                      var totalCredits = 0;
                      var totalGradePoint = 0;

                      function gradeToScore(grade) {
                        var map = { 'A+': 4.00, 'A': 4.00, 'A-': 3.67, 'B+': 3.33, 'B': 3.00, 'B-': 2.67, 'C+': 2.33, 'C': 2.00, 'D': 1.00, 'F': 0, 'F/Abs/I': 0 };
                        return map[grade] !== undefined ? map[grade] : 0;
                      }

                      for (var i = 0; i < rows.length; i++) {
                        var r = rows[i];
                        var nameEl = r.querySelector('.subj-name');
                        var name = nameEl ? nameEl.childNodes[0].textContent.trim() : '-';
                        var code = r.querySelector('.subj-code') ? r.querySelector('.subj-code').textContent.trim() : '-';
                        var gradeEl = r.querySelector('.grade-cell');
                        var grade = gradeEl ? gradeEl.textContent.trim() : '-';
                        var creditAttr = r.getAttribute('data-credit');
                        var credit = (creditAttr && parseInt(creditAttr, 10) > 0) ? parseInt(creditAttr, 10) : 3;

                        var gradeObtained = grade && grade !== '-' ? grade : 'F';
                        var gradeScore = gradeToScore(gradeObtained);
                        var gradePoint = gradeScore * credit;

                        totalCredits += credit;
                        totalGradePoint += gradePoint;

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
                      doc.write('* { box-sizing: border-box; margin: 0; padding: 0; }');
                      doc.write('body { font-family: "Times New Roman", Times, serif; font-size: 13px; color: #000; padding: 30px 45px; background: #fff; line-height: 1.5; }');
                      doc.write('.page-header { text-align: center; margin-bottom: 18px; }');
                      doc.write('.page-header .univ-name { font-size: 16px; font-weight: bold; margin-bottom: 3px; }');
                      doc.write('.page-header .acad-year { font-size: 13px; font-weight: bold; margin-bottom: 2px; }');
                      doc.write('.page-header .doc-title { font-size: 14px; font-weight: bold; text-decoration: underline; margin-top: 4px; }');
                      doc.write('.divider { border: none; border-top: 1px solid #000; margin: 8px 0; }');
                      doc.write('.student-info { width: 100%; margin-bottom: 16px; border-collapse: collapse; font-size: 13px; }');
                      doc.write('.student-info td { padding: 3px 6px; vertical-align: top; }');
                      doc.write('.student-info td.label { font-weight: normal; white-space: nowrap; }');
                      doc.write('.student-info td.colon { width: 8px; padding: 3px 2px; }');
                      doc.write('.student-info td.value { font-weight: bold; }');
                      doc.write('.result-table { width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 12.5px; }');
                      doc.write('.result-table th, .result-table td { border: 1px solid #000; padding: 6px 8px; }');
                      doc.write('.result-table th { background: #fff; font-weight: bold; text-align: center; vertical-align: middle; }');
                      doc.write('.result-table td.num { text-align: center; }');
                      doc.write('.grading-section { margin-top: 22px; }');
                      doc.write('.grading-title { font-weight: bold; text-decoration: underline; margin-bottom: 6px; font-size: 12.5px; }');
                      doc.write('.grading-grid { display: grid; grid-template-columns: repeat(6, auto); gap: 2px 18px; font-size: 12px; width: fit-content; }');
                      doc.write('.grading-grid .gp { display: flex; gap: 6px; }');
                      doc.write('.grading-grid .gv { font-weight: bold; }');
                      doc.write('.issue-date { margin-top: 20px; font-size: 12.5px; font-weight: bold; }');
                      doc.write('.signature-block { margin-top: 55px; text-align: right; font-size: 12.5px; }');
                      doc.write('.signature-block .sig-role { font-weight: bold; }');
                      doc.write('.signature-block .sig-title { font-size: 12px; }');
                      doc.write('@media print { body { padding: 20px 35px; } @page { margin: 1.2cm; size: A4; } }');
                      doc.write('</style></head><body>');

                      doc.write('<div class="page-header">');
                      doc.write('<div class="univ-name">University of Computer Studies (Hpa-an)</div>');
                      doc.write('<div class="acad-year">' + year + ' Academic Year</div>');
                      doc.write('<div class="doc-title">Academic Record</div>');
                      doc.write('</div>');
                      doc.write('<hr class="divider">');

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

                      doc.write('<table class="result-table">');
                      doc.write('<thead><tr>');
                      doc.write('<th style="width:38px;">No.</th>');
                      doc.write('<th style="width:100px;">Course Code</th>');
                      doc.write('<th>Course Name</th>');
                      doc.write('<th style="width:70px;">Academic Credit Unit</th>');
                      doc.write('<th style="width:62px;">Grade Obtained</th>');
                      doc.write('<th style="width:58px;">Grade Score</th>');
                      doc.write('<th style="width:58px;">Grade Point</th>');
                      doc.write('</tr></thead>');
                      doc.write('<tbody>');
                      doc.write(tableRows);

                      doc.write('<tr>');
                      doc.write('<td colspan="3" style="text-align:right; padding:7px 8px; border:1px solid #000; font-weight:bold;">Total Credit Units</td>');
                      doc.write('<td class="num" style="border:1px solid #000; font-weight:bold;">' + totalCredits + '</td>');
                      doc.write('<td colspan="2" style="text-align:right; padding:7px 8px; border:1px solid #000; font-weight:bold;">Total Grade Point</td>');
                      doc.write('<td class="num" style="border:1px solid #000; font-weight:bold;">' + totalGradePoint.toFixed(2) + '</td>');
                      doc.write('</tr>');

                      doc.write('<tr>');
                      doc.write('<td colspan="5" style="border:none;"></td>');
                      doc.write('<td style="border:1px solid #000; font-weight:bold; text-align:right; padding:5px 8px;">Cumulative GPA</td>');
                      doc.write('<td style="border:1px solid #000; text-align:center; font-weight:bold;">' + semesterGPA + '</td>');
                      doc.write('</tr>');

                      doc.write('<tr>');
                      doc.write('<td colspan="5" style="border:none;"></td>');
                      doc.write('<td style="border:1px solid #000; font-weight:bold; text-align:right; padding:5px 8px;">Overall GPA</td>');
                      doc.write('<td style="border:1px solid #000; text-align:center; font-weight:bold;">' + semesterGPA + '</td>');
                      doc.write('</tr>');

                      doc.write('</tbody></table>');

                      doc.write('<div class="grading-section">');
                      doc.write('<div class="grading-title">GRADING SCALE</div>');
                      doc.write('<div class="grading-grid">');
                      var grades = [['>=90', 'A+'], ['80-89', 'A'], ['75-79', 'A-'], ['70-74', 'B+'], ['65-69', 'B'], ['60-64', 'B-'],
                      ['55-59', 'C+'], ['50-54', 'C'], ['40-49', 'D'], ['0-39', 'F/Abs/I']];
                      grades.forEach(function (g) {
                        doc.write('<div class="gp"><span>' + g[0] + '</span><span class="gv">' + g[1] + '</span></div>');
                      });
                      doc.write('</div></div>');

                      doc.write('<div class="issue-date">ISSUE DATE &nbsp;: &nbsp;' + issueDateStr + '</div>');

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