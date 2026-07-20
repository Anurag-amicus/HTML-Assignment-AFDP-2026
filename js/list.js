import { $, $$, createEl, fragment } from './dom.js';
import { attributesApi } from './attributes.js';
import { storage } from './storage.js';
import { formatAbsoluteDate, formatRelativeTime } from './dateUtils.js';

let abortController = null;
const PAGE_SIZE = 5;

const state = {
  page: 1,
  sortCol: null,
  sortDir: 'none',
  filter: {
    q: '',
    bu: '',
    status: ''
  }
};

const toastMap = new Map();

const showToast = (message, type = 'success') => {
  let container = $('#toast-container');
  if (!container) {
    container = createEl('div', { id: 'toast-container', className: 'toast-container' });
    document.body.appendChild(container);
  }

  const toastId = Date.now();
  const toast = createEl('div', { className: `toast toast--${type}`, role: 'status' }, message);
  container.appendChild(toast);

  const timer = setTimeout(() => {
    toast.remove();
    toastMap.delete(toastId);
  }, 3000);
  
  toastMap.set(toastId, timer);
};

const getFilteredAndSorted = async () => {
  if (abortController) {
    abortController.abort();
  }
  abortController = new AbortController();
  const signal = abortController.signal;

  try {
    return await new Promise((resolve, reject) => {
      setTimeout(() => {
        if (signal.aborted) {
          return reject(new DOMException('Aborted', 'AbortError'));
        }
        
        let data = attributesApi.getAll();
        
        if (state.filter.q) {
          const q = state.filter.q.toLowerCase();
          data = data.filter(a => a.attributeName.toLowerCase().includes(q));
        }
        if (state.filter.bu) {
          data = data.filter(a => a.businessUnitId === state.filter.bu);
        }
        if (state.filter.status) {
          const isActive = state.filter.status === 'active';
          data = data.filter(a => a.isActive === isActive);
        }

        if (state.sortCol && state.sortDir !== 'none') {
          data.sort((a, b) => {
            let valA = a[state.sortCol];
            let valB = b[state.sortCol];
            let comp = 0;
            if (typeof valA === 'string') {
               comp = valA.localeCompare(valB);
            } else if (typeof valA === 'boolean') {
               comp = (valA === valB) ? 0 : valA ? -1 : 1;
            } else {
               comp = valA < valB ? -1 : valA > valB ? 1 : 0;
            }
            return state.sortDir === 'ascending' ? comp : -comp;
          });
        }

        resolve(data);
      }, 300);
    });
  } catch (error) {
    if (error.name !== 'AbortError') {
      console.error(error);
    }
    throw error;
  }
};

const renderTable = (data) => {
  const tbody = $('tbody');
  if(!tbody) return;
  tbody.innerHTML = '';
  const frag = fragment();
  
  const start = (state.page - 1) * PAGE_SIZE;
  const end = start + PAGE_SIZE;
  const pagedData = data.slice(start, end);

  const bus = storage.get('businessUnits') || [];
  const locs = storage.get('locations') || [];
  const companies = storage.get('companies') || [];

  pagedData.forEach(item => {
    const bu = bus.find(b => b.id === item.businessUnitId)?.name || item.businessUnitId;
    const loc = locs.find(l => l.id === item.customerLocationId)?.name || item.customerLocationId;
    const comp = companies.find(c => c.id === item.companyId)?.name || item.companyId;

    const tr = createEl('tr', { className: `attribute-card ${!item.isActive ? 'attribute-card--inactive' : ''}` });
    
    tr.appendChild(createEl('td', { 'data-label': 'ID' }, item.id));

    const thName = createEl('th', { scope: 'row', id: `attr-${item.id}`, className: 'attribute-card__title', 'data-label': 'Attribute Name' }, item.attributeName);
    tr.appendChild(thName);
    
    tr.appendChild(createEl('td', { 'data-label': 'Business Unit' }, bu));
    tr.appendChild(createEl('td', { 'data-label': 'Location' }, loc));
    tr.appendChild(createEl('td', { 'data-label': 'Company' }, comp));
    
    const createdCell = createEl('td', { 'data-label': 'Created On' });
    createdCell.innerHTML = `${formatAbsoluteDate(item.createdOn)} <br><small>(${formatRelativeTime(item.createdOn)})</small>`;
    tr.appendChild(createdCell);

    const statusCell = createEl('td', { 'data-label': 'Status' });
    const badge = createEl('span', { role: 'status', className: `badge badge--${item.isActive ? 'active' : 'inactive'}` }, item.isActive ? 'Active' : 'Inactive');
    statusCell.appendChild(badge);
    tr.appendChild(statusCell);

    const actionCell = createEl('td', { headers: `col-actions attr-${item.id}`, className: 'attribute-actions', 'data-label': 'Actions' });
    const editLink = createEl('a', { href: `edit-attribute.html?id=${item.id}`, className: 'btn btn--ghost btn--sm', 'aria-describedby': `attr-${item.id}` }, 'Edit');
    const delBtn = createEl('button', { type: 'button', className: 'btn btn--danger btn--icon btn--sm', 'aria-describedby': `attr-${item.id}` });
    delBtn.innerHTML = `<span class="sr-only">Delete Attribute</span> 🗑️`;
    delBtn.addEventListener('click', () => {
      if (confirm(`Are you sure you want to delete '${item.attributeName}'?`)) {
        attributesApi.remove(item.id);
        showToast(`Deleted Attribute '${item.attributeName}'`);
        updateList();
      }
    });

    actionCell.appendChild(editLink);
    actionCell.appendChild(delBtn);
    tr.appendChild(actionCell);

    frag.appendChild(tr);
  });

  tbody.appendChild(frag);

  const liveRegion = $('#results-status');
  if (liveRegion) {
    liveRegion.innerHTML = `<p>Showing ${data.length} records. Page ${state.page} of ${Math.ceil(data.length / PAGE_SIZE) || 1}.</p>`;
  }

  const statTotal = $('#stat-total');
  const statActive = $('#stat-active');
  if (statTotal && statActive) {
    statTotal.textContent = `Total Tracked Attributes: ${data.length}`;
    statActive.textContent = `Operational Active States: ${data.filter(item => item.isActive).length}`;
  }
};

