class User {
  final String id;
  final String name;
  final String avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}



class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}


class Conversation {
  final String id;
  final String userName;
  final String userAvatar;
  List<Message> messages;

  Conversation({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.messages,
  });
}
