class JobModel {
  final String id;
  final String title;
  final String company;
  final String city;
  final String description;

  final String salary;
  final String employmentType;
  final String experience;
  final String category;
  final String imageUrl;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.city,
    required this.description,
    required this.salary,
    required this.employmentType,
    required this.experience,
    required this.category,
    required this.imageUrl,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      city: json['city'] ?? '',
      description: json['description'] ?? '',
      salary: json['salary'] ?? '',
      employmentType: json['employment_type'] ?? '',
      experience: json['experience'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}