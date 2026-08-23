<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          colors: {
            brand: {
              50: '#f0f7ff',
              100: '#e0effe',
              200: '#bae0fd',
              300: '#7cc8fc',
              400: '#36abfa',
              500: '#0c8ee9',
              600: '#0070c7',
              700: '#0159a3',
              800: '#064c86',
              900: '#0b406f',
              950: '#07284a',
            }
          },
          fontFamily: {
            sans: ['Inter', 'Noto Sans Myanmar', 'system-ui', 'sans-serif'],
            mono: ['ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'monospace']
          }
        }
      }
    }
  </script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link
    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Noto+Sans+Myanmar:wght@300;400;500;600;700;800&display=swap"
    rel="stylesheet">
  <!-- Bootstrap JS only (no Bootstrap CSS — using Tailwind for all styling) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <style>
    /* ══════════════════════════════════════════════
     Bootstrap collapse & modal compat (no Bootstrap CSS)
  ══════════════════════════════════════════════ */
    .collapse:not(.show) {
      display: none;
    }

    .collapsing {
      height: 0;
      overflow: hidden;
      transition: height 0.35s ease;
    }

    .modal {
      display: none;
      position: fixed;
      inset: 0;
      z-index: 1055;
      overflow-x: hidden;
      overflow-y: auto;
    }

    .modal.show {
      display: block;
    }

    .modal-dialog {
      position: relative;
      width: auto;
      margin: 4rem auto 1.5rem;
      max-width: 500px;
      pointer-events: none;
    }

    .modal-dialog-centered {
      display: flex;
      align-items: center;
      min-height: calc(100% - 5.5rem);
      margin-top: 1.5rem;
      margin-bottom: 1.5rem;
    }

    .modal.show .modal-dialog {
      pointer-events: auto;
    }

    /* ── Modal content shell ── */
    .modal-content {
      position: relative;
      display: flex;
      flex-direction: column;
      width: 100%;
      pointer-events: auto;
      background-color: #ffffff !important;
      border: 1px solid rgb(226 232 240) !important;
      border-radius: 1rem !important;
      overflow: hidden;
      box-shadow: 0 20px 60px -5px rgba(15, 23, 42, 0.15), 0 8px 20px -8px rgba(15, 23, 42, 0.10) !important;
    }

    /* ── Backdrop ── */
    .modal-backdrop {
      position: fixed;
      inset: 0;
      z-index: 1050;
      background: rgba(15, 23, 42, 0.45);
      backdrop-filter: blur(6px);
      -webkit-backdrop-filter: blur(6px);
    }

    .modal-backdrop.fade {
      opacity: 0;
    }

    .modal-backdrop.fade.show {
      opacity: 1;
      transition: opacity 0.2s ease;
    }

    /* ── Entrance animation: subtle scale + slide ── */
    .modal.fade .modal-dialog {
      transform: scale(0.96) translateY(-12px);
      transition: transform 0.22s cubic-bezier(0.34, 1.56, 0.64, 1), opacity 0.18s ease;
      opacity: 0;
    }

    .modal.show .modal-dialog {
      transform: scale(1) translateY(0);
      opacity: 1;
    }

    /* ── Scrollbar lock ── */
    body.modal-open {
      overflow: hidden;
    }

    /* ══════════════════════════════════════════════
     Premium Modal Anatomy Classes
  ══════════════════════════════════════════════ */


    .modal-accent-red {
      background: linear-gradient(90deg, rgb(220 38 38), rgb(239 68 68));
    }

    .modal-accent-green {
      background: linear-gradient(90deg, rgb(5 150 105), rgb(16 185 129));
    }

    .modal-accent-amber {
      background: linear-gradient(90deg, rgb(217 119 6), rgb(245 158 11));
    }

    /* Header */
    .modal-header-custom {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      padding: 1.25rem 1.5rem 1rem;
      background: #ffffff;
      border-bottom: 1px solid rgb(241 245 249);
    }

    .modal-header-icon {
      width: 2.25rem;
      height: 2.25rem;
      border-radius: 0.6rem;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      background: rgb(239 246 255);
      color: rgb(37 99 235);
      border: 1px solid rgb(219 234 254);
    }

    .modal-header-icon-red {
      background: rgb(254 242 242);
      color: rgb(220 38 38);
      border-color: rgb(254 202 202);
    }

    .modal-header-icon-green {
      background: rgb(236 253 245);
      color: rgb(5 150 105);
      border-color: rgb(167 243 208);
    }

    .modal-title-group {
      flex: 1;
      min-width: 0;
    }

    .modal-title {
      font-size: 0.9rem;
      font-weight: 700;
      color: rgb(15 23 42);
      margin: 0;
      line-height: 1.3;
    }

    .modal-subtitle {
      font-size: 0.72rem;
      color: rgb(100 116 139);
      margin: 0;
      font-weight: 400;
    }

    .modal-close-btn {
      width: 1.75rem;
      height: 1.75rem;
      border-radius: 0.5rem;
      display: flex;
      align-items: center;
      justify-content: center;
      border: none;
      background: transparent;
      cursor: pointer;
      color: rgb(148 163 184);
      transition: background 0.12s, color 0.12s;
      flex-shrink: 0;
      margin-left: auto;
    }

    .modal-close-btn:hover {
      background: rgb(241 245 249);
      color: rgb(51 65 85);
    }

    /* Body */
    .modal-body {
      background: #ffffff !important;
      color: rgb(15 23 42) !important;
      padding: 1.25rem 1.5rem;
    }

    /* Footer */
    .modal-footer {
      background: rgb(248 250 252) !important;
      border-top: 1px solid rgb(226 232 240) !important;
      padding: 0.875rem 1.5rem;
      display: flex;
      gap: 0.5rem;
      justify-content: flex-end;
      align-items: center;
    }

    /* Form label */
    .form-label {
      color: rgb(51 65 85);
      font-size: 0.78rem;
      font-weight: 600;
      display: block;
      margin-bottom: 0.35rem;
      letter-spacing: 0.01em;
    }

    /* Section divider within modal body */
    .modal-section {
      margin-bottom: 1rem;
    }

    .modal-section-title {
      font-size: 0.68rem;
      font-weight: 700;
      color: rgb(148 163 184);
      text-transform: uppercase;
      letter-spacing: 0.08em;
      padding-bottom: 0.5rem;
      margin-bottom: 0.75rem;
      border-bottom: 1px solid rgb(241 245 249);
    }

    /* ══════════════════════════════════════════════
     Form element styling for modal & standalone inputs
  ══════════════════════════════════════════════ */
    .modal select,
    .modal input[type="text"],
    .modal input[type="number"],
    .modal input[type="email"],
    .modal input[type="password"],
    .modal textarea {
      width: 100%;
      padding: 0.55rem 0.875rem;
      font-size: 0.825rem;
      line-height: 1.5;
      border-radius: 0.5rem;
      border: 1.5px solid rgb(203 213 225);
      background-color: rgb(248 250 252);
      color: rgb(15 23 42);
      transition: border-color 0.15s, box-shadow 0.15s, background 0.15s;
      font-family: inherit;
    }

    .modal select:focus,
    .modal input:focus,
    .modal textarea:focus {
      outline: none;
      border-color: rgb(59 130 246);
      background-color: rgb(255 255 255);
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
    }

    select:hover,
    input[type="text"]:hover,
    input[type="number"]:hover,
    input[type="email"]:hover,
    input[type="password"]:hover,
    textarea:hover {
      border-color: rgb(148 163 184);
      background-color: rgb(255 255 255);
    }

    select:focus,
    input:focus,
    textarea:focus {
      outline: none;
      border-color: rgb(59 130 246);
      background-color: rgb(255 255 255);
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
    }

    select option {
      background: rgb(255 255 255);
      color: rgb(15 23 42);
    }

    /* ══════════════════════════════════════════════
     Common Button Tokens
  ══════════════════════════════════════════════ */
    .btn-primary-custom {
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
      padding: 0.5rem 1.1rem;
      border-radius: 0.5rem;
      background: rgb(37 99 235);
      color: #fff;
      font-weight: 700;
      font-size: 0.82rem;
      border: none;
      cursor: pointer;
      transition: background 0.15s, box-shadow 0.15s, transform 0.1s;
      box-shadow: 0 2px 6px rgba(37, 99, 235, 0.25);
    }

    .btn-primary-custom:hover {
      background: rgb(29 78 216);
      box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);
    }

    .btn-primary-custom:active {
      transform: scale(0.98);
    }

    .btn-danger-custom {
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
      padding: 0.5rem 1.1rem;
      border-radius: 0.5rem;
      background: rgb(220 38 38);
      color: #fff;
      font-weight: 700;
      font-size: 0.82rem;
      border: none;
      cursor: pointer;
      transition: background 0.15s, box-shadow 0.15s, transform 0.1s;
      box-shadow: 0 2px 6px rgba(220, 38, 38, 0.25);
    }

    .btn-danger-custom:hover {
      background: rgb(185 28 28);
      box-shadow: 0 4px 12px rgba(220, 38, 38, 0.35);
    }

    .btn-danger-custom:active {
      transform: scale(0.98);
    }

    .btn-outline-custom {
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
      padding: 0.5rem 1.1rem;
      border-radius: 0.5rem;
      background: transparent;
      color: rgb(71 85 105);
      font-weight: 600;
      font-size: 0.82rem;
      border: 1.5px solid rgb(203 213 225);
      cursor: pointer;
      transition: all 0.15s;
    }

    .btn-outline-custom:hover {
      background: rgb(241 245 249);
      color: rgb(15 23 42);
      border-color: rgb(148 163 184);
    }

    /* Close button (Bootstrap compat) */
    .btn-close,
    .btn-close-white {
      opacity: 0.55;
    }

    .btn-close:hover {
      opacity: 1;
    }
  </style>