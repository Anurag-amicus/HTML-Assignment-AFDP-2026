import { storage } from './storage.js';

export const attributesApi = {
  getAll() {
    return storage.get('attributes') || [];
  },
  getById(id) {
    return this.getAll().find(a => String(a.id) === String(id)) || null;
  },
  save(attribute) {
    const all = this.getAll();
    if (attribute.id) {
      const index = all.findIndex(a => String(a.id) === String(attribute.id));
      if (index !== -1) {
        all[index] = { ...all[index], ...attribute, updatedOn: new Date().toISOString() };
      } else {
        all.push(attribute);
      }
    } else {
      const maxId = all.length > 0 ? Math.max(...all.map(a => parseInt(a.id) || 0)) : 0;
      attribute.id = (maxId + 1).toString();
      attribute.createdOn = new Date().toISOString();
      all.push(attribute);
    }
    storage.set('attributes', all);
    return attribute.id;
  },
  remove(id) {
    let all = this.getAll();
    all = all.filter(a => String(a.id) !== String(id));
    storage.set('attributes', all);
  },
  search(query, allData) {
    if (!query) return allData;
    const q = query.toLowerCase();
    return allData.filter(a => 
      a.attributeName.toLowerCase().includes(q)
    );
  }
};
