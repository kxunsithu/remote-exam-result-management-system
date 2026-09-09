<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <% request.setAttribute("pageTitle", "Student Management" ); java.util.List<common.Student> students =
      (java.util.List<common.Student>) request.getAttribute("students");
        %>
        <!DOCTYPE html>
        <html lang="my">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Students — RERMS Admin</title>
          <%@ include file="../common/tailwind-setup.jsp" %>
        </head>

        <body class="bg-slate-50 text-slate-800 min-h-screen font-sans antialiased">
          <div class="flex min-h-screen">
            <%@ include file="sidebar.jsp" %>

              <main class="flex-1 flex flex-col min-w-0">
                <%@ include file="header.jsp" %>

                  <div class="p-4 sm:p-6 space-y-6 w-full max-w-7xl mx-auto">
                    <!-- Breadcrumb Row -->
                    <div class="flex items-center justify-between text-xs text-slate-500">
                      <div class="flex items-center gap-2">
                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                          class="hover:text-slate-900 transition-colors">ပင်မစာမျက်နှာ</a>
                        <svg class="w-3 h-3 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                          stroke-width="2">
                          <polyline points="9 18 15 12 9 6" />
                        </svg>
                        <span class="text-slate-900 font-medium">ကျောင်းသား/သူများ</span>
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
                      <form method="get" action="${pageContext.request.contextPath}/admin/students"
                        class="flex flex-col sm:flex-row items-center justify-between gap-4">
                        <div class="w-full sm:max-w-md space-y-1">
                          <div class="relative">
                            <svg class="w-4 h-4 text-slate-400 absolute left-3.5 top-3" viewBox="0 0 24 24" fill="none"
                              stroke="currentColor" stroke-width="2">
                              <circle cx="11" cy="11" r="8" />
                              <line x1="21" y1="21" x2="16.65" y2="16.65" />
                            </svg>
                            <input type="text" name="search" placeholder="ကျောင်းသားကို ရှာဖွေရန်..."
                              value="<%= request.getAttribute(" searchKeyword") !=null ?
                              request.getAttribute("searchKeyword") : "" %>"
                            class="w-full pl-10 pr-4 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900
                            text-xs placeholder-slate-400 focus:outline-none focus:border-blue-500 focus:ring-2
                            focus:ring-blue-500/15 transition-all"/>
                          </div>
                          <p class="text-[11px] text-slate-500">
                            ခုံနံပါတ် (Roll Number)၊ အမည်၊ အီးမေးလ် စသည်တို့ဖြင့် ရှာဖွေနိုင်ပါသည်။
                          </p>
                        </div>

                        <button type="button" data-bs-toggle="modal" data-bs-target="#addStudentModal"
                          class="w-full sm:w-auto px-4 py-2.5 rounded bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white text-xs font-bold shadow-md shadow-blue-600/20 flex items-center justify-center gap-2 transition-all transform active:scale-[0.98]">
                          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="12" y1="5" x2="12" y2="19" />
                            <line x1="5" y1="12" x2="19" y2="12" />
                          </svg>
                          <span>မှတ်တမ်းတင်ရန်</span>
                        </button>
                      </form>
                    </div>

                    <!-- Students Data Table Card -->
                    <div class="roundedl bg-white border border-slate-200 shadow-sm overflow-hidden">
                      <div class="overflow-x-auto">
                        <table class="w-full text-left text-xs text-slate-700">
                          <thead
                            class="bg-slate-100/90 text-slate-700 uppercase font-bold text-[10px] tracking-wider border-b border-slate-200">
                            <tr>
                              <th class="py-3.5 px-4 w-12 text-center">စဉ်</th>
                              <th class="py-3.5 px-4">ခုံနံပါတ်</th>
                              <th class="py-3.5 px-4">ကျောင်းသား အမည်</th>
                              <th class="py-3.5 px-4">အီးမေးလ်</th>
                              <th class="py-3.5 px-4">ဖုန်းနံပါတ်</th>
                              <th class="py-3.5 px-4 text-center">လိင်</th>
                              <th class="py-3.5 px-4">ထည့်သွင်းသည့်ရက်စွဲ</th>
                              <th class="py-3.5 px-4 text-center">လုပ်ဆောင်ချက်</th>
                            </tr>
                          </thead>
                          <tbody class="divide-y divide-slate-200">
                            <% if (students !=null && !students.isEmpty()) { int idx=1; for (common.Student s :
                              students) { String phoneStr=s.getPhone() !=null && !s.getPhone().isBlank() ? s.getPhone()
                              : "-" ; String genderStr=s.getGender() !=null && !s.getGender().isBlank() ? s.getGender()
                              : "-" ; String createdStr=s.getCreatedAt() !=null ?
                              s.getCreatedAt().toString().replace("T", " " ) : "-" ; %>
                              <tr class="hover:bg-slate-50 transition-colors">
                                <td class="py-3 px-4 text-center text-slate-400 font-medium">
                                  <%= idx++ %>
                                </td>
                                <td class="py-3 px-4"><span class="font-mono font-bold text-blue-600">
                                    <%= s.getStudentId() %>
                                  </span></td>
                                <td class="py-3 px-4 font-bold text-slate-900">
                                  <%= s.getName() %>
                                </td>
                                <td class="py-3 px-4 text-slate-700">
                                  <%= s.getEmail() %>
                                </td>
                                <td class="py-3 px-4 text-slate-600 font-mono text-[11px]">
                                  <%= phoneStr %>
                                </td>
                                <td class="py-3 px-4 text-center">
                                  <span
                                    class="px-2 py-0.5 rounded-full text-[10px] font-semibold bg-slate-100 border border-slate-200 text-slate-700">
                                    <%= genderStr %>
                                  </span>
                                </td>
                                <td class="py-3 px-4 text-slate-500 text-[11px]">
                                  <%= createdStr %>
                                </td>
                                <td class="py-3 px-4 text-center">
                                  <div class="flex items-center justify-center gap-1.5">
                                    <!-- Edit Button -->
                                    <button type="button"
                                      class="w-7 h-7 rounded bg-blue-50 border border-blue-200 text-blue-600 hover:bg-blue-100 flex items-center justify-center transition-colors"
                                      data-bs-toggle="modal" data-bs-target="#editStudentModal"
                                      data-id="<%= s.getId() %>" data-studentid="<%= s.getStudentId() %>"
                                      data-name="<%= s.getName() %>" data-email="<%= s.getEmail() %>"
                                      data-phone='<%= s.getPhone() != null ? s.getPhone() : "" %>'
                                      data-gender='<%= s.getGender() != null ? s.getGender() : "" %>'
                                      title="ပြင်ဆင်ရန်">
                                      <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                      </svg>
                                    </button>

                                    <!-- Delete Button -->
                                    <button type="button"
                                      class="w-7 h-7 rounded bg-red-50 border border-red-200 text-red-600 hover:bg-red-100 flex items-center justify-center transition-colors"
                                      data-bs-toggle="modal" data-bs-target="#deleteStudentModal"
                                      data-id="<%= s.getId() %>" data-name="<%= s.getName() %>" title="ဖျက်ရန်">
                                      <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <polyline points="3 6 5 6 21 6" />
                                        <path
                                          d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                                      </svg>
                                    </button>

                                    <!-- View Details Button -->
                                    <button type="button"
                                      class="w-7 h-7 rounded bg-slate-100 border border-slate-200 text-slate-700 hover:bg-slate-200 flex items-center justify-center transition-colors"
                                      data-bs-toggle="modal" data-bs-target="#viewStudentModal"
                                      data-studentid="<%= s.getStudentId() %>" data-name="<%= s.getName() %>"
                                      data-email="<%= s.getEmail() %>" data-phone="<%= phoneStr %>"
                                      data-gender="<%= genderStr %>" data-created="<%= createdStr %>"
                                      title="အသေးစိတ်ကြည့်ရန်">
                                      <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                      </svg>
                                    </button>
                                  </div>
                                </td>
                              </tr>
                              <% } } else { %>
                                <tr>
                                  <td colspan="8" class="text-center py-12 px-4 text-slate-500">
                                    <svg class="w-10 h-10 mx-auto mb-3 text-slate-300" viewBox="0 0 24 24" fill="none"
                                      stroke="currentColor" stroke-width="1.5">
                                      <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                      <circle cx="9" cy="7" r="4" />
                                    </svg>
                                    <div class="font-bold text-slate-700 text-sm mb-1">ကျောင်းသား အချက်အလက် မရှိသေးပါ
                                    </div>
                                    <p class="text-xs">ကျောင်းသားအသစ် ထည့်သွင်းပါ သို့မဟုတ် ရှာဖွေမှုစကားလုံး
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

          <!-- Add Student Modal -->
          <div class="modal fade" id="addStudentModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 30rem;">
              <div class="modal-content">
                <div class="modal-accent"></div>
                <div class="modal-header-custom">
                  <div class="modal-header-icon">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2.2">
                      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                      <circle cx="9" cy="7" r="4" />
                      <line x1="19" y1="8" x2="19" y2="14" />
                      <line x1="22" y1="11" x2="16" y2="11" />
                    </svg>
                  </div>
                  <div class="modal-title-group">
                    <h5 class="modal-title">ကျောင်းသားအသစ် ထည့်သွင်းရန်</h5>
                    <p class="modal-subtitle">Add New Student</p>
                  </div>
                  <button type="button" class="modal-close-btn" data-bs-dismiss="modal" aria-label="Close">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2.5">
                      <line x1="18" y1="6" x2="6" y2="18" />
                      <line x1="6" y1="6" x2="18" y2="18" />
                    </svg>
                  </button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin/students">
                  <input type="hidden" name="action" value="add" />
                  <div class="modal-body space-y-4">
                    <div class="grid grid-cols-2 gap-3">
                      <div class="col-span-2 sm:col-span-1">
                        <label class="form-label" for="add-studentId">ခုံနံပါတ် (Roll No.) <span
                            class="text-red-500">*</span></label>
                        <input type="text" id="add-studentId" name="studentId" placeholder="e.g. ST001" required />
                      </div>
                      <div class="col-span-2 sm:col-span-1">
                        <label class="form-label" for="add-gender">လိင် (Gender)</label>
                        <select id="add-gender" name="gender">
                          <option value="">-- ရွေးချယ်ပါ --</option>
                          <option value="Male">ကျား (Male)</option>
                          <option value="Female">မ (Female)</option>
                          <option value="Other">အခြား (Other)</option>
                        </select>
                      </div>
                    </div>
                    <div>
                      <label class="form-label" for="add-name">အမည် အပြည့်အစုံ <span
                          class="text-red-500">*</span></label>
                      <input type="text" id="add-name" name="name" placeholder="ကျောင်းသားအမည်" required />
                    </div>
                    <div>
                      <label class="form-label" for="add-email">အီးမေးလ် <span class="text-red-500">*</span></label>
                      <input type="email" id="add-email" name="email" placeholder="student@example.com" required />
                    </div>
                    <div>
                      <label class="form-label" for="add-phone">ဖုန်းနံပါတ်</label>
                      <input type="text" id="add-phone" name="phone" placeholder="09-XXXXXXXXX" />
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
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

          <!-- Edit Student Modal -->
          <div class="modal fade" id="editStudentModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 30rem;">
              <div class="modal-content">
                <div class="modal-accent" style="background: linear-gradient(90deg, rgb(99 102 241), rgb(168 85 247));">
                </div>
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
                    <h5 class="modal-title">ကျောင်းသားအချက်အလက် ပြင်ဆင်ရန်</h5>
                    <p class="modal-subtitle">Edit Student Information</p>
                  </div>
                  <button type="button" class="modal-close-btn" data-bs-dismiss="modal" aria-label="Close">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2.5">
                      <line x1="18" y1="6" x2="6" y2="18" />
                      <line x1="6" y1="6" x2="18" y2="18" />
                    </svg>
                  </button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin/students">
                  <input type="hidden" name="action" value="update" />
                  <input type="hidden" name="id" id="edit-id" />
                  <div class="modal-body space-y-4">
                    <div class="grid grid-cols-2 gap-3">
                      <div class="col-span-2 sm:col-span-1">
                        <label class="form-label" for="edit-studentId">ခုံနံပါတ် <span
                            class="text-red-500">*</span></label>
                        <input type="text" id="edit-studentId" name="studentId" required />
                      </div>
                      <div class="col-span-2 sm:col-span-1">
                        <label class="form-label" for="edit-gender">လိင်</label>
                        <select id="edit-gender" name="gender">
                          <option value="">-- ရွေးချယ်ပါ --</option>
                          <option value="Male">ကျား (Male)</option>
                          <option value="Female">မ (Female)</option>
                          <option value="Other">အခြား (Other)</option>
                        </select>
                      </div>
                    </div>
                    <div>
                      <label class="form-label" for="edit-name">အမည် <span class="text-red-500">*</span></label>
                      <input type="text" id="edit-name" name="name" required />
                    </div>
                    <div>
                      <label class="form-label" for="edit-email">အီးမေးလ် <span class="text-red-500">*</span></label>
                      <input type="email" id="edit-email" name="email" required />
                    </div>
                    <div>
                      <label class="form-label" for="edit-phone">ဖုန်းနံပါတ်</label>
                      <input type="text" id="edit-phone" name="phone" />
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မပြင်ဆင်ပါ</button>
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

          <!-- Delete Student Modal -->
          <div class="modal fade" id="deleteStudentModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 22rem;">
              <div class="modal-content">
                <div class="modal-accent modal-accent-red"></div>
                <form method="post" action="${pageContext.request.contextPath}/admin/students">
                  <input type="hidden" name="action" value="delete" />
                  <input type="hidden" name="id" id="delete-student-id" />
                  <div class="modal-body text-center" style="padding: 2rem 1.5rem 1.25rem;">
                    <div
                      class="w-14 h-14 rounded-full bg-red-50 border-2 border-red-100 flex items-center justify-center mx-auto mb-4">
                      <svg class="w-7 h-7 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2">
                        <polyline points="3 6 5 6 21 6" />
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2" />
                      </svg>
                    </div>
                    <h5 class="text-base font-bold text-slate-900 mb-1.5">ဖျက်ရန် အတည်ပြုပါ</h5>
                    <p class="text-xs text-slate-500 leading-relaxed">
                      ကျောင်းသား <strong id="delete-student-name" class="text-red-600 font-semibold"></strong> ကို
                      ဖျက်ရန် သေချာပါသလား?<br />
                      <span class="text-slate-400 mt-1 block">ဤလုပ်ဆောင်ချက်ကို ပြန်လည်ပြင်ဆင်၍ မရနိုင်ပါ။</span>
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

          <!-- View Student Modal -->
          <div class="modal fade" id="viewStudentModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
              <div class="modal-content">
                <div class="modal-accent" style="background: linear-gradient(90deg, rgb(5 150 105), rgb(16 185 129));">
                </div>
                <div class="modal-header-custom">
                  <div class="modal-header-icon modal-header-icon-green">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2.2">
                      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                      <circle cx="12" cy="7" r="4" />
                    </svg>
                  </div>
                  <div class="modal-title-group">
                    <h5 class="modal-title">ကျောင်းသား အချက်အလက်</h5>
                    <p class="modal-subtitle">Student Profile Details</p>
                  </div>
                  <button type="button" class="modal-close-btn" data-bs-dismiss="modal" aria-label="Close">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      stroke-width="2.5">
                      <line x1="18" y1="6" x2="6" y2="18" />
                      <line x1="6" y1="6" x2="18" y2="18" />
                    </svg>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="space-y-0 text-xs rounded-lg border border-slate-200 overflow-hidden">
                    <div class="flex items-center justify-between px-4 py-2.5 bg-slate-50 border-b border-slate-200">
                      <span class="text-slate-500 font-medium">ခုံနံပါတ်</span>
                      <strong id="view-studentId" class="text-blue-600 font-mono font-bold"></strong>
                    </div>
                    <div class="flex items-center justify-between px-4 py-2.5 bg-white border-b border-slate-200">
                      <span class="text-slate-500 font-medium">အမည်</span>
                      <strong id="view-name" class="text-slate-900 font-semibold"></strong>
                    </div>
                    <div class="flex items-center justify-between px-4 py-2.5 bg-slate-50 border-b border-slate-200">
                      <span class="text-slate-500 font-medium">အီးမေးလ်</span>
                      <span id="view-email" class="text-slate-700"></span>
                    </div>
                    <div class="flex items-center justify-between px-4 py-2.5 bg-white border-b border-slate-200">
                      <span class="text-slate-500 font-medium">ဖုန်းနံပါတ်</span>
                      <span id="view-phone" class="text-slate-700 font-mono"></span>
                    </div>
                    <div class="flex items-center justify-between px-4 py-2.5 bg-slate-50 border-b border-slate-200">
                      <span class="text-slate-500 font-medium">လိင်</span>
                      <span id="view-gender"
                        class="px-2 py-0.5 rounded-full bg-white border border-slate-200 text-slate-700 font-semibold"></span>
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

          <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
          <script>
            document.getElementById('deleteStudentModal').addEventListener('show.bs.modal', function (event) {
              const btn = event.relatedTarget;
              if (!btn) return;
              const d = btn.dataset;
              document.getElementById('delete-student-id').value = d.id || '';
              document.getElementById('delete-student-name').textContent = d.name || '';
            });

            document.getElementById('editStudentModal').addEventListener('show.bs.modal', function (event) {
              const btn = event.relatedTarget;
              if (!btn) return;
              const d = btn.dataset;
              document.getElementById('edit-id').value = d.id || '';
              document.getElementById('edit-studentId').value = d.studentid || '';
              document.getElementById('edit-name').value = d.name || '';
              document.getElementById('edit-email').value = d.email || '';
              document.getElementById('edit-phone').value = d.phone || '';
              const genderSel = document.getElementById('edit-gender');
              for (let opt of genderSel.options) {
                opt.selected = (opt.value === d.gender);
              }
            });

            document.getElementById('viewStudentModal').addEventListener('show.bs.modal', function (event) {
              const btn = event.relatedTarget;
              if (!btn) return;
              const d = btn.dataset;
              document.getElementById('view-studentId').textContent = d.studentid || '-';
              document.getElementById('view-name').textContent = d.name || '-';
              document.getElementById('view-email').textContent = d.email || '-';
              document.getElementById('view-phone').textContent = d.phone || '-';
              document.getElementById('view-gender').textContent = d.gender || '-';
              document.getElementById('view-created').textContent = d.created || '-';
            });
          </script>
        </body>

        </html>