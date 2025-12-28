class EngineeringTopic {
  final String title;
  final String description;
  final String imagePath;
  final List<String> steps;

  EngineeringTopic({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.steps,
  });
}

class EngineeringData {
  // 🟠 MECHANICAL ENGINEERING DATA (15 topics)
  static final List<EngineeringTopic> mechTopics = [
    EngineeringTopic(
      title: "Orthographic Projection",
      description: "A method of representing a 3D object in 2D using Front, Top, and Side views. This is the foundation of engineering drawing and allows engineers to communicate designs precisely.",
      imagePath: "assets/engineering_hub/mech/ortho.webp",
      steps: [
        "1. Identify the Front View (direction of arrow or most descriptive face).",
        "2. Draw the XY reference line horizontally.",
        "3. Project the Front View dimensions upwards to create the Top View.",
        "4. Project the Front View dimensions downwards for depth.",
        "5. Use a 45-degree miter line to transfer depth to the Side View.",
        "6. Complete all three views ensuring alignment and proper dimensions."
      ],
    ),
    EngineeringTopic(
      title: "Isometric View of Circle",
      description: "Circles appear as ellipses in isometric projection. We use the Four-Center Method to construct these ellipses accurately without complex calculations.",
      imagePath: "assets/engineering_hub/mech/iso_circle.webp",
      steps: [
        "1. Draw an isometric rhombus with sides equal to the diameter D.",
        "2. Mark the midpoints of all four sides of the rhombus.",
        "3. Draw lines from each obtuse angle corner to the midpoint of the opposite side.",
        "4. The intersections of these lines create 4 arc centers.",
        "5. Using a compass, draw arcs from the obtuse corners with larger radius.",
        "6. Draw arcs from the acute corners with smaller radius.",
        "7. The four arcs connect smoothly to form the isometric ellipse."
      ],
    ),
    EngineeringTopic(
      title: "Development of Surfaces",
      description: "Development is the process of unfolding a 3D surface into a flat 2D pattern. This is crucial for sheet metal work, packaging design, and manufacturing.",
      imagePath: "assets/engineering_hub/mech/development.webp",
      steps: [
        "1. Identify the type of surface (cylinder, cone, prism, pyramid).",
        "2. For a cylinder: Draw the base circle and divide it into equal parts (usually 12).",
        "3. Calculate the development length = π × Diameter.",
        "4. Draw a rectangle with length = circumference and width = height.",
        "5. Mark the division points along the length.",
        "6. Add seam allowance for joining (typically 10-15mm).",
        "7. Mark fold lines and cut lines clearly."
      ],
    ),
    EngineeringTopic(
      title: "Sectional Views",
      description: "Sectional views show the internal features of an object by cutting through it. This technique reveals hidden details that cannot be seen in normal orthographic views.",
      imagePath: "assets/engineering_hub/mech/sectional_views.webp",
      steps: [
        "1. Identify the cutting plane that best reveals internal features.",
        "2. Draw the cutting plane line with arrows showing viewing direction.",
        "3. Remove the portion of the object in front of the cutting plane.",
        "4. Draw section lines (hatching) at 45° on cut surfaces.",
        "5. Full Section: Cutting plane passes completely through the object.",
        "6. Half Section: Shows half in section, half in normal view.",
        "7. Offset Section: Cutting plane changes direction to show multiple features."
      ],
    ),
    EngineeringTopic(
      title: "Auxiliary Projection",
      description: "Auxiliary projection is used to show the true shape and size of inclined surfaces that appear foreshortened in principal views.",
      imagePath: "assets/engineering_hub/mech/auxiliary.webp",
      steps: [
        "1. Identify the inclined surface that needs true shape representation.",
        "2. Draw an auxiliary reference line parallel to the inclined surface.",
        "3. Project perpendicular lines from the inclined surface to the auxiliary plane.",
        "4. Transfer depth measurements from principal views.",
        "5. Connect the projected points to form the true shape.",
        "6. The auxiliary view shows the inclined surface without distortion.",
        "7. Used extensively in sheet metal design and surface development."
      ],
    ),
    EngineeringTopic(
      title: "Thread Forms",
      description: "Screw threads are helical ridges on cylindrical or conical surfaces used for fastening and power transmission. Different thread forms serve different purposes.",
      imagePath: "assets/engineering_hub/mech/thread_forms.webp",
      steps: [
        "1. ISO Metric Thread: 60° thread angle, used in most fasteners worldwide.",
        "2. Unified Thread (UNC/UNF): 60° angle, standard in USA and Canada.",
        "3. ACME Thread: 29° angle, used for power transmission and lead screws.",
        "4. Square Thread: 90° angle, highest efficiency for power transmission.",
        "5. Buttress Thread: Asymmetric, used when force is in one direction.",
        "6. Major Diameter: Largest diameter of the thread.",
        "7. Pitch: Distance between corresponding points on adjacent threads."
      ],
    ),
    EngineeringTopic(
      title: "Welding Symbols",
      description: "Welding symbols are standardized graphical representations used on engineering drawings to specify welding processes, joint types, and weld dimensions.",
      imagePath: "assets/engineering_hub/mech/welding_symbols.webp",
      steps: [
        "1. Reference Line: Horizontal line where symbols are placed.",
        "2. Arrow: Points to the joint to be welded.",
        "3. Arrow Side: Weld on the side where arrow points.",
        "4. Other Side: Weld on opposite side of arrow.",
        "5. Fillet Weld: Triangular symbol for corner joints.",
        "6. Groove Weld: V, U, or J symbols for edge preparation.",
        "7. Tail: Contains additional information like welding process."
      ],
    ),
    EngineeringTopic(
      title: "Gear Types",
      description: "Gears are mechanical components that transmit rotational motion and torque between shafts. Different gear types suit different applications and shaft orientations.",
      imagePath: "assets/engineering_hub/mech/gear_types.webp",
      steps: [
        "1. Spur Gear: Straight teeth parallel to axis, for parallel shafts.",
        "2. Helical Gear: Teeth at an angle, smoother and quieter operation.",
        "3. Bevel Gear: Conical shape, for intersecting shafts at angles.",
        "4. Worm Gear: Screw-like gear, high reduction ratio in compact space.",
        "5. Rack and Pinion: Converts rotary motion to linear motion.",
        "6. Pitch Circle: Imaginary circle where gears theoretically contact.",
        "7. Module: Ratio of pitch diameter to number of teeth."
      ],
    ),
    EngineeringTopic(
      title: "Cam Mechanisms",
      description: "A cam is a rotating or sliding component that imparts specific motion to a follower. Cams convert rotary motion into reciprocating or oscillating motion.",
      imagePath: "assets/engineering_hub/mech/cam_mechanisms.webp",
      steps: [
        "1. Disk Cam: Most common type, rotates about fixed axis.",
        "2. Knife-Edge Follower: Simple but high wear, used for low loads.",
        "3. Roller Follower: Reduces friction, suitable for higher loads.",
        "4. Displacement Diagram: Graph showing follower motion vs cam rotation.",
        "5. Lift: Maximum displacement of follower from base circle.",
        "6. Dwell: Period when follower remains stationary.",
        "7. Return: Follower moves back to starting position."
      ],
    ),
    EngineeringTopic(
      title: "Limits and Fits",
      description: "Limits and fits define the allowable variation in dimensions and the relationship between mating parts. Essential for interchangeable manufacturing.",
      imagePath: "assets/engineering_hub/mech/limits_fits.webp",
      steps: [
        "1. Clearance Fit: Hole is always larger than shaft, allows free movement.",
        "2. Transition Fit: May result in clearance or interference.",
        "3. Interference Fit: Shaft is always larger than hole, requires force.",
        "4. Tolerance: Difference between maximum and minimum limits.",
        "5. Upper Deviation: Difference between maximum size and basic size.",
        "6. Lower Deviation: Difference between minimum size and basic size.",
        "7. Fundamental Deviation: Closest deviation to basic size."
      ],
    ),
    EngineeringTopic(
      title: "Belt Drives",
      description: "Belt drives transmit power between shafts using flexible belts. They provide smooth operation, absorb shock loads, and allow for speed variation.",
      imagePath: "assets/engineering_hub/mech/belt_drives.webp",
      steps: [
        "1. Open Belt Drive: Both pulleys rotate in same direction.",
        "2. Cross Belt Drive: Pulleys rotate in opposite directions.",
        "3. Quarter-Turn Belt Drive: Shafts at 90° to each other.",
        "4. Tight Side: Side of belt under higher tension.",
        "5. Slack Side: Side of belt under lower tension.",
        "6. Velocity Ratio: N1/N2 = D2/D1 (inverse of diameter ratio).",
        "7. Slip: Loss of speed due to belt slipping on pulley."
      ],
    ),
    EngineeringTopic(
      title: "Riveted Joints",
      description: "Riveted joints are permanent fastening methods used in structural and pressure vessel applications. Rivets create strong, reliable connections.",
      imagePath: "assets/engineering_hub/mech/riveted_joints.webp",
      steps: [
        "1. Lap Joint: Plates overlap, simpler but eccentric loading.",
        "2. Butt Joint: Plates meet edge-to-edge with cover plates.",
        "3. Pitch: Distance between centers of adjacent rivets.",
        "4. Margin: Distance from rivet center to plate edge.",
        "5. Shear Failure: Rivet cuts through its cross-section.",
        "6. Tearing Failure: Plate tears between rivet holes.",
        "7. Crushing Failure: Plate or rivet deforms under bearing stress."
      ],
    ),
    EngineeringTopic(
      title: "Coupling Types",
      description: "Couplings connect two shafts to transmit power. Different types accommodate misalignment, absorb shock, and provide different levels of flexibility.",
      imagePath: "assets/engineering_hub/mech/coupling_types.webp",
      steps: [
        "1. Rigid Flange Coupling: For perfectly aligned shafts, no flexibility.",
        "2. Flexible Coupling: Accommodates minor misalignment and vibration.",
        "3. Universal Joint (Hooke's Joint): Allows angular misalignment up to 45°.",
        "4. Key and Keyway: Prevents relative rotation between shaft and coupling.",
        "5. Bolts: Secure flanges together in rigid couplings.",
        "6. Torque Transmission: Power transferred through friction or positive drive.",
        "7. Maintenance: Flexible couplings require periodic inspection and lubrication."
      ],
    ),
    EngineeringTopic(
      title: "Bearing Types",
      description: "Bearings support rotating shafts and reduce friction. Different bearing types suit different load conditions, speeds, and space constraints.",
      imagePath: "assets/engineering_hub/mech/bearing_types.webp",
      steps: [
        "1. Deep Groove Ball Bearing: Most common, handles radial and light axial loads.",
        "2. Cylindrical Roller Bearing: High radial load capacity, no axial load.",
        "3. Tapered Roller Bearing: Handles combined radial and axial loads.",
        "4. Thrust Ball Bearing: Designed for pure axial loads.",
        "5. Inner Race: Fits on shaft, rotates with shaft.",
        "6. Outer Race: Fits in housing, usually stationary.",
        "7. Cage: Separates rolling elements, maintains spacing."
      ],
    ),
    EngineeringTopic(
      title: "Spring Types",
      description: "Springs store mechanical energy and provide force or motion. Different spring types serve various applications from shock absorption to energy storage.",
      imagePath: "assets/engineering_hub/mech/spring_types.webp",
      steps: [
        "1. Helical Compression Spring: Resists compressive forces, most common type.",
        "2. Helical Tension Spring: Resists tensile forces, has hooks at ends.",
        "3. Torsion Spring: Resists twisting forces, used in clothespins and mousetraps.",
        "4. Leaf Spring: Flat spring, used in vehicle suspensions.",
        "5. Wire Diameter (d): Thickness of spring wire.",
        "6. Mean Coil Diameter (D): Average diameter of spring coil.",
        "7. Spring Index (C): Ratio D/d, typically 4-12 for good design."
      ],
    ),
  ];

