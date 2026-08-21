<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="my">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ကျောင်းသား အကောင့်သစ် ပြုလုပ်ရန် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
  <meta name="description" content="Create a student account"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">

<div class="auth-card" style="max-width: 26rem; padding: 2rem; border-radius: 1rem; border: 1px solid #e2e8f0; background: #ffffff; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05);">
  <!-- Logo + University Title Header -->
  <div class="auth-brand-header mb-4">
    <div class="sidebar-logo" style="width: 44px; height: 44px; border-radius: 50%; background-color: #10b981;">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
        <circle cx="9" cy="7" r="4"/>
      </svg>
    </div>
    <div>
      <p style="font-size: 0.95rem; font-weight: 700; color: #0f172a; margin: 0; line-height: 1.2;">
        ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)
      </p>
      <span style="font-size: 0.75rem; color: #64748b;">Student Account Registration</span>
    </div>
  </div>

  <h1 class="auth-title mb-3" style="font-size: 1.25rem; font-weight: 700; color: #0f172a;">ကျောင်းသား အကောင့်သစ် ပြုလုပ်ရန်</h1>

  <% String error = (String) request.getAttribute("error"); %>
  <% if (error != null && !error.isEmpty()) { %>
    <div class="alert-custom alert-danger-custom flash-alert mb-3">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/>
      </svg>
      <%= error %>
    </div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/register" data-validate novalidate class="d-flex flex-column gap-3">
    <div>
      <label class="auth-label" for="email">အီးမေးလ် အကောင့် (Email)</label>
      <input type="email" id="email" name="email" class="auth-input"
             placeholder="student@example.com" required autocomplete="email"/>
    </div>

    <div>
      <label class="auth-label" for="password">စကားဝှက် (Password)</label>
      <input type="password" id="password" name="password" class="auth-input"
             placeholder="အနည်းဆုံး ၆ လုံး" required minlength="6" autocomplete="new-password"/>
    </div>

    <div>
      <label class="auth-label" for="confirmPassword">စကားဝှက် အတည်ပြုရန် (Confirm Password)</label>
      <input type="password" id="confirmPassword" name="confirmPassword" class="auth-input"
             placeholder="စကားဝှက် ပြန်လည်ရိုက်ထည့်ပါ" required autocomplete="new-password"/>
    </div>

    <button type="submit" class="btn-auth mt-2" style="background-color: #10b981;">အကောင့်ပြုလုပ်မည်</button>
  </form>

  <div class="text-center mt-4 pt-3 border-top">
    <span style="font-size: 0.8125rem; color: #64748b;">အကောင့်ရှိပြီးသားဖြစ်ပါက</span>
    <a href="${pageContext.request.contextPath}/login" style="font-size: 0.8125rem; color: #2563eb; font-weight: 600;" class="ms-1 hover-underline">
      ဝင်ရောက်မည်
    </a>
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

