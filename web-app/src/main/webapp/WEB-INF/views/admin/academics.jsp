<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  request.setAttribute("pageTitle", "ပညာသင်နှစ်များ");
  String flashSuccess = (String) session.getAttribute("flashSuccess");
  String flashError   = (String) session.getAttribute("flashError");
  session.removeAttribute("flashSuccess");
  session.removeAttribute("flashError");
  java.util.List<common.AcademicYear> years = (java.util.List<common.AcademicYear>) request.getAttribute("years");
  java.util.Map<Integer, java.util.List<common.Semester>> semsByYear =
      (java.util.Map<Integer, java.util.List<common.Semester>>) request.getAttribute("semsByYear");
  java.util.Map<Integer, java.util.List<common.Subject>> subjectsBySemester =
      (java.util.Map<Integer, java.util.List<common.Subject>>) request.getAttribute("subjectsBySemester");
  java.util.List<common.Subject> unassignedSubjects =
      (java.util.List<common.Subject>) request.getAttribute("unassignedSubjects");
  java.util.List<common.Subject> allSubjects =
      (java.util.List<common.Subject>) request.getAttribute("allSubjects");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ပညာသင်နှစ်များ — RERMS Admin</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
  <style>
    .year-card { margin-bottom: 1rem; overflow: hidden; }
    .year-header {
      display: flex; align-items: center; gap: 0.6rem;
      padding: 0.75rem 1rem;
      background: #1e40af; color: #fff;
      font-weight: 700; font-size: 0.95rem;
      cursor: pointer; user-select: none;
      border: none; width: 100%; text-align: left;
      transition: opacity 0.15s;
      border-radius: 0; /* override card-container radius for top */
    }
    .year-header:hover { opacity: 0.92; }
    .year-badge {
      background: rgba(255,255,255,0.18); border-radius: 999px;
      padding: 0.1rem 0.65rem; font-size: 0.78rem; margin-left: auto;
    }
    .year-actions { display: flex; gap: 0.25rem; margin-left: 0.35rem; flex-shrink: 0; }
    .year-body { border: 1px solid #e2e8f0; border-top: none; border-radius: 0 0 0.5rem 0.5rem; overflow: hidden; }
    .sem-row {
      display: flex; align-items: center; gap: 0.75rem;
      padding: 0.65rem 1rem; border-bottom: 1px solid #f1f5f9;
      font-size: 0.855rem;
    }
    .sem-row:last-child { border-bottom: none; }
    .sem-row:hover { background: #f8fafc; }
    .sem-dot { width: 6px; height: 6px; border-radius: 50%; background: #2563eb; display: inline-block; flex-shrink: 0; }
    .sem-block { border-bottom: 1px solid #f1f5f9; }
    .sem-block:last-of-type { border-bottom: none; }
    .sem-block .sem-row { border-bottom: none; }
    .sem-subjects {
      display: flex; flex-wrap: wrap; gap: 0.4rem;
      padding: 0 1rem 0.7rem 1.85rem;
    }
    .subject-chip {
      display: inline-flex; align-items: center; gap: 0.4rem;
      background: #eff6ff; border: 1px solid #dbeafe; color: #1e40af;
      border-radius: 999px; padding: 0.16rem 0.32rem 0.16rem 0.6rem;
      font-size: 0.74rem; font-weight: 600;
    }
    .chip-code { color: #2563eb; font-family: monospace; font-weight: 700; }
    .chip-remove {
      width: 1.05rem; height: 1.05rem; border-radius: 50%;
      border: none; background: #dbeafe; color: #1d4ed8;
      font-size: 0.78rem; line-height: 1; padding: 0; cursor: pointer;
      display: inline-flex; align-items: center; justify-content: center;
    }
    .chip-remove:hover { background: #dc2626; color: #fff; }
    .chevron-icon { transition: transform 0.2s; }
    .collapsed .chevron-icon { transform: rotate(-90deg); }
    .step-hint {
      display: inline-flex; align-items: center; justify-content: center;
      width: 1.15rem; height: 1.15rem; border-radius: 50%;
      background: #dbeafe; color: #1d4ed8;
      font-size: 0.68rem; font-weight: 800; flex-shrink: 0;
    }
  </style>
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

      <!-- Breadcrumb -->
      <div class="d-flex align-items-center justify-content-between mb-3">
        <div class="d-flex align-items-center gap-2" style="font-size: 0.8125rem; color: #64748b;">
          <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #64748b; text-decoration: none;">ဒက်ရှ်ဘုတ်</a>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          <span style="color: #0f172a; font-weight: 500;">ပညာသင်နှစ်များ</span>
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

      <!-- Workflow hint + Add Year Button -->
      <div class="card-container p-3 mb-3">
        <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">
          <div class="d-flex align-items-center gap-3 flex-wrap" style="font-size: 0.8rem; color: #475569;">
            <a href="${pageContext.request.contextPath}/admin/subjects" class="d-inline-flex align-items-center gap-1" style="color: #2563eb; text-decoration: none; font-weight: 600;">
              <span class="step-hint">၁</span> ဘာသာရပ်များ အရင် create လုပ်ရန်
            </a>
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="2.5"><polyline points="9 18 15 12 9 6"/></svg>
            <span class="d-inline-flex align-items-center gap-1"><span class="step-hint">၂</span> ပညာသင်နှစ် ထည့်ရန်</span>
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="2.5"><polyline points="9 18 15 12 9 6"/></svg>
            <span class="d-inline-flex align-items-center gap-1"><span class="step-hint">၃</span> Semester ထည့်ရန်</span>
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="2.5"><polyline points="9 18 15 12 9 6"/></svg>
            <span class="d-inline-flex align-items-center gap-1"><span class="step-hint">၄</span> ရှိပြီးသား ဘာသာရပ်များ ထည့်ရန်</span>
          </div>
          <button type="button" class="btn-add-record" data-bs-toggle="modal" data-bs-target="#addYearModal">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            <span>ပညာသင်နှစ် ထည့်ရန်</span>
          </button>
        </div>
      </div>

      <!-- Academic Year Accordion -->
      <% if (years == null || years.isEmpty()) { %>
        <div class="card-container" style="text-align: center; padding: 3rem 1rem; color: #64748b;">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="mb-2 opacity-40">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
          <div style="font-weight: 600; margin-top: 0.5rem;">ပညာသင်နှစ် မရှိသေးပါ</div>
          <div style="font-size: 0.8rem;">အဆင့် ၁ - <a href="${pageContext.request.contextPath}/admin/subjects" style="color: #2563eb;">ဘာသာရပ်များ</a> အရင် create လုပ်ပါ၊ ပြီးမှ ပညာသင်နှစ် ထည့်သွင်းပါ။</div>
        </div>
      <% } else {
           int yearIdx = 0;
           for (common.AcademicYear y : years) {
             java.util.List<common.Semester> sems = semsByYear != null ? semsByYear.getOrDefault(y.getId(), java.util.Collections.emptyList()) : java.util.Collections.emptyList();
             String collapseId = "year-collapse-" + yearIdx;
      %>
        <div class="year-section card-container year-card" style="padding:0;" data-year-id="<%= y.getId() %>">
          <div class="year-header" role="button" tabindex="0" data-bs-toggle="collapse" data-bs-target="#<%= collapseId %>" aria-expanded="<%= yearIdx == 0 ? "true" : "false" %>">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
            <span>ပညာသင်နှစ် <%= y.getYearName() %></span>
            <svg class="chevron-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
            <span class="year-badge"><%= sems.size() %> Semester · <%= y.getSubjectCount() %> ဘာသာရပ်</span>
            <!-- Per-year actions inside the header -->
            <span class="year-actions" onclick="event.stopPropagation()">
              <button type="button" class="btn-action-icon edit" data-bs-toggle="modal" data-bs-target="#editYearModal"
                      data-id="<%= y.getId() %>" data-yearname="<%= y.getYearName() %>"
                      title="ပညာသင်နှစ် ပြင်ဆင်ရန်" style="background: rgba(255,255,255,0.2); border-color: rgba(255,255,255,0.3); color:#fff;">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                </svg>
              </button>
              <button type="button" class="btn-action-icon delete" data-bs-toggle="modal" data-bs-target="#deleteYearModal"
                      data-id="<%= y.getId() %>" data-name="ပညာသင်နှစ် <%= y.getYearName() %>"
                      title="ပညာသင်နှစ် ဖျက်ရန်" style="background: rgba(255,255,255,0.2); border-color: rgba(255,255,255,0.3); color:#fff;">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <polyline points="3 6 5 6 21 6"/>
                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                </svg>
              </button>
            </span>
          </div>
          <div class="collapse <%= yearIdx == 0 ? "show" : "" %>" id="<%= collapseId %>">
            <div class="year-body">
              <% for (common.Semester s : sems) {
                   java.util.List<common.Subject> semSubjects = subjectsBySemester != null
                       ? subjectsBySemester.getOrDefault(s.getId(), java.util.Collections.emptyList())
                       : java.util.Collections.emptyList();
              %>
                <div class="sem-block">
                  <div class="sem-row">
                    <span class="sem-dot"></span>
                    <span style="font-weight: 600; color: #0f172a;">Semester <%= s.getSemesterNumber() %></span>
                    <span style="font-size: 0.75rem; color: #94a3b8;"><%= semSubjects.size() %> ဘာသာရပ်</span>
                    <div class="action-buttons-group ms-auto" style="display:flex; gap:0.25rem;">
                      <button type="button" class="btn-action-icon detail" data-bs-toggle="modal" data-bs-target="#attachSubjectsModal"
                              data-semid="<%= s.getId() %>"
                              data-semlabel="Semester <%= s.getSemesterNumber() %> · <%= y.getYearName() %>"
                              title="ရှိပြီးသား ဘာသာရပ်များ ထည့်ရန်"
                              style="background: #dbeafe; border-color: #bfdbfe; color: #1d4ed8;">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                          <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                      </button>
                      <a href="${pageContext.request.contextPath}/admin/subjects?semesterId=<%= s.getId() %>" class="btn-action-icon detail"
                         title="ဤ Semester ရဲ့ ဘာသာရပ်များကို ကြည့်ရန်"
                         style="display:inline-flex; align-items:center; justify-content:center; text-decoration:none;">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                        </svg>
                      </a>
                      <button type="button" class="btn-action-icon edit" data-bs-toggle="modal" data-bs-target="#editSemesterModal"
                              data-id="<%= s.getId() %>" data-yearid="<%= s.getAcademicYearId() %>"
                              data-number="<%= s.getSemesterNumber() %>" title="Semester ပြင်ဆင်ရန်">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                          <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                      </button>
                      <button type="button" class="btn-action-icon delete" data-bs-toggle="modal" data-bs-target="#deleteSemesterModal"
                              data-id="<%= s.getId() %>" data-name="Semester <%= s.getSemesterNumber() %> (<%= y.getYearName() %>)" title="ဖျက်ရန်">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <polyline points="3 6 5 6 21 6"/>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                        </svg>
                      </button>
                    </div>
                  </div>

                  <% if (!semSubjects.isEmpty()) { %>
                  <div class="sem-subjects">
                    <% for (common.Subject sub : semSubjects) { %>
                      <span class="subject-chip">
                        <span class="chip-code"><%= sub.getSubjectCode() %></span>
                        <%= sub.getSubjectName() %>
                        <form method="post" action="${pageContext.request.contextPath}/admin/academics" style="display:inline;"
                              onsubmit="return confirm('<%= sub.getSubjectName().replace("'", "\\'") %> ကို ဤ Semester မှ ဖယ်ရှားမှာသလား?');">
                          <input type="hidden" name="action" value="detachSubject"/>
                          <input type="hidden" name="subjectId" value="<%= sub.getId() %>"/>
                          <button type="submit" class="chip-remove" title="Semester မှ ဖယ်ရှားရန်">&times;</button>
                        </form>
                      </span>
                    <% } %>
                  </div>
                  <% } %>
                </div>
              <% } %>

              <!-- Inline add-semester row -->
              <div class="sem-row" style="background:#f8fafc;">
                <form method="post" action="${pageContext.request.contextPath}/admin/academics" class="d-flex align-items-center gap-2 w-100 flex-wrap" data-validate novalidate>
                  <input type="hidden" name="action" value="addSemester"/>
                  <input type="hidden" name="academicYearId" value="<%= y.getId() %>"/>
                  <span class="step-hint">၂</span>
                  <select name="semesterNumber" required style="padding: 0.4rem 0.6rem; font-size: 0.82rem; border-radius: var(--radius-md); border: 1px solid var(--border); background: #fff;">
                    <option value="">Semester ရွေးပါ —</option>
                    <% for (int i = 1; i <= 8; i++) { %>
                      <option value="<%= i %>">Semester <%= i %></option>
                    <% } %>
                  </select>
                  <button type="submit" class="btn-primary-custom" style="font-size: 0.78rem; padding: 0.4rem 0.85rem; gap: 0.35rem;">
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    Semester ထည့်ရန်
                  </button>
                  <span style="font-size: 0.72rem; color: #94a3b8;">ဘာသာရပ်များ မထည့်မီ Semester ကို အရင်ထည့်ပါ။</span>
                </form>
              </div>
            </div>
          </div>

        </div>
      <%   yearIdx++;
           }
         } %>

      </div>
    </main>
  </div>
</div>

<!-- ── Add Academic Year Modal ─────────────────────── -->
<div class="modal fade" id="addYearModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 28rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/academics" data-validate novalidate>
        <input type="hidden" name="action" value="addYear"/>
        <div class="modal-body d-flex flex-column align-items-stretch gap-3 pt-3 text-start">
          <div class="text-center">
            <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #dbeafe; color: #2563eb; display: inline-flex; align-items: center; justify-content: center;">
              <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
              </svg>
            </div>
            <h5 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin: 0.75rem 0 0.25rem;">ပညာသင်နှစ် အသစ် ထည့်သွင်းရန်</h5>
            <p style="font-size: 0.8rem; color: #64748b; margin: 0;">အဆင့် ၁ — ဥပမာ: 2024-2025</p>
          </div>
          <div>
            <label class="form-label" style="font-size: 0.8rem; font-weight: 600; color: #374151;">ပညာသင်နှစ် <span style="color:#dc2626;">*</span></label>
            <input type="text" name="yearName" placeholder="e.g. 2024-2025" pattern="\d{4}\s*-\s*\d{4}" required
                   style="width:100%; padding: 0.55rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
          </div>
        </div>
        <div class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal" style="flex: 1; padding: 0.6rem;">မထည့်သွင်းပါ</button>
          <button type="submit" class="btn-primary-custom" style="flex: 1; padding: 0.6rem;">ထည့်သွင်းမည်</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ── Edit Academic Year Modal ────────────────────── -->
<div class="modal fade" id="editYearModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 28rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/academics" data-validate novalidate>
        <input type="hidden" name="action" value="updateYear"/>
        <input type="hidden" name="id" id="edit-year-id"/>
        <div class="modal-body d-flex flex-column align-items-stretch gap-3 pt-3 text-start">
          <div class="text-center">
            <h5 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin: 0.5rem 0 0.25rem;">ပညာသင်နှစ် ပြင်ဆင်ရန်</h5>
            <p style="font-size: 0.8rem; color: #64748b; margin: 0;">ဥပမာ: 2024-2025</p>
          </div>
          <div>
            <label class="form-label" style="font-size: 0.8rem; font-weight: 600; color: #374151;">ပညာသင်နှစ် <span style="color:#dc2626;">*</span></label>
            <input type="text" name="yearName" id="edit-year-name" placeholder="e.g. 2024-2025" pattern="\d{4}\s*-\s*\d{4}" required
                   style="width:100%; padding: 0.55rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;"/>
          </div>
        </div>
        <div class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal" style="flex: 1; padding: 0.6rem;">မပြင်ဆင်ပါ</button>
          <button type="submit" class="btn-primary-custom" style="flex: 1; padding: 0.6rem;">ပြင်ဆင်မည်</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ── Delete Academic Year Modal ──────────────────── -->
<div class="modal fade" id="deleteYearModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/academics">
        <input type="hidden" name="action" value="deleteYear"/>
        <input type="hidden" name="id" id="delete-year-id"/>
        <div class="modal-body d-flex flex-column align-items-center gap-3 pt-3">
          <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
            </svg>
          </div>
          <div class="d-flex flex-column gap-1">
            <h5 style="font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0;">ပညာသင်နှစ် ပယ်ဖျက်ရန် အတည်ပြုပါ</h5>
            <p style="font-size: 0.85rem; color: #64748b; margin: 0;">
              <strong id="delete-year-name" style="color: #dc2626;"></strong> ကို ပယ်ဖျက်ပါက ၎င်း၏ Semester၊ ဘာသာရပ်နှင့် ရလဒ်များ အားလုံး ပျက်သွားမည်။ သေချာပါသလား။
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

<!-- ── Edit Semester Modal ─────────────────────────── -->
<div class="modal fade" id="editSemesterModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 28rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/academics" data-validate novalidate>
        <input type="hidden" name="action" value="updateSemester"/>
        <input type="hidden" name="id" id="edit-sem-id"/>
        <input type="hidden" name="academicYearId" id="edit-sem-yearid"/>
        <div class="modal-body d-flex flex-column align-items-stretch gap-3 pt-3 text-start">
          <div class="text-center">
            <h5 style="font-size: 1.05rem; font-weight: 700; color: #0f172a; margin: 0.5rem 0 0.25rem;">Semester ပြင်ဆင်ရန်</h5>
          </div>
          <div>
            <label class="form-label" style="font-size: 0.8rem; font-weight: 600; color: #374151;">Semester <span style="color:#dc2626;">*</span></label>
            <select name="semesterNumber" id="edit-sem-number" required
                    style="width:100%; padding: 0.55rem 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; font-size: 0.875rem;">
              <% for (int i = 1; i <= 8; i++) { %>
                <option value="<%= i %>">Semester <%= i %></option>
              <% } %>
            </select>
          </div>
        </div>
        <div class="d-flex align-items-center justify-content-center gap-2 w-100 mt-2">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal" style="flex: 1; padding: 0.6rem;">မပြင်ဆင်ပါ</button>
          <button type="submit" class="btn-primary-custom" style="flex: 1; padding: 0.6rem;">ပြင်ဆင်မည်</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- ── Delete Semester Modal ───────────────────────── -->
<div class="modal fade" id="deleteSemesterModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 26rem;">
    <div class="modal-content text-center p-3" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <form method="post" action="${pageContext.request.contextPath}/admin/academics">
        <input type="hidden" name="action" value="deleteSemester"/>
        <input type="hidden" name="id" id="delete-sem-id"/>
        <div class="modal-body d-flex flex-column align-items-center gap-3 pt-3">
          <div style="width: 3.5rem; height: 3.5rem; border-radius: 50%; background-color: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center;">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
            </svg>
          </div>
          <div class="d-flex flex-column gap-1">
            <h5 style="font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0;">Semester ပယ်ဖျက်ရန် အတည်ပြုပါ</h5>
            <p style="font-size: 0.85rem; color: #64748b; margin: 0;">
              <strong id="delete-sem-name" style="color: #dc2626;"></strong> ကို ပယ်ဖျက်ပါက ၎င်း၏ ဘာသာရပ်နှင့် ရလဒ်များ ပျက်သွားမည်။ သေချာပါသလား။
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

<!-- ── Attach Existing Subjects Modal ──────────────── -->
<div class="modal fade" id="attachSubjectsModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width: 34rem;">
    <div class="modal-content" style="border-radius: 1rem; border: none; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);">
      <div class="modal-header" style="border-bottom: 1px solid #e2e8f0; padding: 1rem 1.25rem;">
        <h5 class="modal-title" style="font-size: 1rem; font-weight: 700; color: #0f172a;">ရှိပြီးသား ဘာသာရပ်များ ထည့်ရန်</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form method="post" action="${pageContext.request.contextPath}/admin/academics" id="attachSubjectsForm">
        <input type="hidden" name="action" value="attachSubjects"/>
        <input type="hidden" name="semesterId" id="attach-semester-id"/>
        <div class="modal-body" style="padding: 1.25rem;">
          <p style="font-size: 0.82rem; color: #64748b; margin-bottom: 0.85rem;">
            ရွေးချယ်ထားသော ဘာသာရပ်များကို <strong id="attach-target-label" style="color: #1d4ed8;"></strong> တွင် ထည့်သွင်းမည်။
            အခြား ပညာသင်နှစ်တွင် ရှိပြီးသား ဘာသာရပ်များကိုလည်း ထပ်ထည့်နိုင်ပါသည်
            <span style="color:#92400e;">(ဤပညာသင်နှစ်အတွက် ခွဲထုတ် copy အသစ် တစ်ခု ဖန်တီးပါမည်)</span>။
          </p>
          <div id="attach-subject-list" class="d-flex flex-column gap-2" style="max-height: 320px; overflow-y: auto;"></div>
          <div id="attach-empty-note" style="display: none; text-align: center; padding: 1.5rem 1rem; color: #64748b; font-size: 0.85rem;">
            ထည့်နိုင်တဲ့ ဘာသာရပ် မရှိတော့ပါ။
            <a href="${pageContext.request.contextPath}/admin/subjects" style="color: #2563eb; font-weight: 600;">ဘာသာရပ်များ page</a> မှ အသစ် create လုပ်ပါ။
          </div>
        </div>
        <div class="modal-footer" style="border-top: 1px solid #e2e8f0; padding: 0.875rem 1.25rem; gap: 0.5rem;">
          <button type="button" class="btn-outline-custom" data-bs-dismiss="modal">မထည့်သွင်းပါ</button>
          <button type="submit" class="btn-primary-custom" id="attach-submit-btn">+ ထည့်သွင်းမည်</button>
        </div>
      </form>
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
document.getElementById('editYearModal').addEventListener('show.bs.modal', function(e) {
  const d = e.relatedTarget.dataset;
  document.getElementById('edit-year-id').value   = d.id || '';
  document.getElementById('edit-year-name').value = d.yearname || '';
});
document.getElementById('deleteYearModal').addEventListener('show.bs.modal', function(e) {
  const d = e.relatedTarget.dataset;
  document.getElementById('delete-year-id').value   = d.id || '';
  document.getElementById('delete-year-name').textContent = d.name || '';
});
document.getElementById('editSemesterModal').addEventListener('show.bs.modal', function(e) {
  const d = e.relatedTarget.dataset;
  document.getElementById('edit-sem-id').value     = d.id || '';
  document.getElementById('edit-sem-yearid').value = d.yearid || '';
  document.getElementById('edit-sem-number').value = d.number || '';
});
document.getElementById('deleteSemesterModal').addEventListener('show.bs.modal', function(e) {
  const d = e.relatedTarget.dataset;
  document.getElementById('delete-sem-id').value   = d.id || '';
  document.getElementById('delete-sem-name').textContent = d.name || '';
});

// Accordion chevron sync
document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(btn) {
  var target = document.querySelector(btn.getAttribute('data-bs-target'));
  if (!target) return;
  target.addEventListener('hide.bs.collapse', function() { btn.classList.add('collapsed'); });
  target.addEventListener('show.bs.collapse', function() { btn.classList.remove('collapsed'); });
});

// ── Attach existing subjects to a semester ─────────────────────
// All subjects rendered from server — duplicates allowed across
// different academic years (a per-year copy is created on attach).
var ALL_SUBJECTS = [
  <% if (allSubjects != null) {
       for (common.Subject sub : allSubjects) {
         String dept = sub.getDepartment() != null ? sub.getDepartment() : "";
         out.print("{ id: " + sub.getId() +
                   ", code: '" + sub.getSubjectCode().replace("'", "\\'") + "'" +
                   ", name: '" + sub.getSubjectName().replace("'", "\\'") + "'" +
                   ", credit: " + sub.getCredit() +
                   ", dept: '" + dept.replace("'", "\\'") + "'" +
                   ", semId: " + sub.getSemesterId() +
                   ", yearId: " + (sub.getAcademicYearId() != null ? sub.getAcademicYearId() : 0) +
                   ", yearName: '" + (sub.getAcademicYearName() != null ? sub.getAcademicYearName().replace("'", "\\'") : "") + "'" +
                   ", semNo: " + (sub.getSemesterNumber() != null ? sub.getSemesterNumber() : 0) + " },");
       }
     } %>
];

// semesterId -> academicYearId map for target-year lookups
var SEM_YEARS = {
  <% if (semsByYear != null) {
       for (java.util.Map.Entry<Integer, java.util.List<common.Semester>> e : semsByYear.entrySet()) {
         for (common.Semester s : e.getValue()) {
           out.print(s.getId() + ": " + e.getKey() + ",");
         }
       }
     } %>
};

function esc(s) {
  var div = document.createElement('div');
  div.textContent = s;
  return div.innerHTML;
}

document.getElementById('attachSubjectsModal').addEventListener('show.bs.modal', function(e) {
  const d = e.relatedTarget.dataset;
  document.getElementById('attach-semester-id').value = d.semid || '';
  document.getElementById('attach-target-label').textContent = d.semlabel || '';
  renderAttachList(parseInt(d.semid, 10) || 0);
});

function renderAttachList(targetSemId) {
  var list      = document.getElementById('attach-subject-list');
  var emptyNote = document.getElementById('attach-empty-note');
  var submitBtn = document.getElementById('attach-submit-btn');
  list.innerHTML = '';

  var targetYearId = SEM_YEARS[targetSemId] || 0;
  // Eligible: unassigned subjects, or subjects assigned in a DIFFERENT
  // academic year (adding them creates a copy for the target year).
  var eligible = ALL_SUBJECTS.filter(function(sub) {
    if (sub.semId === targetSemId) return false;          // already in this semester
    if (sub.semId === 0) return true;                     // unassigned pool
    return sub.yearId !== targetYearId;                   // different academic year
  });

  if (!eligible.length) {
    list.style.display = 'none';
    emptyNote.style.display = 'block';
    submitBtn.disabled = true;
    return;
  }
  list.style.display = 'flex';
  emptyNote.style.display = 'none';
  submitBtn.disabled = false;

  eligible.forEach(function(sub) {
    var label = document.createElement('label');
    label.style.cssText = 'display:flex; align-items:center; gap:0.55rem; border:1px solid #e2e8f0; border-radius:0.5rem; padding:0.5rem 0.7rem; cursor:pointer; font-size:0.83rem;';
    var sourceBadge = '';
    if (sub.semId > 0) {
      sourceBadge = '<span class="badge" style="font-size:0.68rem; background:#fef3c7; color:#92400e;">' +
                    esc(sub.yearName) + ' · Sem ' + sub.semNo + '</span>';
    }
    label.innerHTML =
      '<input type="checkbox" name="subjectIds" value="' + sub.id + '" style="width:1rem; height:1rem; flex-shrink:0;"/>' +
      '<span class="chip-code">' + esc(sub.code) + '</span>' +
      '<span style="font-weight:600; color:#0f172a;">' + esc(sub.name) + '</span>' +
      '<span class="badge badge-info" style="font-size:0.68rem;">' + sub.credit + ' Credits</span>' +
      sourceBadge +
      '<span style="margin-left:auto; color:#94a3b8; font-size:0.72rem;">' + esc(sub.dept) + '</span>';
    list.appendChild(label);
  });
}

document.getElementById('attachSubjectsForm').addEventListener('submit', function(e) {
  var checked = this.querySelectorAll('input[name="subjectIds"]:checked').length;
  if (!checked) {
    e.preventDefault();
    alert('ကျေးဇူးပြု၍ ဘာသာရပ် အနည်းဆုံး တစ်ခု ရွေးချယ်ပါ။');
  }
});
</script>
</body>
</html>
