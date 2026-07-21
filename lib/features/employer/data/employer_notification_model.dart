class EmployerNotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  EmployerNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });

  factory EmployerNotificationModel.fromJson(Map<String, dynamic> json) {
    return EmployerNotificationModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      time: json['time'] ?? '',
      isUnread: json['is_unread'] ?? false,
    );
  }
}