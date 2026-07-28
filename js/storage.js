const NAMESPACE = 'ams.';

export const storage = {
  get(key) {
    try {
      const item = localStorage.getItem(`${NAMESPACE}${key}`);
      return item ? JSON.parse(item) : null;
    } catch (e) {
      console.error(`Error reading ${key} from storage`, e);
      return null;
    }
  },
  set(key, value) {
    try {
      localStorage.setItem(`${NAMESPACE}${key}`, JSON.stringify(value));
    } catch (e) {
      console.error(`Error writing ${key} to storage`, e);
    }
  },
  remove(key) {
    localStorage.removeItem(`${NAMESPACE}${key}`);
  }
};

export const initializeSeedData = async () => {
  if (storage.get('seedVersion') === '1.0') {
    return; // Already seeded
  }

  try {
    const urls = [
      './data/attributes.json',
      './data/businessUnits.json',
      './data/locations.json',
      './data/companies.json'
    ];
    
    const responses = await Promise.all(urls.map(url => fetch(url)));
    
    responses.forEach((res, index) => {
      if (!res.ok) throw new Error(`Failed to fetch ${urls[index]}: ${res.status}`);
    });
    
    const [attributes, businessUnits, locations, companies] = await Promise.all(
      responses.map(res => res.json())
    );

    storage.set('attributes', attributes);
    storage.set('businessUnits', businessUnits);
    storage.set('locations', locations);
    storage.set('companies', companies);
    storage.set('seedVersion', '1.0');

  } catch (error) {
    console.error("Failed to initialize seed data", error);
    throw error;
  }
};


export const reset = async () => {
  try {
    storage.remove('attributes');
    storage.remove('businessUnits');
    storage.remove('locations');
    storage.remove('companies');
    storage.remove('seedVersion');

    await initializeSeedData();

    console.log("Storage has been reset successfully.");
  } catch (error) {
    console.error("Failed to reset storage", error);
  }
};
