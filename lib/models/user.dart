class UserModels {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  String password; // ملاحظة: عادة لا نخزن كلمات المرور بشكل مباشر

  UserModels({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  // تحويل المستخدم إلى Map لتخزينه في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      // لا نقوم بتضمين كلمة المرور هنا لأسباب أمنية
    };
  }

  // إنشاء مستخدم من Map (مثلاً عند استرجاع البيانات من قاعدة البيانات)
  factory UserModels.fromMap(Map<String, dynamic> map) {
    return UserModels(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      password: '', // لا نسترجع كلمة المرور من قاعدة البيانات
    );
  }

  // نسخة من المستخدم مع إمكانية تحديث بعض الحقول
  UserModels copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
  }) {
    return UserModels(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }
}