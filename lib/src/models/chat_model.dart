class Chat {
  final String profileImageUrl;
  final String userName;
  final String recentMessage;
  final int unreadMessages;
  final DateTime lastReceivedMessageTime;
  final List<String> statusImages;

  Chat({
    required this.profileImageUrl,
    required this.userName,
    required this.recentMessage,
    this.unreadMessages = 0,
    required this.lastReceivedMessageTime,
    required this.statusImages,
  });
}
