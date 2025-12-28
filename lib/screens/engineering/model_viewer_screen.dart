import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:fluxflow/data/model_data.dart';

class ModelViewerScreen extends StatefulWidget {
  final EngineeringModel model;

  const ModelViewerScreen({super.key, required this.model});

  @override
  State<ModelViewerScreen> createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  bool _showData = true; // Toggle for HUD
  bool _showAxisHelper = true; // Toggle for axis visualization

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.model.title,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showAxisHelper ? Icons.grid_on : Icons.grid_off,
              color: Colors.amber,
            ),
            onPressed: () => setState(() => _showAxisHelper = !_showAxisHelper),
            tooltip: 'Toggle Axis Helper',
          ),
          IconButton(
            icon: Icon(
              _showData ? Icons.info : Icons.info_outline,
              color: Colors.cyanAccent,
            ),
            onPressed: () => setState(() => _showData = !_showData),
            tooltip: 'Toggle Geometric Data',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. THE 3D MODEL VIEWER
          ModelViewer(
            src: widget.model.assetPath,
            alt: "3D Model of ${widget.model.title}",
            ar: true,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: const Color(0xFF000000),
            loading: Loading.eager,
            disableZoom: false,
            // Enhanced interaction settings
            interactionPrompt: InteractionPrompt.none,
            touchAction: TouchAction.panY,
          ),

          // 2. AXIS HELPER VISUALIZATION
          if (_showAxisHelper)
            Positioned(
              top: 100,
              left: 15,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "AXIS REFERENCE",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAxisIndicator("X", Colors.red, Icons.arrow_forward),
                    const SizedBox(height: 4),
                    _buildAxisIndicator("Y", Colors.green, Icons.arrow_upward),
                    const SizedBox(height: 4),
                    _buildAxisIndicator("Z", Colors.blue, Icons.arrow_back),
                  ],
                ),
              ),
            ),

          // 3. GESTURE CONTROLS GUIDE
          Positioned(
            top: _showAxisHelper ? 240 : 100,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.purple.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CONTROLS",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildGestureHint(Icons.touch_app, "Drag", "Rotate"),
                  const SizedBox(height: 4),
                  _buildGestureHint(Icons.pinch, "Pinch", "Zoom"),
                  const SizedBox(height: 4),
                  _buildGestureHint(Icons.pan_tool, "Two Fingers", "Pan"),
                  const SizedBox(height: 4),
                  _buildGestureHint(Icons.refresh, "Auto", "Rotate"),
                ],
              ),
            ),
          ),

          // 4. THE GEOMETRIC HUD (Bottom Overlay)
          if (_showData)
            Positioned(
              bottom: 30,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "GEOMETRIC DATA",
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.analytics,
                          color: Colors.cyanAccent,
                          size: 14,
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey[800]),
                    
                    const SizedBox(height: 8),
                    
                    // The Data Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _dataColumn("Faces", widget.model.faceCount),
                        _dataColumn("Vertices", widget.model.vertices),
                        _dataColumn("Material", widget.model.material),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Dimensions Bar
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.straighten,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "DIMENSIONS: ${widget.model.dimensions}",
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Coordinates Bar with Color-Coded Axes
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "ORIGIN:",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                          _coordWithColor("X", widget.model.origin['x']!, Colors.red),
                          _coordWithColor("Y", widget.model.origin['y']!, Colors.green),
                          _coordWithColor("Z", widget.model.origin['z']!, Colors.blue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAxisIndicator(String axis, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          "$axis-Axis",
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGestureHint(IconData icon, String gesture, String action) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple[200], size: 14),
        const SizedBox(width: 6),
        Text(
          "$gesture:",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          action,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _dataColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _coordWithColor(String axis, double val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        "$axis: ${val.toStringAsFixed(1)}",
        style: TextStyle(
          color: color,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
