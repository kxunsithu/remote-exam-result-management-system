<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "Subject Management");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
  java.util.List<common.Subject> subjects = (java.util.List<common.Subject>) request.getAttribute("subjects");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Subjects — RERMS Admin</title>
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
          <span style="color: #0f172a; font-weight: 500;">ဘာသာရပ်များ</span>
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
        <form method="get" action="${pageContext.request.contextPath}/admin/subjects" class="d-flex flex-column gap-2">
          <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">
            <!-- Left: Search Box & Subtext -->
            <div class="d-flex flex-column" style="flex: 1; min-width: 280px; max-width: 480px;">
              <div class="search-input-wrap" style="max-width: 100%;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
                <input type="text" name="search" placeholder="ဘာသာရပ် ရှာဖွေရန်"
                       value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"/>
              </div>
              <span class="toolbar-subtext">
                ဘာသာရပ်သင်္ကေတ၊ အမည် သို့မဟုတ် ဌာနအလိုက် ရှာဖွေနိုင်ပါသည်။
              </span>
            </div>

            <!-- Right: Action Buttons -->
            <div class="d-flex align-items-center gap-2 flex-wrap ms-auto">

              <button type="button" class="btn-add-record" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                  <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                <span>မှတ်တမ်းတင်ရန်</span>
              </button>
            </div>
          </div>
        </form>
      </div>

      <!-- Subjects Data Table Card -->
      <div class="card-container">
        <div class="table-wrapper">
          <table class="data-table">
            <thead>
              <tr>
                <th style="width: 50px;">စဉ်</th>
                <th>ဘာသာရပ် သင်္ကေတ</th>
                <th>ဘာသာရပ် အမည်</th>
                <th>ခရက်ဒစ် (Credit)</th>
                <th>ဌာန</th>
                <th>Semester</th>
                <th style="text-align: center;">လုပ်ဆောင်ချက်</th>
              </tr>
            </thead>
            <tbody>
              <% if (subjects != null && !subjects.isEmpty()) {
                 int idx = 1;
                 for (common.Subject s : subjects) { %>
              <tr>
                <td style="color: #64748b; font-weight: 500;"><%= idx++ %></td>
                <td><span style="font-weight: 700; color: #2563eb; font-family: monospace;"><%= s.getSubjectCode() %></span></td>
                <td><span style="font-weight: 600; color: #0f172a;"><%= s.getSubjectName() %></span></td>
                <td><span class="badge badge-info"><%= s.getCredit() %> Credits</span></td>
                <td style="font-size: 0.82rem; color: #64748b;"><%= s.getDepartment() %></td>
                <td><span class="badge badge-warning">Sem <%= s.getSemester() %></span></td>
                <td style="text-align: center;">
                  <div class="action-buttons-group justify-content-center">
                    <button type="button" class="btn-action-icon edit" data-bs-toggle="modal"
                            data-bs-target="#editSubjectModal"
                            data-id="<%= s.getId() %>"
                            data-subjectcode="<%= s.getSubjectCode() %>"
                            data-subjectname="<%= s.getSubjectName() %>"
                            data-credit="<%= s.getCredit() %>"
                            data-department="<%= s.getDepartment() %>"
                            data-semester="<%= s.getSemester() %>"
                            title="ပြင်ဆင်ရန်">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                      </svg>
                    </button>

                    <button type="button" class="btn-action-icon delete" data-bs-toggle="modal" data-bs-target="#deleteSubjectModal"
                            data-id="<%= s.getId() %>" data-name="<%= s.getSubjectName() %>" title="ဖျက်ရန်">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                      </svg>
                    </button>

                    <button type="button" class="btn-action-icon detail" data-bs-toggle="modal" data-bs-target="#viewSubjectModal"
                            data-code="<%= s.getSubjectCode() %>"
                            data-name="<%= s.getSubjectName() %>"
                            data-credit="<%= s.getCredit() %>"
                            data-department="<%= s.getDepartment() %>"
                            data-semester="<%= s.getSemester() %>"
                            data-created="<%= s.getCreatedAt() != null ? s.getCreatedAt().toString().replace("T", " ") : "-" %>"
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
                <td colspan="7" style="text-align: center; padding: 2.5rem 1rem; color: var(--muted-foreground);">
                  <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-2 opacity-50">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                  </svg>
                  <div style="font-weight: 600; color: var(--foreground);">ဘာသာရပ် မရှိသေးပါ</div>
                  <div style="font-size: 0.8rem;">ဘာသာရပ်အသစ် ထည့်သွင်းပါ။</div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>

        <!-- Pagination Footer Bar -->
        <div class="pagination-footer-bar">
          <div>
            Showing <%= subjects != null && !subjects.isEmpty() ? 1 : 0 %> to <%= subjects != null ? subjects.size() : 0 %> of <%= subjects != null ? subjects.size() : 0 %> Entries
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

<!-- ── Add Subject Modal ─────────────────────────────── -->
<div class="modal fade" id="addSubjectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 32rem;">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom: 1px solid #e2e8f0; padding: 1rem 1.25rem;">
        <h5 class="modal-title" style="font-size: 1rem; font-weight: 700; color: #0f172a;">ဘာသာရပ်အသစ် ထည့်သွင်းရန်</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/subjects" data-validate novalidate>
        <input type="hidden" name="action" value="add"/>
        <div class="modal-body" style="padding: 1.25rem;">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label font-bold" for="add-subjectCode">ဘာသာရပ် သင်္ကေတ (Subject Code) *</label>
              <input type="text" id="add-subjectCode" name="subjectCode" placeholder="e.g. CS101" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="add-subjectName">ဘာသာရပ် အမည် (Subject Name) *</label>
              <input type="text" id="add-subjectName" name="subjectName" placeholder="e.g. Java Programming" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="add-department">ဌာန (Department) *</label>
              <select id="add-department" name="department" required
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ဌာန ရွေးချယ်ပါ --</option>
                <option value="Computer Science">Computer Science</option>
                <option value="Information Technology">Information Technology</option>
                <option value="Information Systems">Information Systems</option>
                <option value="Computer Technology">Computer Technology</option>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label font-bold" for="add-credit">ခရက်ဒစ် (Credit) *</label>
              <select id="add-credit" name="credit" required
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ရွေးချယ်ပါ --</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
              </select>
            </div>
            <div class="col-6">
              <label class="form-label font-bold" for="add-semester">Semester *</label>
              <select id="add-semester" name="semester" required
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ရွေးချယ်ပါ --</option>
                <% for (int i = 1; i <= 8; i++) { %>
                  <option value="<%= i %>">Sem <%= i %></option>
                <% } %>
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

<!-- ── Edit Subject Modal ─────────────────────────────── -->
<div class="modal fade" id="editSubjectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom: 1px solid #e2e8f0; padding: 1rem 1.25rem;">
        <h5 class="modal-title" style="font-size: 1rem; font-weight: 700; color: #0f172a;">ဘာသာရပ်အချက်အလက် ပြင်ဆင်ရန်</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/subjects" data-validate novalidate>
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="edit-subj-id"/>
        <div class="modal-body" style="padding: 1.25rem;">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label font-bold" for="edit-subjectCode">ဘာသာရပ် သင်္ကေတ *</label>
              <input type="text" name="subjectCode" id="edit-subjectCode" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-md-6">
              <label class="form-label font-bold" for="edit-subjectName">ဘာသာရပ် အမည် *</label>
              <input type="text" name="subjectName" id="edit-subjectName" required
                     style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
            </div>
            <div class="col-12">
              <label class="form-label font-bold" for="edit-subj-department">ဌာန (Department) *</label>
              <select name="department" id="edit-subj-department" required
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ဌာန ရွေးချယ်ပါ --</option>
                <option value="Computer Science">Computer Science</option>
                <option value="Information Technology">Information Technology</option>
                <option value="Information Systems">Information Systems</option>
                <option value="Computer Technology">Computer Technology</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label font-bold" for="edit-credit">ခရက်ဒစ် (Credit) *</label>
              <select name="credit" id="edit-credit" required
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ရွေးချယ်ပါ --</option>
                <% for (int i = 1; i <= 6; i++) { %>
                  <option value="<%= i %>"><%= i %></option>
                <% } %>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label font-bold" for="edit-semester">Semester *</label>
              <select name="semester" id="edit-semester" required
                      style="width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
                <option value="">-- ရွေးချယ်ပါ --</option>
                <% for (int i = 1; i <= 8; i++) { %>
                  <option value="<%= i %>">Sem <%= i %></option>
                <% } %>
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

<!-- ── Delete Subject Modal ─────────────────────────── -->
<div class="modal fade" id="deleteSubjectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/subjects">
        <input type="hidden" name="action" value="delete"/>
        <input type="hidden" name="id" id="delete-subject-id"/>
        <div class="modal-body d-flex flex-column align-items-center gap-3 pt-3">
          <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
            </svg>
          </div>
          <div class="d-flex flex-column gap-1">
            <h5 style="font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0;">ဘာသာရပ် ပယ်ဖျက်ရန် အတည်ပြုပါ</h5>
            <p style="font-size: 0.85rem; color: #64748b; margin: 0;">
              ဘာသာရပ် <strong id="delete-subject-name" style="color: #dc2626;"></strong> ကို ပယ်ဖျက်ရန် သေချာပါသလား။ ဤလုပ်ဆောင်ချက်ကို ပြန်လည်ပြင်ဆင်၍ မရနိုင်ပါ။
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
<div class="modal fade" id="viewSubjectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 30rem;">
    <div class="modal-content">
      <div class="modal-header" style="border-bottom: 1px solid #e2e8f0; padding: 1rem 1.25rem;">
        <h5 class="modal-title" style="font-size: 1rem; font-weight: 700; color: #0f172a;">ဘာသာရပ် အချက်အလက် အသေးစိတ်</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" style="padding: 1.25rem;">
        <div class="d-flex flex-column gap-3">
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">ဘာသာရပ် သင်္ကေတ (Code):</span>
            <strong id="view-subj-code" style="color: #2563eb; font-family: monospace;"></strong>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">ဘာသာရပ် အမည် (Name):</span>
            <strong id="view-subj-name" style="color: #0f172a;"></strong>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">ဌာန (Department):</span>
            <span id="view-subj-dept" style="color: #334155;"></span>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">ခရက်ဒစ် (Credit):</span>
            <span id="view-subj-credit" class="badge badge-info"></span>
          </div>
          <div class="d-flex justify-content-between border-bottom pb-2">
            <span style="color: #64748b; font-size: 0.875rem;">Semester:</span>
            <span id="view-subj-semester" class="badge badge-warning"></span>
          </div>
          <div class="d-flex justify-content-between">
            <span style="color: #64748b; font-size: 0.875rem;">ထည့်သွင်းသည့်ရက်စွဲ (Created At):</span>
            <span id="view-subj-created" style="color: #64748b; font-size: 0.8125rem;"></span>
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
document.getElementById('deleteSubjectModal').addEventListener('show.bs.modal', function(e) {
  const btn = e.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('delete-subject-id').value = d.id || '';
  document.getElementById('delete-subject-name').textContent = d.name || '';
});

document.getElementById('editSubjectModal').addEventListener('show.bs.modal', function(e) {
  const btn = e.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('edit-subj-id').value        = d.id || '';
  document.getElementById('edit-subjectCode').value    = d.subjectcode || '';
  document.getElementById('edit-subjectName').value    = d.subjectname || '';
  document.getElementById('edit-credit').value         = d.credit || '';
  const deptSel = document.getElementById('edit-subj-department');
  for (let opt of deptSel.options) {
    opt.selected = (opt.value === d.department);
  }
  document.getElementById('edit-semester').value       = d.semester || '';
});

document.getElementById('viewSubjectModal').addEventListener('show.bs.modal', function(e) {
  const btn = e.relatedTarget;
  if (!btn) return;
  const d = btn.dataset;
  document.getElementById('view-subj-code').textContent     = d.code || '-';
  document.getElementById('view-subj-name').textContent     = d.name || '-';
  document.getElementById('view-subj-dept').textContent     = d.department || '-';
  document.getElementById('view-subj-credit').textContent   = (d.credit || '-') + ' Credits';
  document.getElementById('view-subj-semester').textContent = 'Sem ' + (d.semester || '-');
  document.getElementById('view-subj-created').textContent  = d.created || '-';
});
</script>
</body>
</html>
