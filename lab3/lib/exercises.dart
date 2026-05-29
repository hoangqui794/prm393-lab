// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';

// ============================================================================
// BÀI TẬP 1 – Product Model & Repository (Mô hình Sản phẩm & Kho dữ liệu)
// Mục tiêu: Hiểu cách hoạt động của Future và Stream (bao gồm Broadcast Stream)
// ============================================================================

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  // Danh sách sản phẩm mẫu (giả lập lưu trong cơ sở dữ liệu)
  final List<Product> _products = [
    Product(id: 'P01', name: 'Tai nghe không dây Premium', price: 199.99),
    Product(id: 'P02', name: 'Bàn phím cơ Gaming', price: 129.50),
    Product(id: 'P03', name: 'Ghế công thái học Office', price: 349.00),
  ];

  // Khởi tạo StreamController dạng broadcast để cho phép nhiều thực thể cùng lắng nghe (listen)
  final StreamController<Product> _liveAddedController = StreamController<Product>.broadcast();

  // Trả về danh sách sản phẩm hiện tại sau một khoảng trễ giả lập mạng
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(seconds: 1)); // Trễ 1 giây giả lập mạng
    return List.unmodifiable(_products);
  }

  // Trả về stream các sản phẩm mới được thêm vào thời gian thực
  Stream<Product> liveAdded() => _liveAddedController.stream;

  // Thêm sản phẩm mới và phát ra (emit) thông qua stream
  void addProduct(Product product) {
    _products.add(product);
    _liveAddedController.add(product); // Phát sự kiện sản phẩm mới vào stream
  }

  // Đóng StreamController khi không dùng nữa để tránh rò rỉ bộ nhớ (memory leaks)
  void dispose() {
    _liveAddedController.close();
  }
}

// Hàm chạy demo Bài tập 1
Future<void> runExercise1() async {
  print('\n=== BÀI TẬP 1: PRODUCT MODEL & REPOSITORY ===');
  final repository = ProductRepository();

  // 1. Lắng nghe stream cập nhật thời gian thực trước khi thêm sản phẩm mới
  final subscription = repository.liveAdded().listen((product) {
    print('[Stream Live] Phát hiện sản phẩm mới được thêm: $product');
  });

  // 2. Lấy danh sách sản phẩm ban đầu thông qua Future
  print('Đang tải danh sách sản phẩm ban đầu...');
  final initialProducts = await repository.getAll();
  print('Danh sách sản phẩm ban đầu nhận được:');
  for (var product in initialProducts) {
    print(' - $product');
  }

  // 3. Giả lập thêm sản phẩm mới sau 500ms để quan sát Stream hoạt động
  await Future.delayed(const Duration(milliseconds: 500));
  print('Thêm sản phẩm mới: Chuột không dây Silent...');
  repository.addProduct(Product(id: 'P04', name: 'Chuột không dây Silent', price: 49.99));

  await Future.delayed(const Duration(milliseconds: 500));
  print('Thêm sản phẩm mới: Loa Bluetooth Mini...');
  repository.addProduct(Product(id: 'P05', name: 'Loa Bluetooth Mini', price: 79.00));

  // Chờ một chút trước khi kết thúc để nhận hết luồng stream
  await Future.delayed(const Duration(milliseconds: 500));
  await subscription.cancel();
  repository.dispose();
  print('=== BÀI TẬP 1 HOÀN THÀNH ===\n');
}


