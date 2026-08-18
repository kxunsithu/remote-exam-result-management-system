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
<div class="auth-card text-center fade-in-up" style="max-width:480px;">
  <div class="auth-logo" style="background:linear-gradient(135deg,#f59e0b,#d97706);">
    <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
      <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
    </svg>
  </div>
  <h1 style="color:#f8fafc;font-size:2.5rem;font-weight:800;margin-bottom:.5rem;">404</h1>
  <h2 style="color:#f1f5f9;font-size:1.25rem;font-weight:600;margin-bottom:1rem;">Page Not Found</h2>
  <p style="color:#94a3b8;font-size:.9rem;margin-bottom:2rem;">
    The page you are looking for does not exist or has been moved.
  </p>
  <a href="${pageContext.request.contextPath}/login" style="display:block;">
    <button class="btn-auth">Return Home</button>
  </a>
</div>
</body>
</html>
