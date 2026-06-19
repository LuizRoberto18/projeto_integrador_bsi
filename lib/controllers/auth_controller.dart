import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  bool get isLoggedIn => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    // Listen to Firebase auth state changes
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      currentUser.value = null;
    } else {
      await _loadUserData(firebaseUser.uid);
    }
  }

  Future<void> _loadUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      currentUser.value = UserModel.fromFirestore(doc);
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapAuthError(e.code);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? disability,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = UserModel(
        id: cred.user!.uid,
        name: name,
        email: email,
        disability: disability,
        memberSince: DateTime.now(),
      );
      await _db.collection('users').doc(cred.user!.uid).set(user.toFirestore());
      currentUser.value = user;
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _mapAuthError(e.code);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      final uid = cred.user!.uid;

      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) {
        final user = UserModel(
          id: uid,
          name: googleUser.displayName ?? '',
          email: googleUser.email,
          memberSince: DateTime.now(),
        );
        await _db.collection('users').doc(uid).set(user.toFirestore());
        currentUser.value = user;
      }
      return true;
    } catch (e) {
      errorMessage.value = 'Erro ao entrar com Google.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
        return 'E-mail ou senha inválidos.';
      case 'email-already-in-use':
        return 'Este e-mail já está em uso.';
      case 'weak-password':
        return 'Senha muito fraca. Mínimo 6 caracteres.';
      case 'invalid-email':
        return 'E-mail inválido.';
      default:
        return 'Ocorreu um erro. Tente novamente.';
    }
  }
}
