<%-- navbar.jsp: sessionUser, userEmail, userInitial, pageTitle are declared in sidebar.jsp which is always included first --%>
<!-- ── Top Header Navbar ──────────────────────── -->
<header class="top-navbar">
  <div class="d-flex align-items-center gap-3">
    <!-- Main Title in Myanmar -->
    <h2 class="m-0" style="font-size: 1.15rem; font-weight: 700; color: #0f172a;">
      ကျောင်းသား ပေါ်တယ်
    </h2>
  </div>

  <div class="navbar-actions">
    <!-- Student User Profile Pill -->
    <div class="d-flex align-items-center gap-2 px-2 py-1 rounded-pill" style="background-color: #f8fafc; border: 1px solid #e2e8f0;">
      <div style="width: 24px; height: 24px; border-radius: 50%; background-color: #dcfce7; display: flex; align-items: center; justify-content: center; color: #166534; font-weight: 700; font-size: 0.75rem;">
        <%= userInitial %>
      </div>
      <span style="font-size: 0.8125rem; font-weight: 600; color: #334155;"><%= userEmail %></span>
    </div>
  </div>
</header>

