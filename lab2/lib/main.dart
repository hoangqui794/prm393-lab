// LAB 2: DART ESSENTIALS PRACTICE LAB
// Student: Trương Hoàng Quí
// Subject: PRM393 - Mobile Programming

import 'dart:async';

void main() async {
  print("==================================================");
  print("        BẮT ĐẦU CHẠY BÀI THỰC HÀNH LAB 2         ");
  print("==================================================\n");

  // Chạy bài tập 1
  exercise1();

  // Chạy bài tập 2
  exercise2();

  // Chạy bài tập 3
  exercise3();

  // Chạy bài tập 4
  exercise4();

  // Chạy bài tập 5 (Được định nghĩa dạng async)
  await exercise5();

  print("==================================================");
  print("          HOÀN THÀNH BÀI THỰC HÀNH LAB 2          ");
  print("==================================================");
}

// ==========================================================
// EXERCISE 1: BASIC SYNTAX & DATA TYPES
// Mục tiêu: Làm quen với cấu trúc chương trình và khai báo biến
// ==========================================================
void exercise1() {
  print("--- BÀI TẬP 1: Cú pháp cơ bản & Các kiểu dữ liệu ---");
  
  // Khai báo các biến với các kiểu dữ liệu cơ bản trong Dart
  int age = 21;                             // Kiểu số nguyên (Integer)
  double gpa = 3.82;                         // Kiểu số thực (Double)
  String name = "Trương Hoàng Quí";          // Kiểu chuỗi ký tự (String)
  bool isStudent = true;                    // Kiểu logic (Boolean)

  // Sử dụng print() và String interpolation ($var, ${expr}) để hiển thị giá trị
  // - Dùng $name để in trực tiếp giá trị của biến name
  // - Dùng ${...} khi cần thực hiện phép tính toán hoặc gọi thuộc tính/phương thức trong chuỗi
  print("Họ và tên sinh viên: $name");
  print("Tuổi: $age");
  print("Điểm trung bình (GPA): $gpa");
  print("Trạng thái sinh viên: ${isStudent ? 'Đang đi học' : 'Đã tốt nghiệp'}");
  print("Năm sinh dự kiến (tính toán từ biểu thức): ${DateTime.now().year - age}");
  print(""); // Tạo khoảng trống giữa các bài tập
}

// ==========================================================
// EXERCISE 2: COLLECTIONS & OPERATORS
// Mục tiêu: Thao tác với List, Set, Map và các toán tử cơ bản
// ==========================================================
void exercise2() {
  print("--- BÀI TẬP 2: Collection & Các toán tử ---");
  
  // 1. Khai báo và sử dụng List (Mảng có thứ tự, cho phép trùng lặp)
  List<int> numbers = [10, 20, 30, 40, 50];
  print("List ban đầu: $numbers");

  // Sử dụng các toán tử số học (+) và so sánh (>)
  int sumOfFirstTwo = numbers[0] + numbers[1]; // Lấy phần tử index 0 cộng phần tử index 1
  bool isSumGreaterThan50 = sumOfFirstTwo > 50; // So sánh tổng với 50
  print("Tổng của 2 phần tử đầu tiên ($sumOfFirstTwo) > 50: $isSumGreaterThan50");

  // 2. Khai báo và sử dụng Set (Danh sách các giá trị duy nhất, không trùng lặp)
  // Mặc dù ta điền hai từ "Dart", Dart sẽ tự động loại bỏ giá trị trùng
  Set<String> categories = {"Flutter", "Dart", "Firebase", "Dart"};
  print("Set các danh mục (tự động loại bỏ trùng lặp): $categories");

  // Thêm phần tử mới vào Set
  categories.add("Android");
  // Xóa phần tử khỏi Set
  categories.remove("Firebase");
  print("Set sau khi thêm 'Android' và xóa 'Firebase': $categories");

  // 3. Khai báo và sử dụng Map (Cấu trúc cặp khóa - giá trị: Key - Value)
  Map<String, dynamic> courseInfo = {
    "courseName": "PRM393 - Lập trình di động",
    "studentsCount": 35,
    "isCompleted": false
  };
  print("Map thông tin môn học ban đầu: $courseInfo");

  // Truy cập giá trị qua Key bằng toán tử []
  print("Tên môn học lấy từ Map: ${courseInfo['courseName']}");

  // Chỉnh sửa giá trị của Key hiện có
  courseInfo['isCompleted'] = true;
  // Thêm một cặp Key - Value mới
  courseInfo['semester'] = "Summer 2026";
  print("Map sau khi cập nhật thông tin: $courseInfo");
  print("");
}

