# AFDP 2026 Batch

Name - Anurag Chandra
Training - Path 2

# HTML Assignment

## Task 1

![Html Image](assets/image%201.png)

### Why does the order of `<meta charset>` matter ?

    The browser must see the character encoding within the first 1024 bytes ot the HTML
    document. If it is placed after any title and description, the browser might use default
    encoding and it might start rendering in that default encoding and when it sees the charset
    lower down in the document, re-renders the page using the mentioned encoding which
    eventually slows down the page and cause performance and issue or glitchy start.

### What does `<meta name = "theme-color">` control on mobile devices ?

    This tag controls browsers'UI for that website like it can control and affect address bar
    and tab management border etc but only on mobile as it doesn't usually affect browsing in
    desktop and it is only temporary while browsing the website only and in mobile only.

## Task 2 & 4

### When does `<section>` need an accessible name (aria-labelledby or aria-label) to register as a landmark?

By default, a `<section>` is treated as a generic structural block, but to be formally recognized as a navigable "Region Landmark" by assistive technologies, it must be given an accessible name, typically by linking it to its inner heading using `aria-labelledby="..."`.

### What functional issues does a top-level skip-link solve?

A skip-link solves navigation fatigue. Keyboard-only and screen reader users would otherwise be forced to Tab through the entire global header and navigation menu every single time the page reloads just to reach the main workspace. The skip-link allows them to jump directly to `<main>`.

### Why is the "Delete" action constructed as a nested `<form method="POST">` rather than a standard `<a>` link?

    HTTP GET requests (like standard anchor links) are meant to be idempotent—they should only retrieve data, not destroy it. If "Delete" is a link, automated web crawlers or malicious cross-site request forgery (CSRF) scripts could accidentally trigger the URL and systematically delete database records. Forcing it into a POST form prevents accidental or automated data destruction.

## Task 5 & 6

### Browser Testing Observations

- **With `novalidate` applied:** Submitting the form with empty required fields results in no visible browser warnings. The form submission is silently blocked, leaving the user without immediate alert.

  ![Html image](assets/image%202.png)

- **With `novalidate` removed:** The browser natively blocks the submission and displays a default popup (e.g., "Please fill out this field") pointing to the first invalid input.

### The Three Layers of Validation

1. **HTML Layer:** Provides instant UX feedback (like `required` or `pattern`). A determined user can easily bypass this by opening Browser DevTools and simply deleting the attributes from the DOM.
2. **JavaScript Layer:** Handles complex UI error states and logic. This can be bypassed if a user disables JavaScript in their browser or uses an API client like cURL/Postman to send requests directly.
3. **Server Layer:** This is the non-negotiable layer. Server-side validation cannot be bypassed by the client. It is required in production to enforce data integrity and block malicious payloads (like SQL injection) from entering the database.

## Task 7

### What does `<time datetime="...">` give you that a `<span>` does not?

    A standard `<span>` is just a visual container with no semantic meaning. The `<time>` element combined with the `datetime` attribute provides a strictly formatted, machine-readable timestamp (like ISO 8601). This guarantees that screen readers, search engine scrapers, and software integrations (like calendar tools) can precisely understand the specific date and time, regardless of how it is visually formatted for human users.

## Task 8

### Page 1: Attribute List (`index.html`)

    I chose a traditional dashboard layout with filters at the top, a data table in the center, and a small statistics panel on the side. I avoided a card layout because tables make it easier to compare data, and a filter sidebar because it reduces space for the table. The search bar and first rows are visible above the fold so users can quickly find records. On mobile, I would collapse the filters into a toggle button and replace the table with stacked cards.

### Page 2: Add Attribute Form (`add-attribute.html`)

    I used a simple single-column form with three fieldsets to keep the layout clear and accessible. I avoided a multi-step form because there aren't many fields, and a two-column layout because it makes navigation less intuitive. The main fields are above the fold so users can start entering data immediately. On mobile, all inputs would be full width with larger touch targets.

### Page 3: Edit Attribute Form (`edit-attribute.html`)

    The edit page follows the same layout as the add form but includes read-only record details at the top for context. I avoided inline table editing because it complicates validation and accessibility, and I didn't use a modal because managing focus can be difficult. The record details and main editable fields appear above the fold so users can confirm they're editing the correct item. On mobile, I'd add a sticky Update button at the bottom for easier saving

