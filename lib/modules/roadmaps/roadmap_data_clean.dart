import 'package:flutter/material.dart';

class TopicContent {
  final String title;
  final String content;

  TopicContent({
    required this.title,
    required this.content,
  });
}

class RoadmapStep {
  final String title;
  final String description;
  final String duration;
  final List<TopicContent> topics;
  final List<String> resources;

  RoadmapStep({
    required this.title,
    required this.description,
    required this.duration,
    required this.topics,
    required this.resources,
  });
}

class TechRoadmap {
  final String title;
  final String description;
  final String category;
  final String duration;
  final IconData icon;
  final Color color;
  final List<RoadmapStep> steps;

  TechRoadmap({
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.icon,
    required this.color,
    required this.steps,
  });
}

class RoadmapRepository {
  static final List<TechRoadmap> allRoadmaps = [
    // Frontend Development (Detailed)
    TechRoadmap(
      title: 'Frontend Developer',
      description: 'Complete frontend development roadmap from basics to advanced',
      category: 'Web Development',
      duration: '6-9 months',
      icon: Icons.web,
      color: Colors.blue,
      steps: [
        RoadmapStep(
          title: 'Internet & Web Basics',
          description: 'Understand how the internet and web work',
          duration: '1 week',
          topics: [
            TopicContent(
              title: 'How does the internet work?',
              content: 'The internet is a global network of interconnected computers that communicate using standardized protocols. Data travels through routers, switches, and cables (fiber optic, copper) in packets. Learn about IP addresses, routing, and the client-server model.',
            ),
            TopicContent(
              title: 'What is HTTP/HTTPS?',
              content: 'HTTP (HyperText Transfer Protocol) is the foundation of data communication on the web. HTTPS adds encryption via SSL/TLS for secure communication. Understand request/response cycles, status codes (200, 404, 500), and HTTP methods (GET, POST, PUT, DELETE).',
            ),
            TopicContent(
              title: 'DNS and how it works',
              content: 'DNS (Domain Name System) translates human-readable domain names (google.com) into IP addresses (172.217.164.46). Learn about DNS servers, DNS records (A, CNAME, MX), and the DNS resolution process.',
            ),
            TopicContent(
              title: 'Domain names',
              content: 'Domain names are human-readable addresses for websites. Understand domain structure (subdomain.domain.TLD), domain registration, and how domains connect to hosting servers.',
            ),
            TopicContent(
              title: 'Hosting basics',
              content: 'Web hosting stores your website files on servers accessible via the internet. Learn about shared hosting, VPS, dedicated servers, and cloud hosting. Understand server types and deployment basics.',
            ),
            TopicContent(
              title: 'Browsers and how they work',
              content: 'Browsers parse HTML, CSS, and JavaScript to render web pages. Learn about the rendering engine, JavaScript engine (V8), DOM construction, and browser developer tools.',
            ),
          ],
          resources: [
            'MDN Web Docs - How the Web Works',
            'CS50 Web Programming',
            'roadmap.sh/frontend',
          ],
        ),
        RoadmapStep(
          title: 'HTML Fundamentals',
          description: 'Master HTML5 and semantic markup',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Basic HTML syntax',
              content: 'HTML uses tags to structure content. Learn about opening/closing tags, attributes, nesting elements, and document structure (<!DOCTYPE>, <html>, <head>, <body>). Practice creating basic pages with headings, paragraphs, and lists.',
            ),
            TopicContent(
              title: 'Semantic HTML5 elements',
              content: 'Semantic elements clearly describe their meaning: <header>, <nav>, <main>, <article>, <section>, <aside>, <footer>. These improve accessibility, SEO, and code readability compared to generic <div> elements.',
            ),
            TopicContent(
              title: 'Forms and validations',
              content: 'Forms collect user input using <form>, <input>, <textarea>, <select>, <button>. Learn input types (text, email, password, number), attributes (required, pattern, min, max), and HTML5 validation features.',
            ),
            TopicContent(
              title: 'Accessibility basics (ARIA)',
              content: 'ARIA (Accessible Rich Internet Applications) attributes make web content accessible to people with disabilities. Learn about alt text, semantic HTML, keyboard navigation, screen readers, and ARIA roles/labels.',
            ),
            TopicContent(
              title: 'SEO basics',
              content: 'SEO-friendly HTML includes proper heading hierarchy (h1-h6), meta tags (title, description), semantic structure, alt attributes for images, and clean URLs. These help search engines understand and rank your content.',
            ),
            TopicContent(
              title: 'Best practices',
              content: 'Write clean, maintainable HTML: use semantic elements, proper indentation, lowercase tags, quote attributes, validate your code, and separate content from presentation (use CSS for styling).',
            ),
          ],
          resources: [
            'MDN HTML Guide',
            'web.dev Learn HTML',
            'HTML5 Doctor',
          ],
        ),
        RoadmapStep(
          title: 'CSS Fundamentals',
          description: 'Learn CSS styling and layouts',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'CSS syntax and selectors',
              content: 'CSS rules consist of selectors and declarations. Learn element selectors (p, div), class (.classname), ID (#idname), attribute ([type="text"]), pseudo-classes (:hover, :focus), and combinators (>, +, ~).',
            ),
            TopicContent(
              title: 'Box model',
              content: 'Every element is a box with content, padding, border, and margin. Understanding box-sizing (content-box vs border-box) is crucial for layout control. Use DevTools to visualize the box model.',
            ),
            TopicContent(
              title: 'Positioning (static, relative, absolute, fixed, sticky)',
              content: 'Static is default flow. Relative positions relative to normal position. Absolute positions relative to nearest positioned ancestor. Fixed positions relative to viewport. Sticky switches between relative and fixed.',
            ),
            TopicContent(
              title: 'Display and visibility',
              content: 'Display property controls layout behavior: block (full width), inline (content width), inline-block (inline with block properties), none (removes from flow). Visibility: hidden hides but keeps space.',
            ),
            TopicContent(
              title: 'Flexbox layout',
              content: 'Flexbox is a one-dimensional layout system. Learn flex container properties (display: flex, flex-direction, justify-content, align-items) and flex item properties (flex-grow, flex-shrink, flex-basis, align-self).',
            ),
            TopicContent(
              title: 'Grid layout',
              content: 'CSS Grid is a two-dimensional layout system. Define grid-template-columns/rows, use grid-gap, position items with grid-column/row, and create responsive layouts with auto-fit/auto-fill and minmax().',
            ),
            TopicContent(
              title: 'Responsive design',
              content: 'Design websites that work on all devices. Use relative units (%, em, rem, vw, vh), flexible images (max-width: 100%), and mobile-first approach. Test on multiple screen sizes.',
            ),
            TopicContent(
              title: 'Media queries',
              content: 'Media queries apply CSS based on device characteristics. Use @media (min-width: 768px) for breakpoints. Common breakpoints: mobile (<768px), tablet (768-1024px), desktop (>1024px).',
            ),
          ],
          resources: [
            'CSS-Tricks',
            'Flexbox Froggy',
            'Grid Garden',
            'web.dev Learn CSS',
          ],
        ),
        RoadmapStep(
          title: 'JavaScript Basics',
          description: 'Learn JavaScript fundamentals',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Variables (let, const, var)',
              content: 'Variables store data. Use const for constants, let for reassignable variables (block-scoped), avoid var (function-scoped, hoisted). Example: const name = "John"; let age = 25;',
            ),
            TopicContent(
              title: 'Data types',
              content: 'JavaScript has primitive types: string, number, boolean, null, undefined, symbol, bigint. And reference types: object, array, function. Use typeof to check types. Understand type coercion.',
            ),
            TopicContent(
              title: 'Operators',
              content: 'Arithmetic (+, -, *, /, %), comparison (==, ===, !=, !==, <, >), logical (&&, ||, !), assignment (=, +=, -=), ternary (condition ? true : false). Learn strict equality (===) vs loose (==).',
            ),
            TopicContent(
              title: 'Conditionals',
              content: 'Control flow with if/else statements, else if chains, switch statements, and ternary operators. Example: if (age >= 18) { console.log("Adult"); } else { console.log("Minor"); }',
            ),
            TopicContent(
              title: 'Loops',
              content: 'Iterate with for loops, while loops, do-while loops, for...of (arrays), for...in (objects). Learn break and continue statements. Example: for (let i = 0; i < 10; i++) { console.log(i); }',
            ),
            TopicContent(
              title: 'Functions',
              content: 'Functions are reusable code blocks. Learn function declarations, expressions, arrow functions, parameters, return values, and scope. Example: function add(a, b) { return a + b; }',
            ),
            TopicContent(
              title: 'Arrays and objects',
              content: 'Arrays store ordered lists: [1, 2, 3]. Objects store key-value pairs: {name: "John", age: 25}. Learn array methods (push, pop, map, filter) and object manipulation (dot notation, bracket notation).',
            ),
            TopicContent(
              title: 'String methods',
              content: 'Manipulate strings with methods: length, toUpperCase(), toLowerCase(), slice(), substring(), indexOf(), includes(), split(), replace(), trim(). Template literals: `Hello ${name}`.',
            ),
          ],
          resources: [
            'JavaScript.info',
            'MDN JavaScript Guide',
            'Eloquent JavaScript',
          ],
        ),
        RoadmapStep(
          title: 'JavaScript Advanced',
          description: 'Master advanced JavaScript concepts',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'ES6+ features',
              content: 'Modern JavaScript includes let/const, arrow functions, classes, modules (import/export), default parameters, and more. These features make code cleaner and more maintainable.',
            ),
            TopicContent(
              title: 'Arrow functions',
              content: 'Concise function syntax: const add = (a, b) => a + b. Arrow functions don\'t bind their own "this", making them ideal for callbacks. Single expressions return implicitly.',
            ),
            TopicContent(
              title: 'Destructuring',
              content: 'Extract values from arrays/objects: const {name, age} = person; const [first, second] = array. Simplifies code and makes it more readable. Works with function parameters too.',
            ),
            TopicContent(
              title: 'Spread/rest operators',
              content: 'Spread (...) expands arrays/objects: [...arr1, ...arr2]. Rest collects arguments: function sum(...numbers). Useful for copying, merging, and function parameters.',
            ),
            TopicContent(
              title: 'Template literals',
              content: 'String interpolation with backticks: `Hello ${name}, you are ${age} years old`. Supports multi-line strings and embedded expressions. Cleaner than string concatenation.',
            ),
            TopicContent(
              title: 'Promises',
              content: 'Handle asynchronous operations. States: pending, fulfilled, rejected. Use .then() for success, .catch() for errors, .finally() for cleanup. Chain multiple async operations.',
            ),
            TopicContent(
              title: 'Async/await',
              content: 'Syntactic sugar for promises. async functions return promises. await pauses execution until promise resolves. Makes async code look synchronous: const data = await fetchData();',
            ),
            TopicContent(
              title: 'Fetch API',
              content: 'Modern way to make HTTP requests. Returns promises. Example: fetch(url).then(res => res.json()).then(data => console.log(data)). Replace XMLHttpRequest with fetch.',
            ),
            TopicContent(
              title: 'Closures',
              content: 'Functions that remember their lexical scope. Inner functions access outer function variables even after outer function returns. Used for data privacy and factory functions.',
            ),
            TopicContent(
              title: 'Prototypes',
              content: 'JavaScript inheritance mechanism. Every object has a prototype. Methods defined on prototype are shared across instances. Understanding prototypes is key to mastering JavaScript.',
            ),
            TopicContent(
              title: 'this keyword',
              content: 'Refers to the execution context. In methods, "this" is the object. In functions, depends on how called. Arrow functions inherit "this" from parent scope. Use bind/call/apply to set "this".',
            ),
          ],
          resources: [
            'You Don\'t Know JS',
            'JavaScript30',
            'FreeCodeCamp',
          ],
        ),
        RoadmapStep(
          title: 'DOM Manipulation',
          description: 'Work with the Document Object Model',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Selecting elements',
              content: 'Access DOM elements with querySelector(), querySelectorAll(), getElementById(), getElementsByClassName(). querySelector uses CSS selectors. querySelectorAll returns NodeList.',
            ),
            TopicContent(
              title: 'Manipulating elements',
              content: 'Change content with innerHTML, textContent, innerText. Modify attributes with setAttribute(), getAttribute(). Add/remove classes with classList.add(), classList.remove(), classList.toggle().',
            ),
            TopicContent(
              title: 'Event listeners',
              content: 'Respond to user actions: element.addEventListener("click", function). Common events: click, submit, keydown, mouseover, change. Remove listeners with removeEventListener().',
            ),
            TopicContent(
              title: 'Event delegation',
              content: 'Attach single listener to parent instead of multiple children. Use event.target to identify clicked element. More efficient for dynamic content. Example: list.addEventListener("click", e => if(e.target.tagName === "LI")).',
            ),
            TopicContent(
              title: 'Creating elements',
              content: 'Create new elements with document.createElement("div"). Set properties, add content, then append to DOM with appendChild() or append(). Use insertBefore() for specific positioning.',
            ),
            TopicContent(
              title: 'Modifying styles',
              content: 'Change styles with element.style.property = "value". Better: add/remove CSS classes. Access computed styles with getComputedStyle(). Avoid inline styles when possible.',
            ),
            TopicContent(
              title: 'Working with forms',
              content: 'Access form values with input.value. Prevent default submission with event.preventDefault(). Validate inputs, handle form submission, and provide user feedback.',
            ),
          ],
          resources: [
            'MDN DOM Guide',
            'JavaScript DOM Crash Course',
            'DOM Enlightenment',
          ],
        ),
        RoadmapStep(
          title: 'Version Control (Git)',
          description: 'Learn Git and GitHub',
          duration: '1-2 weeks',
          topics: [
            TopicContent(
              title: 'Git basics',
              content: 'Git tracks code changes. Initialize with git init, clone repos with git clone. Check status with git status. Essential for collaboration and version history.',
            ),
            TopicContent(
              title: 'Commits',
              content: 'Save changes with git add (stage) and git commit -m "message". Commits are snapshots of your code. Write clear, descriptive commit messages. View history with git log.',
            ),
            TopicContent(
              title: 'Branches',
              content: 'Create isolated development lines with git branch. Switch branches with git checkout or git switch. Main branch is usually "main" or "master". Feature branches keep work organized.',
            ),
            TopicContent(
              title: 'Merging',
              content: 'Combine branches with git merge. Resolve conflicts when same code is changed differently. Fast-forward merges vs three-way merges. Use git merge --no-ff for explicit merge commits.',
            ),
            TopicContent(
              title: 'Pull requests',
              content: 'Propose changes on GitHub/GitLab. Request code review before merging. Discuss changes, suggest improvements, and ensure quality. Essential for team collaboration.',
            ),
            TopicContent(
              title: 'GitHub workflow',
              content: 'Fork repos, clone locally, create feature branch, commit changes, push to GitHub, create pull request. Sync with upstream using git pull. Collaborate with issues and discussions.',
            ),
            TopicContent(
              title: 'Git best practices',
              content: 'Commit often with clear messages. Keep commits atomic (one logical change). Pull before push. Use .gitignore for sensitive/generated files. Never commit passwords or API keys.',
            ),
          ],
          resources: [
            'Pro Git Book',
            'GitHub Learning Lab',
            'Git Immersion',
          ],
        ),
        RoadmapStep(
          title: 'Package Managers',
          description: 'Learn npm and yarn',
          duration: '1 week',
          topics: [
            TopicContent(
              title: 'npm basics',
              content: 'npm (Node Package Manager) installs JavaScript packages. Initialize projects with npm init. Install packages with npm install. Packages are stored in node_modules folder.',
            ),
            TopicContent(
              title: 'package.json',
              content: 'Manifest file listing project dependencies, scripts, and metadata. Dependencies vs devDependencies. Lock file (package-lock.json) ensures consistent installs across environments.',
            ),
            TopicContent(
              title: 'Installing packages',
              content: 'npm install package-name adds to dependencies. npm install -D for devDependencies. npm install -g for global packages. Remove with npm uninstall. Update with npm update.',
            ),
            TopicContent(
              title: 'Scripts',
              content: 'Define custom commands in package.json scripts section. Run with npm run script-name. Common scripts: start, test, build, dev. Automate repetitive tasks.',
            ),
            TopicContent(
              title: 'Semantic versioning',
              content: 'Version format: MAJOR.MINOR.PATCH (e.g., 2.4.1). ^ allows minor updates, ~ allows patch updates. Understanding semver prevents breaking changes in dependencies.',
            ),
            TopicContent(
              title: 'yarn alternative',
              content: 'Yarn is faster npm alternative with better caching. Similar commands: yarn add, yarn remove, yarn install. Uses yarn.lock. Both npm and yarn are widely used.',
            ),
          ],
          resources: [
            'npm Documentation',
            'yarn Documentation',
            'Package Manager Guide',
          ],
        ),
        RoadmapStep(
          title: 'CSS Preprocessors',
          description: 'Learn Sass/SCSS',
          duration: '2 weeks',
          topics: [
            TopicContent(
              title: 'Variables',
              content: 'Store reusable values: $primary-color: #3498db; Use throughout stylesheets for consistency. Change once, update everywhere. Compiles to regular CSS.',
            ),
            TopicContent(
              title: 'Nesting',
              content: 'Nest selectors to match HTML structure: .nav { ul { li { } } }. Makes CSS more readable and maintainable. Avoid deep nesting (max 3-4 levels).',
            ),
            TopicContent(
              title: 'Mixins',
              content: 'Reusable style blocks: @mixin flex-center { display: flex; justify-content: center; }. Include with @include flex-center. Accept parameters for flexibility.',
            ),
            TopicContent(
              title: 'Functions',
              content: 'Return values for calculations: @function calculate-rem($px) { @return $px / 16 * 1rem; }. Built-in functions for colors (darken, lighten), math, and strings.',
            ),
            TopicContent(
              title: 'Partials and imports',
              content: 'Split CSS into multiple files: _variables.scss, _mixins.scss. Import with @import or @use. Organize code by component or feature. Underscore prevents compilation.',
            ),
            TopicContent(
              title: 'Inheritance',
              content: 'Share styles with @extend: .error { @extend .message; color: red; }. Reduces code duplication. Use sparingly as it can create complex selectors.',
            ),
          ],
          resources: [
            'Sass Documentation',
            'Sass Guidelines',
            'Sass Tutorial',
          ],
        ),
        RoadmapStep(
          title: 'Build Tools',
          description: 'Learn module bundlers and task runners',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Webpack basics',
              content: 'Module bundler that combines JavaScript, CSS, images into optimized bundles. Configure with webpack.config.js. Define entry points, output, loaders, and plugins.',
            ),
            TopicContent(
              title: 'Vite',
              content: 'Modern build tool with instant server start and lightning-fast HMR. Uses native ES modules in development. Optimized production builds with Rollup. Simpler than Webpack.',
            ),
            TopicContent(
              title: 'Parcel',
              content: 'Zero-config bundler. Automatically detects dependencies and transforms code. Great for beginners. Fast builds with caching. Supports all file types out of the box.',
            ),
            TopicContent(
              title: 'Module bundling',
              content: 'Combines multiple files into fewer bundles. Resolves dependencies, transforms code (Babel, TypeScript), and optimizes for production. Reduces HTTP requests.',
            ),
            TopicContent(
              title: 'Code splitting',
              content: 'Split code into smaller chunks loaded on demand. Reduces initial bundle size. Use dynamic imports: import("./module").then(). Improves performance for large apps.',
            ),
            TopicContent(
              title: 'Hot module replacement',
              content: 'Updates modules in browser without full reload. Preserves application state during development. Instant feedback on code changes. Dramatically improves developer experience.',
            ),
          ],
          resources: [
            'Webpack Documentation',
            'Vite Guide',
            'Frontend Build Tools',
          ],
        ),
        RoadmapStep(
          title: 'React Framework',
          description: 'Master React.js',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'JSX',
              content: 'JavaScript XML syntax for writing HTML in JavaScript. Expressions in curly braces: {variable}. Must return single parent element. className instead of class. Self-closing tags required.',
            ),
            TopicContent(
              title: 'Components',
              content: 'Reusable UI pieces. Functional components are functions returning JSX. Component names start with capital letter. Break UI into small, focused components for maintainability.',
            ),
            TopicContent(
              title: 'Props',
              content: 'Pass data from parent to child components. Read-only, cannot be modified by child. Destructure for cleaner code: function Button({ text, onClick }). Use PropTypes for validation.',
            ),
            TopicContent(
              title: 'State',
              content: 'Component-specific data that triggers re-renders when changed. Managed with useState hook. State is private and controlled by component. Never mutate state directly.',
            ),
            TopicContent(
              title: 'Lifecycle methods',
              content: 'Class component methods for mounting, updating, unmounting. componentDidMount, componentDidUpdate, componentWillUnmount. In functional components, use useEffect hook instead.',
            ),
            TopicContent(
              title: 'Hooks (useState, useEffect, useContext, etc.)',
              content: 'Functions that let you use state and lifecycle in functional components. useState for state, useEffect for side effects, useContext for context, useRef for refs, useMemo/useCallback for optimization.',
            ),
            TopicContent(
              title: 'React Router',
              content: 'Client-side routing library. Define routes with <Route path="/about" element={<About />} />. Navigate with <Link to="/about">. Use useNavigate hook for programmatic navigation.',
            ),
            TopicContent(
              title: 'Forms in React',
              content: 'Controlled components: input value tied to state. Handle changes with onChange. Prevent default form submission. Validate inputs and provide feedback. Use libraries like Formik for complex forms.',
            ),
            TopicContent(
              title: 'Context API',
              content: 'Share data across component tree without prop drilling. Create context with createContext, provide with Provider, consume with useContext. Good for themes, auth, language.',
            ),
            TopicContent(
              title: 'Performance optimization',
              content: 'Use React.memo to prevent unnecessary re-renders. useMemo for expensive calculations. useCallback for function references. Code splitting with lazy() and Suspense. Virtualize long lists.',
            ),
          ],
          resources: [
            'React Official Docs',
            'React Tutorial',
            'Epic React',
            'Scrimba React',
          ],
        ),
        RoadmapStep(
          title: 'State Management',
          description: 'Learn Redux or Zustand',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Redux basics',
              content: 'Centralized state management. Single store holds entire app state. Predictable state updates through actions and reducers. Time-travel debugging with Redux DevTools.',
            ),
            TopicContent(
              title: 'Actions and reducers',
              content: 'Actions describe what happened: {type: "ADD_TODO", payload: {...}}. Reducers specify how state changes: (state, action) => newState. Pure functions, no side effects.',
            ),
            TopicContent(
              title: 'Store',
              content: 'Single source of truth for app state. Created with createStore(). Access state with getState(). Dispatch actions with dispatch(). Subscribe to changes with subscribe().',
            ),
            TopicContent(
              title: 'Redux Toolkit',
              content: 'Official recommended way to write Redux. Simplifies setup with configureStore(). createSlice() combines actions and reducers. Includes Immer for immutable updates.',
            ),
            TopicContent(
              title: 'Zustand alternative',
              content: 'Lightweight state management. Less boilerplate than Redux. Simple API: create((set) => ({count: 0, inc: () => set(s => ({count: s.count + 1}))})).',
            ),
            TopicContent(
              title: 'When to use state management',
              content: 'Use for complex apps with shared state across many components. Not needed for simple apps - Context API or local state suffices. Consider prop drilling pain vs library complexity.',
            ),
          ],
          resources: [
            'Redux Documentation',
            'Redux Toolkit',
            'Zustand Docs',
          ],
        ),
        RoadmapStep(
          title: 'TypeScript',
          description: 'Add type safety to JavaScript',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'TypeScript basics',
              content: 'Superset of JavaScript with static typing. Catches errors at compile time. Better IDE support with autocomplete. Compiles to JavaScript. Use .ts or .tsx files.',
            ),
            TopicContent(
              title: 'Types and interfaces',
              content: 'Define shapes of objects. type User = {name: string; age: number}. interface User {name: string; age: number}. Interfaces can extend, types can use unions.',
            ),
            TopicContent(
              title: 'Generics',
              content: 'Create reusable components that work with multiple types. function identity<T>(arg: T): T { return arg; }. Common in arrays, promises, and React components.',
            ),
            TopicContent(
              title: 'Enums',
              content: 'Define named constants. enum Color {Red, Green, Blue}. Numeric or string enums. Useful for status codes, directions, or fixed sets of values.',
            ),
            TopicContent(
              title: 'Type assertions',
              content: 'Tell TypeScript you know better about a type. const input = document.getElementById("input") as HTMLInputElement. Use sparingly, prefer type guards.',
            ),
            TopicContent(
              title: 'TypeScript with React',
              content: 'Type props: interface Props {name: string}. Type state with useState<Type>(). Type events: React.ChangeEvent<HTMLInputElement>. Use React.FC or explicit return types.',
            ),
          ],
          resources: [
            'TypeScript Handbook',
            'TypeScript Deep Dive',
            'Total TypeScript',
          ],
        ),
        RoadmapStep(
          title: 'Testing',
          description: 'Write tests for your code',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Jest basics',
              content: 'JavaScript testing framework. Write tests with test() or it(). Assertions with expect(). Run with npm test. Supports mocking, snapshots, and coverage reports.',
            ),
            TopicContent(
              title: 'Unit testing',
              content: 'Test individual functions/components in isolation. Fast and focused. Mock dependencies. Example: test("adds 1 + 2 to equal 3", () => expect(add(1, 2)).toBe(3)).',
            ),
            TopicContent(
              title: 'React Testing Library',
              content: 'Test React components from user perspective. render() components, query with screen.getByText(). Fire events with fireEvent or userEvent. Focus on behavior, not implementation.',
            ),
            TopicContent(
              title: 'Integration tests',
              content: 'Test multiple units working together. More realistic than unit tests. Test user flows and component interactions. Balance between unit and E2E tests.',
            ),
            TopicContent(
              title: 'E2E testing with Cypress',
              content: 'Test entire application in real browser. Simulate user interactions. cy.visit(), cy.get(), cy.click(). Catch integration issues. Slower but comprehensive.',
            ),
            TopicContent(
              title: 'Test-driven development',
              content: 'Write tests before code. Red (failing test) → Green (make it pass) → Refactor. Ensures testable code. Clarifies requirements. Prevents regressions.',
            ),
          ],
          resources: [
            'Jest Documentation',
            'Testing Library',
            'Cypress Docs',
          ],
        ),
        RoadmapStep(
          title: 'Web Performance',
          description: 'Optimize your applications',
          duration: '2 weeks',
          topics: [
            TopicContent(
              title: 'Performance metrics',
              content: 'FCP (First Contentful Paint), LCP (Largest Contentful Paint), FID (First Input Delay), CLS (Cumulative Layout Shift), TTI (Time to Interactive). Core Web Vitals matter for SEO.',
            ),
            TopicContent(
              title: 'Lighthouse',
              content: 'Chrome DevTools audit tool. Analyzes performance, accessibility, SEO, best practices. Provides scores and actionable recommendations. Run on desktop and mobile.',
            ),
            TopicContent(
              title: 'Code splitting',
              content: 'Split code into smaller bundles loaded on demand. React.lazy() and Suspense for component-level splitting. Route-based splitting with React Router. Reduces initial load time.',
            ),
            TopicContent(
              title: 'Lazy loading',
              content: 'Load resources when needed, not upfront. Lazy load images with loading="lazy". Lazy load components with React.lazy(). Improves initial page load.',
            ),
            TopicContent(
              title: 'Image optimization',
              content: 'Use modern formats (WebP, AVIF). Compress images. Serve responsive images with srcset. Use CDN. Lazy load off-screen images. Proper sizing prevents layout shifts.',
            ),
            TopicContent(
              title: 'Caching strategies',
              content: 'Browser caching with Cache-Control headers. Service workers for offline support. CDN caching for static assets. Versioned filenames for cache busting. Reduces server load and improves speed.',
            ),
          ],
          resources: [
            'web.dev Performance',
            'Web Performance Guide',
            'Chrome DevTools',
          ],
        ),
      ],
    ),

    // Backend Development (Detailed)
    TechRoadmap(
      title: 'Backend Developer',
      description: 'Complete backend development roadmap',
      category: 'Web Development',
      duration: '7-10 months',
      icon: Icons.dns,
      color: Colors.green,
      steps: [
        RoadmapStep(
          title: 'Internet Basics',
          description: 'Understand internet fundamentals',
          duration: '1 week',
          topics: [
            TopicContent(
              title: 'How does the internet work?',
              content: 'Global network of interconnected computers communicating via protocols. Data travels in packets through routers and switches. Client-server model: clients request, servers respond.',
            ),
            TopicContent(
              title: 'HTTP/HTTPS protocols',
              content: 'HTTP is stateless protocol for web communication. HTTPS adds SSL/TLS encryption for security. Request methods: GET, POST, PUT, DELETE. Status codes: 200 (OK), 404 (Not Found), 500 (Server Error).',
            ),
            TopicContent(
              title: 'TCP/IP',
              content: 'TCP ensures reliable data transmission with error checking and ordering. IP handles addressing and routing. TCP/IP stack: Application, Transport, Internet, Network layers.',
            ),
            TopicContent(
              title: 'DNS',
              content: 'Domain Name System translates domain names to IP addresses. Hierarchical system with root, TLD, and authoritative servers. DNS records: A, AAAA, CNAME, MX, TXT.',
            ),
            TopicContent(
              title: 'APIs',
              content: 'Application Programming Interfaces allow software to communicate. Define endpoints, methods, and data formats. Enable integration between different systems and services.',
            ),
            TopicContent(
              title: 'REST architecture',
              content: 'REpresentational State Transfer: architectural style for APIs. Stateless, client-server, cacheable, uniform interface. Resources identified by URLs, manipulated via HTTP methods.',
            ),
          ],
          resources: [
            'MDN HTTP Guide',
            'roadmap.sh/backend',
            'CS50 Network',
          ],
        ),
        RoadmapStep(
          title: 'Programming Language (Node.js)',
          description: 'Learn JavaScript/Node.js for backend',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'JavaScript fundamentals',
              content: 'Variables, data types, functions, objects, arrays. ES6+ features: arrow functions, destructuring, spread operator, promises. Understanding scope, closures, and prototypes.',
            ),
            TopicContent(
              title: 'Node.js basics',
              content: 'JavaScript runtime built on Chrome V8 engine. Run JavaScript on server-side. Non-blocking I/O, event-driven architecture. Global objects: process, __dirname, require().',
            ),
            TopicContent(
              title: 'npm and package management',
              content: 'Node Package Manager for installing dependencies. package.json defines project metadata and dependencies. npm install, npm start, npm scripts. Semantic versioning.',
            ),
            TopicContent(
              title: 'Asynchronous programming',
              content: 'Callbacks, Promises, async/await for handling async operations. Non-blocking code execution. Error handling with try/catch and .catch(). Avoid callback hell.',
            ),
            TopicContent(
              title: 'Event loop',
              content: 'Single-threaded event loop handles async operations. Call stack, callback queue, event loop phases. Microtasks vs macrotasks. Understanding how Node.js achieves concurrency.',
            ),
            TopicContent(
              title: 'Streams and buffers',
              content: 'Streams handle data in chunks: readable, writable, duplex, transform. Buffers store binary data. Efficient for large files. pipe() connects streams.',
            ),
            TopicContent(
              title: 'File system operations',
              content: 'fs module for file operations: readFile, writeFile, appendFile, unlink. Sync vs async methods. Working with directories. Path module for file paths.',
            ),
          ],
          resources: [
            'Node.js Documentation',
            'Node.js Best Practices',
            'The Net Ninja Node.js',
          ],
        ),
        RoadmapStep(
          title: 'Version Control',
          description: 'Master Git and GitHub',
          duration: '1-2 weeks',
          topics: [
            TopicContent(
              title: 'Git fundamentals',
              content: 'Distributed version control system. Track changes, collaborate, maintain history. git init, clone, add, commit, push, pull. Essential for team development.',
            ),
            TopicContent(
              title: 'Branching strategies',
              content: 'Git Flow: main, develop, feature, release, hotfix branches. GitHub Flow: simpler with main and feature branches. Trunk-based development for CI/CD.',
            ),
            TopicContent(
              title: 'Pull requests',
              content: 'Propose changes for review before merging. Discuss code, suggest improvements, run CI checks. Essential for code quality and knowledge sharing.',
            ),
            TopicContent(
              title: 'Code reviews',
              content: 'Review others\' code for bugs, style, best practices. Provide constructive feedback. Approve or request changes. Improves code quality and team learning.',
            ),
            TopicContent(
              title: 'Git workflows',
              content: 'Centralized, feature branch, gitflow, forking workflows. Choose based on team size and project needs. Consistent workflow improves collaboration.',
            ),
            TopicContent(
              title: 'GitHub Actions basics',
              content: 'CI/CD automation on GitHub. Workflows triggered by events (push, PR). Run tests, build, deploy automatically. YAML configuration files.',
            ),
          ],
          resources: [
            'Pro Git Book',
            'GitHub Learning Lab',
            'Atlassian Git Tutorial',
          ],
        ),
        RoadmapStep(
          title: 'Relational Databases',
          description: 'Learn SQL and PostgreSQL',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Database fundamentals',
              content: 'Structured data storage in tables with rows and columns. Primary keys uniquely identify records. Foreign keys establish relationships. ACID properties ensure reliability.',
            ),
            TopicContent(
              title: 'SQL syntax',
              content: 'Structured Query Language for database operations. SELECT, FROM, WHERE, ORDER BY, GROUP BY. Case-insensitive keywords. Semicolon terminates statements.',
            ),
            TopicContent(
              title: 'CRUD operations',
              content: 'Create (INSERT), Read (SELECT), Update (UPDATE), Delete (DELETE). Basic database operations. WHERE clause filters records. SET clause specifies changes.',
            ),
            TopicContent(
              title: 'Joins',
              content: 'Combine data from multiple tables. INNER JOIN: matching records. LEFT/RIGHT JOIN: all from one side. FULL JOIN: all records. ON clause specifies join condition.',
            ),
            TopicContent(
              title: 'Indexes',
              content: 'Speed up queries by creating lookup structures. B-tree indexes most common. Index frequently queried columns. Trade-off: faster reads, slower writes.',
            ),
            TopicContent(
              title: 'Transactions',
              content: 'Group operations into atomic units. BEGIN, COMMIT, ROLLBACK. ACID: Atomicity, Consistency, Isolation, Durability. Ensure data integrity.',
            ),
            TopicContent(
              title: 'Normalization',
              content: 'Organize data to reduce redundancy. 1NF: atomic values. 2NF: no partial dependencies. 3NF: no transitive dependencies. Balance normalization vs performance.',
            ),
            TopicContent(
              title: 'PostgreSQL specifics',
              content: 'Advanced open-source RDBMS. JSON support, full-text search, array types. Extensions like PostGIS. MVCC for concurrency. psql command-line tool.',
            ),
          ],
          resources: [
            'PostgreSQL Tutorial',
            'SQL Zoo',
            'Mode SQL Tutorial',
          ],
        ),
        RoadmapStep(
          title: 'NoSQL Databases',
          description: 'Learn MongoDB',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'NoSQL concepts',
              content: 'Non-relational databases for flexible schemas. Document, key-value, column-family, graph types. Horizontal scaling, eventual consistency. Good for unstructured data.',
            ),
            TopicContent(
              title: 'MongoDB basics',
              content: 'Document-oriented NoSQL database. Stores data as JSON-like BSON documents. No fixed schema. Collections instead of tables. Documents instead of rows.',
            ),
            TopicContent(
              title: 'Collections and documents',
              content: 'Collections group related documents. Documents are JSON objects with key-value pairs. Embedded documents and arrays. _id field auto-generated.',
            ),
            TopicContent(
              title: 'Queries',
              content: 'find() retrieves documents. Filter with query objects: {age: {$gt: 18}}. Projection selects fields. sort(), limit(), skip() for pagination.',
            ),
            TopicContent(
              title: 'Aggregation',
              content: 'Pipeline for data processing: $match, $group, $sort, $project. Powerful for analytics and transformations. Similar to SQL GROUP BY but more flexible.',
            ),
            TopicContent(
              title: 'Indexing',
              content: 'Improve query performance. Single field, compound, text, geospatial indexes. createIndex() method. Explain plans show index usage.',
            ),
            TopicContent(
              title: 'Mongoose ODM',
              content: 'Object Data Modeling library for MongoDB and Node.js. Define schemas, models, validation. Middleware hooks. Simplifies MongoDB operations.',
            ),
          ],
          resources: [
            'MongoDB University',
            'MongoDB Documentation',
            'Mongoose Docs',
          ],
        ),
        RoadmapStep(
          title: 'APIs (REST)',
          description: 'Build RESTful APIs',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'REST principles',
              content: 'Stateless client-server architecture. Resources identified by URLs. Uniform interface with standard HTTP methods. Cacheable responses. Layered system.',
            ),
            TopicContent(
              title: 'HTTP methods',
              content: 'GET: retrieve data. POST: create resource. PUT: update entire resource. PATCH: partial update. DELETE: remove resource. Idempotent methods can be repeated safely.',
            ),
            TopicContent(
              title: 'Status codes',
              content: '2xx: success (200 OK, 201 Created). 3xx: redirection. 4xx: client errors (400 Bad Request, 401 Unauthorized, 404 Not Found). 5xx: server errors (500 Internal Server Error).',
            ),
            TopicContent(
              title: 'Express.js framework',
              content: 'Minimal Node.js web framework. Handle routes, middleware, requests, responses. app.get(), app.post(), app.listen(). Fast, unopinionated, widely used.',
            ),
            TopicContent(
              title: 'Routing',
              content: 'Map URLs to handler functions. Route parameters: /users/:id. Query strings: /search?q=term. Route methods match HTTP verbs. Router for modular routes.',
            ),
            TopicContent(
              title: 'Middleware',
              content: 'Functions with access to req, res, next. Execute code, modify req/res, end request, call next(). Built-in, third-party, custom middleware. Order matters.',
            ),
            TopicContent(
              title: 'Error handling',
              content: 'Catch errors with try/catch or error middleware. Error middleware has 4 parameters: (err, req, res, next). Return appropriate status codes and messages. Log errors for debugging.',
            ),
            TopicContent(
              title: 'API versioning',
              content: 'Maintain backward compatibility while evolving API. URL versioning: /api/v1/users. Header versioning: Accept: application/vnd.api+json;version=1. Semantic versioning for changes.',
              content: 'Centralized error handling middleware. try/catch for async errors. Custom error classes. Proper status codes and messages. Log errors, don\'t expose internals.',
            ),
            TopicContent(
              title: 'API versioning',
              content: 'Maintain backward compatibility. URL versioning: /api/v1/users. Header versioning: Accept: application/vnd.api+json;version=1. Deprecation strategy.',
            ),
          ],
          resources: [
            'Express.js Guide',
            'REST API Tutorial',
            'API Design Best Practices',
          ],
        ),
        RoadmapStep(
          title: 'Authentication & Authorization',
          description: 'Secure your applications',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Authentication vs Authorization',
              content: 'Authentication: verify identity (who you are). Authorization: verify permissions (what you can do). Authentication comes first, then authorization.',
            ),
            TopicContent(
              title: 'JWT tokens',
              content: 'JSON Web Tokens for stateless authentication. Header, payload, signature. Sign with secret key. Include in Authorization header. Decode to verify and extract data.',
            ),
            TopicContent(
              title: 'OAuth 2.0',
              content: 'Authorization framework for third-party access. Authorization code, implicit, client credentials, password flows. Access tokens and refresh tokens. Used by Google, Facebook login.',
            ),
            TopicContent(
              title: 'Session management',
              content: 'Server-side session storage. Session ID in cookie. Store user data on server. express-session middleware. Secure, httpOnly, sameSite cookie flags.',
            ),
            TopicContent(
              title: 'Password hashing (bcrypt)',
              content: 'Never store plain passwords. bcrypt adds salt and hashes. Slow by design to prevent brute force. Compare hashed passwords with bcrypt.compare().',
            ),
            TopicContent(
              title: 'Role-based access control',
              content: 'Assign roles to users (admin, user, guest). Roles have permissions. Check role before allowing actions. Middleware to protect routes by role.',
            ),
            TopicContent(
              title: 'Security best practices',
              content: 'HTTPS only. Validate input. Sanitize output. Rate limiting. CORS configuration. Helmet.js for headers. Keep dependencies updated. Environment variables for secrets.',
            ),
          ],
          resources: [
            'JWT.io',
            'OAuth 2.0 Guide',
            'OWASP Security',
          ],
        ),
        RoadmapStep(
          title: 'Caching',
          description: 'Implement caching strategies',
          duration: '2 weeks',
          topics: [
            TopicContent(
              title: 'Caching concepts',
              content: 'Store frequently accessed data for faster retrieval. Reduces database load and latency. Cache hit vs miss. TTL (Time To Live) for expiration.',
            ),
            TopicContent(
              title: 'Redis basics',
              content: 'In-memory data store for caching. Key-value pairs. Strings, lists, sets, hashes, sorted sets. SET, GET, EXPIRE commands. Persistence options.',
            ),
            TopicContent(
              title: 'Cache strategies',
              content: 'Cache-aside: app manages cache. Write-through: write to cache and DB. Write-behind: async DB write. Read-through: cache loads from DB. Choose based on use case.',
            ),
            TopicContent(
              title: 'CDN',
              content: 'Content Delivery Network caches static assets globally. Reduces latency by serving from nearest location. CloudFlare, AWS CloudFront. Cache images, CSS, JS.',
            ),
            TopicContent(
              title: 'Server-side caching',
              content: 'Cache database queries, API responses, computed results. Redis, Memcached. Invalidate on data changes. Significantly improves performance.',
            ),
            TopicContent(
              title: 'Client-side caching',
              content: 'Browser caches with Cache-Control headers. Service workers for offline support. LocalStorage for persistent data. Reduce server requests.',
            ),
          ],
          resources: [
            'Redis Documentation',
            'Caching Best Practices',
            'Redis University',
          ],
        ),
        RoadmapStep(
          title: 'Testing',
          description: 'Write backend tests',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Unit testing',
              content: 'Test individual functions in isolation. Mock dependencies. Fast execution. Example: test database queries without actual DB. Focus on single responsibility.',
            ),
            TopicContent(
              title: 'Integration testing',
              content: 'Test multiple components together. Database, API endpoints, external services. More realistic than unit tests. Slower but catch integration issues.',
            ),
            TopicContent(
              title: 'Jest/Mocha',
              content: 'Jest: all-in-one testing framework with mocking, assertions, coverage. Mocha: flexible test runner, pair with Chai for assertions. Both widely used in Node.js.',
            ),
            TopicContent(
              title: 'Supertest for APIs',
              content: 'Test HTTP endpoints without starting server. Make requests, assert responses. Works with Express. Example: request(app).get("/api/users").expect(200).',
            ),
            TopicContent(
              title: 'Test coverage',
              content: 'Measure percentage of code tested. Istanbul/nyc for coverage reports. Aim for 80%+ coverage. Don\'t chase 100%, focus on critical paths.',
            ),
            TopicContent(
              title: 'TDD approach',
              content: 'Test-Driven Development: write test first, then code. Red (fail) → Green (pass) → Refactor. Ensures testable code and clear requirements.',
            ),
          ],
          resources: [
            'Jest Documentation',
            'Testing Node.js Apps',
            'Test-Driven Development',
          ],
        ),
        RoadmapStep(
          title: 'GraphQL (Optional)',
          description: 'Alternative to REST',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'GraphQL basics',
              content: 'Query language for APIs. Request exactly what you need. Single endpoint. Strongly typed schema. Reduces over-fetching and under-fetching.',
            ),
            TopicContent(
              title: 'Queries and mutations',
              content: 'Queries fetch data (like GET). Mutations modify data (like POST/PUT/DELETE). Subscriptions for real-time updates. Arguments for filtering and pagination.',
            ),
            TopicContent(
              title: 'Schema design',
              content: 'Define types, queries, mutations. Type system with scalars (String, Int, Boolean), objects, enums. Schema-first or code-first approach.',
            ),
            TopicContent(
              title: 'Apollo Server',
              content: 'Popular GraphQL server for Node.js. Easy setup, integrates with Express. Built-in playground for testing. Supports subscriptions and caching.',
            ),
            TopicContent(
              title: 'Resolvers',
              content: 'Functions that fetch data for each field. Map schema fields to data sources. Can be async. Chain resolvers for nested data.',
            ),
            TopicContent(
              title: 'GraphQL vs REST',
              content: 'GraphQL: single endpoint, flexible queries, no over-fetching. REST: multiple endpoints, standard HTTP, simpler caching. Choose based on use case.',
            ),
          ],
          resources: [
            'GraphQL Documentation',
            'Apollo Server Docs',
            'How to GraphQL',
          ],
        ),
        RoadmapStep(
          title: 'Containerization',
          description: 'Learn Docker',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Docker basics',
              content: 'Platform for developing, shipping, running applications in containers. Consistent environments across dev, test, prod. Images are blueprints, containers are running instances.',
            ),
            TopicContent(
              title: 'Containers vs VMs',
              content: 'Containers share host OS kernel, lightweight, fast startup. VMs include full OS, heavier, slower. Containers for microservices, VMs for isolation.',
            ),
            TopicContent(
              title: 'Dockerfile',
              content: 'Instructions to build Docker image. FROM base image, COPY files, RUN commands, EXPOSE ports, CMD start command. Layer caching for faster builds.',
            ),
            TopicContent(
              title: 'Docker Compose',
              content: 'Define multi-container apps with YAML. Services, networks, volumes. docker-compose up starts all services. Great for local development with databases.',
            ),
            TopicContent(
              title: 'Container orchestration basics',
              content: 'Manage multiple containers at scale. Kubernetes most popular. Auto-scaling, load balancing, self-healing. Docker Swarm simpler alternative.',
            ),
          ],
          resources: [
            'Docker Documentation',
            'Docker Mastery',
            'Play with Docker',
          ],
        ),
        RoadmapStep(
          title: 'Web Servers',
          description: 'Understand web servers',
          duration: '2 weeks',
          topics: [
            TopicContent(
              title: 'Nginx basics',
              content: 'High-performance web server and reverse proxy. Handles static files, load balancing, SSL termination. Configuration with nginx.conf. Widely used in production.',
            ),
            TopicContent(
              title: 'Apache',
              content: 'Mature, feature-rich web server. .htaccess for directory-level config. Modules for extended functionality. More resource-intensive than Nginx.',
            ),
            TopicContent(
              title: 'Reverse proxy',
              content: 'Server sits between clients and backend servers. Forwards requests, returns responses. Load balancing, caching, SSL termination. Hides backend architecture.',
            ),
            TopicContent(
              title: 'Load balancing',
              content: 'Distribute traffic across multiple servers. Round-robin, least connections, IP hash algorithms. Improves availability and scalability. Health checks for failed servers.',
            ),
            TopicContent(
              title: 'SSL/TLS',
              content: 'Encrypt data in transit with HTTPS. SSL certificates from Let\'s Encrypt (free). TLS 1.2+ recommended. Configure in web server. Essential for security.',
            ),
          ],
          resources: [
            'Nginx Documentation',
            'Web Server Guide',
            'Let\'s Encrypt',
          ],
        ),
        RoadmapStep(
          title: 'Message Brokers',
          description: 'Learn RabbitMQ or Kafka',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Message queue concepts',
              content: 'Asynchronous communication between services. Producers send messages, consumers process them. Decouples services, handles load spikes, ensures delivery.',
            ),
            TopicContent(
              title: 'RabbitMQ basics',
              content: 'Message broker implementing AMQP protocol. Exchanges route messages to queues. Consumers subscribe to queues. Reliable, supports multiple messaging patterns.',
            ),
            TopicContent(
              title: 'Pub/Sub pattern',
              content: 'Publishers send messages to topics. Subscribers receive messages from topics. One-to-many communication. Decouples publishers from subscribers.',
            ),
            TopicContent(
              title: 'Event-driven architecture',
              content: 'Services communicate through events. Loose coupling, scalability, flexibility. Event producers, event bus, event consumers. Async processing.',
            ),
            TopicContent(
              title: 'Kafka basics',
              content: 'Distributed streaming platform. High throughput, fault-tolerant. Topics, partitions, producers, consumers. Used for real-time data pipelines and streaming.',
            ),
          ],
          resources: [
            'RabbitMQ Tutorial',
            'Kafka Documentation',
            'Message Brokers Guide',
          ],
        ),
        RoadmapStep(
          title: 'Deployment',
          description: 'Deploy your applications',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Cloud platforms (AWS, Azure, GCP)',
              content: 'Host applications on cloud infrastructure. AWS most popular, Azure for Microsoft stack, GCP for Google services. Pay-as-you-go pricing. Scalable, reliable.',
            ),
            TopicContent(
              title: 'CI/CD pipelines',
              content: 'Continuous Integration: automated testing on code changes. Continuous Deployment: automated deployment to production. GitHub Actions, Jenkins, GitLab CI. Faster, safer releases.',
            ),
            TopicContent(
              title: 'Environment variables',
              content: 'Store configuration outside code. API keys, database URLs, secrets. Different values for dev, staging, prod. Use .env files locally, cloud config in production.',
            ),
            TopicContent(
              title: 'Monitoring and logging',
              content: 'Track application health and errors. Logs for debugging. Metrics for performance. Alerts for issues. Tools: CloudWatch, Datadog, New Relic, ELK stack.',
            ),
            TopicContent(
              title: 'Scaling strategies',
              content: 'Vertical scaling: bigger servers. Horizontal scaling: more servers. Load balancing distributes traffic. Auto-scaling adjusts capacity. Database replication and sharding.',
            ),
          ],
          resources: [
            'AWS Documentation',
            'Heroku Guide',
            'DigitalOcean Tutorials',
          ],
        ),
      ],
    ),

    // Full Stack Web Development
    TechRoadmap(
      title: 'Full Stack Web Development',
      description: 'Complete path from frontend to backend development',
      category: 'Web Development',
      duration: '10-12 months',
      icon: Icons.web,
      color: Colors.indigo,
      steps: [
        RoadmapStep(
          title: 'HTML & CSS Basics',
          description: 'Learn the foundation of web development',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'HTML5 semantic elements',
              content: 'Meaningful tags: header, nav, main, article, section, aside, footer. Improve accessibility and SEO. Better than generic divs. Screen readers understand structure.',
            ),
            TopicContent(
              title: 'CSS selectors and properties',
              content: 'Target elements with selectors: element, .class, #id, [attribute]. Style with properties: color, font-size, margin, padding. Specificity determines which styles apply.',
            ),
            TopicContent(
              title: 'Flexbox and Grid layouts',
              content: 'Flexbox for one-dimensional layouts (rows or columns). Grid for two-dimensional layouts. Both responsive and powerful. Modern CSS layout systems.',
            ),
            TopicContent(
              title: 'Responsive design',
              content: 'Websites adapt to different screen sizes. Mobile-first approach. Relative units (%, em, rem). Flexible images. Test on multiple devices.',
            ),
            TopicContent(
              title: 'CSS animations',
              content: 'Transitions for smooth property changes. Keyframe animations for complex sequences. Transform for movement, rotation, scaling. Enhance user experience.',
            ),
          ],
          resources: [
            'MDN Web Docs',
            'freeCodeCamp',
            'CSS-Tricks',
          ],
        ),
        RoadmapStep(
          title: 'JavaScript Fundamentals',
          description: 'Master the language of the web',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Variables, data types, operators',
              content: 'let/const for variables. Primitives: string, number, boolean, null, undefined. Objects and arrays. Arithmetic, comparison, logical operators.',
            ),
            TopicContent(
              title: 'Functions and scope',
              content: 'Function declarations, expressions, arrow functions. Parameters and return values. Global, function, block scope. Closures capture outer scope.',
            ),
            TopicContent(
              title: 'Arrays and objects',
              content: 'Arrays store ordered lists. Objects store key-value pairs. Array methods: map, filter, reduce, forEach. Object destructuring and spread operator.',
            ),
            TopicContent(
              title: 'DOM manipulation',
              content: 'Access elements with querySelector. Modify content, attributes, styles. Add event listeners. Create and append elements. Make pages interactive.',
            ),
            TopicContent(
              title: 'ES6+ features',
              content: 'Modern JavaScript: arrow functions, template literals, destructuring, spread/rest, classes, modules. Cleaner, more expressive code.',
            ),
            TopicContent(
              title: 'Async/await and Promises',
              content: 'Handle asynchronous operations. Promises represent future values. async/await makes async code look synchronous. Essential for API calls.',
            ),
          ],
          resources: [
            'JavaScript.info',
            'Eloquent JavaScript',
            'MDN JavaScript Guide',
          ],
        ),
        RoadmapStep(
          title: 'Frontend Framework (React)',
          description: 'Build modern interactive UIs',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Components and Props',
              content: 'Reusable UI pieces. Functional components return JSX. Props pass data from parent to child. Composition over inheritance.',
            ),
            TopicContent(
              title: 'State and Lifecycle',
              content: 'State is component data that changes. useState hook manages state. State changes trigger re-renders. Lifecycle with useEffect hook.',
            ),
            TopicContent(
              title: 'Hooks (useState, useEffect)',
              content: 'useState for state management. useEffect for side effects (API calls, subscriptions). Custom hooks for reusable logic. Rules of hooks.',
            ),
            TopicContent(
              title: 'Context API',
              content: 'Share data across component tree. Avoid prop drilling. createContext, Provider, useContext. Good for themes, auth, language.',
            ),
            TopicContent(
              title: 'React Router',
              content: 'Client-side routing for SPAs. Define routes, navigate between pages. URL parameters and query strings. Nested routes.',
            ),
            TopicContent(
              title: 'Form handling',
              content: 'Controlled components: input value tied to state. Handle onChange events. Form validation. Submit handling. Libraries like Formik simplify complex forms.',
            ),
          ],
          resources: [
            'React Official Docs',
            'React Tutorial',
            'Scrimba React Course',
          ],
        ),
        RoadmapStep(
          title: 'Backend with Node.js',
          description: 'Server-side JavaScript development',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Node.js basics',
              content: 'JavaScript runtime for server-side. Event-driven, non-blocking I/O. Built-in modules: fs, http, path. npm for packages.',
            ),
            TopicContent(
              title: 'Express.js framework',
              content: 'Minimal web framework for Node.js. Routing, middleware, request/response handling. Fast, unopinionated, widely used.',
            ),
            TopicContent(
              title: 'RESTful API design',
              content: 'REST principles: resources, HTTP methods, stateless. URL structure: /api/users/:id. JSON responses. Status codes.',
            ),
            TopicContent(
              title: 'Middleware',
              content: 'Functions with access to req, res, next. Execute code, modify objects, end request. Built-in, third-party, custom middleware.',
            ),
            TopicContent(
              title: 'Authentication (JWT)',
              content: 'JSON Web Tokens for stateless auth. Sign tokens with secret. Verify on protected routes. Include in Authorization header.',
            ),
            TopicContent(
              title: 'Error handling',
              content: 'Centralized error middleware. try/catch for async. Custom error classes. Proper status codes. Log errors securely.',
            ),
          ],
          resources: [
            'Node.js Docs',
            'Express.js Guide',
            'The Net Ninja',
          ],
        ),
        RoadmapStep(
          title: 'Database Management',
          description: 'Store and manage data',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'SQL basics (PostgreSQL)',
              content: 'Relational database with tables, rows, columns. SQL queries: SELECT, INSERT, UPDATE, DELETE. Joins, indexes, transactions.',
            ),
            TopicContent(
              title: 'MongoDB (NoSQL)',
              content: 'Document-oriented database. Flexible schema. Collections and documents. Queries, aggregation, indexing. Good for unstructured data.',
            ),
            TopicContent(
              title: 'Database design',
              content: 'Schema design, relationships (one-to-one, one-to-many, many-to-many). Normalization vs denormalization. Choose SQL vs NoSQL based on needs.',
            ),
            TopicContent(
              title: 'CRUD operations',
              content: 'Create, Read, Update, Delete. Basic database operations. Map to HTTP methods: POST, GET, PUT/PATCH, DELETE.',
            ),
            TopicContent(
              title: 'Indexing and optimization',
              content: 'Indexes speed up queries. Index frequently queried fields. Query optimization. Connection pooling. Caching strategies.',
            ),
          ],
          resources: [
            'PostgreSQL Tutorial',
            'MongoDB University',
            'Database Design Course',
          ],
        ),
        RoadmapStep(
          title: 'Deployment & DevOps',
          description: 'Deploy your applications',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Git and GitHub',
              content: 'Version control with Git. Branches, commits, merges. GitHub for collaboration. Pull requests, code reviews. Essential for teams.',
            ),
            TopicContent(
              title: 'Docker basics',
              content: 'Containerize applications. Consistent environments. Dockerfile defines image. docker-compose for multi-container apps. Simplifies deployment.',
            ),
            TopicContent(
              title: 'CI/CD pipelines',
              content: 'Automated testing and deployment. GitHub Actions, Jenkins. Run tests on every commit. Deploy automatically to production.',
            ),
            TopicContent(
              title: 'Cloud platforms (AWS/Heroku)',
              content: 'Host applications in the cloud. AWS for full control, Heroku for simplicity. Scalable, reliable. Pay-as-you-go pricing.',
            ),
            TopicContent(
              title: 'Environment variables',
              content: 'Store secrets and config outside code. Different values for dev/prod. .env files locally. Cloud platform config in production.',
            ),
          ],
          resources: [
            'GitHub Learning Lab',
            'Docker Documentation',
            'AWS Free Tier',
          ],
        ),
      ],
    ),

    // Python Development
    TechRoadmap(
      title: 'Python Developer',
      description: 'From basics to advanced Python programming',
      category: 'Programming',
      duration: '4-6 months',
      icon: Icons.code,
      color: Colors.green,
      steps: [
        RoadmapStep(
          title: 'Python Basics',
          description: 'Learn Python fundamentals',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Variables and data types',
              content: 'Variables store data: x = 10. Types: int, float, str, bool, list, dict. Dynamic typing. Type hints for clarity: def add(a: int, b: int) -> int.',
            ),
            TopicContent(
              title: 'Control flow (if/else, loops)',
              content: 'if/elif/else for conditions. for loops iterate over sequences. while loops repeat until condition false. break, continue, pass statements.',
            ),
            TopicContent(
              title: 'Functions and modules',
              content: 'Functions with def keyword. Parameters, return values. *args, **kwargs for variable arguments. Modules organize code. import statement.',
            ),
            TopicContent(
              title: 'Lists, tuples, dictionaries',
              content: 'Lists: mutable ordered collections [1, 2, 3]. Tuples: immutable (1, 2, 3). Dictionaries: key-value pairs {"name": "John"}. List comprehensions.',
            ),
            TopicContent(
              title: 'File handling',
              content: 'open() to read/write files. with statement ensures proper closing. read(), write(), readline() methods. JSON, CSV handling.',
            ),
          ],
          resources: [
            'Python.org Tutorial',
            'Automate the Boring Stuff',
            'Codecademy Python',
          ],
        ),
        RoadmapStep(
          title: 'Object-Oriented Programming',
          description: 'Master OOP concepts',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Classes and objects',
              content: 'Classes are blueprints. Objects are instances. __init__ constructor. self refers to instance. Attributes and methods.',
            ),
            TopicContent(
              title: 'Inheritance',
              content: 'Child classes inherit from parent. super() calls parent methods. Method overriding. Multiple inheritance possible but complex.',
            ),
            TopicContent(
              title: 'Polymorphism',
              content: 'Same method name, different implementations. Duck typing: if it walks like a duck... Method overriding enables polymorphism.',
            ),
            TopicContent(
              title: 'Encapsulation',
              content: 'Bundle data and methods. Private attributes with underscore: _private. Name mangling with double underscore: __private. Property decorators.',
            ),
            TopicContent(
              title: 'Magic methods',
              content: 'Special methods with double underscores: __str__, __repr__, __len__, __add__. Customize object behavior. Operator overloading.',
            ),
          ],
          resources: [
            'Real Python OOP',
            'Python OOP Tutorial',
            'Corey Schafer YouTube',
          ],
        ),
        RoadmapStep(
          title: 'Data Structures & Algorithms',
          description: 'Essential CS concepts',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Arrays and linked lists',
              content: 'Arrays: contiguous memory, O(1) access. Lists in Python are dynamic arrays. Linked lists: nodes with pointers, O(n) access, O(1) insertion.',
            ),
            TopicContent(
              title: 'Stacks and queues',
              content: 'Stack: LIFO (Last In First Out). push, pop operations. Queue: FIFO (First In First Out). enqueue, dequeue. Use collections.deque.',
            ),
            TopicContent(
              title: 'Trees and graphs',
              content: 'Trees: hierarchical structure. Binary trees, BST. Graphs: nodes and edges. Directed vs undirected. Adjacency list/matrix representation.',
            ),
            TopicContent(
              title: 'Sorting algorithms',
              content: 'Bubble, selection, insertion: O(n²). Merge, quick, heap: O(n log n). Python sorted() uses Timsort. Understand trade-offs.',
            ),
            TopicContent(
              title: 'Searching algorithms',
              content: 'Linear search: O(n). Binary search: O(log n) on sorted data. Hash tables: O(1) average. DFS and BFS for graphs.',
            ),
            TopicContent(
              title: 'Time complexity',
              content: 'Big O notation measures efficiency. O(1) constant, O(log n) logarithmic, O(n) linear, O(n²) quadratic. Analyze algorithms.',
            ),
          ],
          resources: [
            'LeetCode',
            'HackerRank',
            'GeeksforGeeks',
          ],
        ),
        RoadmapStep(
          title: 'Web Frameworks (Django/Flask)',
          description: 'Build web applications',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Django/Flask basics',
              content: 'Django: full-featured framework with ORM, admin, auth. Flask: lightweight, flexible microframework. Choose based on project needs.',
            ),
            TopicContent(
              title: 'URL routing',
              content: 'Map URLs to view functions. Django: urls.py patterns. Flask: @app.route() decorator. URL parameters and query strings.',
            ),
            TopicContent(
              title: 'Templates',
              content: 'HTML with dynamic content. Jinja2 template engine. Variables {{ }}, logic {% %}. Template inheritance. Filters and tags.',
            ),
            TopicContent(
              title: 'Forms and validation',
              content: 'Handle user input. Django forms or Flask-WTF. CSRF protection. Server-side validation. Display errors to users.',
            ),
            TopicContent(
              title: 'Database ORM',
              content: 'Object-Relational Mapping. Django ORM or SQLAlchemy. Define models as classes. Queries with Python code. Migrations for schema changes.',
            ),
            TopicContent(
              title: 'Authentication',
              content: 'User registration, login, logout. Django built-in auth. Flask-Login extension. Password hashing. Session management. Permissions.',
            ),
          ],
          resources: [
            'Django Documentation',
            'Flask Mega-Tutorial',
            'Django for Beginners',
          ],
        ),
        RoadmapStep(
          title: 'APIs and Testing',
          description: 'Build and test APIs',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'REST API design',
              content: 'RESTful principles. Resources, HTTP methods, status codes. JSON responses. API versioning. Documentation.',
            ),
            TopicContent(
              title: 'Django REST Framework',
              content: 'Powerful toolkit for building APIs. Serializers convert models to JSON. ViewSets and routers. Authentication and permissions. Browsable API.',
            ),
            TopicContent(
              title: 'Unit testing',
              content: 'Test individual functions. pytest or unittest. Assertions, fixtures, mocking. Test-driven development. Aim for high coverage.',
            ),
            TopicContent(
              title: 'Integration testing',
              content: 'Test multiple components together. Test API endpoints. Database interactions. More realistic than unit tests.',
            ),
            TopicContent(
              title: 'API documentation',
              content: 'Document endpoints, parameters, responses. Swagger/OpenAPI specification. Auto-generated docs. Examples and use cases.',
            ),
          ],
          resources: [
            'DRF Documentation',
            'pytest Documentation',
            'Test-Driven Development',
          ],
        ),
      ],
    ),

    // Mobile Development
    TechRoadmap(
      title: 'Flutter Mobile Development',
      description: 'Build cross-platform mobile apps',
      category: 'Mobile Development',
      duration: '5-7 months',
      icon: Icons.phone_android,
      color: Colors.cyan,
      steps: [
        RoadmapStep(
          title: 'Dart Programming',
          description: 'Learn Dart language basics',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Dart syntax',
              content: 'C-style syntax. Strongly typed with type inference. var, final, const for variables. Semicolons required. Main() entry point.',
            ),
            TopicContent(
              title: 'Variables and types',
              content: 'int, double, String, bool, List, Map. Type inference with var. final for runtime constants, const for compile-time. Null safety with ?.',
            ),
            TopicContent(
              title: 'Functions',
              content: 'First-class objects. Named and positional parameters. Optional parameters with []. Arrow syntax for single expressions. Anonymous functions.',
            ),
            TopicContent(
              title: 'Classes and OOP',
              content: 'Classes with constructors. Named constructors. Inheritance with extends. Mixins with with. Abstract classes and interfaces.',
            ),
            TopicContent(
              title: 'Async programming',
              content: 'Future for single async value. Stream for multiple values. async/await syntax. then() and catchError(). Essential for API calls.',
            ),
          ],
          resources: [
            'Dart.dev',
            'Dart Language Tour',
            'DartPad',
          ],
        ),
        RoadmapStep(
          title: 'Flutter Basics',
          description: 'Understand Flutter framework',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Widgets (Stateless/Stateful)',
              content: 'Everything is a widget. StatelessWidget for static UI. StatefulWidget for dynamic UI with setState(). Build method returns widget tree.',
            ),
            TopicContent(
              title: 'Layouts (Row, Column, Stack)',
              content: 'Row for horizontal layout. Column for vertical. Stack for overlapping. Expanded and Flexible for responsive sizing. Padding, Container for spacing.',
            ),
            TopicContent(
              title: 'Material Design',
              content: 'Google\'s design system. Scaffold, AppBar, FloatingActionButton. Material widgets: Card, ListTile, Drawer. Theme for consistent styling.',
            ),
            TopicContent(
              title: 'Navigation',
              content: 'Navigator.push() and pop() for routes. Named routes for organization. Pass data between screens. Bottom navigation, tabs, drawer.',
            ),
            TopicContent(
              title: 'Forms and input',
              content: 'TextField for text input. Form and TextFormField for validation. Controllers manage input. onChanged, onSubmitted callbacks.',
            ),
          ],
          resources: [
            'Flutter.dev',
            'Flutter Cookbook',
            'Flutter Widget Catalog',
          ],
        ),
        RoadmapStep(
          title: 'State Management',
          description: 'Manage app state effectively',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Provider',
              content: 'Recommended by Flutter team. ChangeNotifier for state. Provider wraps widget tree. Consumer rebuilds on changes. Simple and powerful.',
            ),
            TopicContent(
              title: 'Riverpod',
              content: 'Improved Provider. Compile-safe, testable. No BuildContext needed. Providers are global. Auto-dispose. Modern choice.',
            ),
            TopicContent(
              title: 'Bloc pattern',
              content: 'Business Logic Component. Separates UI from logic. Events trigger state changes. Streams for reactive programming. Predictable state.',
            ),
            TopicContent(
              title: 'GetX',
              content: 'All-in-one solution. State management, routing, dependency injection. Minimal boilerplate. Reactive programming. Controversial but popular.',
            ),
            TopicContent(
              title: 'State management best practices',
              content: 'Choose based on app complexity. setState for local state. Provider/Riverpod for app state. Separate business logic from UI. Test state logic.',
            ),
          ],
          resources: [
            'Provider Package',
            'Bloc Library',
            'Flutter State Management',
          ],
        ),
        RoadmapStep(
          title: 'Backend Integration',
          description: 'Connect to APIs and databases',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'HTTP requests',
              content: 'http package for API calls. GET, POST, PUT, DELETE methods. JSON encoding/decoding. Error handling. Async/await for requests.',
            ),
            TopicContent(
              title: 'REST API integration',
              content: 'Connect to RESTful APIs. Parse JSON responses. Model classes for data. Repository pattern. Handle loading, success, error states.',
            ),
            TopicContent(
              title: 'Firebase',
              content: 'Backend-as-a-Service. Authentication, Firestore database, Storage, Cloud Functions. Real-time updates. Easy integration with Flutter.',
            ),
            TopicContent(
              title: 'Supabase',
              content: 'Open-source Firebase alternative. PostgreSQL database. Authentication, storage, real-time subscriptions. REST and GraphQL APIs.',
            ),
            TopicContent(
              title: 'Local storage (Hive/SQLite)',
              content: 'Hive: fast NoSQL database. SQLite: relational database. SharedPreferences for simple key-value. Offline-first apps.',
            ),
          ],
          resources: [
            'Firebase Flutter',
            'Supabase Flutter',
            'HTTP Package Docs',
          ],
        ),
        RoadmapStep(
          title: 'Advanced Features',
          description: 'Add professional features',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Animations',
              content: 'Implicit animations: AnimatedContainer, AnimatedOpacity. Explicit animations with AnimationController. Hero animations for transitions. Lottie for complex animations.',
            ),
            TopicContent(
              title: 'Custom painters',
              content: 'CustomPaint widget for custom graphics. Canvas API for drawing. Paths, shapes, gradients. Create unique UI elements.',
            ),
            TopicContent(
              title: 'Platform channels',
              content: 'Communicate with native code (Android/iOS). MethodChannel for method calls. EventChannel for streams. Access platform-specific features.',
            ),
            TopicContent(
              title: 'Push notifications',
              content: 'Firebase Cloud Messaging for notifications. Local notifications. Handle foreground, background, terminated states. Deep linking.',
            ),
            TopicContent(
              title: 'In-app purchases',
              content: 'Monetize apps. in_app_purchase package. Consumables, non-consumables, subscriptions. Handle purchases, restore, verify.',
            ),
          ],
          resources: [
            'Flutter Animations',
            'Flutter Platform Channels',
            'Firebase Cloud Messaging',
          ],
        ),
        RoadmapStep(
          title: 'Testing & Deployment',
          description: 'Test and publish your app',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Unit testing',
              content: 'Test individual functions and classes. test package. Mocking with mockito. Fast execution. Test business logic.',
            ),
            TopicContent(
              title: 'Widget testing',
              content: 'Test UI components. flutter_test package. Find widgets, tap, enter text. Verify UI behavior. Faster than integration tests.',
            ),
            TopicContent(
              title: 'Integration testing',
              content: 'Test complete app flow. integration_test package. Run on real devices/emulators. Slower but comprehensive.',
            ),
            TopicContent(
              title: 'Play Store deployment',
              content: 'Build release APK/AAB. Sign with keystore. Create Play Console account. Upload, fill store listing. Review process.',
            ),
            TopicContent(
              title: 'App Store deployment',
              content: 'Build iOS release. Xcode for signing. App Store Connect account. Screenshots, description. Review guidelines. TestFlight for beta.',
            ),
          ],
          resources: [
            'Flutter Testing',
            'Play Console Guide',
            'App Store Connect',
          ],
        ),
      ],
    ),

    // Data Science
    TechRoadmap(
      title: 'Data Science & ML',
      description: 'Master data analysis and machine learning',
      category: 'Data Science',
      duration: '8-10 months',
      icon: Icons.analytics,
      color: Colors.purple,
      steps: [
        RoadmapStep(
          title: 'Python for Data Science',
          description: 'Python libraries for data work',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'NumPy arrays',
              content: 'Numerical Python library for array operations. Fast mathematical computations on multi-dimensional arrays. Broadcasting, vectorization, linear algebra. Foundation for data science.',
            ),
            TopicContent(
              title: 'Pandas DataFrames',
              content: 'Data manipulation library with DataFrame structure. Read CSV, Excel, SQL. Filter, group, merge, pivot data. Essential for data cleaning and analysis.',
            ),
            TopicContent(
              title: 'Matplotlib visualization',
              content: 'Plotting library for creating static, animated visualizations. Line plots, scatter plots, bar charts, histograms. Customize colors, labels, legends. Publication-quality figures.',
            ),
            TopicContent(
              title: 'Seaborn plots',
              content: 'Statistical visualization built on Matplotlib. Beautiful default styles. Heatmaps, violin plots, pair plots. Easier syntax for complex visualizations.',
            ),
            TopicContent(
              title: 'Jupyter Notebooks',
              content: 'Interactive coding environment. Mix code, visualizations, markdown text. Cell-by-cell execution. Perfect for data exploration and sharing analysis.',
            ),
          ],
          resources: [
            'Kaggle Learn',
            'DataCamp',
            'Python Data Science Handbook',
          ],
        ),
        RoadmapStep(
          title: 'Statistics & Mathematics',
          description: 'Essential math for data science',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Descriptive statistics',
              content: 'Summarize data with mean, median, mode, standard deviation, variance. Understand distributions, outliers, correlations. Foundation for data analysis.',
            ),
            TopicContent(
              title: 'Probability',
              content: 'Likelihood of events occurring. Probability distributions: normal, binomial, Poisson. Conditional probability, Bayes theorem. Essential for ML algorithms.',
            ),
            TopicContent(
              title: 'Hypothesis testing',
              content: 'Test assumptions about data. Null and alternative hypotheses. P-values, confidence intervals, t-tests, chi-square. Determine statistical significance.',
            ),
            TopicContent(
              title: 'Linear algebra',
              content: 'Vectors, matrices, operations. Dot products, matrix multiplication, eigenvalues. Foundation for ML algorithms, especially neural networks.',
            ),
            TopicContent(
              title: 'Calculus basics',
              content: 'Derivatives for optimization. Gradients in gradient descent. Partial derivatives for multivariable functions. Understanding how ML models learn.',
            ),
          ],
          resources: [
            'Khan Academy Statistics',
            'StatQuest YouTube',
            '3Blue1Brown',
          ],
        ),
        RoadmapStep(
          title: 'Machine Learning Basics',
          description: 'Introduction to ML algorithms',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Supervised learning',
              content: 'Learn from labeled data. Input features map to output labels. Training, validation, test sets. Regression and classification tasks.',
            ),
            TopicContent(
              title: 'Unsupervised learning',
              content: 'Find patterns in unlabeled data. Clustering (K-means, hierarchical), dimensionality reduction (PCA). Anomaly detection, association rules.',
            ),
            TopicContent(
              title: 'Linear regression',
              content: 'Predict continuous values. Fit line to data points. Minimize mean squared error. Simple yet powerful baseline model.',
            ),
            TopicContent(
              title: 'Classification',
              content: 'Predict categories. Logistic regression, decision trees, SVM, random forests. Binary and multi-class classification. Confusion matrix, accuracy, precision, recall.',
            ),
            TopicContent(
              title: 'Decision trees',
              content: 'Tree-like model of decisions. Split data based on features. Easy to interpret. Prone to overfitting. Basis for random forests and gradient boosting.',
            ),
            TopicContent(
              title: 'Model evaluation',
              content: 'Assess model performance. Train/test split, cross-validation. Metrics: accuracy, precision, recall, F1-score, ROC-AUC. Avoid overfitting and underfitting.',
            ),
          ],
          resources: [
            'Scikit-learn Docs',
            'Andrew Ng Course',
            'Hands-On ML Book',
          ],
        ),
        RoadmapStep(
          title: 'Deep Learning',
          description: 'Neural networks and deep learning',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Neural networks',
              content: 'Layers of interconnected neurons. Forward propagation, backpropagation. Activation functions (ReLU, sigmoid, tanh). Learn complex patterns from data.',
            ),
            TopicContent(
              title: 'TensorFlow/PyTorch',
              content: 'Deep learning frameworks. Build, train, deploy neural networks. TensorFlow by Google, PyTorch by Facebook. GPU acceleration for faster training.',
            ),
            TopicContent(
              title: 'CNNs for images',
              content: 'Convolutional Neural Networks for computer vision. Convolutional layers extract features. Pooling layers reduce dimensions. Image classification, object detection.',
            ),
            TopicContent(
              title: 'RNNs for sequences',
              content: 'Recurrent Neural Networks for sequential data. LSTMs and GRUs handle long-term dependencies. Time series, text, speech. Sequence-to-sequence models.',
            ),
            TopicContent(
              title: 'Transfer learning',
              content: 'Use pre-trained models as starting point. Fine-tune on your data. Saves time and computational resources. Models like ResNet, BERT, GPT.',
            ),
          ],
          resources: [
            'Fast.ai',
            'TensorFlow Tutorials',
            'Deep Learning Specialization',
          ],
        ),
        RoadmapStep(
          title: 'Projects & Portfolio',
          description: 'Build real-world projects',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Kaggle competitions',
              content: 'Practice on real datasets. Compete with data scientists worldwide. Learn from kernels and discussions. Build portfolio with competition results.',
            ),
            TopicContent(
              title: 'End-to-end projects',
              content: 'Complete ML pipeline: data collection, cleaning, EDA, modeling, evaluation, deployment. Document process. Showcase problem-solving skills.',
            ),
            TopicContent(
              title: 'Model deployment',
              content: 'Deploy models to production. Flask/FastAPI for APIs. Docker containers. Cloud platforms (AWS, GCP, Azure). Make models accessible.',
            ),
            TopicContent(
              title: 'Portfolio website',
              content: 'Showcase projects online. GitHub Pages, personal website. Write case studies. Include code, visualizations, results. Essential for job applications.',
            ),
            TopicContent(
              title: 'GitHub projects',
              content: 'Version control for projects. Clean, documented code. README with project description. Jupyter notebooks with analysis. Demonstrates coding skills.',
            ),
          ],
          resources: [
            'Kaggle',
            'GitHub',
            'Medium Articles',
          ],
        ),
      ],
    ),

    // DevOps
    TechRoadmap(
      title: 'DevOps Engineer',
      description: 'Master deployment and infrastructure',
      category: 'DevOps',
      duration: '6-8 months',
      icon: Icons.cloud,
      color: Colors.orange,
      steps: [
        RoadmapStep(
          title: 'Linux & Command Line',
          description: 'Master Linux fundamentals',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Linux basics',
              content: 'Navigate filesystem (cd, ls, pwd). File operations (cp, mv, rm, mkdir). Text viewing (cat, less, head, tail). Essential for server management.',
            ),
            TopicContent(
              title: 'Shell scripting',
              content: 'Automate tasks with bash scripts. Variables, loops, conditionals, functions. Cron jobs for scheduling. Make repetitive tasks efficient.',
            ),
            TopicContent(
              title: 'File permissions',
              content: 'Read, write, execute permissions. chmod changes permissions, chown changes ownership. User, group, others. Security through proper permissions.',
            ),
            TopicContent(
              title: 'Process management',
              content: 'View processes (ps, top, htop). Kill processes (kill, killall). Background jobs (&, bg, fg). Monitor system resources.',
            ),
            TopicContent(
              title: 'Networking basics',
              content: 'Check connectivity (ping, traceroute). Network config (ifconfig, ip). Port scanning (netstat, ss). SSH for remote access. Essential for DevOps.',
            ),
          ],
          resources: [
            'Linux Journey',
            'OverTheWire',
            'Linux Command Line Book',
          ],
        ),
        RoadmapStep(
          title: 'Version Control',
          description: 'Git and GitHub mastery',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Git basics',
              content: 'Initialize repos, commit changes, view history. Essential commands: init, clone, add, commit, push, pull. Track code changes over time.',
            ),
            TopicContent(
              title: 'Branching strategies',
              content: 'Git Flow, GitHub Flow, trunk-based development. Feature branches, release branches, hotfixes. Organize team collaboration.',
            ),
            TopicContent(
              title: 'Pull requests',
              content: 'Propose changes for review. Code review process. Discuss, approve, merge. CI checks run automatically. Quality control mechanism.',
            ),
            TopicContent(
              title: 'Git workflows',
              content: 'Team collaboration patterns. Centralized, feature branch, forking workflows. Choose based on team size and project needs.',
            ),
            TopicContent(
              title: 'GitHub Actions',
              content: 'CI/CD automation on GitHub. Workflows triggered by events. Run tests, build, deploy. YAML configuration. Free for public repos.',
            ),
          ],
          resources: [
            'Pro Git Book',
            'GitHub Learning Lab',
            'Atlassian Git Tutorial',
          ],
        ),
        RoadmapStep(
          title: 'Containerization',
          description: 'Docker and container orchestration',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Docker basics',
              content: 'Containerize applications for consistency. Images are templates, containers are instances. docker run, build, ps, stop. Lightweight alternative to VMs.',
            ),
            TopicContent(
              title: 'Dockerfiles',
              content: 'Instructions to build images. FROM, COPY, RUN, EXPOSE, CMD. Layer caching for efficiency. Multi-stage builds reduce size.',
            ),
            TopicContent(
              title: 'Docker Compose',
              content: 'Define multi-container apps in YAML. Services, networks, volumes. docker-compose up/down. Perfect for local development environments.',
            ),
            TopicContent(
              title: 'Container networking',
              content: 'Bridge, host, overlay networks. Container communication. Port mapping. Network isolation for security. Service discovery.',
            ),
            TopicContent(
              title: 'Docker Hub',
              content: 'Registry for Docker images. Public and private repositories. Push/pull images. Official images for popular software. Version tagging.',
            ),
          ],
          resources: [
            'Docker Documentation',
            'Docker Mastery Course',
            'Play with Docker',
          ],
        ),
        RoadmapStep(
          title: 'CI/CD Pipelines',
          description: 'Automate deployment',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Jenkins',
              content: 'Popular open-source automation server. Build, test, deploy pipelines. Plugins for integration. Jenkinsfile for pipeline as code.',
            ),
            TopicContent(
              title: 'GitHub Actions',
              content: 'Native CI/CD for GitHub repos. Workflows in .github/workflows. Matrix builds, caching, artifacts. Free for public repos.',
            ),
            TopicContent(
              title: 'GitLab CI',
              content: 'Built-in CI/CD for GitLab. .gitlab-ci.yml configuration. Runners execute jobs. Auto DevOps for quick setup.',
            ),
            TopicContent(
              title: 'Pipeline design',
              content: 'Stages: build, test, deploy. Parallel execution for speed. Fail fast principle. Environment-specific deployments. Rollback strategies.',
            ),
            TopicContent(
              title: 'Automated testing',
              content: 'Run tests in pipeline. Unit, integration, E2E tests. Code coverage reports. Block deployment on test failures. Quality gates.',
            ),
          ],
          resources: [
            'Jenkins Documentation',
            'GitHub Actions Docs',
            'CI/CD Best Practices',
          ],
        ),
        RoadmapStep(
          title: 'Cloud Platforms',
          description: 'AWS, Azure, or GCP',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Cloud fundamentals',
              content: 'IaaS, PaaS, SaaS models. Pay-as-you-go pricing. Scalability, reliability, global reach. Regions and availability zones.',
            ),
            TopicContent(
              title: 'EC2/Compute',
              content: 'Virtual servers in cloud. Instance types for different workloads. Auto-scaling groups. Load balancers distribute traffic. Core compute service.',
            ),
            TopicContent(
              title: 'S3/Storage',
              content: 'Object storage for files. Buckets and objects. Versioning, lifecycle policies. Static website hosting. Highly durable and available.',
            ),
            TopicContent(
              title: 'Networking',
              content: 'VPC for isolated networks. Subnets, route tables, internet gateways. Security groups and NACLs. VPN and Direct Connect.',
            ),
            TopicContent(
              title: 'IAM and security',
              content: 'Identity and Access Management. Users, groups, roles, policies. Least privilege principle. MFA for security. Audit with CloudTrail.',
            ),
          ],
          resources: [
            'AWS Free Tier',
            'A Cloud Guru',
            'Cloud Academy',
          ],
        ),
        RoadmapStep(
          title: 'Monitoring & Logging',
          description: 'Monitor applications',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Prometheus',
              content: 'Open-source monitoring system. Time-series database. Pull-based metrics collection. PromQL query language. Alerting with Alertmanager.',
            ),
            TopicContent(
              title: 'Grafana',
              content: 'Visualization platform for metrics. Beautiful dashboards. Multiple data sources. Alerts and notifications. Community dashboards available.',
            ),
            TopicContent(
              title: 'ELK Stack',
              content: 'Elasticsearch, Logstash, Kibana for log management. Centralized logging. Search and analyze logs. Visualize with Kibana dashboards.',
            ),
            TopicContent(
              title: 'Application monitoring',
              content: 'Track app performance and errors. APM tools (New Relic, Datadog). Response times, error rates, throughput. User experience monitoring.',
            ),
            TopicContent(
              title: 'Log aggregation',
              content: 'Collect logs from multiple sources. Centralized storage and analysis. Structured logging. Retention policies. Debug production issues.',
            ),
          ],
          resources: [
            'Prometheus Docs',
            'Grafana Tutorials',
            'Elastic Documentation',
          ],
        ),
      ],
    ),

  ];
}