  // 🟢 CIVIL ENGINEERING DATA (12 topics)
  static final List<EngineeringTopic> civilTopics = [
    EngineeringTopic(
      title: "Truss Bridge Analysis",
      description: "A truss is an assembly of beams that creates a rigid structure. In engineering graphics, we analyze forces using the Method of Joints to determine if members are in tension or compression.",
      imagePath: "assets/engineering_hub/civil/truss.webp",
      steps: [
        "1. Draw the Free Body Diagram (FBD) of the entire truss structure.",
        "2. Calculate reaction forces at supports using ΣFy = 0 and ΣM = 0.",
        "3. Identify zero-force members (members with no load).",
        "4. Start at a joint with only two unknown forces.",
        "5. Apply equilibrium equations: ΣFx = 0 and ΣFy = 0.",
        "6. Solve for unknown member forces (T = Tension, C = Compression).",
        "7. Move to the next joint and repeat until all forces are found."
      ],
    ),
    EngineeringTopic(
      title: "Beam Bending Analysis",
      description: "Shear Force Diagrams (SFD) and Bending Moment Diagrams (BMD) are graphical representations that help engineers understand internal forces in beams under various loading conditions.",
      imagePath: "assets/engineering_hub/civil/beam_bending.webp",
      steps: [
        "1. Calculate support reactions using equilibrium equations.",
        "2. Start from the left end of the beam.",
        "3. For SFD: Plot shear force at each point (sudden jumps at point loads).",
        "4. Shear force changes linearly under UDL (Uniformly Distributed Load).",
        "5. For BMD: Integrate the shear force diagram.",
        "6. Maximum bending moment occurs where shear force = 0.",
        "7. Use these diagrams to design beam size and reinforcement."
      ],
    ),
    EngineeringTopic(
      title: "Foundation Types",
      description: "Foundations transfer building loads to the soil. Different foundation types are selected based on soil conditions, load magnitude, and building type.",
      imagePath: "assets/engineering_hub/civil/foundation_types.webp",
      steps: [
        "1. Isolated Footing: Individual foundation for single column.",
        "2. Combined Footing: Single foundation supporting two or more columns.",
        "3. Strap Footing: Two footings connected by a beam (strap).",
        "4. Mat Foundation: Single large slab supporting entire building.",
        "5. Pile Foundation: Deep foundation using piles driven into soil.",
        "6. Bearing Capacity: Maximum pressure soil can withstand.",
        "7. Settlement: Vertical movement of foundation due to soil compression."
      ],
    ),
    EngineeringTopic(
      title: "Column Types",
      description: "Columns are vertical structural members that transfer compressive loads from beams to foundations. Different column types suit different load and architectural requirements.",
      imagePath: "assets/engineering_hub/civil/column_types.webp",
      steps: [
        "1. Tied Column: Rectangular with lateral ties at regular intervals.",
        "2. Spiral Column: Circular with continuous helical reinforcement.",
        "3. Composite Column: Steel section encased in concrete.",
        "4. Pedestal: Short column with height < 3 times least dimension.",
        "5. Longitudinal Reinforcement: Main vertical bars (1-4% of area).",
        "6. Transverse Reinforcement: Ties or spirals prevent buckling.",
        "7. Concrete Cover: Minimum 40mm for durability and fire protection."
      ],
    ),
    EngineeringTopic(
      title: "Beam Types",
      description: "Beams are horizontal structural members that resist bending. Different support conditions create different beam types with unique load-carrying characteristics.",
      imagePath: "assets/engineering_hub/civil/beam_types.webp",
      steps: [
        "1. Simply Supported Beam: Supported at both ends, free to rotate.",
        "2. Cantilever Beam: Fixed at one end, free at other end.",
        "3. Fixed Beam: Both ends are fixed, no rotation allowed.",
        "4. Continuous Beam: Extends over more than two supports.",
        "5. Overhanging Beam: Extends beyond one or both supports.",
        "6. Point Load: Concentrated force at a specific location.",
        "7. UDL: Uniformly Distributed Load over beam length."
      ],
    ),
    EngineeringTopic(
      title: "Arch Types",
      description: "Arches are curved structural elements that carry loads primarily through compression. Different arch shapes suit different spans and aesthetic requirements.",
      imagePath: "assets/engineering_hub/civil/arch_types.webp",
      steps: [
        "1. Semicircular Arch: Half circle, classical Roman architecture.",
        "2. Segmental Arch: Less than semicircle, flatter profile.",
        "3. Pointed Arch: Two curves meeting at apex, Gothic architecture.",
        "4. Three-Hinged Arch: Statically determinate, allows movement.",
        "5. Span: Horizontal distance between supports.",
        "6. Rise: Vertical distance from springing line to crown.",
        "7. Thrust: Horizontal force exerted at supports."
      ],
    ),
    EngineeringTopic(
      title: "Dam Cross-Section",
      description: "Gravity dams resist water pressure through their own weight. The cross-section is designed to ensure stability against overturning, sliding, and crushing.",
      imagePath: "assets/engineering_hub/civil/dam_section.webp",
      steps: [
        "1. Crest: Top of dam where water may overflow.",
        "2. Upstream Face: Sloped surface facing reservoir water.",
        "3. Downstream Face: Steeper surface on dry side.",
        "4. Heel: Upstream edge of dam base.",
        "5. Toe: Downstream edge of dam base.",
        "6. Water Pressure: Triangular distribution, maximum at base.",
        "7. Uplift Pressure: Water seepage under dam reduces stability."
      ],
    ),
    EngineeringTopic(
      title: "Road Cross-Section",
      description: "Flexible pavement consists of multiple layers designed to distribute traffic loads to the subgrade. Each layer serves a specific function.",
      imagePath: "assets/engineering_hub/civil/road_section.webp",
      steps: [
        "1. Wearing Course: Top layer, provides smooth riding surface.",
        "2. Binder Course: Distributes load, prevents crack propagation.",
        "3. Base Course: Main load-bearing layer, high strength material.",
        "4. Sub-base: Distributes load to subgrade, provides drainage.",
        "5. Subgrade: Natural soil, prepared and compacted.",
        "6. Camber: Transverse slope for water drainage (2-3%).",
        "7. Shoulder: Edge strip for emergency stopping and drainage."
      ],
    ),
    EngineeringTopic(
      title: "Slab Types",
      description: "Slabs are horizontal plate elements that transfer loads to beams or walls. Different slab types suit different span lengths and support conditions.",
      imagePath: "assets/engineering_hub/civil/slab_types.webp",
      steps: [
        "1. One-Way Slab: Bends in one direction, length > 2 × width.",
        "2. Two-Way Slab: Bends in both directions, nearly square.",
        "3. Flat Slab: No beams, directly supported on columns.",
        "4. Waffle Slab: Two-way ribbed slab, lightweight and economical.",
        "5. Ribbed Slab: One-way slab with ribs for longer spans.",
        "6. Main Reinforcement: Along shorter span in one-way slab.",
        "7. Distribution Reinforcement: Perpendicular to main bars."
      ],
    ),
    EngineeringTopic(
      title: "Staircase Design",
      description: "Staircases provide vertical circulation in buildings. Proper design ensures safety, comfort, and structural adequacy.",
      imagePath: "assets/engineering_hub/civil/staircase_design.webp",
      steps: [
        "1. Tread: Horizontal part where foot is placed (250-300mm).",
        "2. Riser: Vertical distance between treads (150-190mm).",
        "3. Going: Horizontal projection of a step.",
        "4. Flight: Continuous series of steps between landings.",
        "5. Landing: Platform between flights for rest and direction change.",
        "6. Stringer: Inclined beam supporting steps from sides.",
        "7. Nosing: Projection of tread beyond riser (25-40mm)."
      ],
    ),
    EngineeringTopic(
      title: "Cantilever Retaining Wall",
      description: "Cantilever retaining walls resist lateral earth pressure using a vertical stem and base slab. The heel slab uses soil weight for stability.",
      imagePath: "assets/engineering_hub/civil/cantilever_wall.webp",
      steps: [
        "1. Stem: Vertical wall resisting earth pressure.",
        "2. Heel Slab: Extends under retained soil, provides stability.",
        "3. Toe Slab: Extends in front of stem, prevents overturning.",
        "4. Key: Projection below base to prevent sliding.",
        "5. Active Earth Pressure: Lateral pressure from retained soil.",
        "6. Passive Earth Pressure: Resistance from soil in front of toe.",
        "7. Drainage: Weep holes prevent water pressure buildup."
      ],
    ),
    EngineeringTopic(
      title: "Steel Connections",
      description: "Steel structural connections join members together. Proper connection design ensures load transfer and structural integrity.",
      imagePath: "assets/engineering_hub/civil/steel_connections.webp",
      steps: [
        "1. Bolted Connection: Uses high-strength bolts, allows disassembly.",
        "2. Welded Connection: Permanent, provides continuous load path.",
        "3. Beam-to-Column: Critical connection in frame structures.",
        "4. Splice Connection: Joins two members end-to-end.",
        "5. Shear Connection: Transfers shear force only.",
        "6. Moment Connection: Transfers both shear and moment.",
        "7. Gusset Plate: Connecting plate in truss joints."
      ],
    ),
  ];

