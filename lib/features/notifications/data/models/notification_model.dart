class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      time: json['time'] ?? '',
      isUnread: json['is_unread'] ?? false,
    );
  }
}