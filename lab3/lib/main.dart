// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'exercises.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Dart Lab 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF06040A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A2BE2),
          brightness: Brightness.dark,
          primary: const Color(0xFF8A2BE2),
          secondary: const Color(0xFF00F2FE),
          surface: const Color(0xFF0F0C1B),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Color(0xFFE2E0EC)),
        ),
      ),
      home: const DashboardHome(),
    );
  }
}

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedTab = 0;
  final List<String> _consoleLogs = [];
  final ScrollController _consoleScrollController = ScrollController();
  
  // Repositories
  late ProductRepository _productRepository;
  late UserRepository _userRepository;
  
  // Ex 1 state
  List<Product> _currentProducts = [];
  final List<Product> _liveAddedProducts = [];
  StreamSubscription<Product>? _liveAddedSubscription;
  bool _isLoadingProducts = false;
  
  // Ex 2 state
  List<User> _parsedUsers = [];
  bool _isParsingJson = false;
  
  // Ex 3 state
  final List<Map<String, dynamic>> _loopSteps = [];
  bool _isRunningLoopSim = false;
  int _currentStepIndex = -1;

  // Ex 4 state
  final List<int> _originalNumbers = [];
  final List<int> _mappedNumbers = [];
  final List<int> _filteredNumbers = [];
  bool _isRunningStreamSim = false;
  int _streamProcessingIndex = -1; // -1: stop, 0: original, 1: map, 2: where

  // Ex 5 state
  Settings? _settingsA;
  Settings? _settingsB;
  final TextEditingController _settingsANameCtrl = TextEditingController(text: 'Hệ Thống Lab 3');
  final TextEditingController _settingsBNameCtrl = TextEditingController(text: 'Cấu Hình Mới');

  // Sidebar hover state helper
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepository();
    _userRepository = UserRepository();
    
    // Listen to real-time additions (Ex 1)
    _liveAddedSubscription = _productRepository.liveAdded().listen((product) {
      setState(() {
        _liveAddedProducts.insert(0, product);
      });
      _addLog('⭐ [LIVE STREAM] Phát hiện sản phẩm mới được phát sóng: ${product.name} (Giá: \$${product.price})');
    });

    _addLog('🚀 Hệ thống FPT Advanced Dart Lab 3 khởi chạy thành công.');
  }

  @override
  void dispose() {
    _liveAddedSubscription?.cancel();
    _productRepository.dispose();
    _consoleScrollController.dispose();
    _settingsANameCtrl.dispose();
    _settingsBNameCtrl.dispose();
    super.dispose();
  }

  void _addLog(String text) {
    final time = DateTime.now().toString().substring(11, 19);
    setState(() {
      _consoleLogs.add('[$time] $text');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_consoleScrollController.hasClients) {
        _consoleScrollController.animateTo(
          _consoleScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearLogs() {
    setState(() {
      _consoleLogs.clear();
    });
  }

  // CLI runner integration
  Future<void> _runAllCliExercises() async {
    _clearLogs();
    _addLog('⚡ BẮT ĐẦU CHẠY TOÀN BỘ 5 BÀI TẬP (GIẢ LẬP DÒNG LỆNH)');
    
    // Ex 1
    _addLog('▶️ [Bài 1] Đang khởi tạo ProductRepository...');
    final repo1 = ProductRepository();
    final sub = repo1.liveAdded().listen((p) {
      _addLog('   ↳ [Live Stream] Đã bắt được sản phẩm mới: $p');
    });
    final products = await repo1.getAll();
    _addLog('   ↳ [Future] Lấy thành công ${products.length} sản phẩm.');
    repo1.addProduct(Product(id: 'P04', name: 'Chuột không dây Silent', price: 49.99));
    repo1.addProduct(Product(id: 'P05', name: 'Loa Bluetooth Mini', price: 79.00));
    await Future.delayed(const Duration(milliseconds: 200));
    await sub.cancel();
    repo1.dispose();

    // Ex 2
    _addLog('▶️ [Bài 2] Gọi UserRepository.fetchUsers()...');
    final repo2 = UserRepository();
    final users = await repo2.fetchUsers();
    _addLog('   ↳ [JSON Parsed] Đã giải mã thành công ${users.length} người dùng.');
    for (var u in users) {
      _addLog('     - $u');
    }

    // Ex 3
    _addLog('▶️ [Bài 3] Bắt đầu debug Async + Microtask...');
    _addLog('   1. Main start (Đồng bộ)');
    Future(() {
      _addLog('   4. Future callback (Event Queue)');
    });
    scheduleMicrotask(() {
      _addLog('   3. Microtask callback (Microtask Queue)');
    });
    _addLog('   2. Main end (Đồng bộ)');
    await Future.delayed(const Duration(milliseconds: 200));

    // Ex 4
    _addLog('▶️ [Bài 4] Bắt đầu biến đổi Stream...');
    final originalStream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
    final transformedStream = originalStream
        .map((val) => val * val)
        .where((squared) => squared % 2 == 0);
    await for (final value in transformedStream) {
      _addLog('   ↳ [Listen Stream] Nhận được giá trị: $value');
    }

    // Ex 5
    _addLog('▶️ [Bài 5] Kiểm chứng Factory Constructor...');
    final settings1 = Settings();
    final settings2 = Settings(appName: 'New App', themeMode: 'Light');
    final isSame = identical(settings1, settings2);
    _addLog('   ↳ Instance A: $settings1');
    _addLog('   ↳ Instance B: $settings2');
    _addLog('   ↳ identical(settings1, settings2) => $isSame');

    _addLog('✅ CHẠY HOÀN TẤT CẢ 5 BÀI TẬP CLI.');
  }

  // Interactive functions
  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });
    _addLog('📥 [Bài 1] Đang gửi yêu cầu Future<List<Product>>...');
    final list = await _productRepository.getAll();
    setState(() {
      _currentProducts = list;
      _isLoadingProducts = false;
    });
    _addLog('📥 [Bài 1] Future hoàn thành. Nhận về ${list.length} sản phẩm.');
  }

  void _addNewProduct(String name, double price) {
    if (name.isEmpty) return;
    final newId = 'P0${_currentProducts.length + 1}';
    final product = Product(id: newId, name: name, price: price);
    _addNewProductInteractive(name, price);
    setState(() {
      if (!_currentProducts.any((p) => p.name == name)) {
        _currentProducts = [..._currentProducts, product];
      }
    });
  }

  void _addNewProductInteractive(String name, double price) {
    final product = Product(id: 'P${DateTime.now().millisecond}', name: name, price: price);
    _productRepository.addProduct(product);
  }

  Future<void> _parseJson() async {
    setState(() {
      _isParsingJson = true;
      _parsedUsers = [];
    });
    _addLog('🌐 [Bài 2] Đang fetch JSON từ API giả lập...');
    final users = await _userRepository.fetchUsers();
    setState(() {
      _parsedUsers = users;
      _isParsingJson = false;
    });
    _addLog('🌐 [Bài 2] Đã chuyển đổi chuỗi JSON thành List<User> thành công.');
  }

  Future<void> _runEventLoopDemo() async {
    if (_isRunningLoopSim) return;
    setState(() {
      _isRunningLoopSim = true;
      _loopSteps.clear();
      _currentStepIndex = -1;
    });

    _addLog('🌀 [Bài 3] Khởi chạy mô phỏng Event Loop...');

    // Step 1: Main Start
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _loopSteps.add({'type': 'sync', 'text': '1. Đồng bộ: Bắt đầu hàm main()'});
      _currentStepIndex = 0;
    });
    _addLog('↳ 1. Đồng bộ: Bắt đầu hàm main()');

    // Queue Future
    Future(() {
      setState(() {
        _loopSteps.add({'type': 'event', 'text': '4. Event Queue: Future callback thực thi'});
        _currentStepIndex = _loopSteps.length - 1;
      });
      _addLog('↳ 4. Event Queue: Future callback thực thi');
    });

    // Queue Microtask
    scheduleMicrotask(() {
      setState(() {
        _loopSteps.add({'type': 'microtask', 'text': '3. Microtask Queue: scheduleMicrotask thực thi'});
        _currentStepIndex = _loopSteps.length - 1;
      });
      _addLog('↳ 3. Microtask Queue: scheduleMicrotask thực thi');
    });

    // Step 2: Main End
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _loopSteps.add({'type': 'sync', 'text': '2. Đồng bộ: Kết thúc hàm main()'});
      _currentStepIndex = _loopSteps.length - 1;
    });
    _addLog('↳ 2. Đồng bộ: Kết thúc hàm main()');

    // Chờ microtask chạy
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Chờ event chạy
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _isRunningLoopSim = false;
      _currentStepIndex = -1;
    });
    _addLog('🌀 [Bài 3] Kết thúc mô phỏng Event Loop.');
  }

  Future<void> _runStreamSimulation() async {
    if (_isRunningStreamSim) return;
    setState(() {
      _isRunningStreamSim = true;
      _originalNumbers.clear();
      _mappedNumbers.clear();
      _filteredNumbers.clear();
      _streamProcessingIndex = -1;
    });

    _addLog('🌊 [Bài 4] Bắt đầu đẩy luồng Stream...');
    final list = [1, 2, 3, 4, 5];

    for (var n in list) {
      // 1. Send original
      setState(() {
        _streamProcessingIndex = 0;
        _originalNumbers.add(n);
      });
      _addLog('↳ Stream phát ra: $n');
      await Future.delayed(const Duration(milliseconds: 500));

      // 2. Map transformation
      final squared = n * n;
      setState(() {
        _streamProcessingIndex = 1;
        _mappedNumbers.add(squared);
      });
      _addLog('   ↳ map(): Bình phương $n ➔ $squared');
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Where filter
      setState(() {
        _streamProcessingIndex = 2;
      });
      if (squared % 2 == 0) {
        setState(() {
          _filteredNumbers.add(squared);
        });
        _addLog('      ↳ where(): Lọc chẵn ➔ GIỮ LẠI ($squared)');
      } else {
        _addLog('      ↳ where(): Lọc chẵn ➔ LOẠI BỎ ($squared)');
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      _isRunningStreamSim = false;
      _streamProcessingIndex = -1;
    });
    _addLog('🌊 [Bài 4] Dừng luồng Stream.');
  }

  void _runSingletonDemo() {
    setState(() {
      _settingsA = Settings(appName: _settingsANameCtrl.text.trim(), themeMode: 'Dark');
      _settingsB = Settings(appName: _settingsBNameCtrl.text.trim(), themeMode: 'Light');
    });
    _addLog('⚙️ [Bài 5] Khởi tạo Instance A với tên "${_settingsANameCtrl.text}"');
    _addLog('⚙️ [Bài 5] Khởi tạo Instance B với tên "${_settingsBNameCtrl.text}"');
    _addLog('⚙️ [Bài 5] So sánh vùng nhớ: identical(A, B) => ${identical(_settingsA, _settingsB)}');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 750;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              child: Container(
                color: const Color(0xFF0A0713),
                child: _buildSidebar(isDrawer: true),
              ),
            )
          : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: const Color(0xFF0A0713),
              elevation: 0,
              title: const Text(
                'DART.PRO',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF00F2FE)),
                  onPressed: _runAllCliExercises,
                  tooltip: 'Chạy CLI',
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          // CUSTOM GLASS SIDEBAR (Only persistent on desktop)
          if (!isMobile) _buildSidebar(isDrawer: false),
          
          // MAIN PANEL
          Expanded(
            child: Container(
              color: const Color(0xFF08060D),
              child: Stack(
                children: [
                  // Decorative Background Glows
                  Positioned(
                    top: -100,
                    right: -100,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7F00FF).withOpacity(0.12),
                            blurRadius: 120,
                            spreadRadius: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: 100,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F2FE).withOpacity(0.08),
                            blurRadius: 100,
                            spreadRadius: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: isMobile
                        ? const EdgeInsets.all(12.0)
                        : const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Bar (Only on desktop, mobile has AppBar)
                        if (!isMobile) ...[
                          _buildHeaderBar(),
                          const SizedBox(height: 20),
                        ],
                        
                        // Workspace Section
                        Expanded(
                          child: isMobile
                              ? Column(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: _buildSelectedTabContent(isMobile),
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      flex: 4,
                                      child: _buildTerminalMonitor(),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Interactive Sandbox (Left side)
                                    Expanded(
                                      flex: 8,
                                      child: _buildSelectedTabContent(false),
                                    ),
                                    const SizedBox(width: 20),
                                    // Live Terminal Monitor (Right side)
                                    Expanded(
                                      flex: 5,
                                      child: _buildTerminalMonitor(),
                                    ),
                                  ],
                                ),
                        ),
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

  // --- HEADER BAR ---
  Widget _buildHeaderBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DART ADVANCED LAB 3',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'FPT University • PRM393 Active Session',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
        
        // Premium CLI Run Action Button
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _runAllCliExercises,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7F00FF).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Chạy Toàn Bộ CLI',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- CUSTOM GLASS SIDEBAR ---
  Widget _buildSidebar({bool isDrawer = false}) {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.space_dashboard_rounded, 'label': 'Trang chủ'},
      {'icon': Icons.shopping_bag_rounded, 'label': 'Bài 1: Stream'},
      {'icon': Icons.code_rounded, 'label': 'Bài 2: JSON'},
      {'icon': Icons.query_builder_rounded, 'label': 'Bài 3: Loop'},
      {'icon': Icons.waves_rounded, 'label': 'Bài 4: Flow'},
      {'icon': Icons.fingerprint_rounded, 'label': 'Bài 5: Cache'},
    ];

    return Container(
      width: isDrawer ? null : 220,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0713),
        border: isDrawer
            ? null
            : const Border(
                right: BorderSide(color: Color(0xFF201633), width: 1.5),
              ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Logo & Branding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7F00FF).withOpacity(0.15),
                  border: Border.all(color: const Color(0xFF7F00FF).withOpacity(0.4), width: 1),
                ),
                child: const Icon(Icons.blur_on_rounded, color: Color(0xFF00F2FE), size: 24),
              ),
              const SizedBox(width: 10),
              const Text(
                'DART.PRO',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          
          // Sidebar menu items
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = _selectedTab == index;
                final isHovered = _hoveredIndex == index;
                
                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = -1),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF7F00FF).withOpacity(0.15) 
                            : isHovered 
                                ? Colors.white.withOpacity(0.04) 
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFF7F00FF).withOpacity(0.4) 
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: 18,
                            color: isSelected 
                                ? const Color(0xFF00F2FE) 
                                : const Color(0xFF8F8A9F),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : const Color(0xFF8F8A9F),
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF00F2FE),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Version footer
          Text(
            'Version 3.10.7',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }

  // --- GLASS CARD WIDGET ---
  Widget _buildGlassCard({required Widget child, Color? borderColor}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF110D20).withOpacity(0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? const Color(0xFF281C3F),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: child,
          ),
        ),
      ),
    );
  }

  // --- SELECTION TAB DISPATCHER ---
  Widget _buildSelectedTabContent(bool isMobile) {
    switch (_selectedTab) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildProductTab();
      case 2:
        return _buildJsonTab();
      case 3:
        return _buildEventLoopTab(isMobile);
      case 4:
        return _buildStreamFlowTab();
      case 5:
        return _buildSingletonTab();
      default:
        return _buildHomeTab();
    }
  }

  // --- TAB 0: HOME / INTRO ---
  Widget _buildHomeTab() {
    return _buildGlassCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00F2FE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF00F2FE), size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Lab 3 - Dart Practice Portal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Hệ thống tương tác cao cấp chứng minh 5 khái niệm cốt lõi trong ngôn ngữ Dart nâng cao.',
              style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFF2C1D4D), thickness: 1.2),
            const SizedBox(height: 16),
            
            _buildConceptRow(
              num: '1',
              title: 'Product Repository & Stream Broadcast',
              desc: 'Tải dữ liệu bằng Future. Triển khai phát dữ liệu thời gian thực cho nhiều người nghe sử dụng StreamController.broadcast().',
              color: const Color(0xFF9D4EDD),
            ),
            _buildConceptRow(
              num: '2',
              title: 'JSON Deserialization',
              desc: 'Mô phỏng chuỗi thô JSON từ API, chuyển hóa trực tiếp sang các cấu trúc Model User sử dụng hàm khởi tạo Factory.',
              color: const Color(0xFF00F2FE),
            ),
            _buildConceptRow(
              num: '3',
              title: 'Event Loop & Microtask Priority',
              desc: 'Đánh giá chi tiết thứ tự chạy giữa mã đồng bộ, hàng đợi Microtask và Event Queue (Future).',
              color: const Color(0xFFFF007F),
            ),
            _buildConceptRow(
              num: '4',
              title: 'Functional Stream Transformation',
              desc: 'Thực thi biến đổi luồng số học thông qua map() (lũy thừa) và lọc dữ liệu điều kiện bằng where().',
              color: const Color(0xFF39FF14),
            ),
            _buildConceptRow(
              num: '5',
              title: 'Factory Constructor Singleton Cache',
              desc: 'Cơ chế lưu trữ bộ nhớ đệm (caching) để trả lại cùng một thực thể vùng nhớ (Singleton) tối ưu tài nguyên.',
              color: const Color(0xFFFFB703),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptRow({required String num, required String title, required String desc, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.4), width: 1),
            ),
            child: Center(
              child: Text(
                num,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12, height: 1.3),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- TAB 1: PRODUCT STREAM REPOSITORY ---
  Widget _buildProductTab() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();

    return Column(
      children: [
        // Load products widget
        Expanded(
          flex: 4,
          child: _buildGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.download_done_rounded, color: Color(0xFF00F2FE), size: 18),
                        SizedBox(width: 8),
                        Text('Tải Danh Sách (Future.getAll)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _isLoadingProducts ? null : _loadProducts,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7F00FF).withOpacity(0.2),
                            border: Border.all(color: const Color(0xFF7F00FF).withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _isLoadingProducts
                              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Gọi API Repository', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD4A373))),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _currentProducts.isEmpty
                      ? Center(
                          child: Text(
                            'Chưa tải dữ liệu. Bấm "Gọi API Repository" để lấy.',
                            style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _currentProducts.length,
                          itemBuilder: (context, index) {
                            final p = _currentProducts[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withOpacity(0.04)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7F00FF).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF7F00FF), size: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text('ID: ${p.id}', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                  Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 12),

        // Live stream inputs & listener
        Expanded(
          flex: 5,
          child: _buildGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.sensors_rounded, color: Colors.greenAccent, size: 18),
                    SizedBox(width: 8),
                    Text('Stream Real-time (liveAdded)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: nameCtrl,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Tên SP mới...',
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2C1D4D))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF7F00FF))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Giá (\$)...',
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2C1D4D))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF7F00FF))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          final name = nameCtrl.text.trim();
                          final price = double.tryParse(priceCtrl.text) ?? 0.0;
                          if (name.isNotEmpty && price > 0.0) {
                            _addNewProduct(name, price);
                            nameCtrl.clear();
                            priceCtrl.clear();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00F2FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Phát Live', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Luồng nhận thời gian thực:', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Expanded(
                  child: _liveAddedProducts.isEmpty
                      ? Center(child: Text('Chưa có sản phẩm nào phát đi.', style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 11)))
                      : ListView.builder(
                          itemCount: _liveAddedProducts.length,
                          itemBuilder: (context, index) {
                            final p = _liveAddedProducts[index];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.04),
                                border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.flash_on, color: Colors.greenAccent, size: 14),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.greenAccent))),
                                  Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- TAB 2: JSON DESERIALIZATION ---
  Widget _buildJsonTab() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.javascript_rounded, color: Color(0xFF00F2FE), size: 20),
                  SizedBox(width: 8),
                  Text('Giải Mã Chuỗi JSON Thô', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _isParsingJson ? null : _parseJson,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00F2FE).withOpacity(0.15),
                      border: Border.all(color: const Color(0xFF00F2FE).withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Tải & Giải Mã', style: TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          
          // JSON Code editor simulator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF05030B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF281C3F)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('API Raw Response (JSON):', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                  '''[
  {"name": "Hoang Qui", "email": "qui.hoang@prm393.edu.vn"},
  {"name": "Nguyen Van A", "email": "nva@gmail.com"},
  {"name": "Tran Thi B", "email": "ttb@outlook.com"}
]''',
                  style: TextStyle(fontFamily: 'monospace', color: Colors.greenAccent, fontSize: 11, height: 1.4),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          const Text('Danh sách đối tượng Dart (User Model):', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          
          Expanded(
            child: _isParsingJson
                ? const Center(child: CircularProgressIndicator())
                : _parsedUsers.isEmpty
                    ? Center(
                        child: Text(
                          'Chưa giải mã. Nhấp "Tải & Giải Mã".',
                          style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _parsedUsers.length,
                        itemBuilder: (context, index) {
                          final u = _parsedUsers[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E193C).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withOpacity(0.03)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFF7F00FF).withOpacity(0.2),
                                  child: Text(u.name.substring(0, 1).toUpperCase(), style: const TextStyle(color: Color(0xFF00F2FE), fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                                      Text(u.email, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                                  ),
                                  child: const Text('Model parsed', style: TextStyle(color: Colors.blueAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: EVENT LOOP QUEUE VISUALIZER ---
  Widget _buildEventLoopTab(bool isMobile) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.query_builder_rounded, color: Color(0xFFFF007F), size: 20),
                  SizedBox(width: 8),
                  Text('Event Loop & Microtask Priority', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _isRunningLoopSim ? null : _runEventLoopDemo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF007F).withOpacity(0.15),
                      border: Border.all(color: const Color(0xFFFF007F).withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Chạy Sim', style: TextStyle(color: Color(0xFFFF007F), fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          
          // Queues Display Grid
          Expanded(
            child: isMobile
                ? Column(
                    children: [
                      // Queues indicators stacked
                      _buildQueueIndicator('1. Đồng bộ (Sync)', _currentStepIndex == 0 || _currentStepIndex == 3, const Color(0xFF00F2FE)),
                      const SizedBox(height: 4),
                      _buildQueueIndicator('2. Microtask (Ưu tiên)', _currentStepIndex == 2, const Color(0xFFFFB703)),
                      const SizedBox(height: 4),
                      _buildQueueIndicator('3. Event (Future)', _currentStepIndex == 1, const Color(0xFFFF007F)),
                      const SizedBox(height: 8),
                      
                      // Chronological steps output
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF05030B),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF281C3F)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Màn hình Console output:', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Expanded(
                                child: _loopSteps.isEmpty
                                    ? Center(child: Text('Bấm "Chạy Sim" để xem.', style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic, fontSize: 10)))
                                    : ListView.builder(
                                        itemCount: _loopSteps.length,
                                        itemBuilder: (context, index) {
                                          final step = _loopSteps[index];
                                          final isLast = index == _loopSteps.length - 1;
                                          Color c = Colors.white;
                                          if (step['type'] == 'sync') c = const Color(0xFF00F2FE);
                                          if (step['type'] == 'microtask') c = const Color(0xFFFFB703);
                                          if (step['type'] == 'event') c = const Color(0xFFFF007F);
                                          
                                          return Container(
                                            margin: const EdgeInsets.symmetric(vertical: 2),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: c.withOpacity(0.04),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: c.withOpacity(isLast ? 0.3 : 0.08)),
                                            ),
                                            child: Text(
                                              step['text'] as String,
                                              style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Row(
                    children: [
                      // Queues side-by-side
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQueueIndicator('1. Hàng đợi đồng bộ (Sync)', _currentStepIndex == 0 || _currentStepIndex == 3, const Color(0xFF00F2FE)),
                            _buildQueueIndicator('2. Hàng đợi Microtask (Priority)', _currentStepIndex == 2, const Color(0xFFFFB703)),
                            _buildQueueIndicator('3. Hàng đợi Event Queue (Future)', _currentStepIndex == 1, const Color(0xFFFF007F)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Chronological steps output
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF05030B),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF281C3F)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Thứ tự xuất kết quả màn hình:', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _loopSteps.isEmpty
                                    ? Center(child: Text('Click "Chạy Simulation" để bắt đầu.', style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic, fontSize: 11)))
                                    : ListView.builder(
                                        itemCount: _loopSteps.length,
                                        itemBuilder: (context, index) {
                                          final step = _loopSteps[index];
                                          final isLast = index == _loopSteps.length - 1;
                                          Color c = Colors.white;
                                          if (step['type'] == 'sync') c = const Color(0xFF00F2FE);
                                          if (step['type'] == 'microtask') c = const Color(0xFFFFB703);
                                          if (step['type'] == 'event') c = const Color(0xFFFF007F);
                                          
                                          return AnimatedOpacity(
                                            opacity: 1.0,
                                            duration: const Duration(milliseconds: 350),
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(vertical: 3),
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: c.withOpacity(0.04),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: c.withOpacity(isLast ? 0.3 : 0.08)),
                                              ),
                                              child: Text(
                                                step['text'] as String,
                                                style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueIndicator(String name, bool isActive, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.12) : const Color(0xFF1E193C).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? color : const Color(0xFF281C3F),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)] : [],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : Colors.grey[700],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: STREAM FLOW PIPELINE ---
  Widget _buildStreamFlowTab() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.waves_rounded, color: Color(0xFF39FF14), size: 20),
                  SizedBox(width: 8),
                  Text('Biến đổi luồng dữ liệu Stream', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _isRunningStreamSim ? null : _runStreamSimulation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF39FF14).withOpacity(0.15),
                      border: Border.all(color: const Color(0xFF39FF14).withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Phát luồng', style: TextStyle(color: Color(0xFF39FF14), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFlowStage(
                  title: '1. Nguồn phát Stream (1 - 5)',
                  dataList: _originalNumbers,
                  isActive: _streamProcessingIndex == 0,
                  accentColor: const Color(0xFF00F2FE),
                ),
                const Icon(Icons.arrow_downward_rounded, color: Color(0xFF7F00FF), size: 18),
                _buildFlowStage(
                  title: '2. map(): Bình phương (x * x)',
                  dataList: _mappedNumbers,
                  isActive: _streamProcessingIndex == 1,
                  accentColor: const Color(0xFF7F00FF),
                ),
                const Icon(Icons.arrow_downward_rounded, color: Color(0xFF7F00FF), size: 18),
                _buildFlowStage(
                  title: '3. where(): Lọc số chẵn',
                  dataList: _filteredNumbers,
                  isActive: _streamProcessingIndex == 2,
                  accentColor: const Color(0xFF39FF14),
                  isFilter: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFlowStage({
    required String title,
    required List<int> dataList,
    required bool isActive,
    required Color accentColor,
    bool isFilter = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? accentColor.withOpacity(0.06) : const Color(0xFF16122C).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? accentColor : const Color(0xFF281C3F), width: isActive ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: isActive ? accentColor : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final originalVal = index + 1;
              final valSquared = originalVal * originalVal;
              
              bool hasVal = false;
              String textStr = '';

              if (title.contains('1.')) {
                hasVal = dataList.contains(originalVal);
                textStr = '$originalVal';
              } else {
                hasVal = dataList.contains(valSquared);
                textStr = '$valSquared';
              }

              bool showCanceled = isFilter && !hasVal && _mappedNumbers.contains(valSquared);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: hasVal 
                      ? accentColor.withOpacity(0.2) 
                      : showCanceled 
                          ? Colors.red.withOpacity(0.12)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasVal 
                        ? accentColor 
                        : showCanceled 
                            ? Colors.red
                            : const Color(0xFF281C3F),
                    width: hasVal ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    showCanceled ? '✗' : textStr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: hasVal 
                          ? accentColor 
                          : showCanceled 
                              ? Colors.red 
                              : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  // --- TAB 5: SINGLETON CACHE ---
  Widget _buildSingletonTab() {
    return _buildGlassCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fingerprint_rounded, color: Color(0xFFFFB703), size: 20),
                SizedBox(width: 8),
                Text('Kiểm Thử Singleton & Cache', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 16),
            
            // AppName settings A
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Instance A AppName:', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _settingsANameCtrl,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Instance B AppName:', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _settingsBNameCtrl,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 16),
            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _runSingletonDemo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB703),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Khởi Tạo & So Sánh', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            if (_settingsA != null && _settingsB != null) ...[
              // Object addresses representation
              _buildMemoryBox('Instance A', _settingsA!),
              const SizedBox(height: 8),
              _buildMemoryBox('Instance B', _settingsB!),
              const SizedBox(height: 16),
              
              // Singleton result banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.06),
                  border: Border.all(color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'identical(Instance_A, Instance_B) ➔ TRUE',
                          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Cơ chế cache của Factory Constructor chặn việc tạo đối tượng mới và trả lại vùng nhớ cũ. Tên thật của B vẫn giữ nguyên là "${_settingsB?.appName}".',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.3),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryBox(String title, Settings settings) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF00F2FE))),
              Text('appName: ${settings.appName} | theme: ${settings.themeMode}', style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
          Text(
            'Hash: 0x${settings.hashCode.toRadixString(16).toUpperCase()}',
            style: const TextStyle(fontFamily: 'monospace', color: Color(0xFFFFB703), fontSize: 10, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  // --- TERMINAL CONSOLE LOG MONITOR ---
  Widget _buildTerminalMonitor() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF040209),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF24153E),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal Header bar
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.yellowAccent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.terminal_rounded, color: Colors.greenAccent, size: 14),
              const SizedBox(width: 6),
              const Text(
                'fpt-console@prm393',
                style: TextStyle(fontFamily: 'monospace', color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _clearLogs,
                  child: const Icon(Icons.delete_sweep_rounded, color: Colors.grey, size: 16),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF1E1035), thickness: 1.2),
          const SizedBox(height: 6),
          
          // Terminal logs list
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _consoleLogs.isEmpty
                  ? Center(child: Text('Chưa có logs ghi nhận...', style: TextStyle(color: Colors.grey[700], fontFamily: 'monospace', fontSize: 11)))
                  : ListView.builder(
                      controller: _consoleScrollController,
                      itemCount: _consoleLogs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            _consoleLogs[index],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10.5,
                              color: Color(0xFFC7F9CC),
                              height: 1.3,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
