<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "Student Management");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
  java.util.List<common.Student> students = (java.util.List<common.Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Students — RERMS Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body>
<div class="app-layout">
  <div class="admin-body-row">
    <%@ include file="sidebar.jsp" %>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <main class="main-content">
      <%@ include file="header.jsp" %>
      <div class="page-body">

      <!-- Alerts -->
      <% if (flashSuccess != null) { %>
        <div class="alert-custom alert-success-custom flash-alert"><%= flashSuccess %></div>
      <% } %>
      <% if (flashError != null) { %>
        <div class="alert-custom alert-danger-custom flash-alert"><%= flashError %></div>
      <% } %>
      <% if (request.getAttribute("rmiError") != null) { %>
        <div class="alert-custom alert-warning-custom flash-alert"><%= request.getAttribute("rmiError") %></div>
      <% } %>
      <!-- Breadcrumb Nav & History Controls Row -->
      <div class="d-flex align-items-center justify-content-between mb-3">
        <div class="d-flex align-items-center gap-2" style="font-size: 0.8125rem; color: #64748b;">
          <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #64748b; text-decoration: none;">ဒက်ရှ်ဘုတ်</a>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          <span style="color: #0f172a; font-weight: 500;">ဝင်ခွင့်ရကျောင်းသားများ</span>
        </div>

        <div class="d-flex align-items-center gap-1">
          <button onclick="history.back()" aria-label="Go back" type="button" class="btn-action-icon" style="width: 1.65rem; height: 1.65rem;">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
          </button>
          <button onclick="history.forward()" aria-label="Go forward" type="button" class="btn-action-icon" style="width: 1.65rem; height: 1.65rem;">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
          </button>
        </div>
      </div>
      <div class="card-container p-3 mb-3">
        <form method="get" action="${pageContext.request.contextPath}/admin/students" class="d-flex flex-column gap-2">
          <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">
            <!-- Left: Search Box & Subtext -->
            <div class="d-flex flex-column" style="flex: 1; min-width: 280px; max-width: 480px;">
              <div class="search-input-wrap" style="max-width: 100%;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
                <input type="text" name="search" placeholder="ကျောင်းသားကို ရှာဖွေရန်"
                       value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"/>
              </div>
              <span class="toolbar-subtext">
                ခုံနံပါတ် (Roll Number)၊ အမည်၊ အီးမေးလ် စသည်တို့ဖြင့် ရှာဖွေနိုင်ပါသည်။
              </span>
            </div>

            <!-- Right: Filters & Action Buttons -->
            <div class="d-flex align-items-center gap-2 flex-wrap ms-auto">


              <!-- Add Record Button -->
              <button type="button" class="btn-add-record" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                  <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                <span>မှတ်တမ်းတင်ရန်</span>
              </button>
            </div>
          </div>
        </form>
      </div>

      <!-- Students Data Table Card -->
      <div class="card-container">
        <div class="table-wrapper">
          <table class="data-table">
            <thead>
              <tr>
                <th style="width: 50px;">စဉ်</th>
                <th>ခုံနံပါတ်</th>
                <th>ကျောင်းသား အမည်</th>
                <th>အီးမေးလ်</th>
                <th>ဖုန်းနံပါတ်</th>
                <th style="text-align: center;">လိင်</th>
                <th>ထည့်သွင်းသည့်ရက်စွဲ</th>
                <th style="text-align: center;">လုပ်ဆောင်ချက်</th>
              </tr>
            </thead>
            <tbody>
              <% if (students != null && !students.isEmpty()) {
                 int idx = 1;
                 for (common.Student s : students) {
                   String phoneStr = s.getPhone() != null && !s.getPhone().isBlank() ? s.getPhone() : "-";
                   String genderStr = s.getGender() != null && !s.getGender().isBlank() ? s.getGender() : "-";
                   String createdStr = s.getCreatedAt() != null ? s.getCreatedAt().toString().replace("T", " ") : "-";
              %>
              <tr>
                <td style="color: #64748b; font-weight: 500;"><%= idx++ %></td>
                <td><span style="font-weight: 700; color: #2563eb; font-family: monospace;"><%= s.getStudentId() %></span></td>
                <td><span style="font-weight: 700; color: #0f172a;"><%= s.getName() %></span></td>
                <td style="color: #334155;"><%= s.getEmail() %></td>
                <td style="color: #475569; font-size: 0.82rem;"><%= phoneStr %></td>
                <td style="text-align: center;"><span class="badge badge-secondary"><%= genderStr %></span></td>
                <td style="color: #64748b; font-size: 0.8125rem;"><%= createdStr %></td>
                <td style="text-align: center;">
                  <div class="action-buttons-group justify-content-center">
                    <!-- Edit Button -->
                    <button type="button" class="btn-action-icon edit" data-bs-toggle="modal"
                            data-bs-target="#editStudentModal"
                            data-id="<%= s.getId() %>"
                            data-studentid="<%= s.getStudentId() %>"
                            data-name="<%= s.getName() %>"
                            data-email="<%= s.getEmail() %>"
                            data-phone="<%= s.getPhone() != null ? s.getPhone() : "" %>"
                            data-gender="<%= s.getGender() != null ? s.getGender() : "" %>"
                            title="ပြင်ဆင်ရန်">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                      </svg>
                    </button>

                    <!-- Delete Button -->
                    <button type="button" class="btn-action-icon delete" data-bs-toggle="modal" data-bs-target="#deleteStudentModal"
                            data-id="<%= s.getId() %>" data-name="<%= s.getName() %>" title="ဖျက်ရန်">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                      </svg>
                    </button>

                    <!-- View Details Button -->
                    <button type="button" class="btn-action-icon detail" data-bs-toggle="modal" data-bs-target="#viewStudentModal"
                            data-studentid="<%= s.getStudentId() %>"
                            data-name="<%= s.getName() %>"
                            data-email="<%= s.getEmail() %>"
                            data-phone="<%= phoneStr %>"
                            data-gender="<%= genderStr %>"
                            data-created="<%= createdStr %>"
                            title="အသေးစိတ်ကြည့်ရန်">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>
              <% } } else { %>
              <tr>
                <td colspan="8" style="text-align: center; padding: 2.5rem 1rem; color: var(--muted-foreground);">
                  <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-2 opacity-50">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                  </svg>
                  <div style="font-weight: 600; color: var(--foreground);">ကျောင်းသား အချက်အလက် မရှိသေးပါ</div>
                  <div style="font-size: 0.8rem;">ကျောင်းသားအသစ် ထည့်သွင်းပါ သို့မဟုတ် ရှာဖွေမှုစကားလုံး ပြောင်းလဲပါ။</div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>

        <!-- Pagination Footer Bar -->
        <div class="pagination-footer-bar">
          <div>
            Showing <%= students != null && !students.isEmpty() ? 1 : 0 %> to <%= students != null ? students.size() : 0 %> of <%= students != null ? students.size() : 0 %> Entries
          </div>
          <div class="pagination-controls-wrap">
            <select style="padding: 0.25rem 0.5rem; font-size: 0.78rem; border-radius: 0.375rem;">
              <option selected>5</option>
              <option>10</option>
              <option>25</option>
            </select>
            <span>Page 1 of 1</span>
            <div class="pagination-btn-group">
              <button type="button" class="btn-pagination-step" disabled>&laquo;</button>
              <button type="button" class="btn-pagination-step" disabled>&lt;</button>
              <button type="button" class="btn-pagination-step" disabled>&gt;</button>
              <button type="button" class="btn-pagination-step" disabled>&raquo;</button>
            </div>
          </div>
        </div>
      </div>

    </div>

  </main>
  </div>
</div>

<!-- ── Add Student Modal ─────────────────────────────── -->
<div class="modal fade" id="addStudentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 32rem;">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom: 1px solid #e2e8f0; padding: 1rem 1.25rem;">
        <h5 class="modal-title" style="font-size: 1rem; font-weight: 700; color: #0f172a;">ကျောင်းသားအသစ် ထည့်သွင်းရန်</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/students" data-validate novalidate>
        <input type="hidden" name="action" value="add"/>
        <div class="modal-body" style="padding: 1.25rem;">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label font-bold" for="add-studentId">တက္ကသိုလ်ဝင်တန်း ခုံနံပါတ် (Roll Number) *</label>
              <input type="text" id="add-studentId" name="studentId" placeholder="e.g. ST001" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="add-name">အမည် အပြည့်အစုံ (Full Name) *</label>
              <input type="text" id="add-name" name="name" placeholder="ကျောင်းသားအမည်" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="add-email">အီးမေးလ် (Email) *</label>
              <input type="email" id="add-email" name="email" placeholder="student@example.com" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="add-phone">ဖုန်းနံပါတ် (Phone Number)</label>
              <input type="text" id="add-phone" name="phone" placeholder="09-XXXXXXXXX"
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="add-gender">လိင် (Gender)</label>
              <select id="add-gender" name="gender"
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ရွေးချယ်ပါ --</option>
                <option value="Male">ကျား (Male)</option>
                <option value="Female">မ (Female)</option>
                <option value="Other">အခြား (Other)</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top: 1px solid #e2e8f0; padding: 0.875rem 1.25rem; gap: 0.5rem;">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
          <button type="submit" class="btn-primary-custom">+ ထည့်သွင်းမည်</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ── Edit Student Modal ─────────────────────────────── -->
<div class="modal fade" id="editStudentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 32rem;">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom: 1px solid #e2e8f0; padding: 1rem 1.25rem;">
        <h5 class="modal-title" style="font-size: 1rem; font-weight: 700; color: #0f172a;">ကျောင်းသားအချက်အလက် ပြင်ဆင်ရန်</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/students" data-validate novalidate>
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="edit-id"/>
        <div class="modal-body" style="padding: 1.25rem;">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label font-bold" for="edit-studentId">တက္ကသိုလ်ဝင်တန်း ခုံနံပါတ် *</label>
              <input type="text" id="edit-studentId" name="studentId" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="edit-name">အမည် အပြည့်အစုံ *</label>
              <input type="text" id="edit-name" name="name" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="edit-email">အီးမေးလ် *</label>
              <input type="email" id="edit-email" name="email" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="edit-phone">ဖုန်းနံပါတ်</label>
              <input type="text" id="edit-phone" name="phone"
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="edit-gender">လိင်</label>
              <select id="edit-gender" name="gender"
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ရွေးချယ်ပါ --</option>
                <option value="Male">ကျား (Male)</option>
                <option value="Female">မ (Female)</option>
                <option value="Other">အခြား (Other)</option>
              </select>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top: 1px solid #e2e8f0; padding: 0.875rem 1.25rem; gap: 0.5rem;">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မပြင်ဆင်ပါ</button>
          <button type="submit" class="btn-primary-custom">ပြင်ဆင်မည်</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ── Delete Student Modal ─────────────────────────── -->
<div class="modal fade" id="deleteStudentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/students">
        <input type="hidden" name="action" value="delete"/>
        <input type="hidden" name="id" id="delete-student-id"/>
        <div class="modal-body d-flex flex-column align-items-center gap-3 pt-3">
          <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
            </svg>
          </div>
          <div class="d-flex flex-column gap-1">
            <h5 style="font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0;">ကျောင်းသား ပယ်ဖျက်ရန် အတည်ပြုပါ</h5>
            <p style="font-size: 0.85rem; color: #64748b; margin: 0;">
              ကျောင်းသား <strong id="delete-student-name" style="color: #dc2626;"></strong> ကို ပယ်ဖျက်ရန် သေချာပါသလား။ ဤလုပ်ဆောင်ချက်ကို ပြန်လည်ပြင်ဆင်၍ မရနိုင်ပါ။
            </p>
          </div>
          <div class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
            <button type="button" class="btn-outline-custom" data-bs-dismiss="modal" style="flex: 1; padding: 0.6rem;">မဖျက်ပါ</button>
            <button type="submit" class="btn-primary-custom" style="flex: 1; padding: 0.6rem; background-color: #dc2626; border-color: #dc2626;">ဖျက်မည်</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>
<div class="modal fade" id="viewStudentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 30rem;">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom: 1px solid #e2e8f0; padding: 1rem 1.25rem;">
        <h5 class="modal-title" style="font-size: 1rem; font-weight: 700; color: #0f172a;">ကျောင်းသား အချက်အလက် အသေးစိတ်</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" style="padding: 1.25rem;">
        <div class="d-flex flex-column gap-3">
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">ခုံနံပါတ် (Roll Number):</span>
            <strong id="view-studentId" style="color: #2563eb; font-family: monospace;"></strong>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">အမည် (Name):</span>
            <strong id="view-name" style="color: #0f172a;"></strong>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">အီးမေးလ် (Email):</span>
            <span id="view-email" style="color: #334155;"></span>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">ဖုန်းနံပါတ် (Phone):</span>
            <span id="view-phone" style="color: #334155;"></span>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">လိင် (Gender):</span>
            <span id="view-gender" class="badge badge-info"></span>
          </div>
          <div class="d-flex justify-content-between">
            <span style="color: #64748b; font-size: 0.875rem;">ထည့်သွင်းသည့်ရက်စွဲ (Created At):</span>
            <span id="view-created" style="color: #64748b; font-size: 0.8125rem;"></span>
          </div>
        </div>
      </div>
      <div class="modal-footer" style="border-top: 1px solid #e2e8f0; padding: 0.75rem 1.25rem;">
        <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">ပိတ်မည်</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
(function(){
  var COLLAPSED_KEY = 'sidebarCollapsed';
  var btn = document.getElementById('sidebarToggleBtn');
  var overlay = document.getElementById('sidebarOverlay');
  if (localStorage.getItem(COLLAPSED_KEY) === '1') document.body.classList.add('sidebar-collapsed');
  if (btn) {
    btn.addEventListener('click', function(){
      if (window.innerWidth <= 768) {
        document.body.classList.toggle('sidebar-open');
      } else {
        var collapsed = document.body.classList.toggle('sidebar-collapsed');
        localStorage.setItem(COLLAPSED_KEY, collapsed ? '1' : '0');
      }
    });
  }
  if (overlay) overlay.addEventListener('click', function(){ document.body.classList.remove('sidebar-open'); });
})();
</script>
<script>
document.getElementById('deleteStudentModal').addEventListener('show.bs.modal', function(event) {
  const btn = event.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('delete-student-id').value = d.id || '';
  document.getElementById('delete-student-name').textContent = d.name || '';
});

document.getElementById('editStudentModal').addEventListener('show.bs.modal', function(event) {
  const btn = event.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('edit-id').value         = d.id || '';
  document.getElementById('edit-studentId').value  = d.studentid || '';
  document.getElementById('edit-name').value        = d.name || '';
  document.getElementById('edit-email').value       = d.email || '';
  document.getElementById('edit-phone').value       = d.phone || '';
  const genderSel = document.getElementById('edit-gender');
  for (let opt of genderSel.options) {
    opt.selected = (opt.value === d.gender);
  }
});

document.getElementById('viewStudentModal').addEventListener('show.bs.modal', function(event) {
  const btn = event.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('view-studentId').textContent = d.studentid || '-';
  document.getElementById('view-name').textContent      = d.name || '-';
  document.getElementById('view-email').textContent     = d.email || '-';
  document.getElementById('view-phone').textContent     = d.phone || '-';
  document.getElementById('view-gender').textContent    = d.gender || '-';
  document.getElementById('view-created').textContent   = d.created || '-';
});
</script>
</body>
</html>