## Task 9

### W3C Validation

    There 3 warnings by W3C validation

![Image](assets/W3C-index.html.png)

These warnings are given because there is no need to define role to semantic tags

### Keyboard Navigation

    Tested on every page it is working fine

![Image](assets/Keyboard-testing.png)

### Lighthouse

![HTML](assets/Lighthouse-index.html.png)

96% accessibility achieved and the reason it did not reach 100% is beacause of accessing nav links inside `<ul> & <li>` tags otherwise it is reaching 100% if you only use `<a>`.

### Axe devtools

No issues found
![Image](assets/Axe-index.html.png)

## Task 10

### Bug B

The icon-only buttons need visually hidden text for screen readers. This is the CSS snippet that will be added to our stylesheet in Assignment 2 to handle `.sr-only` elements:
            
            ```css
            .sr-only {
            position: absolute;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
            }
            

# CSS Assignment

## Task 1: CSS Cascade Layers (`@layer`)

### What problem does `@layer` solve over plain link order?

Traditional CSS depends on specificity (IDs are higher than classes, classes are higher than tags). `@layer` solves this by guaranteeing that _any_ rule in a higher-priority layer (like `utilities`) will override _any_ rule in a lower-priority layer (like `base`), regardless of specificity of the lower rule's selector.

### Why are `@layers` harder for someone NOT using them to override later?

Unlayered CSS natively possesses a higher priority than layered CSS. If a developer tries to override layered architecture using their own `@layer` stack but does not understand the specific layer order, their rules will not work properly.

### When is plain link order still preferable?

Plain link order is preferable in small scale project or legacy projects where implementing `@layer` would require a massive refactoring of existing CSS.


## Task 2


### Why are CSS variables superior to Sass variables for runtime theming and prefers-color-scheme?

Sass variables (`$color-primary`) are compiled into static CSS values and once the CSS is sent to the browser, the Sass variables is not accessible. If a user clicks a "Dark Mode" button, there will be no change to the Sass variable without requesting a completely new stylesheet from the server. CSS custom properties (`--color-primary`) live natively in the browser's DOM.
 
### When would Sass variables still beat CSS vars?

Sass variables are still used for compile-time constants (like media query breakpoint widths), advanced color math functions (like `darken($color, 10%)`).


## Task 4

### Why is `outline: none` without a replacement a WCAG failure?
  
  Removing the default focus outline without providing a custom replacement makes it impossible for keyboard-only users (and users relying on assistive technologies) to know which interactive element currently has focus. This fails the WCAG 2.4.7 "Focus Visible" success criterion, completely breaking keyboard navigation.

### What does `:focus-visible` give you that `:focus` does not?
  
  `:focus-visible` allows the browser to discriminate between mouse/touch interactions and keyboard interactions. It ensures a strong, accessible focus ring is shown *only* when the user is navigating via keyboard. Using just `:focus` often applies ugly outlines when mouse users click a button, which historically tempted developers to aggressively apply `outline: none` everywhere.

## Task 5: Mobile-First Layout

### Why mobile-first — what bug do you avoid that desktop-first introduces?

  Mobile-first avoids the bug where mobile users are forced to download massive amounts of complex CSS meant for desktop layouts, only to have to override and hide those rules using `max-width` media queries. It ensures the baseline CSS is lightweight and highly performant for constrained devices.
### Why grid-template-areas over named lines for this scale?

  For page-level macro-layouts (the "chrome"), `grid-template-areas` provides a highly visual, readable, ASCII-art representation of the layout directly in the CSS. Named lines require developers to track complex line numbers or names across multiple elements, which is harder to read and maintain for simple 3x3 grids.
### Justify the em choice for media queries:

  We use `em` units for media queries because they respect the user's browser-level font-size scaling. If a visually impaired user increases their default browser font size from 16px to 24px, an `em`-based breakpoint will scale proportionally and trigger sooner, preserving the layout. A `px`-based breakpoint remains static and will break the layout when the font scales up.
 
## Task 6: Container Queries

### When does a container query beat a media query? Give one component-level example where media queries actively fail:
  
  A container query beats a media query when a component needs to adapt its layout based on the width of its *parent container*, rather than the overall global viewport. A classic example where media queries fail is a "Card" component placed in both a main content area and a narrow right-side sidebar on a desktop screen. A media query looking at the 1200px viewport will incorrectly tell the sidebar card to adopt a wide, horizontal layout (causing it to overflow or squish), whereas a container query correctly tells the sidebar card to adopt its stacked, narrow layout because its specific parent is small.

## Task 7: Responsive Table Strategies

### Why is data-label/::before better than maintaining duplicate mobile/desktop markup?**
  
  It adheres to the "Single Source of Truth" principle. Creating two separate HTML structures (e.g., a `<table>` for desktop and a set of `<div>` cards for mobile) and toggling them with `display: none` heavily bloats the DOM. It also introduces the risk of state desynchronization, where JavaScript might update the data in the desktop table but fail to update the mobile cards. Transforming the table visually via CSS avoids this entirely.

### When does this pattern have a screen-reader cost?**
  
  Using `::before` pseudo-elements to inject text content can result in a repetitive, verbose experience for users navigating via assistive technologies. Depending on the browser and screen reader combination, the software might announce the native table column header AND the newly injected CSS pseudo-element text, effectively reading the column label twice per cell.

## Task 8: Form Styling & Pseudo-Class Power

* **Three things `:has()` unlocks that previously required JS:**
  1. Styling a parent element based on its child's state (e.g., turning a `<fieldset>` border red if any nested `<input>` becomes invalid).
  2. Styling a previous sibling based on a subsequent sibling (e.g., adding a red asterisk to a `<label>` only if the `<input>` that comes *after* it has the `required` attribute).
  3. Contextual component variations (e.g., styling a `.card` layout as two columns if it `:has(img)`, but a single centered column if it doesn't).

* **Why is `:user-invalid` usually the right choice over `:invalid` in a form UX?**
  The native `:invalid` pseudo-class is overly aggressive; it immediately triggers on page load for any empty `required` fields, yelling at the user with red error states before they have even started filling out the form. `:user-invalid` provides a far better user experience by waiting until the user has actually interacted with the field and blurred away (or attempted to submit) before applying the error styles.


## Task 9: Buttons, Badges, Toast & Transitions

* **Why is `transition: all` an antipattern?**
  Using `transition: all` forces the browser's main thread to calculate animation frames for every single property that might change on an element (such as `width`, `padding`, `margin`, or `box-shadow`). Animating these properties triggers expensive layout recalculations (reflows) and visual repaints, causing performance bottlenecks, dropped frames, and visual jank on low-end devices.

* **What two CSS properties are cheap to animate and why?**
  `transform` and `opacity` are cheap to animate because they are offloaded to the GPU's compositor thread. They do not alter the physical geometry of the document or require elements around them to shift, bypassing the expensive layout and paint phases entirely.

* **What does `prefers-reduced-motion` respect, and what's the WCAG criterion behind it?**
  `prefers-reduced-motion` respects the user's OS-level accessibility settings for minimizing non-essential motion. The WCAG criterion behind it is Success Criterion 2.3.3 (Animation from Interactions), which exists to protect users with vestibular disorders from experiencing dizziness, nausea, or migraines triggered by unnecessary UI motion.

## Task 10

* **Specificity Scores (a, b, c, d):**
  * `.btn` -> (0, 0, 1, 0)
  * `button.btn` -> (0, 0, 1, 1)
  * `#submit-btn` -> (0, 1, 0, 0)
  * `:where(.btn)` -> (0, 0, 0, 0)
  * `:is(.btn)` -> (0, 0, 1, 0)
  * `.btn { ... !important }` -> (0, 0, 1, 0) + !important flag
  * `style="background: yellow;"` (Inline) -> (1, 0, 0, 0)

