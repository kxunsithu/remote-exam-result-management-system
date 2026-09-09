<!DOCTYPE html>
<html lang="my">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ဝင်ရောက်ရန် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
  <meta name="description" content="Login to University of Computer Studies (Hpa-an) Exam Result System" />
  <%@ include file="WEB-INF/views/common/tailwind-setup.jsp" %>
    <script>
      function togglePasswordVisibility(inputId, btn) {
        var input = document.getElementById(inputId);
        if (!input) return;
        var eyeIcon = btn ? btn.querySelector('.eye-icon') : null;
        var eyeOffIcon = btn ? btn.querySelector('.eye-off-icon') : null;

        if (input.type === 'password') {
          input.type = 'text';
          if (eyeIcon) eyeIcon.style.display = 'none';
          if (eyeOffIcon) eyeOffIcon.style.display = 'inline-block';
        } else {
          input.type = 'password';
          if (eyeIcon) eyeIcon.style.display = 'inline-block';
          if (eyeOffIcon) eyeOffIcon.style.display = 'none';
        }
      }
    </script>

</head>

<body
  class="bg-slate-50 text-slate-800 min-h-screen flex items-center justify-center p-4 font-sans antialiased bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-blue-50 via-slate-50 to-slate-100">

  <% String preRole=request.getParameter("role"); boolean isStudent="STUDENT" .equalsIgnoreCase(preRole); %>

    <div class="w-full max-w-md bg-white border border-slate-200 roundedl p-8 shadow-xl">

      <div class="text-center mb-6">
        <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="UCS Hpa-an Logo" class="w-16 h-16 rounded-full object-cover mx-auto mb-3 shadow-md border-2 border-slate-200" />
        <h1 class="text-xl font-bold text-slate-900">အကောင့်သို့ ဝင်ရောက်ရန်</h1>
        <p class="text-xs text-slate-500 mt-1">ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</p>
      </div>

      <% String error=(String) request.getAttribute("error"); %>
        <% String success=(String) request.getAttribute("success"); %>

          <% if (error !=null && !error.isEmpty()) { %>
            <div class="p-3 mb-5 rounded bg-red-50 border border-red-200 text-red-700 text-xs flex items-center gap-2">
              <svg class="w-4 h-4 shrink-0 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                stroke-width="2">
                <circle cx="12" cy="12" r="10" />
                <line x1="12" y1="8" x2="12" y2="12" />
                <line x1="12" y1="16" x2="12.01" y2="16" />
              </svg>
              <span>
                <%= error %>
              </span>
            </div>
            <% } %>

              <% if (success !=null && !success.isEmpty()) { %>
                <div
                  class="p-3 mb-5 rounded bg-emerald-50 border border-emerald-200 text-emerald-700 text-xs flex items-center gap-2">
                  <svg class="w-4 h-4 shrink-0 text-emerald-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                    stroke-width="2">
                    <polyline points="20 6 9 17 4 12" />
                  </svg>
                  <span>
                    <%= success %>
                  </span>
                </div>
                <% } %>

                  <!-- Form -->
                  <form method="post" action="${pageContext.request.contextPath}/login" class="space-y-4">
                    <input type="hidden" name="role" value='<%= isStudent ? "STUDENT" : "ADMIN" %>'/>

                    <div>
                      <label class="block text-xs font-semibold text-slate-700 mb-1.5" for="email">အီးမေးလ် အကောင့်
                        (Email)</label>
                      <input type="email" id="email" name="email"
                        class="w-full px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-sm placeholder-slate-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/15 transition-all"
                        placeholder='<%= isStudent ? "student@example.com" : "admin@example.com" %>' required
                      autocomplete="email"/>
                    </div>

                    <div>
                      <label class="block text-xs font-semibold text-slate-700 mb-1.5" for="password">စကားဝှက်
                        (Password)</label>
                      <div class="relative">
                        <input type="password" id="password" name="password"
                          class="w-full px-3.5 py-2.5 pr-10 rounded bg-slate-50 border border-slate-300 text-slate-900 text-sm placeholder-slate-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/15 transition-all"
                          placeholder="••••••••" required autocomplete="current-password" />
                        <button type="button" onclick="togglePasswordVisibility('password', this)"
                          class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 focus:outline-none transition-colors p-1 cursor-pointer z-10"
                          title="စကားဝှက် ကြည့်ရန်/ဖွက်ရန်" aria-label="Toggle password visibility">
                          <svg class="w-4 h-4 eye-icon" style="display:inline-block;" viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                          </svg>
                          <svg class="w-4 h-4 eye-off-icon" style="display:none;" viewBox="0 0 24 24" fill="none"
                            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path
                              d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                            </path>
                            <line x1="1" y1="1" x2="23" y2="23"></line>
                          </svg>
                        </button>
                      </div>
                    </div>

                    <% if (isStudent) { %>
                      <div class="flex justify-end pt-1">
                        <a href="${pageContext.request.contextPath}/register"
                          class="text-xs font-semibold text-blue-600 hover:text-blue-700 transition-colors">
                          အကောင့်သစ် ပြုလုပ်ရန်
                        </a>
                      </div>
                      <% } %>

                        <button type="submit"
                          class="w-full py-3 px-4 rounded bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white font-bold text-sm shadow-md shadow-blue-600/20 transition-all transform active:scale-[0.99] mt-2">
                          ဝင်ရောက်မည်
                        </button>
                  </form>


                  <div class="text-center mt-5">
                    <a href="${pageContext.request.contextPath}/welcome"
                      class="text-xs text-slate-500 hover:text-slate-700 transition-colors">
                      Role ပြန်လည်ရွေးချယ်ရန်
                    </a>
                  </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>

</html>