// ============================================================================
// BÀI TẬP 2 – User Repository with JSON (Xử lý và chuyển đổi dữ liệu JSON)
// Mục tiêu: Thực hành tuần tự hóa (serialization) và giải tuần tự hóa (deserialization) JSON
// ============================================================================

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor khởi tạo đối tượng User từ Map (JSON decoded)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  // Chuyển đối tượng User ngược lại thành Map JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  // Giả lập chuỗi JSON trả về từ API
  Future<String> fetchRawJsonFromApi() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Trễ 800ms giả lập kết nối mạng
    return '''
    [
      {"name": "Hoang Qui", "email": "qui.hoang@prm393.edu.vn"},
      {"name": "Nguyen Van A", "email": "nva@gmail.com"},
      {"name": "Tran Thi B", "email": "ttb@outlook.com"}
    ]
    ''';
  }

  // Tải dữ liệu JSON từ API và chuyển đổi sang danh sách đối tượng User
  Future<List<User>> fetchUsers() async {
    final rawJson = await fetchRawJsonFromApi();
    
    // Bước 1: Giải mã chuỗi JSON thành cấu trúc Dynamic List/Map
    final List<dynamic> decodedList = jsonDecode(rawJson) as List<dynamic>;
    
    // Bước 2: Chuyển đổi từng phần tử dạng Map thành đối tượng User thông qua User.fromJson
    return decodedList
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

// Hàm chạy demo Bài tập 2
Future<void> runExercise2() async {
  print('=== BÀI TẬP 2: USER REPOSITORY WITH JSON ===');
  final userRepository = UserRepository();

  print('Đang gửi yêu cầu tải dữ liệu JSON từ API giả lập...');
  try {
    final users = await userRepository.fetchUsers();
    print('Đã giải mã thành công dữ liệu JSON thành các đối tượng Dart:');
    for (var i = 0; i < users.length; i++) {
      print(' User ${i + 1}: ${users[i]}');
    }
  } catch (e) {
    print('Có lỗi xảy ra khi xử lý JSON: $e');
  }
  print('=== BÀI TẬP 2 HOÀN THÀNH ===\n');
}


// ============================================================================
// BÀI TẬP 3 – Async + Microtask Debugging (Gỡ lỗi Bất đồng bộ & Microtask)
// Mục tiêu: Hiểu rõ sự khác nhau giữa hàng đợi Microtask và Event Queue trong Event Loop của Dart
// ============================================================================

Future<void> runExercise3() async {
  print('=== BÀI TẬP 3: ASYNC + MICROTASK DEBUGGING ===');
  
  print('1. Khởi tạo mã đồng bộ (Synchronous Start)');

  // 1. Đưa một tác vụ vào Event Queue (Hàng đợi sự kiện chính)
  // Tác vụ này sẽ chỉ được chạy khi cả luồng đồng bộ và hàng đợi Microtask trống
  Future(() {
    print('4. Tác vụ Event Queue: Chạy callback của Future (Event Callback)');
  });

  // 2. Đưa một tác vụ vào Microtask Queue (Hàng đợi tác vụ nhỏ ưu tiên cao)
  // Tác vụ này sẽ chạy NGAY LẬP TỨC sau khi mã đồng bộ hiện tại kết thúc, trước khi Event Loop kiểm tra Event Queue
  scheduleMicrotask(() {
    print('3. Tác vụ Microtask Queue: Chạy callback của scheduleMicrotask');
  });

  print('2. Kết thúc mã đồng bộ (Synchronous End)');

  // Chờ một khoảng thời gian ngắn để đảm bảo tất cả các tác vụ bất đồng bộ được thực thi và in ra màn hình
  await Future.delayed(const Duration(milliseconds: 150));
  
  print('\n[Giải thích thứ tự thực thi]:');
  print(' - Bước 1 & 2: Chạy đồng bộ (Synchronous) trên Main Isolate nên in ra đầu tiên.');
  print(' - Bước 3 (Microtask): Chạy ngay sau khi luồng đồng bộ kết thúc vì hàng đợi Microtask có độ ưu tiên cao nhất.');
  print(' - Bước 4 (Future Event): Chạy cuối cùng sau khi hàng đợi Microtask đã được giải phóng hoàn toàn.');
  print('=== BÀI TẬP 3 HOÀN THÀNH ===\n');
}


// ============================================================================
// BÀI TẬP 4 – Stream Transformation (Biến đổi luồng dữ liệu)
// Mục tiêu: Sử dụng các toán tử hàm chức năng như map() và where() để thao tác luồng Stream
// ============================================================================

Future<void> runExercise4() async {
  print('=== BÀI TẬP 4: STREAM TRANSFORMATION ===');

  // 1. Tạo một Stream chứa các số tự nhiên từ 1 đến 5
  final originalStream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);

  // 2. Sử dụng map() để biến đổi luồng số: Bình phương từng giá trị (val => val * val)
  //    Sử dụng where() để lọc dữ liệu: Chỉ giữ lại các số chẵn (squared % 2 == 0)
  final transformedStream = originalStream
      .map((val) {
        final squared = val * val;
        print(' -> [map] Biến đổi: $val -> bình phương = $squared');
        return squared;
      })
      .where((squared) {
        final isEven = squared % 2 == 0;
        print(' -> [where] Lọc số chẵn: $squared -> ${isEven ? 'GIỮ LẠI' : 'BỎ QUA'}');
        return isEven;
      });

  // 3. Lắng nghe (listen) các sự kiện cuối cùng đi qua bộ lọc và in ra
  print('Bắt đầu lắng nghe kết quả cuối cùng từ transformedStream:');
  await for (final value in transformedStream) {
    print(' => [Listen] Nhận giá trị chẵn bình phương: $value');
  }

  print('=== BÀI TẬP 4 HOÀN THÀNH ===\n');
}


