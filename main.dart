import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D2D2D),
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late String _currentTime;
  String _selectedLocation = '아라동';

  final List<Widget> _pages = [
    const HomePage(),
    const CommunityPage(),
    const NearbyPage(),
    const ChatPage(),
    const MyBamtolPage(),
  ];

  final List<String> _nearbyLocations = ['아라동', '홍제동', '평창동', '윤봉근로'];

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
    });
    Future.delayed(const Duration(seconds: 1), _updateTime);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF2D2D2D),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_4_bar,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.wifi, size: 18, color: Colors.grey[400]),
                      const SizedBox(width: 8),
                      Icon(Icons.battery_full, size: 20, color: Colors.green),
                      Text(
                        ' 100%',
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFF2D2D2D),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    onSelected: (String location) {
                      if (location == 'more') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapSelectionPage(
                              onLocationSelected: (selectedLocation) {
                                setState(() {
                                  _selectedLocation = selectedLocation;
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          _selectedLocation = location;
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        ..._nearbyLocations.map((location) {
                          return PopupMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'more',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.deepPurple,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text('더보기 (지도에서 선택)'),
                            ],
                          ),
                        ),
                      ];
                    },
                    child: Row(
                      children: [
                        Text(
                          _selectedLocation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[300],
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.grey[300],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.grey[300],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuPage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        color: Colors.grey[300],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2D2D2D),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: '동네 생활',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: '내 근처'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '나의 밤톨'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('홈 페이지'));
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('동네 생활'));
  }
}

class NearbyPage extends StatelessWidget {
  const NearbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('내 근처'));
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('채팅'));
  }
}

class MyBamtolPage extends StatelessWidget {
  const MyBamtolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('나의 밤톨'));
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D2D2D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFF3D3D3D),
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(child: Center(child: Text('검색 결과가 없습니다'))),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D2D2D),
      ),
      body: const Center(child: Text('메뉴')),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D2D2D),
      ),
      body: const Center(child: Text('알림이 없습니다.')),
    );
  }
}

class MapSelectionPage extends StatefulWidget {
  final Function(String) onLocationSelected;

  const MapSelectionPage({super.key, required this.onLocationSelected});

  @override
  State<MapSelectionPage> createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends State<MapSelectionPage> {
  String? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _allLocations = [
    '아라동',
    '홍제동',
    '평창동',
    '윤봉근로',
    '북아현동',
    '현저동',
    '혜화동',
    '명동',
    '을지로동',
    '태평로1가',
  ];

  List<String> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = _allLocations;
    _searchController.addListener(_filterLocations);
  }

  void _filterLocations() {
    setState(() {
      _filteredLocations = _allLocations
          .where((location) => location.contains(_searchController.text))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위치 선택'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D2D2D),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '위치를 검색하세요',
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Colors.deepPurple,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFF3D3D3D),
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    _filteredLocations[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  tileColor: _selectedLocation == _filteredLocations[index]
                      ? const Color(0xFF3D3D3D)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLocation = _filteredLocations[index];
                    });
                  },
                );
              },
            ),
          ),
          if (_selectedLocation != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    widget.onLocationSelected(_selectedLocation!);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '선택 완료',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
