class ApplicationModel {
  final String id;
  final String status;
  final String createdAt;

  // الحقول المعدلة حسب أسماء الأعمدة في Supabase
  final String? interviewDate;
  final String? interviewAddress; 
  final String? companyPhone;

  final String jobTitle;
  final String company;
  final String city;

  ApplicationModel({
    required this.id,
    required this.status,
    required this.createdAt,
    this.interviewDate,
    this.interviewAddress,
    this.companyPhone,
    required this.jobTitle,
    required this.company,
    required this.city,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> job = {};

    if (json['jobs'] is Map<String, dynamic>) {
      job = json['jobs'] as Map<String, dynamic>;
    } else if (json['jobs'] is List && (json['jobs'] as List).isNotEmpty) {
      job = (json['jobs'] as List).first as Map<String, dynamic>;
    }

    return ApplicationModel(
      id: json['id'].toString(),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
      
      // جلب القيم من الأسماء الموجودة فعلياً في جدولك
      interviewDate: json['interview_date']?.toString(),
      interviewAddress: json['interview_address']?.toString(),
      companyPhone: json['company_phone']?.toString(),
      
      jobTitle: job['title']?.toString() ?? '',
      company: job['company']?.toString() ?? '',
      city: job['city']?.toString() ?? '',
    );
  }
}