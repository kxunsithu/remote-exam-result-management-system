/* app.js — Remote Exam Result Management System */
'use strict';

document.addEventListener('DOMContentLoaded', () => {
  // ── Restore Sidebar Collapsed State from localStorage ─────
  const isCollapsed = localStorage.getItem('sidebar-collapsed') === 'true';
  if (isCollapsed) {
    document.body.classList.add('sidebar-collapsed');
  }

  // ── Sidebar Toggle Functionality ───────────────────────────
  const toggleButtons = document.querySelectorAll('.sidebar-toggle-btn, #sidebar-toggle');
  toggleButtons.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      if (window.innerWidth <= 768) {
        document.body.classList.toggle('sidebar-mobile-open');
      } else {
        document.body.classList.toggle('sidebar-collapsed');
        const collapsedNow = document.body.classList.contains('sidebar-collapsed');
        localStorage.setItem('sidebar-collapsed', collapsedNow ? 'true' : 'false');
      }
    });
  });

  // Close mobile sidebar when clicking outside
  document.addEventListener('click', (e) => {
    if (window.innerWidth <= 768 && document.body.classList.contains('sidebar-mobile-open')) {
      const sidebar = document.querySelector('.sidebar');
      const isToggleClick = Array.from(toggleButtons).some(btn => btn.contains(e.target));
      if (sidebar && !sidebar.contains(e.target) && !isToggleClick) {
        document.body.classList.remove('sidebar-mobile-open');
      }
    }
  });

  // ── Flash message auto-dismiss ──────────────────────────────
  document.querySelectorAll('.flash-alert').forEach(el => {
    setTimeout(() => {
      el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
      el.style.opacity    = '0';
      el.style.transform  = 'translateY(-8px)';
      setTimeout(() => el.remove(), 500);
    }, 5000);
  });

  // ── Animate marks bars if any ────────────────────────────────
  document.querySelectorAll('.marks-bar-fill').forEach(bar => {
    const pct = parseFloat(bar.dataset.pct || 0);
    bar.style.width = '0';
    requestAnimationFrame(() => {
      bar.style.width = Math.min(pct, 100) + '%';
    });
  });

  // ── Global Modal Delete Confirmation ────────────────────────
  let targetFormToDelete = null;
  const deleteModalEl = document.getElementById('globalDeleteModal');
  let deleteBsModal = null;

  document.querySelectorAll('.btn-confirm-delete').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const form = btn.closest('form');
      if (!form) return;
      targetFormToDelete = form;
      const itemName = btn.dataset.name || 'ဤအချက်အလက်';
      const targetNameEl = document.getElementById('globalDeleteTargetName');
      if (targetNameEl) {
        targetNameEl.textContent = itemName;
      }
      if (deleteModalEl && typeof bootstrap !== 'undefined') {
        if (!deleteBsModal) {
          deleteBsModal = bootstrap.Modal.getOrCreateInstance(deleteModalEl);
        }
        deleteBsModal.show();
      } else if (confirm(`Are you sure you want to delete ${itemName}?`)) {
        form.submit();
      }
    });
  });

  const confirmDeleteBtn = document.getElementById('globalConfirmDeleteBtn');
  if (confirmDeleteBtn) {
    confirmDeleteBtn.addEventListener('click', () => {
      if (targetFormToDelete) {
        targetFormToDelete.submit();
      }
    });
  }

  // ── Form validation feedback ────────────────────────────────
  document.querySelectorAll('form[data-validate]').forEach(form => {
    form.addEventListener('submit', (e) => {
      if (!form.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
      }
      form.classList.add('was-validated');
    });
  });

  // ── Marks validation: marks cannot exceed totalMarks ────────
  const marksInput = document.getElementById('marks');
  const totalInput = document.getElementById('totalMarks');
  if (marksInput && totalInput) {
    function validateMarks() {
      const m = parseFloat(marksInput.value);
      const t = parseFloat(totalInput.value);
      if (!isNaN(m) && !isNaN(t) && m > t) {
        marksInput.setCustomValidity('Marks cannot exceed total marks.');
      } else if (!isNaN(m) && m < 0) {
        marksInput.setCustomValidity('Marks cannot be negative.');
      } else {
        marksInput.setCustomValidity('');
      }
    }
    marksInput.addEventListener('input', validateMarks);
    totalInput.addEventListener('input', validateMarks);
  }

  // ── Password confirmation validation ────────────────────────
  const pw1 = document.getElementById('password');
  const pw2 = document.getElementById('confirmPassword');
  if (pw1 && pw2) {
    pw2.addEventListener('input', () => {
      if (pw2.value !== pw1.value) {
        pw2.setCustomValidity('Passwords do not match.');
      } else {
        pw2.setCustomValidity('');
      }
    });
  }
});
