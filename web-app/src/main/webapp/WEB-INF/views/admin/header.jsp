<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<% common.User headerUser=(common.User) session.getAttribute("user");
   String headerEmail=headerUser !=null ? headerUser.getEmail() : "" ;
   String headerInitial=(headerEmail !=null && !headerEmail.isEmpty()) ? headerEmail.substring(0, 1).toUpperCase() : "A" ;
   String headerTitle=(String) request.getAttribute("headerTitle");
   if (headerTitle==null) {
     String pTitle=(String) request.getAttribute("pageTitle");
     if ("Student Management".equalsIgnoreCase(pTitle)) {
       headerTitle="ဝင်ခွင့်ရကျောင်းသားများ စီမံခန့်ခွဲမှု" ;
     } else if ("Subject Management".equalsIgnoreCase(pTitle)) {
       headerTitle="ဘာသာရပ်များ စီမံခန့်ခွဲမှု" ;
     } else if ("Exam Results".equalsIgnoreCase(pTitle) || "ရလဒ်အသေးစိတ်".equalsIgnoreCase(pTitle)) {
       headerTitle="စာမေးပွဲရလဒ်များ စီမံခန့်ခွဲမှု" ;
     } else {
       headerTitle="ဒက်ရှ်ဘုတ်" ;
     }
   }
   String globalFlashSuccess=(String) session.getAttribute("flashSuccess");
   String globalFlashError=(String) session.getAttribute("flashError");
   session.removeAttribute("flashSuccess");
   session.removeAttribute("flashError");
%>
    <!-- Top Header Bar -->
    <header
      class="flex items-center justify-between py-3.5 px-6 bg-white/90 backdrop-blur-md border-b border-slate-200 sticky top-0 z-30">
      <div class="flex items-center gap-3">
        <h1 class="text-base sm:text-lg font-bold text-slate-900 tracking-tight">
          <%= headerTitle %>
        </h1>
      </div>

      <div class="flex items-center gap-3">
        <div
          class="flex items-center gap-2.5 px-3 py-1.5 rounded-full bg-slate-100 border border-slate-200 hover:bg-slate-200/70 transition-all cursor-pointer"
          data-bs-toggle="modal" data-bs-target="#globalLogoutModal" title="ထွက်မည်">
          <div
            class="w-7 h-7 rounded-full bg-blue-600 flex items-center justify-center font-bold text-xs text-white shadow-sm">
            <%= headerInitial %>
          </div>
          <span class="text-xs font-semibold text-slate-700">Admin</span>
        </div>
      </div>
    </header>

    <!-- Global Toast Container -->
    <% if (globalFlashSuccess !=null || globalFlashError !=null || request.getAttribute("rmiError") !=null) { %>
      <div class="fixed top-5 right-5 z-[9999] flex flex-col gap-3 max-w-sm w-[calc(100%-2.5rem)] pointer-events-none">
        <% if (globalFlashSuccess !=null) { %>
          <div
            class="pointer-events-auto rounded p-3.5 bg-white border border-emerald-200 text-slate-800 text-xs font-medium shadow-xl flex items-center gap-3 backdrop-blur-lg flash-alert transition-all">
            <div
              class="w-7 h-7 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center shrink-0">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <polyline points="20 6 9 17 4 12" />
              </svg>
            </div>
            <span class="flex-1">
              <%= globalFlashSuccess %>
            </span>
            <button type="button"
              class="text-slate-400 hover:text-slate-700 p-1 rounded hover:bg-slate-100 transition-colors"
              onclick="this.closest('.flash-alert').remove()">&times;</button>
          </div>
          <% } %>
            <% if (globalFlashError !=null) { %>
              <div
                class="pointer-events-auto rounded p-3.5 bg-white border border-red-200 text-slate-800 text-xs font-medium shadow-xl flex items-center gap-3 backdrop-blur-lg flash-alert transition-all">
                <div class="w-7 h-7 rounded-full bg-red-100 text-red-600 flex items-center justify-center shrink-0">
                  <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                    <line x1="18" y1="6" x2="6" y2="18" />
                    <line x1="6" y1="6" x2="18" y2="18" />
                  </svg>
                </div>
                <span class="flex-1">
                  <%= globalFlashError %>
                </span>
                <button type="button"
                  class="text-slate-400 hover:text-slate-700 p-1 rounded hover:bg-slate-100 transition-colors"
                  onclick="this.closest('.flash-alert').remove()">&times;</button>
              </div>
              <% } %>
                <% if (request.getAttribute("rmiError") !=null) { %>
                  <div
                    class="pointer-events-auto rounded p-3.5 bg-white border border-amber-200 text-slate-800 text-xs font-medium shadow-xl flex items-center gap-3 backdrop-blur-lg flash-alert transition-all">
                    <div
                      class="w-7 h-7 rounded-full bg-amber-100 text-amber-600 flex items-center justify-center shrink-0">
                      <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                        <path
                          d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                        <line x1="12" y1="9" x2="12" y2="13" />
                        <line x1="12" y1="17" x2="12.01" y2="17" />
                      </svg>
                    </div>
                    <span class="flex-1">
                      <%= request.getAttribute("rmiError") %>
                    </span>
                    <button type="button"
                      class="text-slate-400 hover:text-slate-700 p-1 rounded hover:bg-slate-100 transition-colors"
                      onclick="this.closest('.flash-alert').remove()">&times;</button>
                  </div>
                  <% } %>
      </div>
      <% } %>