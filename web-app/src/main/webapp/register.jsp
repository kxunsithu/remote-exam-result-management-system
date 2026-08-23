<!DOCTYPE html>
<html lang="my">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ကျောင်းသား အကောင့်သစ် ပြုလုပ်ရန် — ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)</title>
  <meta name="description" content="Create a student account" />
  <%@ include file="WEB-INF/views/common/tailwind-setup.jsp" %>
</head>

<body
  class="bg-slate-50 text-slate-800 min-h-screen flex items-center justify-center p-4 font-sans antialiased bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-blue-50 via-slate-50 to-slate-100">

  <div class="w-full max-w-md bg-white border border-slate-200 roundedl p-8 shadow-xl">

    <h1 class="text-xl font-bold text-slate-900 mb-6">ကျောင်းသား အကောင့်သစ် ပြုလုပ်ရန်</h1>

    <% String error=(String) request.getAttribute("error"); %>
      <% if (error !=null && !error.isEmpty()) { %>
        <div class="p-3 mb-5 rounded bg-red-50 border border-red-200 text-red-700 text-xs flex items-center gap-2">
          <svg class="w-4 h-4 shrink-0 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2">
            <circle cx="12" cy="12" r="10" />
            <line x1="12" y1="8" x2="12" y2="12" />
          </svg>
          <span>
            <%= error %>
          </span>
        </div>
        <% } %>

          <form method="post" action="${pageContext.request.contextPath}/register" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-slate-700 mb-1.5" for="email">အီးမေးလ် အကောင့်
                (Email)</label>
              <input type="email" id="email" name="email"
                class="w-full px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-sm placeholder-slate-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/15 transition-all"
                placeholder="student@example.com" required autocomplete="email" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 mb-1.5" for="password">စကားဝှက်
                (Password)</label>
              <input type="password" id="password" name="password"
                class="w-full px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-sm placeholder-slate-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/15 transition-all"
                placeholder="အနည်းဆုံး ၆ လုံး" required minlength="6" autocomplete="new-password" />
            </div>

            <div>
              <label class="block text-xs font-semibold text-slate-700 mb-1.5" for="confirmPassword">စကားဝှက် အတည်ပြုရန်
                (Confirm Password)</label>
              <input type="password" id="confirmPassword" name="confirmPassword"
                class="w-full px-3.5 py-2.5 rounded bg-slate-50 border border-slate-300 text-slate-900 text-sm placeholder-slate-400 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/15 transition-all"
                placeholder="စကားဝှက် ပြန်လည်ရိုက်ထည့်ပါ" required autocomplete="new-password" />
            </div>

            <button type="submit"
              class="w-full py-3 px-4 rounded bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white font-bold text-sm shadow-md shadow-blue-600/20 transition-all transform active:scale-[0.99] mt-2">
              အကောင့်ပြုလုပ်မည်
            </button>
          </form>

          <div class="text-center mt-6 pt-5 border-t border-slate-200 text-xs text-slate-500">
            <span>အကောင့်ရှိပြီးသားဖြစ်ပါက</span>
            <a href="${pageContext.request.contextPath}/login?role=STUDENT"
              class="ml-1.5 font-semibold text-blue-600 hover:text-blue-700 transition-colors">
              ဝင်ရောက်မည်
            </a>
          </div>

          <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/welcome"
              class="text-xs text-slate-500 hover:text-slate-700 transition-colors">
              &larr; Role ပြန်လည်ရွေးချယ်ရန်
            </a>
          </div>
  </div>

  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>

</html>