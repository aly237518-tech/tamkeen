class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? city;
  final String? role;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.city,
    this.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      city: json['city'],
      role: json['role'],
    );
  }
}