  // 🔵 COMPUTER SCIENCE (CSE) DATA (13 topics)
  static final List<EngineeringTopic> cseTopics = [
    EngineeringTopic(
      title: "Binary Search Tree (BST)",
      description: "A hierarchical data structure where each node has at most two children. The left subtree contains values less than the parent, and the right subtree contains values greater than the parent.",
      imagePath: "assets/engineering_hub/cse/bst.webp",
      steps: [
        "1. Root node is the top-most node of the tree.",
        "2. For any node: Left child value < Parent node value.",
        "3. For any node: Right child value > Parent node value.",
        "4. No duplicate values are allowed in a standard BST.",
        "5. Insertion: Start at root, compare and move left/right until empty spot.",
        "6. Search: O(log n) average case, O(n) worst case (skewed tree).",
        "7. In-order traversal (Left-Root-Right) gives sorted sequence."
      ],
    ),
    EngineeringTopic(
      title: "Linked List",
      description: "A linear data structure where elements are stored in nodes. Each node contains data and a pointer/reference to the next node. Unlike arrays, linked lists don't require contiguous memory.",
      imagePath: "assets/engineering_hub/cse/linked_list.webp",
      steps: [
        "1. Each node has two parts: Data field and Next pointer.",
        "2. HEAD pointer points to the first node.",
        "3. Last node's next pointer is NULL (end of list).",
        "4. Insertion at beginning: O(1) - just update HEAD.",
        "5. Insertion at end: O(n) - traverse to last node.",
        "6. Deletion: Update the previous node's next pointer.",
        "7. Advantages: Dynamic size, easy insertion/deletion."
      ],
    ),
    EngineeringTopic(
      title: "Hash Table",
      description: "A data structure that implements an associative array using a hash function to compute an index into an array of buckets. Provides O(1) average case for search, insert, and delete operations.",
      imagePath: "assets/engineering_hub/cse/hash_table.webp",
      steps: [
        "1. Hash function converts key into array index: index = hash(key) % table_size.",
        "2. Collision occurs when two keys hash to the same index.",
        "3. Chaining: Store colliding elements in a linked list at that index.",
        "4. Open Addressing: Find next empty slot using probing.",
        "5. Load Factor = n/m (n = elements, m = table size).",
        "6. Rehashing: When load factor exceeds threshold, create larger table.",
        "7. Good hash function distributes keys uniformly across table."
      ],
    ),
    EngineeringTopic(
      title: "AVL Tree",
      description: "A self-balancing binary search tree where the height difference between left and right subtrees (balance factor) is at most 1 for every node. Ensures O(log n) operations.",
      imagePath: "assets/engineering_hub/cse/avl_tree.webp",
      steps: [
        "1. Balance Factor = Height(Left Subtree) - Height(Right Subtree).",
        "2. Valid balance factors: -1, 0, +1 for all nodes.",
        "3. Left Rotation: Used when right subtree is heavier.",
        "4. Right Rotation: Used when left subtree is heavier.",
        "5. Left-Right Rotation: Left rotate child, then right rotate parent.",
        "6. Right-Left Rotation: Right rotate child, then left rotate parent.",
        "7. After insertion/deletion, rebalance from modified node to root."
      ],
    ),
    EngineeringTopic(
      title: "B-Tree",
      description: "A self-balancing multi-way search tree optimized for systems that read and write large blocks of data. Commonly used in databases and file systems.",
      imagePath: "assets/engineering_hub/cse/b_tree.webp",
      steps: [
        "1. Order m: Maximum number of children a node can have.",
        "2. Each node contains multiple keys (m-1 maximum).",
        "3. All leaf nodes are at the same level (perfectly balanced).",
        "4. Internal nodes have at least ⌈m/2⌉ children.",
        "5. Root has at least 2 children (unless it's a leaf).",
        "6. Insertion: Add to leaf, split if overflow, propagate upward.",
        "7. Used in databases for indexing (B+ Tree variant)."
      ],
    ),
    EngineeringTopic(
      title: "Graph Representations",
      description: "Graphs consist of vertices (nodes) and edges (connections). Different representations suit different operations and space requirements.",
      imagePath: "assets/engineering_hub/cse/graph_representations.webp",
      steps: [
        "1. Adjacency Matrix: 2D array, matrix[i][j] = 1 if edge exists.",
        "2. Space: O(V²), good for dense graphs.",
        "3. Edge check: O(1), but wastes space for sparse graphs.",
        "4. Adjacency List: Array of lists, each vertex has list of neighbors.",
        "5. Space: O(V + E), efficient for sparse graphs.",
        "6. Edge check: O(degree), but saves space.",
        "7. Edge List: List of all edges as (u, v) pairs."
      ],
    ),
    EngineeringTopic(
      title: "Sorting Algorithms",
      description: "Sorting arranges elements in a specific order. Different algorithms have different time complexities, space requirements, and stability properties.",
      imagePath: "assets/engineering_hub/cse/sorting_algorithms.webp",
      steps: [
        "1. Bubble Sort: Compare adjacent elements, swap if wrong order. O(n²).",
        "2. Selection Sort: Find minimum, swap with first unsorted. O(n²).",
        "3. Insertion Sort: Insert each element into sorted portion. O(n²).",
        "4. Merge Sort: Divide and conquer, merge sorted halves. O(n log n).",
        "5. Quick Sort: Partition around pivot, recursively sort. O(n log n) average.",
        "6. Stable Sort: Maintains relative order of equal elements.",
        "7. In-place Sort: Uses O(1) extra space."
      ],
    ),
    EngineeringTopic(
      title: "Stack and Queue",
      description: "Linear data structures with specific access patterns. Stack follows LIFO (Last In First Out), Queue follows FIFO (First In First Out).",
      imagePath: "assets/engineering_hub/cse/stack_queue.webp",
      steps: [
        "1. Stack Push: Add element to top, increment top pointer.",
        "2. Stack Pop: Remove element from top, decrement top pointer.",
        "3. Stack Overflow: Push when stack is full.",
        "4. Queue Enqueue: Add element at rear, increment rear pointer.",
        "5. Queue Dequeue: Remove element from front, increment front pointer.",
        "6. Circular Queue: Use modulo to wrap around array.",
        "7. Applications: Stack for recursion, Queue for BFS."
      ],
    ),
    EngineeringTopic(
      title: "Heap Data Structure",
      description: "A complete binary tree where parent nodes satisfy heap property. Max-Heap: parent ≥ children. Min-Heap: parent ≤ children. Used in priority queues and heap sort.",
      imagePath: "assets/engineering_hub/cse/heap_structure.webp",
      steps: [
        "1. Array representation: Parent at i, children at 2i+1 and 2i+2.",
        "2. Heapify: Restore heap property after insertion/deletion.",
        "3. Insert: Add at end, bubble up to maintain heap property.",
        "4. Delete Max/Min: Remove root, move last element to root, bubble down.",
        "5. Build Heap: Start from last non-leaf, heapify downward. O(n).",
        "6. Heap Sort: Build max-heap, repeatedly extract max. O(n log n).",
        "7. Priority Queue: Heap provides O(log n) insert and extract-min."
      ],
    ),
    EngineeringTopic(
      title: "Trie Data Structure",
      description: "A tree-like data structure for storing strings where each path from root to leaf represents a word. Efficient for prefix-based searches and autocomplete.",
      imagePath: "assets/engineering_hub/cse/trie_structure.webp",
      steps: [
        "1. Root node represents empty string.",
        "2. Each edge represents a character.",
        "3. Path from root to node forms a prefix.",
        "4. End-of-word marker indicates complete word.",
        "5. Insert: Follow path creating nodes as needed, mark end.",
        "6. Search: Follow path, check end-of-word marker.",
        "7. Space: O(ALPHABET_SIZE × N × L) where L is average length."
      ],
    ),
    EngineeringTopic(
      title: "Red-Black Tree",
      description: "A self-balancing binary search tree with color properties ensuring O(log n) operations. Less strictly balanced than AVL but faster insertions/deletions.",
      imagePath: "assets/engineering_hub/cse/red_black_tree.webp",
      steps: [
        "1. Every node is either red or black.",
        "2. Root is always black.",
        "3. All leaves (NIL nodes) are black.",
        "4. Red node cannot have red children (no consecutive reds).",
        "5. All paths from node to descendant leaves have same black count.",
        "6. Insertion: Insert as red, recolor and rotate to fix violations.",
        "7. Maximum height: 2 log(n+1), guarantees O(log n) operations."
      ],
    ),
    EngineeringTopic(
      title: "Dijkstra's Algorithm",
      description: "Finds shortest path from source to all vertices in weighted graph with non-negative weights. Uses greedy approach with priority queue.",
      imagePath: "assets/engineering_hub/cse/dijkstra_algorithm.webp",
      steps: [
        "1. Initialize distance to source as 0, all others as infinity.",
        "2. Add source to priority queue (min-heap by distance).",
        "3. Extract vertex with minimum distance from queue.",
        "4. For each neighbor, calculate distance via current vertex.",
        "5. If new distance < old distance, update and add to queue.",
        "6. Mark vertex as visited, repeat until queue is empty.",
        "7. Time Complexity: O((V + E) log V) with binary heap."
      ],
    ),
    EngineeringTopic(
      title: "Memory Management",
      description: "Operating systems organize process memory into segments. Understanding memory layout is crucial for debugging, optimization, and security.",
      imagePath: "assets/engineering_hub/cse/memory_management.webp",
      steps: [
        "1. Text Segment: Contains executable code, read-only.",
        "2. Data Segment (Initialized): Global and static variables with initial values.",
        "3. BSS Segment (Uninitialized): Global and static variables without initial values.",
        "4. Heap: Dynamic memory allocation (malloc/new), grows upward.",
        "5. Stack: Function calls, local variables, grows downward.",
        "6. Stack Frame: Contains return address, parameters, local variables.",
        "7. Memory Leak: Allocated heap memory not freed, causes gradual memory exhaustion."
      ],
    ),
  ];

