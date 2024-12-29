import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _chatsCollection = 'chats';

  Stream<List<Chat>> getChats() {
    return _firestore
        .collection(_chatsCollection)
        .orderBy('lastReceivedMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Chat(
          profileImageUrl: data['profileImageUrl'],
          userName: data['userName'],
          recentMessage: data['recentMessage'],
          unreadMessages: data['unreadMessages'],
          lastReceivedMessageTime: (data['lastReceivedMessageTime'] as Timestamp).toDate(),
          statusImages: List<String>.from(data['statusImages']),
        );
      }).toList();
    });
  }

  Future<void> createChat(Chat chat) async {
    await _firestore.collection(_chatsCollection).add({
      'profileImageUrl': chat.profileImageUrl,
      'userName': chat.userName,
      'recentMessage': chat.recentMessage,
      'unreadMessages': chat.unreadMessages,
      'lastReceivedMessageTime': Timestamp.fromDate(chat.lastReceivedMessageTime),
      'statusImages': chat.statusImages,
    });
  }
}
