<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Register — Remote Exam Result Management System</title>
  <meta name="description" content="Create a student account"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">

<div class="auth-card fade-in-up">
  <div class="auth-logo">
    <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" xmlns="http://www.w3.org/2000/svg">
      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
      <circle cx="9" cy="7" r="4"/>
      <line x1="19" y1="8" x2="19" y2="14"/>
      <line x1="22" y1="11" x2="16" y2="11"/>
    </svg>
  </div>

  <h1 class="auth-title">Create Account</h1>
  <p class="auth-subtitle">Register as a student to view your results</p>

  <% String error = (String) request.getAttribute("error"); %>
  <% if (error != null && !error.isEmpty()) { %>
    <div class="alert-custom alert-danger-custom flash-alert">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/>
      </svg>
      <%= error %>
    </div>
  <% } %>

  <form method="post" action="${pageContext.request.contextPath}/register" data-validate novalidate>
    <div class="mb-3">
      <label class="auth-label" for="email">Email Address</label>
      <input type="email" id="email" name="email" class="auth-input"
             placeholder="student@university.edu" required autocomplete="email"/>
    </div>

    <div class="mb-3">
      <label class="auth-label" for="password">Password</label>
      <input type="password" id="password" name="password" class="auth-input"
             placeholder="Min. 6 characters" required minlength="6" autocomplete="new-password"/>
    </div>

    <div class="mb-4">
      <label class="auth-label" for="confirmPassword">Confirm Password</label>
      <input type="password" id="confirmPassword" name="confirmPassword" class="auth-input"
             placeholder="Repeat password" required autocomplete="new-password"/>
    </div>

    <button type="submit" class="btn-auth mb-3">Create Account</button>
  </form>

  <div class="auth-divider">already have an account?</div>

  <a href="${pageContext.request.contextPath}/login" style="display:block;">
    <button type="button" class="btn-auth btn-auth-outline">Back to Login</button>
  </a>

  <p style="color:#475569; font-size:.75rem; text-align:center; margin-top:1rem;">
    Note: Your account must match a student record in the system.
  </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