// ==========================================================
// EXERCISE 3: CONTROL FLOW & FUNCTIONS
// Mục tiêu: Sử dụng if/else, switch-case, vòng lặp và viết hàm
// ==========================================================

// Định nghĩa hàm sử dụng cú pháp thông thường (Normal Syntax)
double calculateAverageScore(double score1, double score2) {
  // Trả về trung bình cộng của 2 điểm số
  return (score1 + score2) / 2;
}

// Định nghĩa hàm sử dụng cú pháp rút gọn (Arrow Syntax)
String getGradeStatus(double score) => score >= 5.0 ? "ĐẠT" : "KHÔNG ĐẠT";

void exercise3() {
  print("--- BÀI TẬP 3: Cấu trúc điều khiển & Hàm ---");

  // 1. Khối lệnh if/else kiểm tra xếp loại điểm số
  double score = 7.8;
  print("Điểm số kiểm tra: $score");
  if (score >= 8.5) {
    print("Xếp loại học lực: Giỏi/Xuất sắc");
  } else if (score >= 7.0) {
    print("Xếp loại học lực: Khá");
  } else if (score >= 5.0) {
    print("Xếp loại học lực: Trung bình");
  } else {
    print("Xếp loại học lực: Yếu/Kém");
  }

  // 2. Khối lệnh switch-case cho ngày trong tuần
  int dayOfWeek = 2; // Quy định: 2 là Thứ hai, 3 là Thứ ba...
  print("Giá trị ngày trong tuần: $dayOfWeek");
  switch (dayOfWeek) {
    case 1:
      print("Kết quả switch: Hôm nay là Chủ Nhật");
      break;
    case 2:
      print("Kết quả switch: Hôm nay là Thứ Hai");
      break;
    case 3:
      print("Kết quả switch: Hôm nay là Thứ Ba");
      break;
    default:
      print("Kết quả switch: Ngày trong tuần (Thứ Tư đến Thứ Bảy)");
  }

  // 3. Vòng lặp qua Collection (List) sử dụng: for truyền thống, for-in và forEach
  List<String> frameworkList = ["Flutter", "React Native", "Native Android"];
  print("Duyệt List frameworkList:");

  // A. Vòng lặp for truyền thống
  print("  a. Sử dụng vòng lặp for truyền thống:");
  for (int i = 0; i < frameworkList.length; i++) {
    print("     - Vị trí $i: ${frameworkList[i]}");
  }

  // B. Vòng lặp for-in
  print("  b. Sử dụng vòng lặp for-in:");
  for (String framework in frameworkList) {
    print("     - Tên framework: $framework");
  }

  // C. Vòng lặp forEach
  print("  c. Sử dụng phương thức forEach():");
  frameworkList.forEach((framework) {
    print("     - forEach: $framework");
  });

  // 4. Kiểm tra các hàm tự định nghĩa
  double finalScore = calculateAverageScore(7.5, 8.5);
  print("Điểm trung bình (Tính bằng hàm Normal): $finalScore");
  print("Trạng thái học lực (Tính bằng hàm Arrow): ${getGradeStatus(finalScore)}");
  print("");
}

// ==========================================================
// EXERCISE 4: INTRO TO OOP
// Mục tiêu: Định nghĩa lớp, constructor, kế thừa và ghi đè phương thức
// ==========================================================

// Lớp cơ sở (Base Class) đại diện cho Xe Hơi
class Car {
  // Thuộc tính (Properties)
  String brand;
  int year;

  // Constructor mặc định (Default Constructor) sử dụng cú pháp viết nhanh của Dart
  Car(this.brand, this.year);

  // Named Constructor (Constructor có tên) dùng cho trường hợp khởi tạo đặc biệt
  Car.anonymous()
      : brand = "Chưa xác định",
        year = 2026;

  // Phương thức hiển thị thông tin
  void showDetails() {
    print("Thông tin xe: Thương hiệu: $brand | Năm sản xuất: $year");
  }
}

// Lớp con ElectricCar kế thừa từ Car sử dụng từ khóa extends
class ElectricCar extends Car {
  double batteryCapacity; // Dung lượng pin (kWh)

