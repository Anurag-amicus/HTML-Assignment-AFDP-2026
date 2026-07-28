export const $ = (selector, context = document) => context.querySelector(selector);
export const $$ = (selector, context = document) => context.querySelectorAll(selector);
export const on = (element, type, handler, options) => {
  if (element) {
    element.addEventListener(type, handler, options);
  }
};
export const createEl = (tag, attributes = {}, ...children) => {
  const el = document.createElement(tag);
  Object.entries(attributes).forEach(([key, value]) => {
    if (key.startsWith('data-')) el.setAttribute(key, value);
    else if (key === 'className') el.className = value;
    else if (key === 'htmlFor') el.htmlFor = value;
    else if (key === 'aria-label') el.setAttribute('aria-label', value);
    else if (key === 'aria-sort') el.setAttribute('aria-sort', value);
    else if (key === 'aria-describedby') el.setAttribute('aria-describedby', value);
    else el[key] = value;
  });
  children.forEach(child => {
    if (typeof child === 'string' || typeof child === 'number') {
      el.appendChild(document.createTextNode(child));
    } else if (child instanceof Node) {
      el.appendChild(child);
    }
  });
  return el;
};
export const fragment = () => document.createDocumentFragment();