  // 🟣 ELECTRONICS & COMMUNICATION (ECE) DATA (14 topics)
  static final List<EngineeringTopic> eceTopics = [
    EngineeringTopic(
      title: "RC Circuit Analysis",
      description: "A Resistor-Capacitor circuit is a fundamental circuit that exhibits time-dependent behavior. The capacitor charges and discharges exponentially, creating a time constant τ = RC.",
      imagePath: "assets/engineering_hub/ece/rc_circuit.webp",
      steps: [
        "1. Time constant τ = R × C (in seconds).",
        "2. Charging: Vc(t) = Vs(1 - e^(-t/τ)) where Vs is source voltage.",
        "3. After 5τ, capacitor is considered fully charged (99.3%).",
        "4. Discharging: Vc(t) = V0 × e^(-t/τ) where V0 is initial voltage.",
        "5. Current during charging: I(t) = (Vs/R) × e^(-t/τ).",
        "6. Used in timing circuits, filters, and signal processing.",
        "7. Larger τ means slower charging/discharging."
      ],
    ),
    EngineeringTopic(
      title: "Operational Amplifier Configurations",
      description: "Op-amps are versatile integrated circuits used for signal amplification and processing. The two basic configurations are inverting and non-inverting amplifiers.",
      imagePath: "assets/engineering_hub/ece/opamp.webp",
      steps: [
        "1. Inverting Amplifier: Input at inverting terminal (-).",
        "2. Inverting gain: Av = -Rf/Rin (negative sign means 180° phase shift).",
        "3. Non-Inverting Amplifier: Input at non-inverting terminal (+).",
        "4. Non-inverting gain: Av = 1 + (Rf/Rin) (always ≥ 1).",
        "5. Virtual ground concept: Both inputs at same voltage.",
        "6. Ideal op-amp: Infinite gain, infinite input impedance, zero output impedance.",
        "7. Used in audio amplifiers, filters, comparators, and instrumentation."
      ],
    ),
    EngineeringTopic(
      title: "Logic Gates",
      description: "Logic gates are the building blocks of digital circuits. They perform Boolean operations on binary inputs (0 and 1) to produce binary outputs.",
      imagePath: "assets/engineering_hub/ece/logic_gates.webp",
      steps: [
        "1. AND Gate: Output is 1 only when ALL inputs are 1.",
        "2. OR Gate: Output is 1 when ANY input is 1.",
        "3. NOT Gate (Inverter): Output is opposite of input.",
        "4. NAND Gate: NOT-AND, output is 0 only when all inputs are 1.",
        "5. NOR Gate: NOT-OR, output is 1 only when all inputs are 0.",
        "6. XOR Gate: Output is 1 when inputs are different.",
        "7. NAND and NOR are universal gates (can build any logic circuit)."
      ],
    ),
    EngineeringTopic(
      title: "Full Adder Circuit",
      description: "A full adder is a digital circuit that adds three binary bits: two significant bits (A, B) and a carry-in (Cin). It produces a sum and a carry-out (Cout).",
      imagePath: "assets/engineering_hub/ece/full_adder.webp",
      steps: [
        "1. Inputs: A, B (bits to add), Cin (carry from previous stage).",
        "2. Outputs: Sum and Cout (carry to next stage).",
        "3. Sum = A ⊕ B ⊕ Cin (three-way XOR).",
        "4. Cout = (A·B) + (Cin·(A⊕B)) where · is AND, + is OR.",
        "5. Implementation: Two XOR gates, two AND gates, one OR gate.",
        "6. Multiple full adders create a ripple-carry adder.",
        "7. Used in ALU (Arithmetic Logic Unit) of processors."
      ],
    ),
    EngineeringTopic(
      title: "Transistor Configurations",
      description: "BJT (Bipolar Junction Transistor) amplifiers have three configurations based on which terminal is common. Each has unique characteristics for different applications.",
      imagePath: "assets/engineering_hub/ece/transistor_config.webp",
      steps: [
        "1. Common Emitter (CE): High voltage and current gain, 180° phase shift.",
        "2. CE Applications: General purpose amplification, most common config.",
        "3. Common Base (CB): High voltage gain, no current gain, no phase shift.",
        "4. CB Applications: High frequency amplifiers, impedance matching.",
        "5. Common Collector (CC): High current gain, voltage gain ≈ 1, no phase shift.",
        "6. CC Applications: Buffer, impedance matching (emitter follower).",
        "7. Biasing: DC voltages to set operating point in active region."
      ],
    ),
    EngineeringTopic(
      title: "Flip-Flops",
      description: "Flip-flops are bistable multivibrators that store one bit of information. They are fundamental building blocks of sequential digital circuits.",
      imagePath: "assets/engineering_hub/ece/flip_flops.webp",
      steps: [
        "1. SR Flip-Flop: Set-Reset, S=R=1 is invalid state.",
        "2. JK Flip-Flop: Improved SR, J=K=1 toggles output.",
        "3. D Flip-Flop: Data flip-flop, output follows input on clock edge.",
        "4. T Flip-Flop: Toggle flip-flop, toggles on T=1.",
        "5. Edge-Triggered: Changes output on clock edge (rising or falling).",
        "6. Level-Triggered: Changes output when clock is high or low.",
        "7. Applications: Registers, counters, memory elements."
      ],
    ),
    EngineeringTopic(
      title: "Counters",
      description: "Counters are sequential circuits that count clock pulses. They can count up, down, or in specific sequences for various applications.",
      imagePath: "assets/engineering_hub/ece/counters.webp",
      steps: [
        "1. Asynchronous (Ripple) Counter: Flip-flops triggered sequentially.",
        "2. Ripple delay: Each stage adds propagation delay.",
        "3. Synchronous Counter: All flip-flops triggered simultaneously.",
        "4. No cumulative delay, faster operation than ripple.",
        "5. Modulo-N Counter: Counts from 0 to N-1, then resets.",
        "6. Up Counter: Increments on each clock pulse.",
        "7. Down Counter: Decrements on each clock pulse."
      ],
    ),
    EngineeringTopic(
      title: "Multiplexer and Demultiplexer",
      description: "Multiplexers select one of many inputs to route to output. Demultiplexers route one input to one of many outputs. They are inverse operations.",
      imagePath: "assets/engineering_hub/ece/mux_demux.webp",
      steps: [
        "1. Multiplexer (MUX): Many inputs, one output, select lines choose input.",
        "2. 4:1 MUX: 4 data inputs, 2 select lines, 1 output.",
        "3. MUX Applications: Data routing, parallel-to-serial conversion.",
        "4. Demultiplexer (DEMUX): One input, many outputs, select lines choose output.",
        "5. 1:4 DEMUX: 1 data input, 2 select lines, 4 outputs.",
        "6. DEMUX Applications: Serial-to-parallel conversion, data distribution.",
        "7. MUX and DEMUX are complementary operations."
      ],
    ),
    EngineeringTopic(
      title: "Encoder and Decoder",
      description: "Encoders convert information from one format to another. Decoders perform the reverse operation, converting encoded data back to original format.",
      imagePath: "assets/engineering_hub/ece/encoder_decoder.webp",
      steps: [
        "1. Encoder: Converts 2^n inputs to n-bit binary code.",
        "2. Priority Encoder: If multiple inputs active, encodes highest priority.",
        "3. 4:2 Encoder: 4 inputs (one-hot) to 2-bit binary output.",
        "4. Decoder: Converts n-bit binary to 2^n outputs (one-hot).",
        "5. 2:4 Decoder: 2-bit binary input to 4 outputs (only one active).",
        "6. Applications: Address decoding, display drivers, data conversion.",
        "7. Enable input: Activates/deactivates encoder or decoder."
      ],
    ),
    EngineeringTopic(
      title: "Filter Circuits",
      description: "Active filters use op-amps to provide gain and better performance than passive filters. They shape frequency response for signal processing applications.",
      imagePath: "assets/engineering_hub/ece/filter_circuits.webp",
      steps: [
        "1. Low-Pass Filter: Passes low frequencies, blocks high frequencies.",
        "2. Cutoff frequency fc: -3dB point, fc = 1/(2πRC).",
        "3. High-Pass Filter: Passes high frequencies, blocks low frequencies.",
        "4. Band-Pass Filter: Passes frequencies within a specific range.",
        "5. Band-Stop (Notch) Filter: Blocks frequencies within a range.",
        "6. Active filters: Use op-amps, provide gain and impedance isolation.",
        "7. Applications: Audio processing, communication systems, noise reduction."
      ],
    ),
    EngineeringTopic(
      title: "Oscillator Circuits",
      description: "Oscillators generate periodic waveforms without external input signal. They convert DC power to AC signals at specific frequencies.",
      imagePath: "assets/engineering_hub/ece/oscillator_circuits.webp",
      steps: [
        "1. Barkhausen Criterion: Loop gain ≥ 1, phase shift = 0° or 360°.",
        "2. RC Phase-Shift Oscillator: Uses RC network for phase shift.",
        "3. Frequency: f = 1/(2π√6RC) for 3-stage RC network.",
        "4. Wien Bridge Oscillator: Uses Wien bridge for frequency selection.",
        "5. Colpitts Oscillator: LC oscillator using capacitive voltage divider.",
        "6. Crystal Oscillator: Uses quartz crystal for high stability.",
        "7. Applications: Clock generation, signal generators, communication systems."
      ],
    ),
    EngineeringTopic(
      title: "Modulation Techniques",
      description: "Modulation varies a carrier signal's properties to encode information. Essential for wireless communication and signal transmission over long distances.",
      imagePath: "assets/engineering_hub/ece/modulation_techniques.webp",
      steps: [
        "1. Carrier Signal: High-frequency sinusoidal signal.",
        "2. Message Signal: Low-frequency information signal.",
        "3. Amplitude Modulation (AM): Varies carrier amplitude.",
        "4. AM Modulation Index: m = (Amax - Amin)/(Amax + Amin).",
        "5. Frequency Modulation (FM): Varies carrier frequency.",
        "6. Phase Modulation (PM): Varies carrier phase.",
        "7. FM/PM advantages: Better noise immunity than AM."
      ],
    ),
    EngineeringTopic(
      title: "Number Systems",
      description: "Digital systems use different number systems for representation and computation. Understanding conversions is essential for digital design.",
      imagePath: "assets/engineering_hub/ece/number_systems.webp",
      steps: [
        "1. Binary (Base-2): Uses 0 and 1, fundamental to digital systems.",
        "2. Octal (Base-8): Uses 0-7, groups of 3 binary bits.",
        "3. Decimal (Base-10): Uses 0-9, human-readable format.",
        "4. Hexadecimal (Base-16): Uses 0-9, A-F, groups of 4 binary bits.",
        "5. Binary to Decimal: Multiply each bit by 2^position, sum results.",
        "6. BCD (Binary Coded Decimal): Each decimal digit as 4-bit binary.",
        "7. Gray Code: Adjacent values differ by only one bit, reduces errors."
      ],
    ),
    EngineeringTopic(
      title: "Shift Registers",
      description: "Shift registers are cascaded flip-flops that shift data bits serially or in parallel. Used for data storage, conversion, and manipulation.",
      imagePath: "assets/engineering_hub/ece/shift_registers.webp",
      steps: [
        "1. Serial-In Serial-Out (SISO): Data enters and exits serially.",
        "2. Serial-In Parallel-Out (SIPO): Serial input, parallel output.",
        "3. Parallel-In Serial-Out (PISO): Parallel input, serial output.",
        "4. Parallel-In Parallel-Out (PIPO): Both parallel, used for storage.",
        "5. Left Shift: Data moves toward MSB (Most Significant Bit).",
        "6. Right Shift: Data moves toward LSB (Least Significant Bit).",
        "7. Applications: Serial communication, data conversion, delay lines."
      ],
    ),
  ];

