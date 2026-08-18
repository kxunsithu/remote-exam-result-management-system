/* app.js — Remote Exam Result Management System */
'use strict';

// ── Flash message auto-dismiss ───────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  // Auto-dismiss flash alerts after 5 seconds
  document.querySelectorAll('.flash-alert').forEach(el => {
    setTimeout(() => {
      el.style.transition = 'opacity .5s, transform .5s';
      el.style.opacity    = '0';
      el.style.transform  = 'translateY(-8px)';
      setTimeout(() => el.remove(), 500);
    }, 5000);
  });

  // Sidebar mobile toggle
  const toggleBtn = document.getElementById('sidebar-toggle');
  const sidebar   = document.querySelector('.sidebar');
  if (toggleBtn && sidebar) {
    toggleBtn.addEventListener('click', () => sidebar.classList.toggle('open'));
    document.addEventListener('click', (e) => {
      if (!sidebar.contains(e.target) && e.target !== toggleBtn) {
        sidebar.classList.remove('open');
      }
    });
  }

  // Animate marks bars
  document.querySelectorAll('.marks-bar-fill').forEach(bar => {
    const pct = parseFloat(bar.dataset.pct || 0);
    bar.style.width = '0';
    requestAnimationFrame(() => {
      bar.style.width = Math.min(pct, 100) + '%';
    });
  });

  // Confirmation dialogs for delete
  document.querySelectorAll('.btn-confirm-delete').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const name = btn.dataset.name || 'this record';
      if (!confirm(`Are you sure you want to delete ${name}?\nThis action cannot be undone.`)) {
        e.preventDefault();
      }
    });
  });

  // Form validation feedback
  document.querySelectorAll('form[data-validate]').forEach(form => {
    form.addEventListener('submit', (e) => {
      if (!form.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
      }
      form.classList.add('was-validated');
    });
  });

  // Marks validation: marks cannot exceed totalMarks
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

  // Password confirmation validation
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

  // Edit modal pre-fill (Bootstrap 5)
  const editModal = document.getElementById('editModal');
  if (editModal) {
    editModal.addEventListener('show.bs.modal', (event) => {
      const btn = event.relatedTarget;
      if (!btn) return;
      const data = btn.dataset;
      editModal.querySelectorAll('[data-field]').forEach(el => {
        const field = el.dataset.field;
        if (data[field] !== undefined) el.value = data[field];
      });
    });
  }
});

/* Grade badge helper (used in JS-rendered content if any) */
function gradeBadgeClass(grade) {
  const map = { 'A+': 'grade-aplus', 'A': 'grade-a', 'B+': 'grade-bplus',
                'B': 'grade-b', 'C+': 'grade-cplus', 'C': 'grade-c',
                'D': 'grade-d', 'F': 'grade-f' };
  return map[grade] || 'grade-f';
}
