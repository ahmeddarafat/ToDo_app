import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_todo_app/data/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Can Create Preferences', () async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool working = false;
    String name = 'john';
    pref.setBool('working', working);
    pref.setString('name', name);

    expect(pref.getBool('working'), false);
    expect(pref.getString('name'), 'john');
  });

  test('SharePref class is working', () async {
    await SharedPrefs.init();
    SharedPrefs.setBool(key: 'seen', value: true);
    bool? seen = SharedPrefs.getBool(key: 'seen');

    expect(seen, true);
  });

  /// remember to move it to its folder

  // test('anonymous is wroking', () async {
  //   WidgetsFlutterBinding.ensureInitialized();

  //   await Firebase.initializeApp();

  //   await FirebaseAuth.instance.signInAnonymously();

  //   var user = FirebaseAuth.instance.currentUser;

  //   expect(user!.isAnonymous, true);
  // });
}
