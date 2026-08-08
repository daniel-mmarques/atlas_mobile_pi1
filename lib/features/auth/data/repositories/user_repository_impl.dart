import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  @override
  Future<void> createUserIfNotExists(String uid, String email) async {
    final doc = _users.doc(uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'uid': uid,
        'email': email,
        'name': null,
        'gender': null,
        'height': null,
        'weight': null,
        'birthDate': null,
        'activityLevel': null,
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    final snapshot = await _users.doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return AppUser.fromMap(uid, snapshot.data()!);
  }

  @override
  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return AppUser.fromMap(uid, snapshot.data()!);
    });
  }

  @override
  Future<void> completeProfile({
    required String uid,
    required String name,
    required DateTime birthDate,
    required Gender gender,
    required double height,
    required double weight,
    required ActivityLevel activityLevel,
  }) async {
    await _users.doc(uid).set(
      {
        'uid': uid,
        'name': name,
        'birthDate': Timestamp.fromDate(birthDate),
        'gender': gender.name,
        'height': height,
        'weight': weight,
        'activityLevel': activityLevel.name,
        'profileCompleted': true,
      },
      SetOptions(merge: true),
    );
  }
}
