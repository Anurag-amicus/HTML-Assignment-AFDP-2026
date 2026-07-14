# BUGS and FIXES

### Bug A: Fake Buttons (`<div role="button" onclick="...">`)

* **Observation:** When tabbing through the page, the keyboard focus completely skips the `<div>` because it is not inherently focusable.

* **Fix:** Replaced the `<div>` with a native `<button type="button">`. This automatically provides keyboard focusability and native 'Enter'/'Space' activation without needing extra JavaScript.
 
### Bug B: Icon-Only Buttons (e.g., `<button>🗑️</button>`)

* **Observation:** A sighted user sees a trash can and knows it means "Delete". However, a screen reader just announces "Button" or attempts to read the unicode character name, providing zero context about what the button actually does. 

* **Fix:** Added a visually hidden span inside the button: `<button><span class="sr-only">Delete Attribute</span> 🗑️</button>`. The screen reader now reads the text, while sighted users still only see the icon.
 
### Bug C: Multiple `<h1>` Elements on a Single Page

* **Observation:** Lighthouse doesnot flag multiple `<h1>` tags.

* **Fix:** There is no fix needed
 
### Bug D: Unassociated Labels (`<label>Attribute Name</label><input type="text">`)
* **Observation:** Because the label lacks a `for` attribute matching the input's `id`, they are programmatically detached. Clicking the text of the label does not focus the text box, reducing the clickable hit-area for mouse/touch users. Screen readers also fail to announce the label when the input receives focus.

* **Fix:** Added `for="attr-name"` to the `<label>` and `id="attr-name"` to the `<input>` so clicking the label now instantly focuses on the input field.
 