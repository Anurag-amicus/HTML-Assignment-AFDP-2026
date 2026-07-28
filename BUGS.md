# BUGS and FIXES

# Assignment 1

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
 

# Assignment 2

## Bug A — Absolute Positioning Without a Positioned Ancestor
 
### Problem
 
A `.toast` element was given:
```css
.toast {
  position: absolute;
  top: 1rem;
  right: 1rem;
}
```
 
but none of its parent elements had a positioning context.
 
### Observed Behaviour
 
The toast appeared relative to the viewport instead of the intended container, causing it to overlap unrelated page content.
 
### Fix
 
```css
.parent-container {
  position: relative;
}
```
 
or alternatively:
 
```css
.toast {
  position: fixed;
}
```
 
if the toast should remain attached to the viewport.
 
### Why It Happened
 
An absolutely positioned element uses its nearest positioned ancestor as its containing block. When no ancestor has a position value other than `static`, the browser falls back to positioning relative to the viewport.
 
---
 
## Bug B — z-index Has No Effect
 
### Problem
 
The following style was applied:
 
```css
.box {
  z-index: 999;
}
```
 
but the element continued appearing behind other content.
 
### Observed Behaviour
 
Changing the `z-index` value had no visible effect.
 
### Fix
 
```css
.box {
  position: relative;
  z-index: 999;
}
```
 
### Why It Happened
 
The `z-index` property only works on positioned elements or elements that create their own stacking context. Since the element had the default `position: static`, the browser ignored the z-index value.
 
### Conditions That Create a Stacking Context
 
Examples include:
 
```css
position: relative;
position: absolute;
position: fixed;
position: sticky;
opacity: 0.99;
transform: translateX(0);
filter: blur(0);
isolation: isolate;
```
 
---
 
## Bug C — Margin Collapsing
 
### Problem
 
A child element's top margin appeared outside its parent container.
 
Example:
 
```css
.parent {
  background: white;
}
 
.child {
  margin-top: 2rem;
}
```
 
### Observed Behaviour
 
The spacing appeared above the parent rather than inside it.
 
### Fix Option 1
 
```css
.parent {
  padding-top: 1px;
}
```
 
### Fix Option 2
 
```css
.parent {
  border-top: 1px solid transparent;
}
```
 
### Fix Option 3 (Preferred)
 
```css
.parent {
  display: flow-root;
}
```
 
### Why `flow-root` Is Preferred
 
`flow-root` creates a new block formatting context without introducing visual side effects. Unlike padding or borders, it solves the margin-collapsing issue while preserving the intended appearance of the layout.
 
---
 
## Bug D — Flex Child Overflow
 
### Problem
 
A flex item containing a long string overflowed its container.
 
Example:
 
```css
.container {
  display: flex;
}
 
.item {
  flex: 1;
}
```
 
### Observed Behaviour
 
Long text extended beyond the container boundary and broke the layout.
 
### Root Cause
 
Flex items default to:
 
```css
min-width: auto;
```
 
which prevents them from shrinking below the width of their content.
 
### Fix
 
```css
.item {
  min-width: 0;
}
```
 
### Why It Works
 
Setting `min-width: 0` allows the flex item to shrink within the available space. This enables proper text wrapping, truncation, or overflow handling and prevents layout breakage.
 
---
 
## Key Lessons Learned
 
1. Absolute positioning requires a positioned ancestor to establish a containing block.
2. `z-index` only works within valid stacking contexts.
3. Margin collapsing is a normal CSS behavior and can be controlled using block formatting contexts such as `flow-root`.
4. Flexbox layouts often require `min-width: 0` to prevent content overflow.
 
Understanding these behaviors improves debugging efficiency and leads to more predictable CSS layouts.

# Assignment 3

## Bugs A

### Observation

  * Using var-
    It prints
    3
    3
    3
  ![image](assets/devtools/final%20audit/var.png)

### Fix

  * Using let-
    It Prints
    0
    1
    2
  ![image](assets/devtools/final%20audit/let.png)


Using var creates one shared variable for all loop iterations, so every callback prints the final value. Using let creates a new variable for each iteration, so every callback keeps the correct value.

## Bugs B

### Observation

  In the console we see something like
  `<button id="btn">Add Row</button>`
    NaN
  ![image](assets/devtools/final%20audit/BugsB.png)

### Fix 

  * Method 1: Change the constructor

        class Table {
        constructor() {
            this.count = 0;
            this.addRow = this.addRow.bind(this)
        }
        addRow() {
            this.count++;
            console.log(this);
            console.log(this.count);
        }
    }

  * Method 2: Arrow function

          addRow = () => {
          this.count++
          console.log(this)
          console.log(this.count)
          }

## Bugs C

### Observation
  When forgetting json.parse
  ![image](assets/devtools/final%20audit/BugsC.png)

### Fix
  After using json.parse()
  ![image](assets/devtools/final%20audit/BugsC2.png)

## Bugs D

### Demo
  ![image](assets/devtools/final%20audit/BugsD.png)

### Fix

  ![image](assets/devtools/final%20audit/BugsD2.png)

## Bugs E

### Without abort controller for scollY event listner

        // 1. Define the handler function
        function handleScroll() {
          const scrollY = window.scrollY;
          console.log('Current Scroll Y:', scrollY);
        }

        // 2. Attach the listener
        window.addEventListener('scroll', handleScroll);

        // 3. Remove the listener later when needed
        // (e.g., when a component unmounts or a user clicks a button)
        function stopTrackingScroll() {
          window.removeEventListener('scroll', handleScroll);
          console.log('Scroll listener removed.');
        }

  ![image](assets/devtools/final%20audit/BugsE.png)

### With abort controller

        // 1. Create AbortController
        const controller = new AbortController();
        const { signal } = controller;

        // 2. Add scroll listener
        window.addEventListener(
          'scroll',
          () => {
            const scrollY = window.scrollY;
            console.log('Current Scroll Y:', scrollY);

            // Abort when scroll exceeds 300px
            if (scrollY > 300) {
              controller.abort();
              console.log('Scroll listener aborted at:', scrollY);
            }
          },
          { signal }
        );

  ![image](assets/devtools/final%20audit/BugsE2.png)


## Task 18

![alt text](assets/devtools/final%20audit/t18.png)