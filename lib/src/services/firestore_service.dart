import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Chat>> getUserChats() {
    final currentUserId = _auth.currentUser?.uid;
    
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastReceivedMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final chats = <Chat>[];
          
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final otherUserId = (data['participants'] as List)
                .firstWhere((id) => id != currentUserId);
                
            // Check if user is blocked
            final currentUserDoc = await _firestore
                .collection('users')
                .doc(currentUserId)
                .get();
                
            final blockedUsers = List<String>.from(
                currentUserDoc.data()?['blockedUsers'] ?? []);
                
            if (!blockedUsers.contains(otherUserId)) {
              chats.add(Chat(
                profileImageUrl: data['profileImageUrl'],
                userName: data['userName'],
                recentMessage: data['recentMessage'],
                unreadMessages: data['unreadMessages'],
                lastReceivedMessageTime: 
                    (data['lastReceivedMessageTime'] as Timestamp).toDate(),
                statusImages: List<String>.from(data['statusImages']),
              ));
            }
          }
          return chats;
    });
  }

  Future<void> createNewChat(String otherUserId, String initialMessage) async {
    final currentUserId = _auth.currentUser?.uid;
    final chatDoc = _firestore.collection('chats').doc();
    
    final otherUserDoc = await _firestore.collection('users').doc(otherUserId).get();
    final otherUserData = otherUserDoc.data();

    await chatDoc.set({
      'participants': [currentUserId, otherUserId],
      'profileImageUrl': otherUserData?['profileImageUrl'],
      'userName': otherUserData?['userName'],
      'recentMessage': initialMessage,
      'unreadMessages': 1,
      'lastReceivedMessageTime': Timestamp.now(),
      'statusImages': [],
    });
  }

  Future<void> deleteChat(String chatId) async {
    // Delete chat document
    await _firestore.collection('chats').doc(chatId).delete();
    
    // Delete associated messages
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();
        
    for (var message in messages.docs) {
      await message.reference.delete();
    }
  }

  Future<void> editMessage(String chatId, String messageId, String newContent) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'content': newContent,
      'editedAt': Timestamp.now(),
      'isEdited': true,
    });
  }

}