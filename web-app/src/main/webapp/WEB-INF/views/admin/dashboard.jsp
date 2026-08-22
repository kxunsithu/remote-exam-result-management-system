<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
      <% request.setAttribute("pageTitle", "Dashboard" ); String flashSuccess=(String)
        session.getAttribute("flashSuccess"); String flashError=(String) session.getAttribute("flashError");
        session.removeAttribute("flashSuccess"); session.removeAttribute("flashError"); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Admin Dashboard — RERMS</title>
          <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
          <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
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
                  <% if (flashSuccess !=null) { %>
                    <div class="alert-custom alert-success-custom flash-alert">
                      <%= flashSuccess %>
                    </div>
                    <% } %>
                      <% if (flashError !=null) { %>
                        <div class="alert-custom alert-danger-custom flash-alert">
                          <%= flashError %>
                        </div>
                        <% } %>
                          <% if (request.getAttribute("rmiError") !=null) { %>
                            <div class="alert-custom alert-warning-custom flash-alert">
                              <%= request.getAttribute("rmiError") %>
                            </div>
                            <% } %>
                              <!-- Breadcrumb Nav & History Controls Row -->
                              <div class="d-flex align-items-center justify-content-between mb-3">
                                <div class="d-flex align-items-center gap-2"
                                  style="font-size: 0.8125rem; color: #64748b;">
                                  <span>ဒက်ရှ်ဘုတ်</span>
                                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <polyline points="9 18 15 12 9 6" />
                                  </svg>
                                  <span style="color: #0f172a; font-weight: 500;">ပင်မအကျဉ်းချုပ်</span>
                                </div>

                                <div class="d-flex align-items-center gap-1">
                                  <button onclick="history.back()" aria-label="Go back" type="button"
                                    class="btn-action-icon" style="width: 1.65rem; height: 1.65rem;">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                      stroke-width="2.5">
                                      <line x1="19" y1="12" x2="5" y2="12" />
                                      <polyline points="12 19 5 12 12 5" />
                                    </svg>
                                  </button>
                                  <button onclick="history.forward()" aria-label="Go forward" type="button"
                                    class="btn-action-icon" style="width: 1.65rem; height: 1.65rem;">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                      stroke-width="2.5">
                                      <line x1="5" y1="12" x2="19" y2="12" />
                                      <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                  </button>
                                </div>
                              </div>
                              <div class="banner-card">
                                <div class="d-flex flex-column gap-3">
                                  <div class="banner-identity">
                                    <div class="banner-logo-box" style="border-radius: 50%; border-color: #2563eb;">
                                      <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2">
                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                        <path d="M6 12v5c3 3 9 3 12 0v-5" />
                                      </svg>
                                    </div>
                                    <div class="d-flex flex-column gap-1">
                                      <div class="d-flex align-items-center gap-2 flex-wrap">
                                        <span class="banner-tag-pill">UCS (Hpa-an)</span>
                                        <span style="font-size: 0.75rem; color: var(--muted-foreground);">University of Computer Studies (Hpa-an)</span>
                                      </div>
                                      <h1 class="page-title-heading" style="font-size: 1.35rem; color: #0f172a; margin: 0;">
                                        ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ) — စာမေးပွဲရလဒ် စီမံခန့်ခွဲမှု စနစ်
                                      </h1>
                                    </div>
                                  </div>

                                  <p style="font-size: 0.875rem; color: #64748b; line-height: 1.6; margin: 0;">
                                    ကြိုဆိုပါသည်၊ <strong style="color: #0f172a;">Administrator</strong>။
                                    ကျောင်းသားအချက်အလက်များ၊ ဘာသာရပ်များ၊ သင်ရိုးညွှန်းတမ်းနှင့် စာမေးပွဲရလဒ်များကို
                                    အချိန်နှင့်တပြေးညီ လွယ်ကူစွာ စီမံခန့်ခွဲနိုင်ပါသည်။
                                  </p>

                                  <div class="d-flex align-items-center gap-2 flex-wrap pt-2 border-top">
                                    <span class="badge badge-info">
                                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                                        <polyline points="22,6 12,13 2,6" />
                                      </svg>
                                      admin@example.com
                                    </span>
                                    <span class="badge badge-success">
                                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="me-1">
                                        <circle cx="12" cy="12" r="10" />
                                        <polyline points="12 6 12 12 16 14" />
                                      </svg>
                                      Java RMI Server Connected
                                    </span>
                                  </div>
                                </div>
                              </div>

                              <!-- Overview Statistics Grid -->
                              <div class="stats-grid">
                                <!-- Card 1: Total Students -->
                                <a href="${pageContext.request.contextPath}/admin/students" class="stat-card-item">
                                  <div class="stat-card-header">
                                    <span class="stat-card-label" style="font-size: 0.85rem;">ကျောင်းသား/သူ ဦးရေ</span>
                                    <div class="stat-card-icon-wrap">
                                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                        <circle cx="9" cy="7" r="4" />
                                      </svg>
                                    </div>
                                  </div>
                                  <div class="d-flex align-items-baseline justify-content-between">
                                    <div class="stat-card-value">
                                      <%= request.getAttribute("totalStudents") !=null ?
                                        request.getAttribute("totalStudents") : "0" %>
                                    </div>
                                    <span style="font-size: 0.78rem; font-weight: 600; color: var(--primary);">ကြည့်ရန်
                                      →</span>
                                  </div>
                                </a>

                                 <!-- Card 2: Total Subjects -->
                                <a href="${pageContext.request.contextPath}/admin/subjects" class="stat-card-item">
                                  <div class="stat-card-header">
                                    <span class="stat-card-label" style="font-size: 0.85rem;">ဘာသာရပ် အရေအတွက်</span>
                                    <div class="stat-card-icon-wrap"
                                      style="background-color: rgba(37, 99, 235, 0.1); color: #2563eb;">
                                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                      </svg>
                                    </div>
                                  </div>
                                  <div class="d-flex align-items-baseline justify-content-between">
                                    <div class="stat-card-value">
                                      <%= request.getAttribute("totalSubjects") !=null ?
                                        request.getAttribute("totalSubjects") : "0" %>
                                    </div>
                                    <span style="font-size: 0.78rem; font-weight: 600; color: #2563eb;">ကြည့်ရန်
                                      →</span>
                                  </div>
                                </a>

                                <!-- Card 3: Exam Results -->
                                <a href="${pageContext.request.contextPath}/admin/results" class="stat-card-item">
                                  <div class="stat-card-header">
                                    <span class="stat-card-label" style="font-size: 0.85rem;">စာမေးပွဲ ရလဒ်များ</span>
                                    <div class="stat-card-icon-wrap"
                                      style="background-color: rgba(139, 92, 246, 0.1); color: #8b5cf6;">
                                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                      </svg>
                                    </div>
                                  </div>
                                  <div class="d-flex align-items-baseline justify-content-between">
                                    <div class="stat-card-value">
                                      <%= request.getAttribute("totalResults") !=null ?
                                        request.getAttribute("totalResults") : "0" %>
                                    </div>
                                    <span style="font-size: 0.78rem; font-weight: 600; color: #8b5cf6;">ကြည့်ရန်
                                      →</span>
                                  </div>
                                </a>
                              </div>

                              <!-- Quick Actions Grid -->
                              <div class="d-flex flex-column gap-3">
                                <h2 style="font-size: 0.95rem; font-weight: 700; color: #0f172a;">
                                  လျင်မြန်စွာ ဆောင်ရွက်ရန်
                                </h2>
                                <div class="quick-actions-grid">
                                  <a href="${pageContext.request.contextPath}/admin/students" class="quick-action-card">
                                    <div class="quick-action-icon">
                                      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                                        <circle cx="9" cy="7" r="4" />
                                      </svg>
                                    </div>
                                    <div class="d-flex flex-column gap-1">
                                      <div style="font-size: 0.875rem; font-weight: 700; color: var(--foreground);">
                                        ကျောင်းသား/သူ စီမံခန့်ခွဲမှု</div>
                                      <div style="font-size: 0.75rem; color: var(--muted-foreground);">
                                        ကျောင်းသားအချက်အလက်များ ထည့်သွင်းခြင်း၊ ပြင်ဆင်ခြင်း</div>
                                    </div>
                                  </a>

                                  <a href="${pageContext.request.contextPath}/admin/subjects" class="quick-action-card">
                                    <div class="quick-action-icon"
                                      style="background-color: rgba(37, 99, 235, 0.1); color: #2563eb;">
                                      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <line x1="12" y1="5" x2="12" y2="19" />
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                      </svg>
                                    </div>
                                    <div class="d-flex flex-column gap-1">
                                      <div style="font-size: 0.875rem; font-weight: 700; color: var(--foreground);">
                                        ဘာသာရပ် စီမံခန့်ခွဲမှု</div>
                                      <div style="font-size: 0.75rem; color: var(--muted-foreground);">သင်ရိုးညွှန်းတမ်း
                                        ဘာသာရပ်များနှင့် Credit သတ်မှတ်ချက်များ</div>
                                    </div>
                                  </a>

                                  <a href="${pageContext.request.contextPath}/admin/results" class="quick-action-card">
                                    <div class="quick-action-icon"
                                      style="background-color: rgba(139, 92, 246, 0.1); color: #8b5cf6;">
                                      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                      </svg>
                                    </div>
                                    <div class="d-flex flex-column gap-1">
                                      <div style="font-size: 0.875rem; font-weight: 700; color: var(--foreground);">
                                        စာမေးပွဲ ရလဒ် ထည့်သွင်းရန်</div>
                                      <div style="font-size: 0.75rem; color: var(--muted-foreground);">အမှတ်များ
                                        စိစစ်ခြင်းနှင့် Grade တွက်ချက်ခြင်း</div>
                                    </div>
                                  </a>
                                </div>
                              </div>



                </div>
              </main>
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
        </body>

        </html>