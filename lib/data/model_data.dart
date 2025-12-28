class EngineeringModel {
  final String title;
  final String assetPath; // Path to your local file
  // 📐 ENGINEERING METADATA
  final String dimensions;
  final String faceCount;  // "Polygons"
  final String vertices;   // "Points"
  final String material;
  // 📍 SPATIAL COORDINATES (X, Y, Z Origin)
  final Map<String, double> origin; 

  EngineeringModel({
    required this.title,
    required this.assetPath,
    required this.dimensions,
    required this.faceCount,
    required this.vertices,
    required this.material,
    required this.origin,
  });
}

// 👇 EDIT THIS LIST WITH YOUR ACTUAL MODEL DETAILS
final List<EngineeringModel> my3DModels = [
  EngineeringModel(
    title: "12-Bit I2C DAC Module",
    assetPath: "assets/3d_models/12bit_i2c_dac_module.glb",
    dimensions: "50mm x 30mm x 15mm",
    faceCount: "8,400 Faces",
    vertices: "4,200 Vertices",
    material: "PCB & Components",
    origin: {'x': 0.0, 'y': 0.0, 'z': 0.0},
  ),
  EngineeringModel(
    title: "DMX Grove Connector",
    assetPath: "assets/3d_models/connecteur-dmx-grove-1.snapshot.2.glb",
    dimensions: "40mm x 25mm x 20mm",
    faceCount: "15,600 Faces",
    vertices: "7,800 Vertices",
    material: "Plastic Housing",
    origin: {'x': 0.0, 'y': 0.0, 'z': 0.0},
  ),
  EngineeringModel(
    title: "I/O Expansion Shield v7",
    assetPath: "assets/3d_models/sheild-i-o-expension-v7-1-1.snapshot.1.glb",
    dimensions: "68mm x 53mm x 25mm",
    faceCount: "24,800 Faces",
    vertices: "12,400 Vertices",
    material: "PCB & Electronic Components",
    origin: {'x': 0.0, 'y': 0.0, 'z': 0.0},
  ),
  EngineeringModel(
    title: "CO2 Laser Engraver/Cutting Machine",
    assetPath: "assets/3d_models/co2_laser_engravercutting_machine.glb",
    dimensions: "900mm x 600mm x 400mm",
    faceCount: "45,200 Faces",
    vertices: "22,600 Vertices",
    material: "Aluminum Frame & Acrylic",
    origin: {'x': 0.0, 'y': 0.0, 'z': 0.0},
  ),
  EngineeringModel(
    title: "Industrial Lathe Machine",
    assetPath: "assets/3d_models/industrial_lathe.glb",
    dimensions: "1200mm x 800mm x 600mm",
    faceCount: "38,500 Faces",
    vertices: "19,250 Vertices",
    material: "Cast Iron & Steel",
    origin: {'x': 0.0, 'y': 0.0, 'z': 0.0},
  ),
];