// ============================================================================
// BÀI TẬP 5 – Factory Constructors & Cache (Hàm khởi tạo Factory & Bộ nhớ đệm)
// Mục tiêu: Triển khai mẫu Singleton và cơ chế Caching bằng Factory Constructor
// ============================================================================

class Settings {
  final String appName;
  final String themeMode;

  // Thuộc tính tĩnh lưu giữ thực thể duy nhất (Singleton Instance / Cache)
  static Settings? _cache;

  // Hàm khởi tạo riêng tư (Private Constructor) với ký tự gạch dưới _
  // Ngăn chặn việc khởi tạo trực tiếp từ bên ngoài bằng Settings._internal()
  Settings._internal({required this.appName, required this.themeMode});

  // Factory Constructor: Chặn tiến trình tạo mới đối tượng.
  // Nếu _cache chưa tồn tại, tạo mới thực thể bằng private constructor và gán vào cache.
  // Nếu đã tồn tại, trả lại thực thể có sẵn trong cache thay vì tạo mới.
  factory Settings({String appName = 'PRM Lab 3', String themeMode = 'Dark'}) {
    _cache ??= Settings._internal(appName: appName, themeMode: themeMode);
    return _cache!;
  }
  
  @override
  String toString() => 'Settings(appName: $appName, themeMode: $themeMode, hashCode: $hashCode)';
}

Future<void> runExercise5() async {
  print('=== BÀI TẬP 5: FACTORY CONSTRUCTORS & CACHE ===');

  // Khởi tạo thực thể đầu tiên
  print('Khởi tạo instance A với cấu hình mặc định...');
  final settingsA = Settings();
  print(' -> Instance A: $settingsA');

  // Khởi tạo thực thể thứ hai (cố gắng truyền tham số mới)
  print('Cố gắng khởi tạo instance B với tham số mới (AppName = "New App", Theme = "Light")...');
  final settingsB = Settings(appName: 'New App', themeMode: 'Light');
  print(' -> Instance B: $settingsB');

  // Kiểm tra xem hai biến có cùng trỏ tới một vùng nhớ duy nhất hay không
  final isSame = identical(settingsA, settingsB);
  print('\nKiểm tra: identical(settingsA, settingsB) => $isSame');
  
  if (isSame) {
    print('KẾT LUẬN: Cả hai đối tượng là MỘT và DUY NHẤT. Thiết kế Singleton đã hoạt động thành công.');
    print('Dữ liệu của instance B vẫn là của instance A ("${settingsB.appName}") vì nó được lấy từ cache ra.');
  } else {
    print('KẾT LUẬN: Thất bại! Hai thực thể khác nhau.');
  }

  print('=== BÀI TẬP 5 HOÀN THÀNH ===\n');
}


// ============================================================================
// HÀM MAIN CHẠY TẤT CẢ CÁC BÀI TẬP DƯỚI DẠNG CLI
// ============================================================================
void main() async {
  print('================================================================');
  print('  BÀI THỰC HÀNH LAB 3 - CÁC TÍNH NĂNG DART NÂNG CAO (CLI RUNNER)');
  print('================================================================');

  await runExercise1();
  await runExercise2();
  await runExercise3();
  await runExercise4();
  await runExercise5();

  print('================================================================');
  print('  TẤT CẢ CÁC BÀI TẬP ĐÃ CHẠY HOÀN TẤT VÀ KHÔNG CÓ LỖI LẬP TRÌNH.');
  print('================================================================');
}
