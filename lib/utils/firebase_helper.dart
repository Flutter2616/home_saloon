import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Firebasehelper {
  static Firebasehelper helper = Firebasehelper._();

  Firebasehelper._();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> manul_register(String email, String password) async {
    try
    {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      return "success";
    }
    catch(e)
    {
      return "$e";
    }
  }

  Future<String> manul_login(String email, String password) async {
    try
    {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    }
    catch(e)
    {
      return "$e";
    }
  }

  bool checkuser()
  {
    User? user=auth.currentUser;
    return user!=null;
  }


    Future<String> google_Signin() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      try
      {
          await auth.signInWithCredential(credential);
          return "success";
      }
      catch(e)
      {
        return "$e";
      }
    }


  Future<void> logout()
  async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }

  Map<String, String?> userdetail() {
    User? user = auth.currentUser;
    return {
      "name": user!.displayName,
      "email": user.email,
      "phone": user.phoneNumber,
      "uid": user.uid
    };
  }
}
