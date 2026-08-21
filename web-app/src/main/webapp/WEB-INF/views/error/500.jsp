<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>500 System Error — RERMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">
<div class="auth-card text-center" style="max-width: 400px;">
  <div class="sidebar-logo mx-auto mb-3" style="width: 56px; height: 56px; background-color: rgba(220, 38, 38, 0.1); color: #dc2626; border-color: rgba(220, 38, 38, 0.2);">
    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <polygon points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2"/>
      <line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
    </svg>
  </div>
  <h1 style="color: var(--foreground); font-size: 2.25rem; font-weight: 800; margin-bottom: 0.25rem;">500</h1>
  <h2 style="color: var(--foreground); font-size: 1.125rem; font-weight: 700; margin-bottom: 0.5rem;">Internal Server Error</h2>
  <p style="color: var(--muted-foreground); font-size: 0.875rem; margin-bottom: 1.5rem;">
    An unexpected error occurred. Please ensure the RMI Server is running and try again.
  </p>
  <a href="${pageContext.request.contextPath}/login" style="text-decoration: none;">
    <button type="button" class="btn-auth">Return to Login</button>
  </a>
</div>
</body>
</html>
