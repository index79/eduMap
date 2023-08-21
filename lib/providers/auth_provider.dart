import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduMap/services/kakao_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eduMap/constants/constants.dart';
import 'package:eduMap/models/models.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
    required this.firebaseFirestore,
  });

  String? getUserFirebaseId() {
    return prefs.getString(FirestoreConstants.id);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user as User;
      // crate a new document for the user with the uid
      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> handleSignIn(String provider) async {
    notify(Status.authenticating);
    dynamic user;
    AuthCredential? credential;
    User? firebaseUser;

    if (provider == 'google') {
      try {
        user = await googleSignIn.signIn();
        if (user == null) {
          notify(Status.authenticateCanceled);
          return false;
        }
        GoogleSignInAuthentication googleAuth = await user.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        firebaseUser =
            (await firebaseAuth.signInWithCredential(credential)).user;
      } catch (e) {
        notify(Status.authenticateCanceled);
        return false;
      }
    } else if (provider == 'kakao') {
      try {
        user = await KakaoService().signInWithKakao();
        if (user == null ||
            user.id == null ||
            user.kakaoAccount?.email == null) {
          notify(Status.authenticateCanceled);
          return false;
        }
        try {
          var kakao = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: user.kakaoAccount.email,
            password: user.id.toString(),
          );
          credential = new AuthCredential(
              providerId: user.id.toString(), signInMethod: "kakao");
          firebaseUser = kakao.user;
        } catch (e) {
          User authUser = await registerWithEmailAndPassword(
              user.kakaoAccount?.email, user.id.toString());
          credential = new AuthCredential(
              providerId: authUser.uid, signInMethod: 'kakao');
          firebaseUser = authUser;
        }
      } catch (e) {
        notify(Status.authenticateCanceled);
        return false;
      }
    } else {
      notify(Status.authenticateCanceled);
      return false;
    }

    if (firebaseUser != null) {
      final QuerySnapshot result = await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Writing data to server because here is a new user
        firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(firebaseUser.uid)
            .set({
          FirestoreConstants.nickname: firebaseUser.displayName,
          FirestoreConstants.photoUrl: firebaseUser.photoURL,
          FirestoreConstants.id: firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });

        // Write data to local storage
        User? currentUser = firebaseUser;
        await prefs.setString(FirestoreConstants.id, currentUser.uid);
        await prefs.setString(
            FirestoreConstants.nickname, currentUser.displayName ?? "");
        await prefs.setString(
            FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      } else {
        // Already sign up, just get data from firestore
        DocumentSnapshot documentSnapshot = documents[0];
        UserChat userChat = UserChat.fromDocument(documentSnapshot);
        // Write data to local
        await prefs.setString(FirestoreConstants.id, userChat.id);
        await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
        await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
        await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
      }
      notify(Status.authenticated);
      return true;
    } else {
      notify(Status.authenticateError);
      return false;
    }
  }

  void notify(Status staus) {
    _status = status;
    notifyListeners();
  }

  void handleException() {
    _status = Status.authenticateException;
    notifyListeners();
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
