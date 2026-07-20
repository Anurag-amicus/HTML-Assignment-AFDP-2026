import { $, $$ } from './dom.js';
import { validators } from './validation.js';
import { attributesApi } from './attributes.js';
import { storage } from './storage.js';

export const initForm = () => {
  const form = $('form');
  if (!form) return;

  const errorSummary = $('#form-error-summary');
  const touched = new Set();
  const currentId = $('input[name="id"]')?.value;

  // Polyfill for error summary focus via tabindex
  errorSummary.tabIndex = -1;

  const validateField = (input) => {
    const name = input.name;
    let value = input.value;
    if (input.type === 'radio') {
      const checked = $(`input[name="${name}"]:checked`);
      value = checked ? checked.value : '';
    }
    
    let error = null;
    const allAttr = attributesApi.getAll();
    const currentBu = $('#attr-bu')?.value;
    const validLocs = storage.get('locations')?.filter(l => l.businessUnitId === currentBu);

    switch(name) {
      case 'attributeName': error = validators.attributeName(value, allAttr, currentId, currentBu); break;
      case 'businessUnit': error = validators.businessUnit(value); break;
      case 'customerLocation': error = validators.customerLocation(value, validLocs); break;
      case 'company': error = validators.company(value); break;
      case 'createdOn': error = validators.createdOn(value); break;
      case 'notes': error = validators.notes(value); break;
    }

    const errorSpan = $(`#${input.id}-error`);
    const fieldContainer = input.closest('.form-field');
    
    if (error) {
      if (errorSpan) errorSpan.textContent = error;
      fieldContainer?.classList.add('form-field--invalid');
      input.setAttribute('aria-invalid', 'true');
    } else {
      if (errorSpan) errorSpan.textContent = '';
      fieldContainer?.classList.remove('form-field--invalid');
      input.setAttribute('aria-invalid', 'false');
    }
    
    // Get label text ignoring visually hidden elements if necessary, simplified for now
    let label = $(`label[for="${input.id}"]`)?.textContent;
    if(!label && input.type === 'radio') label = 'Status';

    return error ? { id: input.id, label: label, error } : null;
  };

  const inputs = $$('input, select, textarea', form);

  inputs.forEach(input => {
    if (input.type === 'hidden') return;
    
    input.addEventListener('blur', () => {
      touched.add(input.name);
      validateField(input);
    });

    input.addEventListener('input', () => {
      if (input.name === 'notes') {
         const hint = $('#attr-notes-hint');
         if (hint) {
           hint.textContent = `${input.value.length} / 500 characters`;
         }
      }
      if (touched.has(input.name)) {
        validateField(input);
      }
    });
  });

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const errors = [];
    
    inputs.forEach(input => {
      if (input.type === 'hidden') return;
      touched.add(input.name);
      const err = validateField(input);
      if (err) errors.push(err);
    });

    if (errors.length > 0) {
      errorSummary.innerHTML = `
        <h3 class="alert-heading">There is a problem</h3>
        <ul class="alert-list">
          ${errors.map(err => `<li><a href="#${err.id}">${err.label}: ${err.error}</a></li>`).join('')}
        </ul>
      `;
      errorSummary.hidden = false;
      errorSummary.focus();
      return;
    }

    // Success
    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());
    data.isActive = data.isActive === 'true';
    if (currentId) data.id = currentId;

    attributesApi.save(data);
    window.location.href = `index.html?msg=${currentId ? 'updated' : 'created'}`;
  });
};
