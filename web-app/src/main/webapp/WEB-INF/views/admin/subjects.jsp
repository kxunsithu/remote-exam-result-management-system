<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "Subject Management" ); java.util.List<common.Subject> subjects =
      (java.util.List<common.Subject>) request.getAttribute("subjects");
        String filterSemesterId = (String) request.getAttribute("filterSemesterId");
        %>
        <%! private static java.util.LinkedHashMap<String, java.util.List<common.Subject>> groupSubjects(java.util.List
          <common.Subject> list) {
            java.util.LinkedHashMap<String, java.util.List<common.Subject>> groups = new java.util.LinkedHashMap<>();
                if (list == null) return groups;
                for (common.Subject s : list) {
                String key = s.getSubjectCode() + "|" + s.getSubjectName() + "|" + s.getCredit() + "|" +
                s.getDepartment();
                groups.computeIfAbsent(key, k -> new java.util.ArrayList<>()).add(s);
                  }
                  return groups;
                  }

                  private static String esc(String v) {
                  if (v == null) return "";
                  return v.replace("&", "&amp;").replace("\\", "&#92;").replace("\"", "&quot;")
                  .replace("<", "&lt;" ).replace(">", "&gt;");
                    }
                    %>
                    <!DOCTYPE html>
                    <html lang="my">

                    <head>
                      <meta charset="UTF-8" />
                      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                      <title>Subjects — RERMS Admin</title>
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
                                    <span class="text-slate-900 font-medium">ဘာသာရပ်များ</span>
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

                                <!-- Toolbar Card -->
                                <div class="p-4 roundedl bg-white border border-slate-200 shadow-sm">
                                  <form method="get" action="${pageContext.request.contextPath}/admin/subjects"
                                    class="flex flex-col sm:flex-row items-center justify-between gap-4">
                                    <div class="w-full sm:max-w-md space-y-1">
                                      <div class="relative">
                                        <svg class="w-4 h-4 text-slate-400 absolute left-3.5 top-3" viewBox="0 0 24 24"
                                          fill="none" stroke="currentColor" stroke-width="2">
                                          <circle cx="11" cy="11" r="8" />
                                          <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                        </svg>
                                        <input type="text" name="search" placeholder="ဘာသာရပ် ရှာဖွေရန်..."
                                          value="<%= request.getAttribute(" searchKeyword") !=null ?
                                          request.getAttribute("searchKeyword") : "" %>"
                                        class="w-full pl-10 pr-4 py-2.5 rounded bg-slate-50 border border-slate-300
                                        text-slate-900 text-xs placeholder-slate-400 focus:outline-none
                                        focus:border-blue-500 focus:ring-2 focus:ring-blue-500/15 transition-all"/>
                                      </div>
                                      <p class="text-[11px] text-slate-500">
                                        ဘာသာရပ်သင်္ကေတ၊ အမည် သို့မဟုတ် ဌာနအလိုက် ရှာဖွေနိုင်ပါသည်။
                                      </p>
                                    </div>

                                    <div class="flex items-center gap-3 w-full sm:w-auto">
                                      <% if (filterSemesterId !=null) { %>
                                        <a href="${pageContext.request.contextPath}/admin/subjects"
                                          class="px-3 py-1.5 rounded bg-blue-50 border border-blue-200 text-blue-700 text-xs font-semibold hover:bg-blue-100 transition-colors">
                                          Semester ဖြင့် စစ်ထားသည် · အားလုံးကြည့်ရန် ✕
                                        </a>
                                        <% } %>
                                          <button type="button" data-bs-toggle="modal" data-bs-target="#addSubjectModal"
                                            class="w-full sm:w-auto px-4 py-2.5 rounded bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white text-xs font-bold shadow-md shadow-blue-600/20 flex items-center justify-center gap-2 transition-all transform active:scale-[0.98]">
                                            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                              stroke-width="2.5">
                                              <line x1="12" y1="5" x2="12" y2="19" />
                                              <line x1="5" y1="12" x2="19" y2="12" />
                                            </svg>
                                            <span>မှတ်တမ်းတင်ရန်</span>
                                          </button>
                                    </div>
                                  </form>
                                </div>

                                <!-- Subjects Data Table Card -->
                                <div class="roundedl bg-white border border-slate-200 shadow-sm overflow-hidden">
                                  <div class="overflow-x-auto">
                                    <table class="w-full text-left text-xs text-slate-700">
                                      <thead
                                        class="bg-slate-100/90 text-slate-700 uppercase font-bold text-[10px] tracking-wider border-b border-slate-200">
                                        <tr>
                                          <th class="py-3.5 px-4 w-12 text-center">စဉ်</th>
                                          <th class="py-3.5 px-4">ဘာသာရပ် သင်္ကေတ</th>
                                          <th class="py-3.5 px-4">ဘာသာရပ် အမည်</th>
                                          <th class="py-3.5 px-4">ခရက်ဒစ် (Credit)</th>
                                          <th class="py-3.5 px-4">ဌာန</th>
                                          <th class="py-3.5 px-4 text-center">Semester</th>
                                          <th class="py-3.5 px-4 text-center">လုပ်ဆောင်ချက်</th>
                                        </tr>
                                      </thead>
                                      <tbody class="divide-y divide-slate-200">
                                        <% java.util.LinkedHashMap<String, java.util.List<common.Subject>> subjectGroups
                                          = groupSubjects(subjects);
                                          if (!subjectGroups.isEmpty()) {
                                          int idx = 1;
                                          for (java.util.List<common.Subject> grp : subjectGroups.values()) {
                                            common.Subject s = grp.get(0);
                                            StringBuilder assignmentsJson = new StringBuilder("[");
                                            boolean hasUnassigned = false;
                                            java.time.LocalDateTime earliest = null;
                                            for (common.Subject x : grp) {
                                            if (x.getSemesterNumber() != null && x.getSemesterNumber() > 0) {
                                            int semNo = x.getSemesterNumber();
                                            if (assignmentsJson.length() > 1) assignmentsJson.append(",");
                                            assignmentsJson.append("{\"s\":").append(semNo).append("}");
                                            } else {
                                            hasUnassigned = true;
                                            }
                                            if (x.getCreatedAt() != null && (earliest == null ||
                                            x.getCreatedAt().isBefore(earliest))) {
                                            earliest = x.getCreatedAt();
                                            }
                                            }
                                            assignmentsJson.append("]");
                                            %>
                                            <tr class="hover:bg-slate-50 transition-colors">
                                              <td class="py-3 px-4 text-center text-slate-400 font-medium">
                                                <%= idx++ %>
                                              </td>
                                              <td class="py-3 px-4"><span class="font-mono font-bold text-blue-600">
                                                  <%= s.getSubjectCode() %>
                                                </span></td>
                                              <td class="py-3 px-4 font-bold text-slate-900">
                                                <%= s.getSubjectName() %>
                                              </td>
                                              <td class="py-3 px-4">
                                                <span
                                                  class="px-2.5 py-0.5 rounded-full text-[10px] font-semibold bg-blue-50 border border-blue-200 text-blue-700">
                                                  <%= s.getCredit() %> Credits
                                                </span>
                                              </td>
                                              <td class="py-3 px-4 text-slate-600">
                                                <%= s.getDepartment() %>
                                              </td>
                                              <td class="py-3 px-4 text-center">
                                                <% Integer dispSemNo=s.getSemesterNumber(); if (dispSemNo !=null &&
                                                  dispSemNo> 0) { %>
                                                  <span
                                                    class="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-amber-50 border border-amber-200 text-amber-700">Semester <%= dispSemNo %></span>
                                                  <% } else { %>
                                                    <span class="text-slate-400">—</span>
                                                    <% } %>
                                              </td>
                                              <td class="py-3 px-4 text-center">
                                                <div class="flex items-center justify-center gap-1.5">
                                                  <button type="button"
                                                    class="w-7 h-7 rounded bg-blue-50 border border-blue-200 text-blue-600 hover:bg-blue-100 flex items-center justify-center transition-colors"
                                                    data-bs-toggle="modal" data-bs-target="#editSubjectModal"
                                                    data-id="<%= s.getId() %>"
                                                    data-subjectcode="<%= s.getSubjectCode() %>"
                                                    data-subjectname="<%= s.getSubjectName() %>"
                                                    data-credit="<%= s.getCredit() %>"
                                                    data-department="<%= s.getDepartment() %>"
                                                    data-semesternumber="<%= s.getSemesterNumber() != null ? s.getSemesterNumber() : 0 %>"
                                                    title="ပြင်ဆင်ရန်">
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
                                                    data-bs-toggle="modal" data-bs-target="#deleteSubjectModal"
                                                    data-id="<%= s.getId() %>" data-name="<%= s.getSubjectName() %>"
                                                    title="ဖျက်ရန်">
                                                    <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                      stroke="currentColor" stroke-width="2">
                                                      <polyline points="3 6 5 6 21 6" />
                                                      <path
                                                        d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                                    </svg>
                                                  </button>

                                                  <button type="button"
                                                    class="w-7 h-7 rounded bg-slate-100 border border-slate-200 text-slate-700 hover:bg-slate-200 flex items-center justify-center transition-colors"
                                                    data-bs-toggle="modal" data-bs-target="#viewSubjectModal"
                                                    data-code="<%= s.getSubjectCode() %>"
                                                    data-name="<%= s.getSubjectName() %>"
                                                    data-credit="<%= s.getCredit() %>"
                                                    data-department="<%= s.getDepartment() %>"
                                                    data-assignments="<%= esc(assignmentsJson.toString()) %>"
                                                    data-unassigned="<%= hasUnassigned %>"
                                                    data-created='<%= earliest != null ? earliest.toString().replace("T", " ") : "-" %>'
                                                    title="အသေးစိတ်ကြည့်ရန်">
                                                    <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                                                      stroke="currentColor" stroke-width="2">
                                                      <line x1="5" y1="12" x2="19" y2="12" />
                                                      <polyline points="12 5 19 12 12 19" />
                                                    </svg>
                                                  </button>
                                                </div>
                                              </td>
                                            </tr>
                                            <% } } else { %>
                                              <tr>
                                                <td colspan="7" class="text-center py-12 px-4 text-slate-500">
                                                  <svg class="w-10 h-10 mx-auto mb-3 text-slate-300" viewBox="0 0 24 24"
                                                    fill="none" stroke="currentColor" stroke-width="1.5">
                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                    <path
                                                      d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                  </svg>
                                                  <div class="font-bold text-slate-700 text-sm mb-1">ဘာသာရပ် အချက်အလက်
                                                    မရှိသေးပါ</div>
                                                  <p class="text-xs">ဘာသာရပ်အသစ် ထည့်သွင်းပါ သို့မဟုတ် ရှာဖွေမှုစကားလုံး
                                                    ပြောင်းလဲပါ။</p>
                                                </td>
                                              </tr>
                                              <% } %>
                                      </tbody>
                                    </table>
                                  </div>
                                </div>

                              </div>
                          </main>
                      </div>

                      <!-- Add Subject Modal -->
                      <div class="modal fade" id="addSubjectModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" style="max-width: 30rem;">
                          <div class="modal-content">
                            <div class="modal-accent"></div>
                            <div class="modal-header-custom">
                              <div class="modal-header-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2.2">
                                  <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                  <path d="M2 17l10 5 10-5" />
                                  <path d="M2 12l10 5 10-5" />
                                </svg>
                              </div>
                              <div class="modal-title-group">
                                <h5 class="modal-title">ဘာသာရပ်အသစ် ထည့်သွင်းရန်</h5>
                                <p class="modal-subtitle">Add New Subject</p>
                              </div>
                              <button type="button" class="modal-close-btn" data-bs-dismiss="modal">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2.5">
                                  <line x1="18" y1="6" x2="6" y2="18" />
                                  <line x1="6" y1="6" x2="18" y2="18" />
                                </svg>
                              </button>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/admin/subjects">
                              <input type="hidden" name="action" value="add" />
                              <div class="modal-body space-y-4">
                                <div class="grid grid-cols-2 gap-3">
                                  <div>
                                    <label class="form-label" for="add-subjectCode">သင်္ကေတ (Code) <span
                                        class="text-red-500">*</span></label>
                                    <input type="text" id="add-subjectCode" name="subjectCode"
                                      placeholder="e.g. CST-101" required />
                                  </div>
                                  <div>
                                    <label class="form-label" for="add-credit">ခရက်ဒစ် <span
                                        class="text-red-500">*</span></label>
                                    <input type="number" id="add-credit" name="credit" min="1" max="10" value="3"
                                      required />
                                  </div>
                                </div>
                                <div>
                                  <label class="form-label" for="add-subjectName">ဘာသာရပ် အမည် <span
                                      class="text-red-500">*</span></label>
                                  <input type="text" id="add-subjectName" name="subjectName"
                                    placeholder="e.g. Java Programming" required />
                                </div>
                                <div>
                                  <label class="form-label" for="add-department">ဌာန (Department)</label>
                                  <select id="add-department" name="department">
                                    <option value="">-- ရွေးချယ်ပါ --</option>
                                    <option value="CS">CS — Computer Science</option>
                                    <option value="CT">CT — Computer Technology</option>
                                    <option value="CST">CST — Computer Science &amp; Technology</option>
                                  </select>
                                </div>
                                <div>
                                  <label class="form-label" for="add-semesterNumber">Semester <span
                                      class="text-red-500">*</span></label>
                                  <select id="add-semesterNumber" name="semesterNumber" required>
                                    <option value="">-- ရွေးချယ်ပါ --</option>
                                    <% for (int i=1; i <=8; i++) { %>
                                      <option value="<%= i %>">Semester <%= i %>
                                      </option>
                                      <% } %>
                                  </select>
                                </div>
                              </div>
                              <div class="modal-footer">
                                <button type="button" class="btn-outline-custom"
                                  data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
                                <button type="submit" class="btn-primary-custom">
                                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
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

                      <!-- Edit Subject Modal -->
                      <div class="modal fade" id="editSubjectModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" style="max-width: 30rem;">
                          <div class="modal-content">
                            <div class="modal-accent"
                              style="background: linear-gradient(90deg, rgb(99 102 241), rgb(168 85 247));"></div>
                            <div class="modal-header-custom">
                              <div class="modal-header-icon"
                                style="background: rgb(245 243 255); color: rgb(99 102 241); border-color: rgb(221 214 254);">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2.2">
                                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                </svg>
                              </div>
                              <div class="modal-title-group">
                                <h5 class="modal-title">ဘာသာရပ် ပြင်ဆင်ရန်</h5>
                                <p class="modal-subtitle">Edit Subject</p>
                              </div>
                              <button type="button" class="modal-close-btn" data-bs-dismiss="modal">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2.5">
                                  <line x1="18" y1="6" x2="6" y2="18" />
                                  <line x1="6" y1="6" x2="18" y2="18" />
                                </svg>
                              </button>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/admin/subjects">
                              <input type="hidden" name="action" value="update" />
                              <input type="hidden" name="id" id="edit-subject-id" />
                              <div class="modal-body space-y-4">
                                <div class="grid grid-cols-2 gap-3">
                                  <div>
                                    <label class="form-label" for="edit-subjectCode">သင်္ကေတ <span
                                        class="text-red-500">*</span></label>
                                    <input type="text" id="edit-subjectCode" name="subjectCode" required />
                                  </div>
                                  <div>
                                    <label class="form-label" for="edit-credit">ခရက်ဒစ် <span
                                        class="text-red-500">*</span></label>
                                    <input type="number" id="edit-credit" name="credit" min="1" max="10" required />
                                  </div>
                                </div>
                                <div>
                                  <label class="form-label" for="edit-subjectName">ဘာသာရပ် အမည် <span
                                      class="text-red-500">*</span></label>
                                  <input type="text" id="edit-subjectName" name="subjectName" required />
                                </div>
                                <div>
                                  <label class="form-label" for="edit-department">ဌာန (Department)</label>
                                  <select id="edit-department" name="department">
                                    <option value="">-- ရွေးချယ်ပါ --</option>
                                    <option value="CS">CS — Computer Science</option>
                                    <option value="CT">CT — Computer Technology</option>
                                    <option value="CST">CST — Computer Science &amp; Technology</option>
                                  </select>
                                </div>
                                <div>
                                  <label class="form-label" for="edit-semesterNumber">Semester <span
                                      class="text-red-500">*</span></label>
                                  <select id="edit-semesterNumber" name="semesterNumber" required>
                                    <option value="">-- ရွေးချယ်ပါ --</option>
                                    <% for (int i=1; i <=8; i++) { %>
                                      <option value="<%= i %>">Semester <%= i %>
                                      </option>
                                      <% } %>
                                  </select>
                                </div>
                              </div>
                              <div class="modal-footer">
                                <button type="button" class="btn-outline-custom"
                                  data-bs-dismiss="modal">မပြင်ဆင်ပါ</button>
                                <button type="submit" class="btn-primary-custom"
                                  style="background: rgb(99 102 241); box-shadow: 0 2px 6px rgba(99,102,241,0.3);">
                                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                    <polyline points="17 21 17 13 7 13 7 21" />
                                    <polyline points="7 3 7 8 15 8" />
                                  </svg>
                                  ပြင်ဆင်မည်
                                </button>
                              </div>
                            </form>
                          </div>
                        </div>
                      </div>

                      <!-- Delete Subject Modal -->
                      <div class="modal fade" id="deleteSubjectModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" style="max-width: 22rem;">
                          <div class="modal-content">
                            <div class="modal-accent modal-accent-red"></div>
                            <form method="post" action="${pageContext.request.contextPath}/admin/subjects">
                              <input type="hidden" name="action" value="delete" />
                              <input type="hidden" name="id" id="delete-subject-id" />
                              <div class="modal-body text-center" style="padding: 2rem 1.5rem 1.25rem;">
                                <div
                                  class="w-14 h-14 rounded-full bg-red-50 border-2 border-red-100 flex items-center justify-center mx-auto mb-4">
                                  <svg class="w-7 h-7 text-red-500" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <polyline points="3 6 5 6 21 6" />
                                    <path
                                      d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                  </svg>
                                </div>
                                <h5 class="text-base font-bold text-slate-900 mb-1.5">ဖျက်ရန် အတည်ပြုပါ</h5>
                                <p class="text-xs text-slate-500 leading-relaxed">
                                  ဘာသာရပ် <strong id="delete-subject-name" class="text-red-600 font-semibold"></strong>
                                  ကို ဖျက်ရန် သေချာပါသလား?<br />
                                  <span class="text-slate-400 mt-1 block">ဤလုပ်ဆောင်ချက်ကို ပြန်လည်ပြင်ဆင်၍
                                    မရနိုင်ပါ။</span>
                                </p>
                              </div>
                              <div class="modal-footer">
                                <button type="button" class="btn-outline-custom flex-1 justify-center"
                                  data-bs-dismiss="modal">မဖျက်ပါ</button>
                                <button type="submit" class="btn-danger-custom flex-1 justify-center">
                                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="3 6 5 6 21 6" />
                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6" />
                                  </svg>
                                  ဖျက်မည်
                                </button>
                              </div>
                            </form>
                          </div>
                        </div>
                      </div>

                      <!-- View Subject Modal -->
                      <div class="modal fade" id="viewSubjectModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
                          <div class="modal-content">
                            <div class="modal-accent"
                              style="background: linear-gradient(90deg, rgb(217 119 6), rgb(245 158 11));"></div>
                            <div class="modal-header-custom">
                              <div class="modal-header-icon"
                                style="background: rgb(255 251 235); color: rgb(217 119 6); border-color: rgb(253 230 138);">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2.2">
                                  <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                  <path d="M2 17l10 5 10-5" />
                                  <path d="M2 12l10 5 10-5" />
                                </svg>
                              </div>
                              <div class="modal-title-group">
                                <h5 class="modal-title">ဘာသာရပ် အချက်အလက်</h5>
                                <p class="modal-subtitle">Subject Details</p>
                              </div>
                              <button type="button" class="modal-close-btn" data-bs-dismiss="modal">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                  stroke-width="2.5">
                                  <line x1="18" y1="6" x2="6" y2="18" />
                                  <line x1="6" y1="6" x2="18" y2="18" />
                                </svg>
                              </button>
                            </div>
                            <div class="modal-body">
                              <div class="space-y-0 text-xs rounded-lg border border-slate-200 overflow-hidden">
                                <div
                                  class="flex items-center justify-between px-4 py-2.5 bg-slate-50 border-b border-slate-200">
                                  <span class="text-slate-500 font-medium">သင်္ကေတ</span>
                                  <strong id="view-subjectCode" class="text-blue-600 font-mono font-bold"></strong>
                                </div>
                                <div
                                  class="flex items-center justify-between px-4 py-2.5 bg-white border-b border-slate-200">
                                  <span class="text-slate-500 font-medium">အမည်</span>
                                  <strong id="view-subjectName" class="text-slate-900 font-semibold"></strong>
                                </div>
                                <div
                                  class="flex items-center justify-between px-4 py-2.5 bg-slate-50 border-b border-slate-200">
                                  <span class="text-slate-500 font-medium">ခရက်ဒစ်</span>
                                  <span id="view-credit"
                                    class="px-2 py-0.5 rounded-full bg-blue-50 text-blue-700 font-semibold border border-blue-200"></span>
                                </div>
                                <div
                                  class="flex items-center justify-between px-4 py-2.5 bg-white border-b border-slate-200">
                                  <span class="text-slate-500 font-medium">ဌာန</span>
                                  <span id="view-department" class="text-slate-700"></span>
                                </div>
                                <div
                                  class="flex items-start justify-between px-4 py-2.5 bg-slate-50 border-b border-slate-200">
                                  <span class="text-slate-500 font-medium">Semester</span>
                                  <div id="view-assignments" class="text-right space-y-1"></div>
                                </div>
                                <div class="flex items-center justify-between px-4 py-2.5 bg-white">
                                  <span class="text-slate-500 font-medium">ထည့်သွင်းသည့်ရက်</span>
                                  <span id="view-created" class="text-slate-500"></span>
                                </div>
                              </div>
                            </div>
                            <div class="modal-footer">
                              <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">ပိတ်မည်</button>
                            </div>
                          </div>
                        </div>
                      </div>

                      <script
                        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                      <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                      <script>
                        document.getElementById('deleteSubjectModal').addEventListener('show.bs.modal', function (event) {
                          const btn = event.relatedTarget;
                          if (!btn) return;
                          const d = btn.dataset;
                          document.getElementById('delete-subject-id').value = d.id || '';
                          document.getElementById('delete-subject-name').textContent = d.name || '';
                        });

                        document.getElementById('editSubjectModal').addEventListener('show.bs.modal', function (event) {
                          const btn = event.relatedTarget;
                          if (!btn) return;
                          const d = btn.dataset;
                          document.getElementById('edit-subject-id').value = d.id || '';
                          document.getElementById('edit-subjectCode').value = d.subjectcode || '';
                          document.getElementById('edit-subjectName').value = d.subjectname || '';
                          document.getElementById('edit-credit').value = d.credit || '3';
                          document.getElementById('edit-department').value = d.department || '';
                          const semSel = document.getElementById('edit-semesterNumber');
                          for (let opt of semSel.options) {
                            opt.selected = (opt.value === String(d.semesternumber || ''));
                          }
                        });

                        document.getElementById('viewSubjectModal').addEventListener('show.bs.modal', function (event) {
                          const btn = event.relatedTarget;
                          if (!btn) return;
                          const d = btn.dataset;
                          document.getElementById('view-subjectCode').textContent = d.code || '-';
                          document.getElementById('view-subjectName').textContent = d.name || '-';
                          document.getElementById('view-credit').textContent = (d.credit || '-') + ' Credits';
                          document.getElementById('view-department').textContent = d.department || '-';
                          document.getElementById('view-created').textContent = d.created || '-';

                          const wrap = document.getElementById('view-assignments');
                          wrap.innerHTML = '';
                          let assignments = [];
                          try { assignments = JSON.parse(d.assignments || '[]'); } catch (err) { assignments = []; }

                          if (assignments.length) {
                            const seen = {};
                            assignments.forEach(function (a) {
                              const key = a.s;
                              if (!key || seen[key]) return;
                              seen[key] = true;
                              const row = document.createElement('div');
                              row.className = 'd-flex align-items-center justify-content-end';
                              row.innerHTML = '<span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-amber-50 border border-amber-200 text-amber-700">Semester ' + key + '</span>';
                              wrap.appendChild(row);
                            });
                          }
                          if (!wrap.children.length) {
                            const un = document.createElement('div');
                            un.innerHTML = '<span class="badge" style="background: #f1f5f9; color: #94a3b8; font-size: 0.72rem;">မထည့်ရသေးပါ</span>';
                            wrap.appendChild(un.firstChild);
                          }
                        });
                      </script>
                    </body>

                    </html>