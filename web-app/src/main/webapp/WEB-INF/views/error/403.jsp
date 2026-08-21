<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>403 Access Denied — RERMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">
<div class="auth-card text-center" style="max-width: 400px;">
  <div class="sidebar-logo mx-auto mb-3" style="width: 56px; height: 56px; background-color: rgba(220, 38, 38, 0.1); color: #dc2626; border-color: rgba(220, 38, 38, 0.2);">
    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
    </svg>
  </div>
  <h1 style="color: var(--foreground); font-size: 2.25rem; font-weight: 800; margin-bottom: 0.25rem;">403</h1>
  <h2 style="color: var(--foreground); font-size: 1.125rem; font-weight: 700; margin-bottom: 0.5rem;">Access Denied</h2>
  <p style="color: var(--muted-foreground); font-size: 0.875rem; margin-bottom: 1.5rem;">
    You do not have permission to access this resource or perform this operation.
  </p>
  <a href="${pageContext.request.contextPath}/login" style="text-decoration: none;">
    <button type="button" class="btn-auth">Return to Login</button>
  </a>
</div>
</body>
</html>
