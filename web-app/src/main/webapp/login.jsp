<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login — Remote Exam Result Management System</title>
  <meta name="description" content="Login to the Remote Exam Result Management System"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">

<div class="auth-card fade-in-up">
  <!-- Logo -->
  <div class="auth-logo">
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"
            stroke="white" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
  </div>

  <h1 class="auth-title">Welcome Back</h1>
  <p class="auth-subtitle">Remote Exam Result Management System</p>

  <%-- Flash messages --%>
  <% String error = (String) request.getAttribute("error"); %>
  <% String success = (String) request.getAttribute("success"); %>

  <% if (error != null && !error.isEmpty()) { %>
    <div class="alert-custom alert-danger-custom flash-alert">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      <%= error %>
    </div>
  <% } %>

  <% if (success != null && !success.isEmpty()) { %>
    <div class="alert-custom alert-success-custom flash-alert">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <polyline points="20 6 9 17 4 12"/>
      </svg>
      <%= success %>
    </div>
  <% } %>

  <!-- Login Form -->
  <form method="post" action="${pageContext.request.contextPath}/login" data-validate novalidate>
    <div class="mb-3">
      <label class="auth-label" for="email">Email Address</label>
      <input type="email" id="email" name="email" class="auth-input"
             placeholder="you@example.com" required autocomplete="email"/>
    </div>

    <div class="mb-3">
      <label class="auth-label" for="password">Password</label>
      <input type="password" id="password" name="password" class="auth-input"
             placeholder="••••••••" required autocomplete="current-password"/>
    </div>

    <div class="mb-4">
      <label class="auth-label" for="role">Login As</label>
      <select id="role" name="role" class="auth-input" required>
        <option value="ADMIN">Administrator</option>
        <option value="STUDENT">Student</option>
      </select>
    </div>

    <button type="submit" class="btn-auth mb-3">Sign In</button>
  </form>

  <div class="auth-divider">or</div>

  <a href="${pageContext.request.contextPath}/register" style="display:block;">
    <button type="button" class="btn-auth btn-auth-outline">Create Student Account</button>
  </a>

  <!-- Demo credentials hint -->
  <div style="margin-top:1.5rem; padding:1rem; background:rgba(255,255,255,.04);
              border-radius:8px; border:1px solid rgba(255,255,255,.06);">
    <p style="color:#64748b; font-size:.72rem; font-weight:600; text-transform:uppercase;
              letter-spacing:.06em; margin-bottom:.5rem;">Demo Accounts</p>
    <p style="color:#94a3b8; font-size:.78rem; margin:0;">
      Admin: <span style="color:#818cf8">admin@example.com</span> / admin123</p>
    <p style="color:#94a3b8; font-size:.78rem; margin:.2rem 0 0;">
      Student: <span style="color:#818cf8">student@example.com</span> / student123</p>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
