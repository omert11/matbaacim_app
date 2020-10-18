import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FBApi {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser firebaseUser;

  FBApi(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<FBApi> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(authCredential)).user;

    /* final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ); */

    assert(user.email != null);
    assert(user.displayName != null);

    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return FBApi(user);
  }
  static String singOutGoogleAndFirebase(){
    _googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    return '/giris';
  }
  static Future<bool> singChecker()async{
    final FirebaseUser user = (await FirebaseAuth.instance.currentUser());
    if(user!=null){
      return true;
    }else{
      return false;
    }
  }
}