import { storage } from './storage.js';

export const initTheme = () => {
  const toggleBtn = document.querySelector('#theme-toggle');
  if (!toggleBtn) return;

  const currentTheme = storage.get('theme');
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

  const applyTheme = (theme) => {
    document.documentElement.setAttribute('data-theme', theme);
  };

  if (currentTheme) {
    applyTheme(currentTheme);
  } else {
    applyTheme(prefersDark.matches ? 'dark' : 'light');
  }

  toggleBtn.addEventListener('click', () => {
    const newTheme = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    applyTheme(newTheme);
    storage.set('theme', newTheme);
  });

  prefersDark.addEventListener('change', (e) => {
    if (!storage.get('theme')) {
      applyTheme(e.matches ? 'dark' : 'light');
    }
  });
};
