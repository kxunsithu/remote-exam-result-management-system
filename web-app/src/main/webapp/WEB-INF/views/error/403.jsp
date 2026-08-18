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
<div class="auth-card text-center fade-in-up" style="max-width:480px;">
  <div class="auth-logo" style="background:linear-gradient(135deg,#ef4444,#dc2626);">
    <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
      <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
    </svg>
  </div>
  <h1 style="color:#f8fafc;font-size:2.5rem;font-weight:800;margin-bottom:.5rem;">403</h1>
  <h2 style="color:#f1f5f9;font-size:1.25rem;font-weight:600;margin-bottom:1rem;">Access Denied</h2>
  <p style="color:#94a3b8;font-size:.9rem;margin-bottom:2rem;">
    You do not have permission to access this resource or perform this operation.
  </p>
  <a href="${pageContext.request.contextPath}/login" style="display:block;">
    <button class="btn-auth">Return to Safety</button>
  </a>
</div>
</body>
</html>
