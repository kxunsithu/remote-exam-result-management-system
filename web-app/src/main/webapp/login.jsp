<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="my">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ဝင်ရောက်ရန် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
  <meta name="description" content="Login to University of Computer Studies (Hpa-an) Exam Result System"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">

<%
  // Role comes from the dedicated role selection page (?role=ADMIN|STUDENT)
  String preRole = request.getParameter("role");
  boolean isStudent = "STUDENT".equalsIgnoreCase(preRole);
%>

<div class="auth-card" style="max-width: 26rem; padding: 2rem; border-radius: 1rem; border: 1px solid #e2e8f0; background: #ffffff; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05);">
  <!-- Logo + University Title -->
  <div class="auth-brand-header mb-4">
    <div class="sidebar-logo" style="width: 44px; height: 44px; border-radius: 50%; background-color: <%= isStudent ? "#10b981" : "#2563eb" %>;">
      <% if (isStudent) { %>
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
      </svg>
      <% } else { %>
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
        <line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/>
      </svg>
      <% } %>
    </div>
    <div>
      <p style="font-size: 0.95rem; font-weight: 700; color: #0f172a; margin: 0; line-height: 1.2;">
        ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)
      </p>
      <span style="font-size: 0.75rem; color: #64748b;">University of Computer Studies (Hpa-an)</span>
    </div>
  </div>

  <!-- Selected role badge -->
  <div style="display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.3rem 0.7rem; border-radius: 999px; background-color: <%= isStudent ? "#ecfdf5" : "#eff6ff" %>; border: 1px solid <%= isStudent ? "#a7f3d0" : "#bfdbfe" %>; margin-bottom: 0.75rem;">
    <span style="width: 0.45rem; height: 0.45rem; border-radius: 50%; background-color: <%= isStudent ? "#10b981" : "#2563eb" %>;"></span>
    <span style="font-size: 0.72rem; font-weight: 700; color: <%= isStudent ? "#047857" : "#1d4ed8" %>;">
      <%= isStudent ? "Student အနေဖြင့် ဝင်ရောက်မည်" : "Admin အနေဖြင့် ဝင်ရောက်မည်" %>
    </span>
  </div>

  <!-- Page Title -->
  <h1 class="auth-title mb-3" style="font-size: 1.25rem; font-weight: 700; color: #0f172a;">
    အကောင့်သို့ ဝင်ရောက်ရန်
  </h1>

  <%-- Flash messages --%>
  <% String error = (String) request.getAttribute("error"); %>
  <% String success = (String) request.getAttribute("success"); %>

  <% if (error != null && !error.isEmpty()) { %>
    <div class="alert-custom alert-danger-custom flash-alert mb-3">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      <%= error %>
    </div>
  <% } %>

  <% if (success != null && !success.isEmpty()) { %>
    <div class="alert-custom alert-success-custom flash-alert mb-3">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <polyline points="20 6 9 17 4 12"/>
      </svg>
      <%= success %>
    </div>
  <% } %>

  <!-- Login Form -->
  <form method="post" action="${pageContext.request.contextPath}/login" data-validate novalidate class="d-flex flex-column gap-3">
    <input type="hidden" name="role" value="<%= isStudent ? "STUDENT" : "ADMIN" %>"/>

    <div>
      <label class="auth-label" for="email">အီးမေးလ် အကောင့် (Email)</label>
      <input type="email" id="email" name="email" class="auth-input"
             placeholder="<%= isStudent ? "john.doe@university.edu" : "admin@example.com" %>" required autocomplete="email"/>
    </div>

    <div>
      <label class="auth-label" for="password">စကားဝှက် (Password)</label>
      <input type="password" id="password" name="password" class="auth-input"
             placeholder="••••••••" required autocomplete="current-password"/>
    </div>

    <div class="d-flex align-items-center justify-content-between pt-1">
      <div class="form-check m-0">
        <input class="form-check-input" type="checkbox" id="rememberMe">
        <label class="form-check-label text-sm text-foreground" for="rememberMe" style="cursor: pointer; font-size: 0.8125rem; color: #475569;">
          မှတ်သားထားရန်
        </label>
      </div>
      <% if (isStudent) { %>
      <a href="${pageContext.request.contextPath}/register" style="font-size: 0.8125rem; color: #10b981; font-weight: 600;" class="hover-underline">
        အကောင့်သစ် ပြုလုပ်ရန်
      </a>
      <% } %>
    </div>

    <button type="submit" class="btn-auth mt-2" style="<%= isStudent ? "background-color: #10b981;" : "" %>">ဝင်ရောက်မည်</button>
  </form>

  <!-- Demo credentials hint card -->
  <div style="margin-top: 1.5rem; padding: 0.875rem; background-color: #f8fafc; border-radius: 0.5rem; border: 1px solid #e2e8f0;">
    <div style="font-size: 0.72rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 0.4rem;">
      စမ်းသပ် အသုံးပြုနိုင်သော အကောင့်
    </div>
    <% if (isStudent) { %>
    <div style="font-size: 0.8125rem; color: #334155;">
      Student: <strong style="color: #10b981;">john.doe@university.edu</strong> / student123
    </div>
    <% } else { %>
    <div style="font-size: 0.8125rem; color: #334155;">
      Admin: <strong style="color: #2563eb;">admin@example.com</strong> / admin123
    </div>
    <% } %>
  </div>

  <div class="text-center mt-3">
    <a href="${pageContext.request.contextPath}/welcome" style="font-size: 0.75rem; color: #94a3b8;" class="hover-underline">
      &larr; ဘက် ပြန်ရွေးရန်
    </a>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
