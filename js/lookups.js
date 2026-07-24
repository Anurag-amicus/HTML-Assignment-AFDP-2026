import { storage } from './storage.js';
import { $ } from './dom.js';

export const initLookups = () => {
  const buSelect = $('#attribute-business-unit');
  const locSelect = $('#attribute-location');
  const companySelect = $('#attribute-company');

  if (!buSelect || !locSelect || !companySelect) return;

  const bus = storage.get('businessUnits') || [];
  const locs = storage.get('locations') || [];
  const companies = storage.get('companies') || [];

  const populateSelect = (selectEl, data, placeholder) => {
    const currentValue = selectEl.getAttribute('data-value') || selectEl.value;
    selectEl.innerHTML = `<option value="">${placeholder}</option>`;
    data.forEach(item => {
      const option = document.createElement('option');
      option.value = item.id;
      option.textContent = item.name;
      selectEl.appendChild(option);
    });
    if (currentValue) selectEl.value = currentValue;
  };

  populateSelect(buSelect, bus, 'Select a Department...');
  populateSelect(companySelect, companies, 'Select a Company...');

  const updateLocations = () => {
    const buId = buSelect.value;
    if (!buId) {
      locSelect.innerHTML = `<option value="">Select a Business Unit first</option>`;
      locSelect.disabled = true;
    } else {
      const filteredLocs = locs.filter(l => l.businessUnitId === buId);
      populateSelect(locSelect, filteredLocs, 'Select a Location...');
      locSelect.disabled = false;
    }
  };

  buSelect.addEventListener('change', () => {
    locSelect.value = ''; // Clear value on bu change
    updateLocations();
  });

  // Init locations on load
  updateLocations();
};
