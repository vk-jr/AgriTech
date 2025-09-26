import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await _cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'No cameras available';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Plant Layout'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showARInfo,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _buildARView(),
      floatingActionButton: _isCameraInitialized
          ? FloatingActionButton(
              onPressed: _captureARView,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomCard(
          backgroundColor: Colors.red.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Camera Error',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Retry',
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _initializeCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildARView() {
    return Stack(
      children: [
        // Camera Preview
        if (_isCameraInitialized)
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
        
        // AR Overlay Elements
        _buildAROverlay(),
        
        // Control Panel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildControlPanel(),
        ),
      ],
    );
  }

  Widget _buildAROverlay() {
    return Stack(
      children: [
        // Grid overlay for plant placement
        _buildGridOverlay(),
        
        // Virtual plant markers
        _buildPlantMarkers(),
        
        // Measurement tools
        _buildMeasurementTools(),
        
        // Information panel
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: _buildInfoPanel(),
        ),
      ],
    );
  }

  Widget _buildGridOverlay() {
    return CustomPaint(
      painter: GridPainter(),
      size: Size.infinite,
    );
  }

  Widget _buildPlantMarkers() {
    return Stack(
      children: [
        // Example plant markers - in a real AR app, these would be positioned based on AR tracking
        Positioned(
          top: 200,
          left: 100,
          child: _buildPlantMarker('Tomato', Colors.red, true),
        ),
        Positioned(
          top: 300,
          left: 200,
          child: _buildPlantMarker('Lettuce', Colors.green, false),
        ),
        Positioned(
          top: 250,
          left: 300,
          child: _buildPlantMarker('Carrot', Colors.orange, false),
        ),
      ],
    );
  }

  Widget _buildPlantMarker(String plantName, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectPlant(plantName),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.eco,
              color: Colors.white,
              size: 24,
            ),
            Text(
              plantName[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementTools() {
    return Positioned(
      top: 150,
      left: 50,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          '2.5m',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return CustomCard(
      backgroundColor: Colors.black.withOpacity(0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.view_in_ar, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'AR Plant Layout Viewer',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Point your camera at the ground to visualize plant placement',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                Icons.add_circle,
                'Add Plant',
                () => _showPlantSelector(),
              ),
              _buildControlButton(
                Icons.straighten,
                'Measure',
                () => _toggleMeasurement(),
              ),
              _buildControlButton(
                Icons.grid_on,
                'Grid',
                () => _toggleGrid(),
              ),
              _buildControlButton(
                Icons.settings,
                'Settings',
                () => _showARSettings(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Save Layout',
                  type: ButtonType.secondary,
                  onPressed: _saveLayout,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Share View',
                  onPressed: _shareARView,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _selectPlant(String plantName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: $plantName'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _captureARView() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AR view captured!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPlantSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Plant to Add',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildPlantOption('Tomato', Icons.eco, Colors.red),
                _buildPlantOption('Lettuce', Icons.eco, Colors.green),
                _buildPlantOption('Carrot', Icons.eco, Colors.orange),
                _buildPlantOption('Pepper', Icons.eco, Colors.yellow),
                _buildPlantOption('Cucumber', Icons.eco, Colors.lightGreen),
                _buildPlantOption('Herbs', Icons.eco, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantOption(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name added to AR view')),
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMeasurement() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Measurement mode toggled')),
    );
  }

  void _toggleGrid() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grid overlay toggled')),
    );
  }

  void _showARSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AR Settings'),
        content: const Text('AR settings will be available in the full version.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveLayout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Layout saved successfully!')),
    );
  }

  void _shareARView() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing AR view...')),
    );
  }

  void _showARInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AR Plant Layout'),
        content: const Text(
          'This AR feature allows you to visualize plant placement in your garden or farm. '
          'Point your camera at the ground and add virtual plants to plan your layout.\n\n'
          'Features:\n'
          '• Add virtual plants\n'
          '• Measure distances\n'
          '• Grid overlay for spacing\n'
          '• Save and share layouts',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    const gridSize = 50.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
