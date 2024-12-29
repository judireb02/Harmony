import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<void> blockUser(String blockedUserId) async {
    final currentUserId = _auth.currentUser?.uid;
    await _firestore.collection('users').doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayUnion([blockedUserId])
    });
  }

  Future<void> unblockUser(String blockedUserId) async {
    final currentUserId = _auth.currentUser?.uid;
    await _firestore.collection('users').doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayRemove([blockedUserId])
    });
  }

  Future<void> reportUser(String reportedUserId, String reason) async {
    await _firestore.collection('reports').add({
      'reportedUserId': reportedUserId,
      'reportedBy': _auth.currentUser?.uid,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending'
    });
  }
}
