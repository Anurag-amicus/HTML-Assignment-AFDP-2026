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