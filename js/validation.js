export const validators = {
  attributeName: (value, allAttributes, currentId, currentBu) => {
    if (!value) return "Attribute Name is required.";
    if (value.length < 3 || value.length > 100) return "Must be 3-100 characters.";
    if (!/^[a-zA-Z0-9 _-]+$/.test(value)) return "Only letters, numbers, spaces, _, - allowed.";
    if (currentBu) {
      const duplicate = allAttributes.find(a => 
        a.attributeName.toLowerCase() === value.toLowerCase() &&
        a.businessUnitId === currentBu &&
        String(a.id) !== String(currentId)
      );
      if (duplicate) return "Attribute name must be unique within the Business Unit.";
    }
    return null;
  },
  businessUnit: (value) => {
    if (!value) return "Business Unit is required.";
    return null;
  },
  customerLocation: (value, validLocationsForBu) => {
    if (!value) return "Location is required.";
    if (validLocationsForBu && !validLocationsForBu.find(l => l.id === value)) {
      return "Location does not belong to selected Business Unit.";
    }
    return null;
  },
  company: (value) => {
    if (!value) return "Company is required.";
    return null;
  },
  createdOn: (value) => {
    if (!value) return "Creation Date is required.";
    const selectedDate = new Date(value);
    const today = new Date();
    today.setHours(23, 59, 59, 999);
    if (selectedDate > today) return "Creation Date cannot be in the future.";
    return null;
  },
  notes: (value) => {
    if (value && value.length > 500) return "Notes must be under 500 characters.";
    return null;
  }
};
