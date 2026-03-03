import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/emergency_service.dart';
import '../../../shared/widgets/glass_card.dart';

class PoliceDashboardScreen extends StatefulWidget {
  const PoliceDashboardScreen({super.key});

  @override
  State<PoliceDashboardScreen> createState() => _PoliceDashboardScreenState();
}

class _PoliceDashboardScreenState extends State<PoliceDashboardScreen> {
  final MapController _mapController = MapController();
  
  // Firestore references
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  int _selectedIndex = 0;
  int _activeCount = 0;
  int _acknowledgedCount = 0;
  int _resolvedTodayCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    // Load statistics from Firestore
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    
    // Get active count
    final activeSnapshot = await _firestore
        .collection('emergencies')
        .where('status', isEqualTo: 'active')
        .get();
    
    // Get acknowledged count
    final acknowledgedSnapshot = await _firestore
        .collection('emergencies')
        .where('status', isEqualTo: 'acknowledged')
        .get();
    
    // Get resolved today count
    final resolvedSnapshot = await _firestore
        .collection('emergencies')
        .where('status', isEqualTo: 'resolved')
        .where('resolvedAt', isGreaterThan: Timestamp.fromDate(todayStart))
        .get();
    
    if (mounted) {
      setState(() {
        _activeCount = activeSnapshot.docs.length;
        _acknowledgedCount = acknowledgedSnapshot.docs.length;
        _resolvedTodayCount = resolvedSnapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.cyan),
                    ),
                    child: const Icon(Icons.shield, color: AppColors.cyan),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Control Room',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('emergencies')
                              .where('status', whereIn: ['active', 'acknowledged'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            final count = snapshot.data?.docs.length ?? 0;
                            return Text(
                              '$count Active Emergencies',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.cyan,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _loadStats,
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => context.go('/'),
                  ),
                ],
              ),
            ),
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard('Active', _activeCount.toString(), AppColors.red, Icons.warning_amber),
                  const SizedBox(width: 12),
                  _buildStatCard('Acknowledged', _acknowledgedCount.toString(), AppColors.orange, Icons.check_circle_outline),
                  const SizedBox(width: 12),
                  _buildStatCard('Resolved Today', _resolvedTodayCount.toString(), AppColors.green, Icons.done_all),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Map with real-time emergencies
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('emergencies')
                          .where('status', whereIn: ['active', 'acknowledged'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(color: AppColors.cyan),
                          );
                        }
                        
                        final emergencies = snapshot.data!.docs;
                        
                        return FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: const LatLng(37.7749, -122.4194),
                            initialZoom: 13,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.zelda.app',
                            ),
                            MarkerLayer(
                              markers: emergencies.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final lat = data['latitude'] as double?;
                                final lng = data['longitude'] as double?;
                                final status = data['status'] as String?;
                                
                                if (lat == null || lng == null) {
                                  return Marker(
                                    point: const LatLng(0, 0),
                                    width: 0,
                                    height: 0,
                                    child: const SizedBox(),
                                  );
                                }
                                
                                return Marker(
                                  point: LatLng(lat, lng),
                                  width: 40,
                                  height: 40,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.go('/police/emergency', extra: data);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: status == 'acknowledged' 
                                            ? AppColors.orange 
                                            : AppColors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (status == 'acknowledged' 
                                                ? AppColors.orange 
                                                : AppColors.red).withValues(alpha: 0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        data['triggerType'] == 'voice' 
                                            ? Icons.mic 
                                            : Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Emergency List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Emergencies',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(color: AppColors.cyan),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('emergencies')
                    .where('status', whereIn: ['active', 'acknowledged'])
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.cyan),
                    );
                  }
                  
                  final emergencies = snapshot.data!.docs;
                  
                  if (emergencies.isEmpty) {
                    return const Center(
                      child: Text(
                        'No active emergencies',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: emergencies.length,
                    itemBuilder: (context, index) {
                      final doc = emergencies[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildEmergencyCard(data);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.navy,
        selectedItemColor: AppColors.cyan,
        unselectedItemColor: Colors.white.withValues(alpha: 0.5),
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            context.go('/police/live-map');
          }
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Live Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: GlassCard(
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> emergency) {
    final createdAt = emergency['createdAt'];
    String timeAgo = '';
    
    if (createdAt != null) {
      final date = (createdAt as Timestamp).toDate();
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) {
        timeAgo = '${diff.inMinutes} min ago';
      } else if (diff.inHours < 24) {
        timeAgo = '${diff.inHours} hours ago';
      } else {
        timeAgo = '${diff.inDays} days ago';
      }
    }
    
    return GestureDetector(
      onTap: () {
        context.go('/police/emergency', extra: emergency);
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.red.withValues(alpha: 0.3),
              AppColors.red.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.red.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    emergency['triggerType'] == 'voice' ? Icons.mic : Icons.touch_app,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    emergency['userName'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppColors.cyan),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: emergency['status'] == 'acknowledged' 
                        ? AppColors.orange 
                        : AppColors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    emergency['status']?.toString().toUpperCase() ?? 'ACTIVE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
