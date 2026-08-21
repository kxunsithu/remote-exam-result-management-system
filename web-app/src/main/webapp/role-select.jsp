<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="my">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ဘက်ရွေးချယ်ရန် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
  <meta name="description" content="Select your role to continue"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
</head>
<body class="auth-page">

<div class="auth-card" style="max-width: 34rem; padding: 2rem; border-radius: 1rem; border: 1px solid #e2e8f0; background: #ffffff; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05);">

  <!-- Logo + University Title Header -->
  <div class="auth-brand-header mb-4">
    <div class="sidebar-logo" style="width: 44px; height: 44px; border-radius: 50%; background-color: #2563eb;">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
      </svg>
    </div>
    <div>
      <p style="font-size: 0.95rem; font-weight: 700; color: #0f172a; margin: 0; line-height: 1.2;">
        ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)
      </p>
      <span style="font-size: 0.75rem; color: #64748b;">University of Computer Studies (Hpa-an)</span>
    </div>
  </div>

  <!-- Page Title -->
  <h1 class="auth-title mb-1" style="font-size: 1.25rem; font-weight: 700; color: #0f172a;">
    ဆက်လက်ရန် အသုံးပြုသူ ဘက်ကို ရွေးချယ်ပါ
  </h1>
  <p style="font-size: 0.8125rem; color: #64748b; margin-bottom: 1.75rem;">
    Select your role to login or register
  </p>

  <!-- Role Cards -->
  <div class="role-cards">
    <!-- Admin Card -->
    <a href="${pageContext.request.contextPath}/login?role=ADMIN" class="role-card">
      <span class="role-card-icon" style="background-color: #eff6ff; color: #2563eb;">
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
          <line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/>
        </svg>
      </span>
      <span class="role-card-body">
        <strong>Admin</strong>
        <small>ဆရာ / စီမံခန့်ခွဲသူ ဘက် — ဝင်ရောက်မည်</small>
      </span>
      <span class="role-card-arrow">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
        </svg>
      </span>
    </a>

    <!-- Student Card -->
    <a href="${pageContext.request.contextPath}/login?role=STUDENT" class="role-card">
      <span class="role-card-icon" style="background-color: #ecfdf5; color: #10b981;">
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
          <path d="M6 12v5c3 3 9 3 12 0v-5"/>
        </svg>
      </span>
      <span class="role-card-body">
        <strong>Student</strong>
        <small>ကျောင်းသား / သူ ဘက် — ဝင်ရောက်မည်</small>
      </span>
      <span class="role-card-arrow">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
        </svg>
      </span>
    </a>
  </div>

  <!-- Register hint -->
  <div class="text-center mt-4 pt-3 border-top">
    <span style="font-size: 0.8125rem; color: #64748b;">ကျောင်းသား အကောင့် မရှိသေးပါက</span>
    <a href="${pageContext.request.contextPath}/register" style="font-size: 0.8125rem; color: #10b981; font-weight: 600;" class="ms-1 hover-underline">
      အကောင့်သစ် ပြုလုပ်မည်
    </a>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<style>
  .role-cards {
    display: grid;
    grid-template-columns: 1fr;
    gap: 0.85rem;
  }
  .role-card {
    display: flex;
    align-items: center;
    gap: 0.9rem;
    padding: 1rem 1.1rem;
    border: 1.5px solid #e2e8f0;
    border-radius: 0.75rem;
    background: #f8fafc;
    text-decoration: none;
    transition: all 0.15s ease;
  }
  .role-card:hover {
    border-color: #93c5fd;
    background: #eff6ff;
    transform: translateY(-1px);
    box-shadow: 0 6px 16px -6px rgba(37, 99, 235, 0.25);
  }
  .role-card-icon {
    width: 3rem; height: 3rem;
    display: flex; align-items: center; justify-content: center;
    border-radius: 50%;
    flex-shrink: 0;
  }
  .role-card-body { display: flex; flex-direction: column; line-height: 1.35; }
  .role-card-body strong { font-size: 0.95rem; color: #0f172a; }
  .role-card-body small { font-size: 0.72rem; color: #94a3b8; }
  .role-card-arrow { margin-left: auto; color: #cbd5e1; transition: all 0.15s ease; }
  .role-card:hover .role-card-arrow { color: #2563eb; transform: translateX(3px); }
</style>
</body>
</html>
