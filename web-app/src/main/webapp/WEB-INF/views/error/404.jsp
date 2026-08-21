<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>404 Page Not Found — RERMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">
<div class="auth-card text-center" style="max-width: 400px;">
  <div class="sidebar-logo mx-auto mb-3" style="width: 56px; height: 56px; background-color: rgba(245, 158, 11, 0.1); color: #f59e0b; border-color: rgba(245, 158, 11, 0.2);">
    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
    </svg>
  </div>
  <h1 style="color: var(--foreground); font-size: 2.25rem; font-weight: 800; margin-bottom: 0.25rem;">404</h1>
  <h2 style="color: var(--foreground); font-size: 1.125rem; font-weight: 700; margin-bottom: 0.5rem;">Page Not Found</h2>
  <p style="color: var(--muted-foreground); font-size: 0.875rem; margin-bottom: 1.5rem;">
    The requested resource could not be found on the server.
  </p>
  <a href="${pageContext.request.contextPath}/login" style="text-decoration: none;">
    <button type="button" class="btn-auth">Return to Login</button>
  </a>
</div>
</body>
</html>
