class Conversation {
  final int id;
  final String name;

  Conversation({
    required this.id,
    required this.name,
  });

  factory Conversation.fromJson(
    Map<String, dynamic> json,
    int myUserId,
  ) {
    final members = json['members'];

    String otherName = 'مستخدم';

    if (members is List) {
      for (final m in members) {
        final userId = m['user_id'];
        final user = m['user'];

        if (userId != myUserId && user is Map) {
          otherName = user['email']
              ?? user['name']
              ?? user['username']
              ?? 'مستخدم';
          break;
        }
      }
    }

    return Conversation(
      id: json['id'],
      name: otherName,
    );
  }
}
