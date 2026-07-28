import { initializeSeedData } from './storage.js';
import { initTheme } from './theme.js';
import { initList } from './list.js';
import { initLookups } from './lookups.js';
import { initForm } from './forms.js';
import { attributesApi } from './attributes.js';

const boot = async () => {
  initTheme();
  
  const mainEl = document.querySelector('main');
  const loading = document.createElement('div');
  loading.textContent = 'Loading...';
  loading.className = 'loading-banner';
  
  if (mainEl) mainEl.insertAdjacentElement('afterbegin', loading);

  try {
    await initializeSeedData();
    loading.remove();
  } catch(e) {
    loading.remove();
    if (mainEl) {
      mainEl.insertAdjacentHTML('afterbegin', '<div class="banner banner--error" style="color:red; padding:1rem;">Failed to load initial data. <button onclick="location.reload()">Retry</button></div>');
    }
  }

  if (document.querySelector('table.table')) {
    initList();
  } else if (document.querySelector('form[action="#"]') || document.querySelector('form[action="/update-attribute"]')) {
    const params = new URLSearchParams(window.location.search);
    const id = params.get('id');
    if (id) {
       const attr = attributesApi.getById(id);
       if (attr) {
          document.querySelector('#attribute-name').value = attr.attributeName;
          
          const bu = document.querySelector('#attribute-business-unit');
          if(bu) {
            bu.value = attr.businessUnitId;
            bu.setAttribute('data-value', attr.businessUnitId);
          }
          
          const loc = document.querySelector('#attribute-location');
          if(loc) loc.setAttribute('data-value', attr.customerLocationId);

          const comp = document.querySelector('#attribute-company');
          if(comp) comp.setAttribute('data-value', attr.companyId);

          const statusAct = document.querySelector('#status-active');
          const statusInact = document.querySelector('#status-inactive');
          if(statusAct) statusAct.checked = attr.isActive;
          if(statusInact) statusInact.checked = !attr.isActive;

          const dateField = document.querySelector('#attribute-date');
          if(dateField) dateField.value = attr.createdOn ? attr.createdOn.split('T')[0] : '';
          
          const notesField = document.querySelector('#attribute-notes');
          if(notesField) notesField.value = attr.notes || '';
          
          const idField = document.querySelector('input[name="id"]');
          if(idField) idField.value = attr.id;
       }
    }
    initLookups();
    initForm();
  }
};

document.addEventListener('DOMContentLoaded', boot);

