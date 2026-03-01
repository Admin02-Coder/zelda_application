import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();
  
  // Sample emergency data
  final List<Map<String, dynamic>> _activeEmergencies = [
    {'id': '1', 'name': 'John Doe', 'lat': 37.7749, 'lng': -122.4194, 'time': '2 min ago', 'type': 'voice'},
    {'id': '2', 'name': 'Jane Smith', 'lat': 37.7849, 'lng': -122.4094, 'time': '5 min ago', 'type': 'manual'},
    {'id': '3', 'name': 'Mike Johnson', 'lat': 37.7649, 'lng': -122.4294, 'time': '8 min ago', 'type': 'manual'},
    {'id': '4', 'name': 'Sarah Williams', 'lat': 37.7949, 'lng': -122.4394, 'time': '12 min ago', 'type': 'voice'},
    {'id': '5', 'name': 'David Brown', 'lat': 37.7549, 'lng': -122.4494, 'time': '15 min ago', 'type': 'manual'},
  ];

  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Live Map',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() => _selectedFilter = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Emergencies')),
              const PopupMenuItem(value: 'voice', child: Text('Voice Trigger')),
              const PopupMenuItem(value: 'manual', child: Text('Manual Trigger')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('All', 'all', _activeEmergencies.length),
                const SizedBox(width: 8),
                _buildFilterChip('Voice', 'voice', _activeEmergencies.where((e) => e['type'] == 'voice').length),
                const SizedBox(width: 8),
                _buildFilterChip('Manual', 'manual', _activeEmergencies.where((e) => e['type'] == 'manual').length),
              ],
            ),
          ),
          // Map
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: const LatLng(37.7749, -122.4194),
                      initialZoom: 12,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.zelda.app',
                      ),
                      MarkerLayer(
                        markers: _getFilteredEmergencies().map((emergency) {
                          return Marker(
                            point: LatLng(emergency['lat'], emergency['lng']),
                            width: 50,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/emergency-details',
                                  arguments: emergency,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: emergency['type'] == 'voice' ? AppColors.red : AppColors.orange,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (emergency['type'] == 'voice' ? AppColors.red : AppColors.orange).withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  emergency['type'] == 'voice' ? Icons.mic : Icons.touch_app,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Emergency List
          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedFilter == 'all' 
                          ? 'All Emergencies (${_activeEmergencies.length})'
                          : '${_selectedFilter == 'voice' ? 'Voice' : 'Manual'} Emergencies (${_getFilteredEmergencies().length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View Details',
                        style: TextStyle(color: AppColors.cyan),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _getFilteredEmergencies().length,
                    itemBuilder: (context, index) {
                      final emergency = _getFilteredEmergencies()[index];
                      return _buildEmergencyListItem(emergency);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyan.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.cyan : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Text(
              '$label ',
              style: TextStyle(
                color: isSelected ? AppColors.cyan : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.cyan : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? AppColors.navy : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredEmergencies() {
    if (_selectedFilter == 'all') return _activeEmergencies;
    return _activeEmergencies.where((e) => e['type'] == _selectedFilter).toList();
  }

  Widget _buildEmergencyListItem(Map<String, dynamic> emergency) {
    return GestureDetector(
      onTap: () {
        _mapController.move(
          LatLng(emergency['lat'], emergency['lng']),
          15,
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  emergency['type'] == 'voice' ? Icons.mic : Icons.touch_app,
                  color: emergency['type'] == 'voice' ? AppColors.red : AppColors.orange,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    emergency['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: AppColors.cyan),
                const SizedBox(width: 4),
                Text(
                  emergency['time'],
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to locate',
              style: TextStyle(
                color: AppColors.cyan.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