* **Prediction & Verification:**
  * **Prediction:** The button will be **orange**.
  * **Verification:** DevTools confirms the color is orange. Even though the inline style (yellow) has the highest base specificity, the `!important` declaration on the `.btn` class overrides it.

* **Where `:where()` and `:is()` fall:**
  * `:where()` always has a specificity of 0 (0, 0, 0), making it incredibly easy to override.
  * `:is()` takes the specificity of its most specific argument. In this case, `:is(.btn)` has a specificity of (0, 1, 0).

* **What beats an `!important` inline style?**
  An inline style with `!important` (`style="background: yellow !important;"`) is the highest possible specificity created by an author. The only things that can beat it are `!important` rules originating from the browser's User Agent stylesheet or a custom User stylesheet, or a cascade layer exception.

* **Rule for using `!important` in production code:**
  `!important` should almost never be used in production code. It breaks the natural cascade and makes CSS exceptionally difficult to maintain. The only acceptable use cases are for single-purpose utility classes (e.g., `.sr-only` or `.hidden`) or when forcefully overriding uneditable third-party CSS.

## Task 11

### style Panel of inactive radio button

 ![image](assets/devtools/Screenshot%202026-07-17%20192338.png)

### compute panel

 ![image](assets/devtools/Screenshot%202026-07-17%20192354.png)

