import 'package:flutter/material.dart';

class TopicContent {
  final String title;
  final String content;

  const TopicContent({
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

  const RoadmapStep({
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

  const TechRoadmap({
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
    static const List<TechRoadmap> allRoadmaps = [
    // Frontend Developer
    TechRoadmap(
      title: 'Frontend Developer',
      description: 'Master the art of creating beautiful, interactive web interfaces.',
      category: 'Web Development',
      duration: '6-9 months',
      icon: Icons.web,
      color: Colors.blue,
      steps: [
        RoadmapStep(
          title: 'Internet & Web Fundamentals',
          description: 'Understanding the underlying infrastructure of the web.',
          duration: '1-2 weeks',
          topics: [
            TopicContent(
              title: 'How the Internet Works',
              content: 'The internet is a vast global network. Learn about the TCP/IP model, packet switching, routers, ISPs, and the physical infrastructure (cables, satellites) that connects the world.',
            ),
            TopicContent(
              title: 'HTTP/HTTPS & Protocols',
              content: 'Deep dive into HyperText Transfer Protocol. Understand methods (GET, POST, PUT, DELETE), status codes (200s, 300s, 400s, 500s), headers, cookies, and the handshake process of SSL/TLS for security.',
            ),
            TopicContent(
              title: 'DNS & Domains',
              content: 'The phonebook of the internet. Learn how Domain Name Systems resolve human-readable URLs into IP addresses, record types (A, CNAME, MX), and propagation.',
            ),
             TopicContent(
              title: 'Browsers & Rendering',
              content: 'How browsers work: The DOM (Document Object Model) tree, CSSOM, Render Tree, Layout, and Paint. Understand the V8 engine (Chrome) and SpiderMonkey (Firefox).',
            ),
          ],
          resources: [
            'MDN Web Docs - How the Web Works',
            'CS50 Computer Science Introduction',
            'High Performance Browser Networking',
          ],
        ),
        RoadmapStep(
          title: 'HTML & Semantic Web',
          description: 'The skeleton of all web pages.',
          duration: '2 weeks',
          topics: [
            TopicContent(
              title: 'Semantic HTML5',
              content: 'Beyond <div>. Using <header>, <nav>, <main>, <article>, <section>, <aside>, <footer> for better SEO and accessibility. Understanding the document outline.',
            ),
            TopicContent(
              title: 'Forms & Validation',
              content: 'Creating robust forms with proper input types, labels, and native HTML5 validation attributes (required, pattern, min/max). Handling form submission and accessibility.',
            ),
            TopicContent(
              title: 'SEO & Accessibility (A11y)',
              content: 'Writing code for everyone and machines. Meta tags, Open Graph, ARIA roles, landmarks, tab limits, and ensuring screen reader compatibility.',
            ),
          ],
          resources: [
            'W3C HTML Standard',
            'WebAIM Accessibility Guide',
          ],
        ),
        RoadmapStep(
          title: 'CSS & Modern Layouts',
          description: 'Styling and responsive design mastery.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'The Box Model & Selectors',
              content: 'Mastering margins, borders, padding, and content. Understanding specificity wars, pseudo-classes (:hover, :focus), and pseudo-elements (::before, ::after).',
            ),
            TopicContent(
              title: 'Flexbox & Grid',
              content: 'Modern layout systems. Flexbox for 1D layouts (alignment, distribution) and CSS Grid for complex 2D layouts (areas, tracks). When to use which?',
            ),
            TopicContent(
              title: 'Responsive Design',
              content: 'Mobile-first approach. Media queries (@media), fluid typography (rem, em, vw), and responsive images (srcset, sizes).',
            ),
             TopicContent(
              title: 'Modern CSS Features',
              content: 'CSS Variables (Custom Properties), calc(), clamp(), transitions, animations, and transforms3D.',
            ),
          ],
          resources: [
            'CSS-Tricks Flexbox Guide',
            'CSS Grid Garden',
            'Smashing Magazine CSS',
          ],
        ),
        RoadmapStep(
          title: 'JavaScript Deep Dive',
          description: 'The programming language of the web.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'ES6+ Syntax',
              content: 'Arrow functions, destructuring, spread/rest operators, template literals, default parameters, and modules (import/export).',
            ),
            TopicContent(
              title: 'Async Programming',
              content: 'The Event Loop unraveled. Callbacks, Promises, async/await pattern, and error handling with try/catch. Microtasks vs Macrotasks.',
            ),
            TopicContent(
              title: 'DOM Manipulation',
              content: 'Selecting elements, traversing the tree, adding/removing nodes, and handling events (bubbling, capturing, delegation) efficiently.',
            ),
             TopicContent(
              title: 'Data Structures',
              content: 'Working with Arrays (map, filter, reduce), Objects, Maps, and Sets. Understanding reference vs value types.',
            ),
          ],
          resources: [
            'You Don\'t Know JS (Book Series)',
            'JavaScript.info',
            'Eloquent JavaScript',
          ],
        ),
        RoadmapStep(
          title: 'Frontend Frameworks',
          description: 'Building complex apps efficiently.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'React.js Ecosystem',
              content: 'Components, Props, Hooks (useState, useEffect, useMemo, useCallback), Virtual DOM, and unidirectional data flow. React Router for navigation.',
            ),
            TopicContent(
              title: 'State Management',
              content: 'Prop drilling vs Context API vs Global State libraries (Redux Toolkit, Zustand, Recoil). When to use which?',
            ),
            TopicContent(
              title: 'Framework Concepts',
              content: 'Understanding Single Page Applications (SPA), client-side routing, and component lifecycles.',
            ),
          ],
          resources: [
            'React Official Docs',
            'Redux Toolkit Essentials',
            'Kent C. Dodds Blog',
          ],
        ),
         RoadmapStep(
          title: 'Modern Ecosystem',
          description: 'Tools that power modern development.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Package Managers',
              content: 'npm vs yarn vs pnpm. Understanding package.json, semantic versioning, and locking dependencies.',
            ),
            TopicContent(
              title: 'Build Tools & Bundlers',
              content: 'Vite (fast dev server), Turbopack. Understanding Hot Module Replacement (HMR) and tree-shaking.',
            ),
            TopicContent(
              title: 'Modern Stylings',
              content: 'Tailwind CSS for utility-first styling. Radix UI / Shadcn UI for accessible, headless components. CSS Modules.',
            ),
            TopicContent(
              title: 'Git Version Control',
              content: 'Branching strategies (Git Flow), pull requests, merge conflicts, and conventional commits.',
            ),
          ],
          resources: [
            'Vite Documentation',
            'Tailwind CSS Docs',
            'Pro Git Book',
          ],
        ),
        RoadmapStep(
          title: 'Testing Fundamentals',
          description: 'Ensuring code quality and reliability.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Unit Testing with Jest',
              content: 'Test runners, assertions, mocking, and spies. Code coverage reports and TDD (Test-Driven Development) approach.',
            ),
            TopicContent(
              title: 'Component Testing',
              content: 'React Testing Library for testing components. User-event simulation, queries (getBy, queryBy, findBy), and async testing.',
            ),
            TopicContent(
              title: 'End-to-End Testing',
              content: 'Cypress or Playwright for full user flow testing. Recording tests, network interception, and visual regression.',
            ),
          ],
          resources: [
            'Jest Documentation',
            'Testing Library Docs',
            'Cypress Best Practices',
          ],
        ),
        RoadmapStep(
          title: 'TypeScript Mastery',
          description: 'Type-safe JavaScript development.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Type System Basics',
              content: 'Primitive types, interfaces, type aliases, union/intersection types. Type inference and type narrowing.',
            ),
            TopicContent(
              title: 'Generics & Advanced Types',
              content: 'Generic functions and classes. Conditional types, mapped types, and template literal types.',
            ),
            TopicContent(
              title: 'Utility Types',
              content: 'Partial, Required, Pick, Omit, Record, ReturnType. Creating custom utility types for reusable patterns.',
            ),
          ],
          resources: [
            'TypeScript Handbook',
            'Type Challenges',
          ],
        ),
      ],
    ),

    // Backend Developer
    TechRoadmap(
      title: 'Backend Developer',
      description: 'Architecting the server-side, databases, and APIs.',
      category: 'Web Development',
      duration: '7-10 months',
      icon: Icons.dns,
      color: Colors.green,
      steps: [
        RoadmapStep(
          title: 'OS & Server Basics',
          description: 'Linux and Runtime Environments.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Linux Command Line',
              content: 'Bash scripting, file permissions (chmod/chown), process management (ps, kill), and SSH for remote server access.',
            ),
            TopicContent(
              title: 'Process & Threads',
              content: 'Understanding concurrency, parallelism, blocking vs non-blocking I/O, and memory management basics.',
            ),
          ],
          resources: [
            'Linux Command Line Adventure',
            'Operating Systems Concepts',
          ],
        ),
        RoadmapStep(
          title: 'Programming Languages',
          description: 'Choosing a backend weapon.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Node.js (JavaScript)',
              content: 'Event-driven, non-blocking I/O model. Express.js or NestJS frameworks. Great for real-time apps.',
            ),
            TopicContent(
              title: 'Python',
              content: 'Django (batteries included) or FastAPI (modern, fast). Great for AI/ML integration and rapid development.',
            ),
             TopicContent(
              title: 'Go / Rust',
              content: 'High-performance systems. Go for microservices, Rust for safety and speed.',
            ),
          ],
          resources: [
            'Node.js Design Patterns',
            'FastAPI Documentation',
          ],
        ),
        RoadmapStep(
          title: 'Databases & Backend as a Service',
          description: 'Storing and managing data.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Relational (SQL)',
              content: 'PostgreSQL/MySQL. ACID compliance, normalization (1NF-3NF), complex joins, indexing strategies, and viral transactions.',
            ),
            TopicContent(
              title: 'NoSQL & Caching',
              content: 'MongoDB (Document), Redis (Key-Value). CAP theorem. Eventual consistency basics.',
            ),
            TopicContent(
              title: 'Supabase / Firebase',
              content: 'BaaS Providers. Authentication, Realtime Database/Postgres, Storage buckets, and Edge Functions.',
            ),
            TopicContent(
              title: 'ORMs',
              content: 'Prisma, Drizzle ORM. Type-safe database access and migration management.',
            ),
          ],
          resources: [
            'PostgreSQL Official Docs',
            'Supabase Documentation',
            'Prisma Guide',
          ],
        ),
        RoadmapStep(
          title: 'API Design',
          description: 'Communication interfaces.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'RESTful Architecture',
              content: 'Resources, statelessness, HATEOAS, HTTP verbs, status codes, and versioning strategies.',
            ),
            TopicContent(
              title: 'GraphQL',
              content: 'Schemas, types, queries, mutations, resolvers. Avoiding N+1 problem. Apollo Server.',
            ),
            TopicContent(
              title: 'Authentication & Authorization',
              content: 'JWT (JSON Web Tokens), OAuth2, OIDC, Session-based auth. RBAC (Role-Based Access Control).',
            ),
          ],
          resources: [
            'REST API Design Rulebook',
            'GraphQL.org',
          ],
        ),
         RoadmapStep(
          title: 'System Design & DevOps',
          description: 'Scaling and deploying.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Caching Strategies',
              content: 'Client-side, CDN, Load Balancer, Server-side (Redis/Memcached). Cache-aside vs Write-through.',
            ),
            TopicContent(
              title: 'Containerization',
              content: 'Docker images, containers, volumes, networking. Docker Compose for dev environments.',
            ),
             TopicContent(
              title: 'CI/CD Pipelines',
              content: 'Automated testing and deployment using GitHub Actions or GitLab CI.',
            ),
          ],
          resources: [
            'System Design Primer',
            'Docker Documentation',
          ],
        ),
        RoadmapStep(
          title: 'Security & Authentication',
          description: 'Protecting your APIs and data.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'JWT & Session Management',
              content: 'JSON Web Tokens structure (header, payload, signature). Access vs Refresh tokens. Secure session handling.',
            ),
            TopicContent(
              title: 'OAuth2 & OIDC',
              content: 'Authorization flows (Authorization Code, PKCE). OpenID Connect for identity. Social login integration.',
            ),
            TopicContent(
              title: 'Secure Coding Practices',
              content: 'Input validation, SQL injection prevention, XSS protection. OWASP Top 10 vulnerabilities and mitigations.',
            ),
          ],
          resources: [
            'OWASP Security Guide',
            'OAuth2 Simplified',
          ],
        ),
        RoadmapStep(
          title: 'Microservices Architecture',
          description: 'Building distributed systems.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Service Communication',
              content: 'REST vs gRPC. Synchronous vs asynchronous messaging. Message brokers (RabbitMQ, Kafka).',
            ),
            TopicContent(
              title: 'API Gateway & Service Mesh',
              content: 'Kong, NGINX as gateways. Istio for service mesh. Rate limiting, circuit breakers, retries.',
            ),
            TopicContent(
              title: 'Event Sourcing & CQRS',
              content: 'Event-driven architecture patterns. Command Query Responsibility Segregation. Saga patterns for transactions.',
            ),
          ],
          resources: [
            'Microservices.io Patterns',
            'Building Microservices Book',
          ],
        ),
      ],
    ),

    // Full Stack Developer
    TechRoadmap(
      title: 'Full Stack Developer',
      description: 'The complete package: Frontend, Backend, and DevOps.',
      category: 'Web Development',
      duration: '10-12 months',
      icon: Icons.layers,
      color: Colors.indigo,
      steps: [
        RoadmapStep(
          title: 'The T-Shaped Skillset',
          description: 'Breadth across the stack, depth in one area.',
          duration: 'Ongoing',
          topics: [
            TopicContent(
              title: 'Balancing the Stack',
              content: 'Understanding how frontend decisions impact backend load and vice versa. Managing shared interfaces and types.',
            ),
          ],
          resources: [],
        ),
        RoadmapStep(
          title: 'Integration & Architecture',
          description: 'Connecting the pieces.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'API Integration',
              content: 'Consuming your own APIs. Error handling patterns, loading states, and data fetching (React Query/SWR).',
            ),
             TopicContent(
              title: 'Monorepos',
              content: 'Managing frontend and backend in one repo with tools like TurboRepo or Nx. Shared packages (types, utils).',
            ),
          ],
          resources: ['Monorepo Tools Guide'],
        ),
         RoadmapStep(
          title: 'Full Stack Frameworks',
          description: 'The meta-frameworks era.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Next.js / Nuxt',
              content: 'Server-Side Rendering (SSR), Static Site Generation (SSG), API Routes, Middleware, and Edge Functions.',
            ),
            TopicContent(
              title: 'Server Actions',
              content: 'Blurring the line between client and server code securely.',
            ),
          ],
          resources: ['Next.js Documentation'],
        ),
      ],
    ),

    // React Native Developer
    TechRoadmap(
      title: 'React Native Developer',
      description: 'Cross-platform mobile apps with React.',
      category: 'Mobile Development',
      duration: '6-8 months',
      icon: Icons.phone_android,
      color: Colors.purple,
      steps: [
        RoadmapStep(
          title: 'React Native Core',
          description: 'It is not the web.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Native Components',
              content: 'View, Text, Image, ScrollView, FlatList. Differences from HTML tags. Styling with Flexbox (defaults to column).',
            ),
            TopicContent(
              title: 'Metro Bundler',
              content: 'How the JS bundle is created and served to the simulator/device.',
            ),
          ],
          resources: ['React Native Docs'],
        ),
        RoadmapStep(
          title: 'Navigation & Architecture',
          description: 'Structuring mobile apps.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'React Navigation',
              content: 'Stack, Tab, Drawer navigators. Param passing and deep linking.',
            ),
            TopicContent(
              title: 'Native Modules',
              content: 'Bridging JavaScript to Native (Swift/Kotlin) code for platform-specific features.',
            ),
          ],
          resources: ['React Navigation Docs'],
        ),
        RoadmapStep(
          title: 'Performance',
          description: 'Hitting 60 FPS.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'JS Thread vs UI Thread',
              content: 'Keeping the bridge uncongested. Understanding frame drops.',
            ),
            TopicContent(
              title: 'Reanimated',
              content: 'Running animations on the UI thread for buttery smooth interactions.',
            ),
          ],
          resources: ['React Native Performance Guide'],
        ),
      ],
    ),

    // Flutter Developer
    TechRoadmap(
      title: 'Flutter Developer',
      description: 'Building beautiful native apps with Dart.',
      category: 'Mobile Development',
      duration: '4-6 months',
      icon: Icons.flutter_dash,
      color: Colors.blueAccent,
      steps: [
        RoadmapStep(
          title: 'Dart Mastery',
          description: 'The language engine.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Type System',
              content: 'Sound null safety, extensions, mixins, and generics.',
            ),
             TopicContent(
              title: 'Async Dart',
              content: 'Features, Streams, Isolates (concurrency). Event loop mechanics.',
            ),
          ],
          resources: ['Dart Language Guided Tour'],
        ),
        RoadmapStep(
          title: 'Flutter Framework',
          description: 'Widget composition.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Widget Tree',
              content: 'Everything is a widget. Element Tree and RenderObject Tree concepts for performance.',
            ),
            TopicContent(
              title: 'Layout',
              content: 'Constraint system: "Constraints go down. Sizes go up. Parent sets position."',
            ),
          ],
          resources: ['Flutter Internals'],
        ),
        RoadmapStep(
          title: 'Advanced State Management',
          description: 'Scalable app architecture.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Bloc / Cubit',
              content: 'Event-driven state management. Separating business logic from UI.',
            ),
             TopicContent(
              title: 'Riverpod',
              content: 'Compile-safe dependency injection and state management. Providers and modifiers.',
            ),
          ],
          resources: ['Bloc Library Docs', 'Riverpod Docs'],
        ),
        RoadmapStep(
          title: 'Platform Channels & Native',
          description: 'Bridging Flutter with native code.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Method Channels',
              content: 'Invoking native Android (Kotlin/Java) and iOS (Swift/ObjC) code from Dart. Handling responses and errors.',
            ),
            TopicContent(
              title: 'Platform Views',
              content: 'Embedding native views in Flutter. AndroidView and UiKitView widgets. Performance considerations.',
            ),
            TopicContent(
              title: 'Plugin Development',
              content: 'Creating reusable Flutter plugins. Federated plugin structure for multi-platform support.',
            ),
          ],
          resources: ['Flutter Platform Channels', 'Developing Packages Guide'],
        ),
        RoadmapStep(
          title: 'App Publishing & CI/CD',
          description: 'From source code to app stores.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'App Store Preparation',
              content: 'App icons, splash screens, versioning. Play Store console and App Store Connect setup.',
            ),
            TopicContent(
              title: 'Release Builds',
              content: 'Signing APK/AAB for Android. Provisioning profiles and certificates for iOS. Obfuscation and shrinking.',
            ),
            TopicContent(
              title: 'CI/CD Pipelines',
              content: 'Codemagic, Bitrise, or GitHub Actions for automated builds. Fastlane for deployment automation.',
            ),
          ],
          resources: ['Flutter Build/Release Docs', 'Codemagic Guide'],
        ),
      ],
    ),

    // DevOps Engineer
    TechRoadmap(
      title: 'DevOps Engineer',
      description: 'Bridging development and operations.',
      category: 'DevOps',
      duration: '8-10 months',
      icon: Icons.cloud,
      color: Colors.teal,
      steps: [
        RoadmapStep(
          title: 'Automation & Scripting',
          description: 'Automate everything.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Python for DevOps',
              content: 'Writing automation scripts, interacting with cloud APIs (boto3), and data processing.',
            ),
            TopicContent(
              title: 'Infrastructure as Code (IaC)',
              content: 'Terraform or OpenTofu. Declarative infrastructure management. State logic.',
            ),
          ],
          resources: ['Terraform Up & Running'],
        ),
        RoadmapStep(
          title: 'Container Orchestration',
          description: 'Managing fleets of containers.',
          duration: '5-6 weeks',
          topics: [
            TopicContent(
              title: 'Kubernetes (K8s) Architecture',
              content: 'Control Plane, Nodes, Pods, Services, Ingress, ConfigMaps, and Secrets.',
            ),
            TopicContent(
              title: 'Helm Charts',
              content: 'Package manager for K8s. Templating manifests.',
            ),
          ],
          resources: ['Kubernetes The Hard Way'],
        ),
        RoadmapStep(
          title: 'Observability',
          description: 'Logs, Metrics, and Traces.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'ELK / EFK Stack',
              content: 'Elasticsearch, Logstash/Fluentd, Kibana for logging.',
            ),
            TopicContent(
              title: 'Prometheus & Grafana',
              content: 'Time-series metrics collection and visualization dashboards.',
            ),
          ],
          resources: ['Prometheus Specs'],
        ),
        RoadmapStep(
          title: 'Security & Compliance (DevSecOps)',
          description: 'Shifting security left.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Container Security',
              content: 'Image scanning (Trivy, Snyk). Pod security policies. Secrets management (Vault, Sealed Secrets).',
            ),
            TopicContent(
              title: 'Vulnerability Management',
              content: 'SAST/DAST in CI pipelines. Dependency scanning. CVE tracking and patching workflows.',
            ),
            TopicContent(
              title: 'Compliance Automation',
              content: 'Policy as Code (OPA/Gatekeeper). SOC2, HIPAA, GDPR compliance checks. Audit logging.',
            ),
          ],
          resources: ['OWASP DevSecOps', 'HashiCorp Vault'],
        ),
        RoadmapStep(
          title: 'FinOps & Cost Optimization',
          description: 'Cloud cost management.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Cost Visibility',
              content: 'Cloud billing dashboards. Cost allocation tags. Showback and chargeback models.',
            ),
            TopicContent(
              title: 'Optimization Strategies',
              content: 'Right-sizing instances. Reserved/Spot instances. Auto-scaling policies. Serverless cost optimization.',
            ),
            TopicContent(
              title: 'FinOps Culture',
              content: 'Cross-team cost ownership. Budget alerts. Continuous cost optimization practices.',
            ),
          ],
          resources: ['FinOps Foundation', 'AWS Cost Optimization'],
        ),
      ],
    ),

    // Machine Learning Engineer
    TechRoadmap(
      title: 'Machine Learning Engineer',
      description: 'Building intelligent systems.',
      category: 'AI & Machine Learning',
      duration: '12-15 months',
      icon: Icons.psychology,
      color: Colors.deepPurple,
      steps: [
        RoadmapStep(
          title: 'Data Engineering',
          description: 'Getting data ready.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Data Pipelines',
              content: 'ETL (Extract, Transform, Load) processes. Apache Airflow / Prefect.',
            ),
            TopicContent(
              title: 'Feature Engineering',
              content: 'Encoding categorical data, normalization, handling missing values, and dimensionality reduction.',
            ),
          ],
          resources: ['Data Engineering Cookbook'],
        ),
        RoadmapStep(
          title: 'Model Architectures',
          description: 'Choosing the right brain.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Transformers',
              content: 'Attention mechanism. BERT, GPT architectures. Foundation of modern NLP.',
            ),
            TopicContent(
              title: 'Computer Vision',
              content: 'CNNs (ResNet, EfficientNet), Object Detection (YOLO), Segmentation.',
            ),
          ],
          resources: ['Fast.ai Deep Learning'],
        ),
        RoadmapStep(
          title: 'MLOps & Deployment',
          description: 'From notebook to production.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Model Serving',
              content: 'TF Serving, TorchServe, Triton Inference Server. ONNX runtime.',
            ),
            TopicContent(
              title: 'Experiment Tracking',
              content: 'MLflow, Weights & Biases. Versioning data and models.',
            ),
          ],
          resources: ['MLOps Community'],
        ),
        RoadmapStep(
          title: 'Large Language Models',
          description: 'The era of generative AI.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'LLM Architecture',
              content: 'Transformer architecture deep dive. GPT, LLaMA, Mistral variants. Tokenization and embeddings.',
            ),
            TopicContent(
              title: 'Prompt Engineering',
              content: 'Zero-shot, few-shot prompting. Chain-of-thought reasoning. System prompts and instruction tuning.',
            ),
            TopicContent(
              title: 'Fine-tuning Techniques',
              content: 'LoRA, QLoRA for efficient fine-tuning. RLHF (Reinforcement Learning from Human Feedback). DPO (Direct Preference Optimization).',
            ),
          ],
          resources: ['Hugging Face Course', 'Anthropic Prompt Engineering Guide'],
        ),
        RoadmapStep(
          title: 'Retrieval Augmented Generation',
          description: 'LLMs with external knowledge.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Vector Databases',
              content: 'Embeddings storage and similarity search. Pinecone, Weaviate, Chroma, FAISS. Indexing strategies.',
            ),
            TopicContent(
              title: 'RAG Pipeline Architecture',
              content: 'Chunking strategies, retrieval methods. Hybrid search (dense + sparse). Reranking for relevance.',
            ),
            TopicContent(
              title: 'LangChain & LlamaIndex',
              content: 'Building production RAG applications. Chains, agents, and tools. Memory management for conversations.',
            ),
          ],
          resources: ['LangChain Docs', 'Building LLM Applications'],
        ),
      ],
    ),

    // NEW ROADMAPS START HERE

    // Data Scientist
    TechRoadmap(
      title: 'Data Scientist',
      description: 'Extracting insights from data.',
      category: 'Data Science',
      duration: '8-12 months',
      icon: Icons.analytics,
      color: Colors.orange,
      steps: [
        RoadmapStep(
          title: 'Mathematical Foundations',
          description: 'The language of data.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Statistics & Probability',
              content: 'Distributions (Normal, Binomial), Hypothesis testing (p-values, A/B testing), Bayesian inference.',
            ),
            TopicContent(
              title: 'Linear Algebra',
              content: 'Vectors, Matrices, Eigenvalues - essential for understanding ML algorithms.',
            ),
          ],
          resources: ['Khan Academy Statistics'],
        ),
        RoadmapStep(
          title: 'Data Visualization',
          description: 'Storytelling with data.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Libraries',
              content: 'Matplotlib, Seaborn, Plotly (interactive), Tableau/PowerBI (business intelligence).',
            ),
            TopicContent(
              title: 'Principles',
              content: 'Color theory, chart selection (scatter vs bar vs heatmaps), and avoiding misleading visuals.',
            ),
          ],
          resources: ['Storytelling with Data'],
        ),
         RoadmapStep(
          title: 'Machine Learning',
          description: 'Predictive modeling.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Supervised Learning',
              content: 'Regression (Linear, Logistic), Classification (Decision Trees, Random Forests, SVM).',
            ),
            TopicContent(
              title: 'Unsupervised Learning',
              content: 'Clustering (K-Means, DBSCAN), Dimensionality Reduction (PCA).',
            ),
          ],
          resources: ['Scikit-Learn User Guide'],
        ),
        RoadmapStep(
          title: 'Deep Learning Foundations',
          description: 'Neural network architectures.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Neural Networks',
              content: 'Perceptrons, activation functions (ReLU, Sigmoid). Backpropagation algorithm. Loss functions and optimizers (SGD, Adam).',
            ),
            TopicContent(
              title: 'CNNs & RNNs',
              content: 'Convolutional layers for images. Recurrent networks for sequences. LSTM and GRU for long-term dependencies.',
            ),
            TopicContent(
              title: 'Frameworks',
              content: 'TensorFlow/Keras vs PyTorch. Model training loops. GPU acceleration. Transfer learning for faster results.',
            ),
          ],
          resources: ['Deep Learning Book (Goodfellow)', 'PyTorch Tutorials'],
        ),
      ],
    ),

    // Cybersecurity Specialist
    TechRoadmap(
      title: 'Cybersecurity Specialist',
      description: 'Protecting digital assets and infrastructure.',
      category: 'Security',
      duration: '10-12 months',
      icon: Icons.security,
      color: Colors.red,
      steps: [
        RoadmapStep(
          title: 'Networking Security',
          description: 'Securing the pipes.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'OSI Model Security',
              content: 'Attacks and defenses at each layer. ARP spoofing, Man-in-the-Middle, DDoS.',
            ),
             TopicContent(
              title: 'Firewalls & IDS/IPS',
              content: 'Configuring rules, monitoring traffic patterns, and intrusion detection.',
            ),
          ],
          resources: ['CompTIA Network+'],
        ),
        RoadmapStep(
          title: 'Ethical Hacking',
          description: 'Thinking like an attacker.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Reconnaissance',
              content: 'OSINT (Open Source Intelligence), Nmap scanning, Shodan.',
            ),
            TopicContent(
              title: 'Web App Pentesting',
              content: 'OWASP Top 10 deep dive. SQL Injection, XSS, CSRF, IDOR attacks.',
            ),
             TopicContent(
              title: 'Metasploit',
              content: 'Using frameworks for exploit development and payload delivery.',
            ),
          ],
          resources: ['The Web Application Hacker\'s Handbook'],
        ),
        RoadmapStep(
          title: 'Cryptography',
          description: 'The science of secrets.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Encryption Standards',
              content: 'Symmetric (AES) vs Asymmetric (RSA, ECC). Hashing (SHA-256).',
            ),
            TopicContent(
              title: 'PKI',
              content: 'Public Key Infrastructure. Certificates, X.509, and Chain of Trust.',
            ),
          ],
          resources: ['Practical Cryptography'],
        ),
      ],
    ),

    // Cloud Engineer
    TechRoadmap(
      title: 'Cloud Engineer',
      description: 'Architecting scalable cloud solutions.',
      category: 'Cloud Computing',
      duration: '8-10 months',
      icon: Icons.cloud_queue,
      color: Colors.lightBlue,
      steps: [
        RoadmapStep(
          title: 'AWS / Azure / GCP',
          description: 'Mastering a provider.',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Compute',
              content: 'AWS EC2, Lambda, ECS. Azure VMs, Functions. GCP Compute Engine.',
            ),
            TopicContent(
              title: 'Storage',
              content: 'Object storage (S3), Block storage (EBS), File storage (EFS). Lifecycle policies.',
            ),
             TopicContent(
              title: 'Networking',
              content: 'VPC design, Subnets, Route Tables, Internet Gateways, Peering.',
            ),
          ],
          resources: ['AWS Solutions Architect Study Guide'],
        ),
        RoadmapStep(
          title: 'Serverless Architecture',
          description: 'Focus on code, not servers.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Event-Driven Patterns',
              content: 'Triggering functions from queues (SQS), streams (Kinesis), or API Gateway.',
            ),
            TopicContent(
              title: 'Cold Starts & Limits',
              content: 'Understanding execution limits, timeouts, and optimization strategies.',
            ),
          ],
          resources: ['Serverless Framework'],
        ),
      ],
    ),

    // Game Developer
    TechRoadmap(
      title: 'Game Developer',
      description: 'Creating immersive virtual worlds.',
      category: 'Game Development',
      duration: '10-12 months',
      icon: Icons.sports_esports,
      color: Colors.amber,
      steps: [
        RoadmapStep(
          title: 'Game Engines',
          description: 'The tools of the trade.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Unity (C#)',
              content: 'GameObjects, Components, Prefabs, Physics Engine, and Asset pipeline.',
            ),
            TopicContent(
              title: 'Unreal Engine (C++ / Blueprints)',
              content: 'Actors, Pawns, Material Editor, Niagara (VFX), and Lumen/Nanite rendering.',
            ),
          ],
          resources: ['Unity Learn', 'Unreal Online Learning'],
        ),
        RoadmapStep(
          title: 'Game Mathematics',
          description: 'Physics and transforms.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: '3D Math',
              content: 'Vectors, Dot/Cross products (lighting/facing), Quaternions (rotation without gimbal lock).',
            ),
            TopicContent(
              title: 'Physics',
              content: 'Collision detection (Raycasting, AABB, Mesh colliders), Rigidbodies, Forces.',
            ),
          ],
          resources: ['3D Math Primer for Graphics'],
        ),
        RoadmapStep(
          title: 'Game Design Patterns',
          description: 'Architecting maintainable games.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Pattern Library',
              content: 'Game Loop, Object Pool (memory management), State Machine, Component pattern, Command pattern (input).',
            ),
          ],
          resources: ['Game Programming Patterns'],
        ),
      ],
    ),

    // Blockchain Developer
    TechRoadmap(
      title: 'Blockchain Developer',
      description: 'Decentralized applications and Web3.',
      category: 'Blockchain',
      duration: '8-10 months',
      icon: Icons.link,
      color: Colors.brown,
      steps: [
        RoadmapStep(
          title: 'Smart Contracts',
          description: 'Code on the chain.',
          duration: '5-6 weeks',
          topics: [
            TopicContent(
              title: 'Solidity',
              content: 'Contract structure, mappings, modifiers, payable functions, inheritance. EVM (Ethereum Virtual Machine).',
            ),
             TopicContent(
              title: 'Security',
              content: 'Reentrancy attacks, Overflow/Underflow, Gas optimization, Checking-Effects-Interaction pattern.',
            ),
          ],
          resources: ['CryptoZombies', 'Solidity Documentation'],
        ),
        RoadmapStep(
          title: 'Web3 Development',
          description: 'Connecting frontend to blockchain.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Libraries',
              content: 'Ethers.js / Web3.js. Connecting wallets (MetaMask), signing transactions, reading contract state.',
            ),
            TopicContent(
              title: 'Indexing',
              content: 'Using The Graph protocol to query blockchain data efficiently utilizing subgraphs.',
            ),
          ],
          resources: ['Scaffold-ETH'],
        ),
        RoadmapStep(
          title: 'DeFi & Protocols',
          description: 'Financial legos.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Concepts',
              content: 'Liquidity Pools, AMMs (Automated Market Makers) like Uniswap, Yield Farming, Flash Loans.',
            ),
            TopicContent(
              title: 'Token Standards',
              content: 'ERC-20 (Fungible), ERC-721 (NFT), ERC-1155 (Multi-token).',
            ),
          ],
          resources: ['Mastering Ethereum'],
        ),
      ],
    ),

    // DSA & Competitive Programming
    TechRoadmap(
      title: 'DSA & Competitive Programming',
      description: 'Master algorithms for coding interviews and competitions.',
      category: 'Programming Fundamentals',
      duration: '6-9 months',
      icon: Icons.code,
      color: Colors.deepOrange,
      steps: [
        RoadmapStep(
          title: 'Arrays & Strings',
          description: 'Foundation of all problems.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Two Pointer Technique',
              content: 'Solving problems with O(n) instead of O(n²). Examples: Two Sum, Container With Most Water, 3Sum.',
            ),
            TopicContent(
              title: 'Sliding Window',
              content: 'Fixed and variable window patterns. Max sum subarray, longest substring without repeating chars.',
            ),
            TopicContent(
              title: 'Prefix Sum & Hash Maps',
              content: 'Subarray sum problems. Using hash maps for O(1) lookups. Frequency counting.',
            ),
          ],
          resources: ['LeetCode Patterns', 'NeetCode Roadmap'],
        ),
        RoadmapStep(
          title: 'Trees & Graphs',
          description: 'Hierarchical and networked data.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Binary Trees',
              content: 'Traversals (Inorder, Preorder, Postorder), DFS vs BFS, Height/Depth, LCA, Diameter.',
            ),
            TopicContent(
              title: 'BST Operations',
              content: 'Insert, Delete, Search in O(log n). Validate BST, Kth Smallest.',
            ),
            TopicContent(
              title: 'Graph Algorithms',
              content: 'BFS (shortest path), DFS (cycle detection), Dijkstra, Topological Sort, Union-Find.',
            ),
          ],
          resources: ['Striver A2Z DSA Sheet', 'CP Algorithms'],
        ),
        RoadmapStep(
          title: 'Dynamic Programming',
          description: 'Overlapping subproblems.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Classic DP Patterns',
              content: '0/1 Knapsack, Unbounded Knapsack, LCS, LIS, Coin Change, Matrix Chain Multiplication.',
            ),
            TopicContent(
              title: 'State & Transition',
              content: 'Identifying states, writing recurrence relations. Memoization vs Tabulation.',
            ),
            TopicContent(
              title: 'DP on Trees & Grids',
              content: 'House Robber III, Unique Paths, Min Path Sum.',
            ),
          ],
          resources: ['Aditya Verma DP Playlist', 'CSES Problem Set'],
        ),
        RoadmapStep(
          title: 'Advanced Topics',
          description: 'Competitive programming techniques.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Segment Trees',
              content: 'Range queries and point updates in O(log n). Lazy propagation.',
            ),
            TopicContent(
              title: 'Binary Search Variations',
              content: 'Search space problems, rotated arrays, finding boundaries.',
            ),
            TopicContent(
              title: 'Bit Manipulation',
              content: 'XOR tricks, setting/clearing bits, counting set bits, subsets using bitmask.',
            ),
          ],
          resources: ['Codeforces Blog', 'TopCoder Tutorials'],
        ),
      ],
    ),

    // System Design
    TechRoadmap(
      title: 'System Design',
      description: 'Architecting large-scale distributed systems.',
      category: 'Software Engineering',
      duration: '4-6 months',
      icon: Icons.architecture,
      color: Colors.cyan,
      steps: [
        RoadmapStep(
          title: 'Fundamentals',
          description: 'Building blocks of systems.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Scalability',
              content: 'Vertical vs Horizontal scaling. Load Balancing algorithms (Round Robin, Least Connections, IP Hash).',
            ),
            TopicContent(
              title: 'CAP Theorem',
              content: 'Consistency, Availability, Partition Tolerance trade-offs. CP vs AP systems.',
            ),
            TopicContent(
              title: 'Database Scaling',
              content: 'Read replicas, Sharding strategies (Hash, Range), Replication (Master-Slave, Multi-Master).',
            ),
          ],
          resources: ['System Design Primer', 'Designing Data-Intensive Applications'],
        ),
        RoadmapStep(
          title: 'Components Deep Dive',
          description: 'Essential system building blocks.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Caching',
              content: 'CDN, Application cache (Redis/Memcached), Cache-aside vs Write-through. TTL and eviction policies (LRU, LFU).',
            ),
            TopicContent(
              title: 'Message Queues',
              content: 'Kafka, RabbitMQ, SQS. Pub/Sub patterns. Event-driven architecture. Dead letter queues.',
            ),
            TopicContent(
              title: 'API Gateway & Rate Limiting',
              content: 'Token bucket, Leaky bucket algorithms. Authentication, routing, request throttling.',
            ),
          ],
          resources: ['AWS Architecture Center', 'Google SRE Book'],
        ),
        RoadmapStep(
          title: 'Design Patterns',
          description: 'Common system architectures.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'URL Shortener',
              content: 'Base62 encoding, distributed ID generation, redirect handling, analytics tracking.',
            ),
            TopicContent(
              title: 'Chat System',
              content: 'WebSockets, presence detection, message delivery guarantees, fan-out patterns.',
            ),
            TopicContent(
              title: 'News Feed',
              content: 'Push vs Pull model, ranking algorithms, caching hot content, infinite scroll pagination.',
            ),
          ],
          resources: ['ByteByteGo', 'Grokking System Design'],
        ),
      ],
    ),

    // UI/UX Designer
    TechRoadmap(
      title: 'UI/UX Designer',
      description: 'Creating intuitive and beautiful user experiences.',
      category: 'Design',
      duration: '5-7 months',
      icon: Icons.design_services,
      color: Colors.pink,
      steps: [
        RoadmapStep(
          title: 'Design Fundamentals',
          description: 'Visual design principles.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Color Theory',
              content: 'Color wheel, complementary colors, 60-30-10 rule, accessibility contrast ratios (WCAG AA/AAA).',
            ),
            TopicContent(
              title: 'Typography',
              content: 'Font pairing, hierarchy, line height, letter spacing. System fonts vs web fonts.',
            ),
            TopicContent(
              title: 'Layout & Spacing',
              content: '8px grid system, whitespace, visual hierarchy, F-pattern and Z-pattern layouts.',
            ),
          ],
          resources: ['Refactoring UI', 'Google Material Design'],
        ),
        RoadmapStep(
          title: 'UX Research',
          description: 'Understanding users.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'User Personas',
              content: 'Creating fictional user profiles based on research. Demographics, goals, pain points.',
            ),
            TopicContent(
              title: 'User Journey Mapping',
              content: 'Visualizing user interactions from start to goal. Identifying friction points.',
            ),
            TopicContent(
              title: 'Usability Testing',
              content: 'Think-aloud protocols, A/B testing, heatmaps, session recordings.',
            ),
          ],
          resources: ['Don Norman - Design of Everyday Things'],
        ),
        RoadmapStep(
          title: 'Design Tools',
          description: 'Industry standard software.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Figma Mastery',
              content: 'Auto layout, components, variants, prototyping, design systems, plugins.',
            ),
            TopicContent(
              title: 'Design Systems',
              content: 'Building scalable component libraries. Atomic design methodology. Documentation.',
            ),
            TopicContent(
              title: 'Handoff to Developers',
              content: 'Inspect mode, CSS extraction, asset export, design tokens.',
            ),
          ],
          resources: ['Figma Official Tutorials', 'Design Systems Handbook'],
        ),
      ],
    ),
    // Cyber Security Analyst
    TechRoadmap(
      title: 'Cyber Security Analyst',
      description: 'Defending systems and networks.',
      category: 'Security',
      duration: '8-12 months',
      icon: Icons.security,
      color: Colors.redAccent,
      steps: [
        RoadmapStep(
          title: 'Networking Fundamentals',
          description: 'How data moves.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'OSI Model',
              content: '7 Layers of networking. TCP/IP stack. IP addressing (IPv4/IPv6), Subnetting, MAC addresses.',
            ),
            TopicContent(
              title: 'Protocols',
              content: 'DNS, DHCP, HTTP/S, FTP, SSH, SMTP. Wireshark for packet analysis.',
            ),
          ],
          resources: ['CompTIA Network+', 'Professor Messer'],
        ),
        RoadmapStep(
          title: 'Security Bases',
          description: 'Core security concepts.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'CIA Triad',
              content: 'Confidentiality, Integrity, Availability. Identity & Access Management (IAM).',
            ),
            TopicContent(
              title: 'Threats & Vulnerabilities',
              content: 'Malware types, Phishing, Social Engineering, DDoS, Man-in-the-Middle attacks.',
            ),
          ],
          resources: ['CompTIA Security+'],
        ),
        RoadmapStep(
          title: 'Ethical Hacking',
          description: 'Offensive security (Red Team).',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Reconnaissance',
              content: 'OSINT (Open Source Intelligence), Nmap scanning, Enumeration.',
            ),
            TopicContent(
              title: 'Web App Security',
              content: 'OWASP Top 10. SQL Injection, XSS, CSRF, Burp Suite usage.',
            ),
            TopicContent(
              title: 'Exploitation',
              content: 'Metasploit framework. Privilege escalation. Reverse shells.',
            ),
          ],
          resources: ['The Web Application Hacker\'s Handbook', 'TryHackMe'],
        ),
        RoadmapStep(
          title: 'Defensive Security',
          description: 'Blue Team operations.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'SOC Operations',
              content: 'SIEM tools (Splunk, Elastic). Log analysis. Incident Response phases.',
            ),
            TopicContent(
              title: 'Digital Forensics',
              content: 'Evidence handling, memory analysis, disk imaging.',
            ),
          ],
          resources: ['Blue Team Labs Online'],
        ),
      ],
    ),

    // Data Scientist
    TechRoadmap(
      title: 'Data Scientist',
      description: 'Extracting insights from data.',
      category: 'Data Science',
      duration: '10-14 months',
      icon: Icons.science,
      color: Colors.tealAccent,
      steps: [
        RoadmapStep(
          title: 'Python for Data Science',
          description: 'The primary language.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Libraries',
              content: 'NumPy for numerical computing. Pandas for data manipulation (DataFrames). Matplotlib/Seaborn for visualization.',
            ),
            TopicContent(
              title: 'Exploratory Data Analysis (EDA)',
              content: 'Cleaning data, handling missing values, outlier detection, statistical summaries.',
            ),
          ],
          resources: ['Python for Data Analysis Book', 'Kaggle Learn'],
        ),
        RoadmapStep(
          title: 'Mathematics & Statistics',
          description: 'The theory behind the models.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Statistics',
              content: 'Descriptive vs Inferential. Probability distributions, Hypothesis testing (p-values), Bayesian inference.',
            ),
            TopicContent(
              title: 'Linear Algebra / Calculus',
              content: 'Vectors, Matrices, Eigenvalues. Derivatives, Gradients (for optimization).',
            ),
          ],
          resources: ['Khan Academy Statistics', '3Blue1Brown'],
        ),
        RoadmapStep(
          title: 'Machine Learning Models',
          description: 'Predictive modeling.',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Supervised Learning',
              content: 'Regression (Linear/Logistic), Decision Trees, Random Forests, SVMs. Scikit-learn library.',
            ),
            TopicContent(
              title: 'Unsupervised Learning',
              content: 'Clustering (K-Means, DBSCAN), PCA (Dimensionality Reduction).',
            ),
            TopicContent(
              title: 'Model Evaluation',
              content: 'Cross-validation, Confusion Matrix, ROC/AUC, Precision-Recall trade-off.',
            ),
          ],
          resources: ['Hands-On Machine Learning (Aurélien Géron)'],
        ),
        RoadmapStep(
          title: 'Deep Learning',
          description: 'Neural networks.',
          duration: '8-10 weeks',
          topics: [
            TopicContent(
              title: 'Neural Nets',
              content: 'Perceptrons, Backpropagation, Activation functions (ReLU, Sigmoid). TensorFlow / PyTorch.',
            ),
            TopicContent(
              title: 'Specialized Architectures',
              content: 'CNNs for image data. RNNs/LSTMs for sequential data.',
            ),
          ],
          resources: ['Deep Learning Specialization (Andrew Ng)'],
        ),
      ],
    ),

    // Cybersecurity Specialist
    TechRoadmap(
      title: 'Cybersecurity Specialist',
      description: 'Protecting systems, networks, and data from cyber threats.',
      category: 'Security',
      duration: '10-12 months',
      icon: Icons.security,
      color: Colors.red,
      steps: [
        RoadmapStep(
          title: 'Security Fundamentals',
          description: 'Core concepts and threat landscape.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'CIA Triad',
              content: 'Confidentiality, Integrity, Availability - the foundation of information security. Understanding threats, vulnerabilities, and risks.',
            ),
            TopicContent(
              title: 'Attack Vectors',
              content: 'Phishing, malware, ransomware, DDoS, man-in-the-middle. Understanding how attackers operate.',
            ),
            TopicContent(
              title: 'Security Frameworks',
              content: 'NIST Cybersecurity Framework, ISO 27001, CIS Controls. Compliance requirements (GDPR, HIPAA, PCI-DSS).',
            ),
          ],
          resources: [
            'NIST Cybersecurity Framework',
            'OWASP Top 10',
            'Security+ Study Guide',
          ],
        ),
        RoadmapStep(
          title: 'Network Security',
          description: 'Securing network infrastructure.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Firewalls & IDS/IPS',
              content: 'Firewall rules, stateful vs stateless inspection. Intrusion Detection/Prevention Systems. Snort, Suricata.',
            ),
            TopicContent(
              title: 'VPN & Encryption',
              content: 'Virtual Private Networks. IPSec, SSL/TLS protocols. End-to-end encryption. Certificate management.',
            ),
            TopicContent(
              title: 'Network Monitoring',
              content: 'Wireshark for packet analysis. NetFlow analysis. Detecting anomalies and suspicious traffic patterns.',
            ),
          ],
          resources: [
            'Wireshark Network Analysis',
            'Zero Trust Security Model',
          ],
        ),
        RoadmapStep(
          title: 'Penetration Testing',
          description: 'Ethical hacking and vulnerability assessment.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Reconnaissance & Scanning',
              content: 'OSINT (Open Source Intelligence). Nmap for network scanning. Vulnerability scanners (Nessus, OpenVAS).',
            ),
            TopicContent(
              title: 'Exploitation Techniques',
              content: 'Metasploit Framework. SQL injection, XSS, CSRF. Buffer overflows. Privilege escalation.',
            ),
            TopicContent(
              title: 'Web Application Security',
              content: 'Burp Suite for web app testing. OWASP Top 10 vulnerabilities. API security testing.',
            ),
          ],
          resources: [
            'Metasploit Unleashed',
            'Web Application Hacker\'s Handbook',
            'HackTheBox Practice',
          ],
        ),
        RoadmapStep(
          title: 'Incident Response & Forensics',
          description: 'Handling security breaches.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Incident Response Lifecycle',
              content: 'Preparation, Detection, Containment, Eradication, Recovery, Lessons Learned. NIST IR framework.',
            ),
            TopicContent(
              title: 'Digital Forensics',
              content: 'Evidence collection and preservation. Memory forensics, disk imaging. Chain of custody.',
            ),
            TopicContent(
              title: 'SIEM & Log Analysis',
              content: 'Security Information and Event Management. Splunk, ELK Stack. Correlation rules and alerting.',
            ),
          ],
          resources: [
            'Incident Handler\'s Handbook',
            'Practical Malware Analysis',
          ],
        ),
      ],
    ),

    // Data Science Engineer
    TechRoadmap(
      title: 'Data Science Engineer',
      description: 'Extracting insights from data using statistics, ML, and visualization.',
      category: 'Data Science',
      duration: '10-12 months',
      icon: Icons.analytics,
      color: Colors.orange,
      steps: [
        RoadmapStep(
          title: 'Mathematics & Statistics',
          description: 'The foundation of data science.',
          duration: '4-6 weeks',
          topics: [
            TopicContent(
              title: 'Probability & Statistics',
              content: 'Distributions (Normal, Binomial, Poisson). Hypothesis testing, p-values, confidence intervals. Bayesian statistics.',
            ),
            TopicContent(
              title: 'Linear Algebra',
              content: 'Vectors, matrices, eigenvalues. Matrix operations for ML. Dimensionality reduction (PCA, SVD).',
            ),
            TopicContent(
              title: 'Calculus & Optimization',
              content: 'Derivatives, gradients. Gradient descent algorithm. Convex optimization basics.',
            ),
          ],
          resources: [
            'Mathematics for Machine Learning',
            'StatQuest YouTube Channel',
          ],
        ),
        RoadmapStep(
          title: 'Python for Data Science',
          description: 'The data scientist\'s toolkit.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'NumPy & Pandas',
              content: 'Array operations, broadcasting. DataFrames, groupby, merge, pivot tables. Time series analysis.',
            ),
            TopicContent(
              title: 'Data Visualization',
              content: 'Matplotlib, Seaborn for statistical plots. Plotly for interactive dashboards. Storytelling with data.',
            ),
            TopicContent(
              title: 'Jupyter Notebooks',
              content: 'Interactive development. Markdown documentation. Reproducible analysis workflows.',
            ),
          ],
          resources: [
            'Python Data Science Handbook',
            'Pandas Documentation',
          ],
        ),
        RoadmapStep(
          title: 'Machine Learning Fundamentals',
          description: 'Core ML algorithms and concepts.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Supervised Learning',
              content: 'Linear/Logistic Regression. Decision Trees, Random Forests. Support Vector Machines. Model evaluation metrics.',
            ),
            TopicContent(
              title: 'Unsupervised Learning',
              content: 'K-Means clustering, DBSCAN. Hierarchical clustering. Anomaly detection.',
            ),
            TopicContent(
              title: 'Feature Engineering',
              content: 'Encoding categorical variables. Scaling and normalization. Feature selection techniques.',
            ),
          ],
          resources: [
            'Scikit-learn Documentation',
            'Hands-On Machine Learning',
          ],
        ),
        RoadmapStep(
          title: 'Deep Learning',
          description: 'Neural networks and modern architectures.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Neural Network Basics',
              content: 'Perceptrons, activation functions. Backpropagation. Loss functions and optimizers (SGD, Adam).',
            ),
            TopicContent(
              title: 'CNNs for Computer Vision',
              content: 'Convolutional layers, pooling. Transfer learning with pre-trained models (ResNet, EfficientNet).',
            ),
            TopicContent(
              title: 'Transformers for NLP',
              content: 'Attention mechanism. BERT, GPT architectures. Foundation of modern NLP.',
            ),
          ],
          resources: [
            'Deep Learning Specialization (Coursera)',
            'PyTorch Tutorials',
          ],
        ),
        RoadmapStep(
          title: 'MLOps & Production',
          description: 'Deploying models at scale.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Model Deployment',
              content: 'REST APIs with FastAPI/Flask. Model serving (TensorFlow Serving, TorchServe). Containerization.',
            ),
            TopicContent(
              title: 'Experiment Tracking',
              content: 'MLflow, Weights & Biases. Versioning datasets and models. Reproducibility.',
            ),
            TopicContent(
              title: 'Monitoring & Retraining',
              content: 'Model drift detection. A/B testing. Automated retraining pipelines.',
            ),
          ],
          resources: [
            'MLOps Principles',
            'MLflow Documentation',
          ],
        ),
      ],
    ),

    // Cloud Solutions Architect
    TechRoadmap(
      title: 'Cloud Solutions Architect',
      description: 'Designing scalable, resilient cloud infrastructure.',
      category: 'Cloud Computing',
      duration: '8-10 months',
      icon: Icons.cloud_queue,
      color: Colors.cyan,
      steps: [
        RoadmapStep(
          title: 'Cloud Fundamentals',
          description: 'Understanding cloud computing models.',
          duration: '2-3 weeks',
          topics: [
            TopicContent(
              title: 'Service Models',
              content: 'IaaS (Infrastructure), PaaS (Platform), SaaS (Software). When to use each model.',
            ),
            TopicContent(
              title: 'Deployment Models',
              content: 'Public, Private, Hybrid, Multi-cloud. Trade-offs and use cases.',
            ),
            TopicContent(
              title: 'Cloud Economics',
              content: 'CapEx vs OpEx. Pay-as-you-go pricing. Total Cost of Ownership (TCO) analysis.',
            ),
          ],
          resources: [
            'AWS Cloud Practitioner',
            'Cloud Computing Concepts',
          ],
        ),
        RoadmapStep(
          title: 'Core Cloud Services',
          description: 'Mastering essential cloud services.',
          duration: '6-8 weeks',
          topics: [
            TopicContent(
              title: 'Compute Services',
              content: 'EC2/VMs, Lambda/Functions, ECS/AKS/GKE for containers. Auto-scaling groups.',
            ),
            TopicContent(
              title: 'Storage Solutions',
              content: 'Object storage (S3/Blob), Block storage (EBS), File systems (EFS/Azure Files). Lifecycle policies.',
            ),
            TopicContent(
              title: 'Networking',
              content: 'VPC/VNet, Subnets, Route Tables. Load Balancers (ALB, NLB). CDN (CloudFront, Azure CDN).',
            ),
          ],
          resources: [
            'AWS Solutions Architect Associate',
            'Azure Fundamentals',
          ],
        ),
        RoadmapStep(
          title: 'High Availability & Disaster Recovery',
          description: 'Building resilient systems.',
          duration: '3-4 weeks',
          topics: [
            TopicContent(
              title: 'Multi-Region Architecture',
              content: 'Active-active vs active-passive. Global load balancing. Data replication strategies.',
            ),
            TopicContent(
              title: 'Backup & Recovery',
              content: 'RPO (Recovery Point Objective) and RTO (Recovery Time Objective). Automated backups. Point-in-time recovery.',
            ),
            TopicContent(
              title: 'Fault Tolerance',
              content: 'Circuit breakers, retries, timeouts. Chaos engineering principles.',
            ),
          ],
          resources: [
            'AWS Well-Architected Framework',
            'Disaster Recovery Strategies',
          ],
        ),
        RoadmapStep(
          title: 'Security & Compliance',
          description: 'Securing cloud workloads.',
          duration: '4-5 weeks',
          topics: [
            TopicContent(
              title: 'Identity & Access Management',
              content: 'IAM policies, roles, and groups. Principle of least privilege. MFA enforcement.',
            ),
            TopicContent(
              title: 'Network Security',
              content: 'Security groups, NACLs, WAF (Web Application Firewall). DDoS protection.',
            ),
            TopicContent(
              title: 'Encryption & Secrets',
              content: 'KMS for key management. Secrets Manager/Key Vault. Encryption at rest and in transit.',
            ),
          ],
          resources: [
            'AWS Security Best Practices',
            'Cloud Security Alliance',
          ],
        ),
      ],
    ),
  ];

  // Helper methods for filtering and searching
  static List<TechRoadmap> getRoadmapsByCategory(String category) {
    return allRoadmaps.where((roadmap) => roadmap.category == category).toList();
  }

  static List<String> getAllCategories() {
    return allRoadmaps.map((roadmap) => roadmap.category).toSet().toList();
  }

  static List<TechRoadmap> searchRoadmaps(String query) {
    query = query.toLowerCase();
    return allRoadmaps.where((roadmap) {
      return roadmap.title.toLowerCase().contains(query) ||
             roadmap.description.toLowerCase().contains(query) ||
             roadmap.category.toLowerCase().contains(query);
    }).toList();
  }

  static TechRoadmap? getRoadmapById(String title) {
    try {
      return allRoadmaps.firstWhere((roadmap) => roadmap.title == title);
    } catch (e) {
      return null;
    }
  }
}