const renderPagination = (totalItems) => {
  const totalPages = Math.ceil(totalItems / PAGE_SIZE) || 1;
  let paginationContainer = $('#pagination-controls');
  if (!paginationContainer) {
    paginationContainer = createEl('div', { id: 'pagination-controls', className: 'pagination' });
    $('table')?.after(paginationContainer);
  }
  paginationContainer.innerHTML = '';

  const prev = createEl('button', { className: 'btn btn--ghost btn--page', disabled: state.page === 1 }, 'Prev');
  prev.addEventListener('click', () => {
    if (state.page > 1) { state.page--; updateList(); }
  });
  paginationContainer.appendChild(prev);

  for (let i = 1; i <= totalPages; i++) {
    const btn = createEl('button', { 
      className: `btn btn--page ${state.page === i ? 'btn--primary' : 'btn--ghost'}`,
      'aria-current': state.page === i ? 'page' : undefined,
      'aria-label': `Page ${i}`
    }, i);
    btn.addEventListener('click', () => {
      state.page = i;
      updateList();
    });
    paginationContainer.appendChild(btn);
  }

  const next = createEl('button', { className: 'btn btn--ghost btn--page', disabled: state.page === totalPages }, 'Next');
  next.addEventListener('click', () => {
    if (state.page < totalPages) { state.page++; updateList(); }
  });
  paginationContainer.appendChild(next);
};

const updateList = async () => {
  try {
    const data = await getFilteredAndSorted();
    renderTable(data);
    renderPagination(data.length);
  } catch (error) {
    if (error.name === 'AbortError') return;
  }
};

export const initList = () => {
  const table = $('table');
  if (!table) return;

  const params = new URLSearchParams(window.location.search);
  
  if (params.get('q')) state.filter.q = params.get('q');
  if (params.get('bu')) state.filter.bu = params.get('bu');
  if (params.get('status')) state.filter.status = params.get('status');
  
  const searchInput = $('#search-term');
  const buFilter = $('#filter-bu');
  const statusFilter = $('#filter-status');
  if(searchInput) searchInput.value = state.filter.q;
  if(buFilter) buFilter.value = state.filter.bu;
  if(statusFilter) statusFilter.value = state.filter.status;

  updateList();

  const msg = params.get('msg');
  if (msg) {
    showToast(`Attribute successfully ${msg}!`);
    params.delete('msg');
    const newUrl = window.location.pathname + (params.toString() ? '?' + params.toString() : '');
    history.replaceState(null, '', newUrl);
  }

  let debounceTimer;
  searchInput?.addEventListener('input', (e) => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      state.filter.q = e.target.value;
      state.page = 1;
      updateURL();
      updateList();
    }, 300);
  });

  const onSelectChange = (e, key) => {
    state.filter[key] = e.target.value;
    state.page = 1;
    updateURL();
    updateList();
  };
  buFilter?.addEventListener('change', (e) => onSelectChange(e, 'bu'));
  statusFilter?.addEventListener('change', (e) => onSelectChange(e, 'status'));

  const updateURL = () => {
    const p = new URLSearchParams();
    if (state.filter.q) p.set('q', state.filter.q);
    if (state.filter.bu) p.set('bu', state.filter.bu);
    if (state.filter.status) p.set('status', state.filter.status);
    const newUrl = window.location.pathname + (p.toString() ? '?' + p.toString() : '');
    history.replaceState(null, '', newUrl);
  };

  $('form[role="search"]')?.addEventListener('submit', (e) => e.preventDefault());

  const thead = $('thead');
  thead?.addEventListener('click', (e) => {
    const th = e.target.closest('th');
    if (!th || !th.hasAttribute('aria-sort')) return;
    
    $$('th[aria-sort]').forEach(el => {
      if (el !== th) el.setAttribute('aria-sort', 'none');
    });

    const currentSort = th.getAttribute('aria-sort');
    let nextSort = 'ascending';
    if (currentSort === 'ascending') nextSort = 'descending';
    else if (currentSort === 'descending') nextSort = 'none';

    th.setAttribute('aria-sort', nextSort);
    state.sortDir = nextSort;
    
    const idMap = {
      'col-id': 'id',
      'col-name': 'attributeName',
      'col-bu': 'businessUnitId',
      'col-loc': 'customerLocationId',
      'col-company': 'companyId',
      'col-created': 'createdOn',
      'col-status': 'isActive'
    };
    state.sortCol = nextSort === 'none' ? null : idMap[th.id];
    
    updateList();
  });
};