### layout panel

 ![image](assets/devtools/Screenshot%202026-07-17%20192617.png)

### coverage 

![image](assets/devtools/Screenshot%202026-07-17%20192725.png)

### Lighthouse performance across 3 pages

![image](assets/devtools/Screenshot%202026-07-17%20193043.png)
![image](assets/devtools/Screenshot%202026-07-17%20193117.png)
![image](assets/devtools/Screenshot%202026-07-17%20193157.png)


# JS Assignment

## Task 1

* This project uses ES Modules, with each JavaScript file responsible for a single concern, making the codebase easier to maintain, test, and reuse.

* ES modules run in strict mode by default which is helpful for catching errors.

* Module scripts are deferred by default i.e. they are downloaded in parallel but only executed after the HTML has been fully parsed.

* ES modules do not work very well when a page is opened directly with the file:// protocol because browsers enforce CORS/security rules for module imports.

### What does "deferred by default" mean?

  The module runs after the HTML is fully loaded. You can usually use DOM elements without DOMContentLoaded.

### What does VS Code Live Server do?

  It bypasses the CORS/security rules and use HTTP protocol instead of file:// to achive this.

## Task 3

### Why namespace localStorage keys?

  This project uses namespaced localStorage keys like ams.attributes and ams.theme to avoid conflicts with other apps.

### What happens if two apps use "theme"?

  They can overwrite each other's data, causing incorrect behavior.

### Why wrap storage reads in try/catch?

  JSON.parse() can fail if the data is invalid or missing and some browsers (like incognito mode) may block localStorage or have zero storage space, try/catch prevents the app from crashing.

## Task 4

### When is innerHTML acceptable?

  For trusted, fixed HTML that is not from user input.

### When is it dangerous?

  When displaying user or external data.

### What is XSS?

  XSS is an attack where malicious JavaScript is injected into a web page and runs in the user's browser.

### Why is DocumentFragment faster?

  It creates all elements in memory first and adds them to the page once, so the browser performs fewer reflows and layout calculations

## Task 5

### How does debounce work?

  A timer variable is stored in a closure. Every new keystroke clears the old timer with clearTimeout(). A new setTimeout() starts. The function runs only after the user stops typing for the specified delay.

### What bug is avoided by saving filters in the URL?

  Without saving filters in the URL, refreshing the page resets all filters and shows the full list again, which is confusing. Saving them in the URL restores the same filtered view after a refresh.

## Task 6

### What is event delegation?

  It is a technique where one parent element handles events for all of its child elements.

### Why is it better than one listener per element?(Two reasons)

* Uses fewer event listeners, so memory usage is lower.
* Works automatically for dynamically added elements.

### When does delegation fail?

  It does not work for events that do not bubble, such as:
  * focus
  * blur
  * mouseenter
  * mouseleave

### What should you use instead?

  Use focusin and focusout for focus-related events because they bubble.

## Task 7

### Why do real apps paginate on the server?

  * To avoid sending huge amounts of data to the browser.
  * It improves performance and reduces memory usage.