  // 📐 ENGINEERING GRAPHICS (1st Year) - All Units
  static final List<EngineeringTopic> graphicsTopics = [
    // UNIT I: CURVES & SCALES
    EngineeringTopic(
      title: "Ellipse (General Method)",
      description: "A conic section where the eccentricity is less than 1. Used in arches, bridges, and planetary orbits. The ellipse has two foci and the sum of distances from any point to both foci is constant.",
      imagePath: "assets/engineering_hub/graphics/ellipse.webp",
      steps: [
        "1. Draw the directrix (DD) as a vertical line.",
        "2. Draw the axis (AB) perpendicular to directrix.",
        "3. Mark the focus (F) at the given distance from directrix.",
        "4. Calculate eccentricity e < 1 (e = distance from focus / distance from directrix).",
        "5. Draw arcs from focus with varying radii.",
        "6. Draw perpendiculars from directrix at corresponding points.",
        "7. Mark intersection points to trace the ellipse curve."
      ],
    ),
    EngineeringTopic(
      title: "Cycloid Construction",
      description: "The curve generated by a point on the circumference of a circle rolling along a straight line. Used in gear tooth profiles and cycloidal pendulums.",
      imagePath: "assets/engineering_hub/graphics/cycloid.webp",
      steps: [
        "1. Draw the generating circle of radius r.",
        "2. Draw the base line equal to circumference (2πr).",
        "3. Divide the circle into 8 or 12 equal parts.",
        "4. Divide the base line into same number of equal parts.",
        "5. Draw horizontal lines from division points on circle.",
        "6. Draw vertical lines from division points on base.",
        "7. Mark intersections and connect smoothly to form cycloid."
      ],
    ),
    EngineeringTopic(
      title: "Diagonal Scales",
      description: "Used to represent three consecutive units (e.g., meters, decimeters, centimeters) or measure very small subdivisions accurately on engineering drawings.",
      imagePath: "assets/engineering_hub/graphics/diagonal_scale.webp",
      steps: [
        "1. Calculate Representative Fraction (RF = Drawing length / Actual length).",
        "2. Determine Length of Scale = RF × Maximum distance to be measured.",
        "3. Draw a rectangle with calculated length.",
        "4. Divide horizontally for main units.",
        "5. Subdivide first division for smaller units.",
        "6. Draw diagonals to create minute subdivisions.",
        "7. Label all divisions clearly."
      ],
    ),

    // UNIT II: ORTHOGRAPHIC PROJECTIONS
    EngineeringTopic(
      title: "Projection of Points",
      description: "Visualizing a point's position in 4 quadrants relative to HP (Horizontal Plane) and VP (Vertical Plane). Foundation of all orthographic projections.",
      imagePath: "assets/engineering_hub/graphics/points.webp",
      steps: [
        "1. Identify the quadrant based on point position.",
        "2. 1st Quadrant: Above HP, In front of VP.",
        "3. 2nd Quadrant: Above HP, Behind VP.",
        "4. 3rd Quadrant: Below HP, Behind VP.",
        "5. 4th Quadrant: Below HP, In front of VP.",
        "6. Draw XY reference line.",
        "7. Mark front view (a') and top view (a) accordingly."
      ],
    ),
    EngineeringTopic(
      title: "Projection of Lines (Inclined)",
      description: "Drawing lines that are inclined to both HP and VP. Essential for understanding true length and angles of inclination in engineering drawings.",
      imagePath: "assets/engineering_hub/graphics/lines.webp",
      steps: [
        "1. Draw line parallel to VP (assume simple position).",
        "2. Mark true length in front view.",
        "3. Rotate line to given angle with HP.",
        "4. Project endpoints to get new front view.",
        "5. Draw top view showing inclination with VP.",
        "6. Calculate apparent lengths in both views.",
        "7. Verify using Pythagorean theorem for true length."
      ],
    ),

    // UNIT III: PROJECTION OF SOLIDS
    EngineeringTopic(
      title: "Projection of Solids (Axis Inclined)",
      description: "Drawing Prisms, Pyramids, Cylinders, and Cones when their axis is tilted to HP or VP. Uses multi-stage projection method.",
      imagePath: "assets/engineering_hub/graphics/solids.webp",
      steps: [
        "1. Stage 1: Draw solid in simple position (axis perpendicular to HP).",
        "2. Identify all corner points and edges.",
        "3. Stage 2: Tilt the solid to given angle with HP.",
        "4. Rotate all points about base.",
        "5. Stage 3: If needed, tilt to VP as well.",
        "6. Project all points to get final orthographic views.",
        "7. Join visible edges with solid lines, hidden with dashed lines."
      ],
    ),

    // UNIT IV: SECTIONS & DEVELOPMENT
    EngineeringTopic(
      title: "Sections of Solids",
      description: "Cutting a solid with a plane to reveal internal details and obtain the true shape of the section. Critical for manufacturing and assembly drawings.",
      imagePath: "assets/engineering_hub/graphics/sections.webp",
      steps: [
        "1. Draw the solid in simple position.",
        "2. Draw the cutting plane (Section Plane) at given position.",
        "3. Mark VT (Vertical Trace) and HT (Horizontal Trace).",
        "4. Identify intersection points where plane cuts edges.",
        "5. Project these points to the other view.",
        "6. Connect points to get true shape of section.",
        "7. Add section lines (hatching) at 45° to show cut surface."
      ],
    ),
    EngineeringTopic(
      title: "Development of Surfaces",
      description: "Unfolding a 3D object into a flat 2D pattern. Essential for sheet metal work, packaging design, and fabrication.",
      imagePath: "assets/engineering_hub/graphics/development.webp",
      steps: [
        "1. For Prisms/Cylinders: Use Parallel Line Method.",
        "2. Calculate stretch-out length = Perimeter of base.",
        "3. For Pyramids/Cones: Use Radial Line Method.",
        "4. Calculate slant height for true length of edges.",
        "5. Draw development starting from seam line.",
        "6. Mark all fold lines and cut lines.",
        "7. Add tabs for joining if required."
      ],
    ),

    // UNIT V: CONVERSION OF VIEWS
    EngineeringTopic(
      title: "Isometric to Orthographic Conversion",
      description: "Converting a 3D isometric view into standard 2D orthographic projections (Front, Top, and Side views). Essential skill for reading engineering drawings.",
      imagePath: "assets/engineering_hub/graphics/iso_to_ortho.webp",
      steps: [
        "1. Study the isometric view carefully.",
        "2. Identify the viewing direction (usually marked with arrow).",
        "3. Draw XY reference line.",
        "4. Draw Front View showing Length × Height.",
        "5. Project downward for Top View showing Length × Width.",
        "6. Project sideways for Side View showing Width × Height.",
        "7. Ensure all three views are properly aligned."
      ],
    ),
  ];
}