  // Constructor của lớp con phải gọi và chuyển thông tin cho Constructor lớp cha thông qua ': super(...)'
  ElectricCar(String brand, int year, this.batteryCapacity) : super(brand, year);

  // Ghi đè phương thức (Method Overriding) của lớp cha để bổ sung thông tin pin xe điện
  @override
  void showDetails() {
    print("Thông tin xe điện: Thương hiệu: $brand | Năm sản xuất: $year | Dung lượng pin: ${batteryCapacity} kWh");
  }
}

void exercise4() {
  print("--- BÀI TẬP 4: Lập trình hướng đối tượng (OOP) ---");

  // Khởi tạo đối tượng từ Car sử dụng Default Constructor
  Car normalCar = Car("Toyota Corolla", 2021);
  normalCar.showDetails();

  // Khởi tạo đối tượng từ Car sử dụng Named Constructor
  Car unknownCar = Car.anonymous();
  unknownCar.showDetails();

  // Khởi tạo đối tượng từ ElectricCar (Kế thừa từ Car)
  ElectricCar electricCar = ElectricCar("Tesla Model Y", 2025, 82.0);
  electricCar.showDetails(); // Gọi phương thức đã được override
  print("");
}

// ==========================================================
// EXERCISE 5: ASYNC, FUTURE, NULL SAFETY & STREAMS
// Mục tiêu: Viết hàm bất đồng bộ, thao tác với null safety và luồng dữ liệu (Stream)
// ==========================================================

// Hàm bất đồng bộ (Asynchronous Function) sử dụng Future và await
Future<String> simulateNetworkRequest() async {
  print("   [Async] Bắt đầu gọi API tải dữ liệu...");
  // Sử dụng Future.delayed để dừng tiến trình trong 2 giây (giả lập tải mạng)
  await Future.delayed(Duration(seconds: 2));
  return "   [Async] Kết quả tải: Dữ liệu tải từ API thành công!";
}

// Hàm sinh Stream (Luồng dữ liệu phát ra nhiều giá trị theo thời gian)
// Sử dụng async* và từ khóa yield để gửi các giá trị vào luồng
Stream<int> integerStream(int count) async* {
  for (int i = 1; i <= count; i++) {
    await Future.delayed(Duration(seconds: 1)); // Nghỉ 1 giây trước khi phát giá trị tiếp theo
    yield i; // Đẩy giá trị i vào Stream
  }
}

Future<void> exercise5() async {
  print("--- BÀI TẬP 5: Bất đồng bộ (Async/Await), Null Safety & Stream ---");

  // 1. Thực hành tính năng Null Safety trong Dart
  String? username; // Biến kiểu String có thể chứa giá trị null nhờ dấu ?
  print("Giá trị biến username hiện tại: $username");

  // Sử dụng toán tử điều kiện rút gọn ?? (Null-coalescing operator)
  // Nếu username là null thì lấy giá trị mặc định là "Tài khoản mặc định"
  String activeUser = username ?? "Tài khoản mặc định";
  print("Biến activeUser (sau khi dùng toán tử ??): $activeUser");

  // Gán giá trị khác null cho username
  username = "hoangqui794";
  
  // Sử dụng toán tử check null an toàn ?. để truy cập thuộc tính mà không sợ lỗi Crash nếu biến null
  print("Độ dài của username (dùng ?.): ${username?.length}");

  // Sử dụng toán tử null assertion ! để khẳng định chắc chắn biến không thể null với compiler
  print("Độ dài của username (dùng khẳng định !): ${username!.length}");

  // 2. Chạy hàm bất đồng bộ Future kết hợp await
  print("Bắt đầu gọi hàm bất đồng bộ (giả lập 2 giây chờ):");
  String networkData = await simulateNetworkRequest();
  print("Dữ liệu nhận về từ Future: $networkData");

  // 3. Thực hành Stream (Lắng nghe các luồng dữ liệu)
  print("Bắt đầu lắng nghe dữ liệu phát ra từ Stream (3 giá trị, mỗi giây 1 số):");
  Stream<int> myStream = integerStream(3);
  
  // Sử dụng cú pháp 'await for' để lắng nghe tuần tự các giá trị phát ra từ Stream
  await for (int number in myStream) {
    print("   [Stream] Đã nhận số: $number");
  }
  print("Kết thúc việc nhận dữ liệu từ Stream.");
  print("");
}