### What breaks at 100k rows on the client?

  * Loading becomes slow.
  * Memory usage becomes very high.
  * Filtering, sorting, and rendering become slow and can make the page  unresponsive.

### What is the contract between the client and server?

  * The client sends the page number, page size, sort, and filter values.
  * The server returns only that page of results along with the total number of records.

## Task 8

### What is the difference between setTimeout() and setInterval()?

  * setTimeout() runs once after a delay.
  * setInterval() runs repeatedly until it is stopped.

### When does clearTimeout() matter?

  When you need to cancel a pending timeout before it runs, such as when replacing or removing a toast early.

### Why is a single global toast buggy?

  If a new toast appears before the old timer finishes, the old timer can hide the new toast too early.

### How does a Map of timers fix it?

  Each toast gets its own timer stored in the Map, so timers do not interfere with each other.

## Task 9

### How does this dependent-dropdown pattern translate to a real backend (eager-load all locations vs fetch per BU change)?

 * Option 1: Load all locations when the page opens (eager loading).
 * Option 2: Request locations from the server whenever the Business Unit changes.

### What are the network and payload trade-offs?

* Eager loading

  * Faster after the page loads.
  * Larger initial download.

* Fetch per BU

  * Smaller initial download.
  * Requires a new network request each time the Business Unit changes, so there may be a small delay.

## Task 10

### Why can't HTML alone check uniqueness?

  HTML can validate a single field, but it cannot compare it with other existing records.

### Why check "belongs to BU" if the dropdown already restricts it?

  Users can modify form values using browser DevTools, so JavaScript must validate the relationship before saving.

### Why is focus management a WCAG concern?

  After a failed submit, moving focus to the error summary lets keyboard and screen-reader users quickly find and understand the validation errors.

## Task 11

### What does Angular Reactive Forms give you for free?

  * Form state (touched, dirty, pristine)
  * Validation handling
  * Error tracking
  * Form status (valid/invalid)

### What does it NOT give you?

  Your application's business rules, such as uniqueness checks or custom validation logic.

## Task 13

### Promise.all vs Promise.allSettled

  * Promise.all()
      * Stops immediately if any promise fails (fail-fast).
      * Best when all requests are required.
  * Promise.allSettled()
      * Waits for every promise to finish.
      * Returns both successful and failed results.

### Which should you use here?

  Use Promise.all() because the app cannot work correctly if even one JSON file is missing.

### What does Promise.any() solve?

  Promise.any() returns the first successful promise and ignores failures unless all promises fail. It is useful when multiple sources can provide the same data and you only need one to succeed.

## Task 14

### Why is debounce alone not enough?

  Debounce reduces the number of requests, but an older request can still finish after a newer one and overwrite the correct results. This is called the stale-response-wins bug.

### How does AbortController fix this?

  It cancels the previous request before starting a new one, so only the latest request can update the page.

### When else is AbortController used in vanilla JavaScript?

  To cancel fetch() requests.
  To automatically remove event listeners using the signal option.
  To cancel reading from a ReadableStream.

## Task 15

### Does fetch() reject on a 404?

  No. It resolves successfully, but response.ok is false.

### What does try/catch catch?

  Network errors and exceptions that are thrown.

### What does it miss?

  HTTP errors such as 404 and 500, unless you throw an error yourself.

### How to handle both?
  
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error("Request failed");
      }
  
### How is Axios different?

  Axios automatically rejects the promise for HTTP errors (like 404 or 500), so they are handled directly in the catch block.

## Task 16

### Why prefer the user's choice over the OS preference?

  Because the user has explicitly chosen the theme they want, and that preference should not be changed automatically.

### What is the CSS-only equivalent?

  The prefers-color-scheme media query.

### Why is the JavaScript toggle better here?

  It allows users to override the system theme and saves their choice in localStorage, so the same theme is used every time they visit the app.

## Final Lighthouse Scores

### index-page

  ![image](assets/devtools/final%20audit/Screenshot%202026-07-20%20160430.png)

### add-attribute-page

  ![image](assets/devtools/final%20audit/Screenshot%202026-07-20%20160619.png)

### edit-attribute-page

  ![image](assets/devtools/final%20audit/Screenshot%202026-07-20%20160710.png)