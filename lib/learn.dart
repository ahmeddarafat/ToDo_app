import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(Learn());
}

class Learn extends StatefulWidget {
  Learn({Key? key}) : super(key: key);

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  final _connectivity = Connectivity();
  final _connectivityChangeState = Connectivity().onConnectivityChanged;
  var result = ConnectivityResult.none;
  late StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _connectivityChangeState.listen((result) {
      this.result = result;
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Test"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 80.w,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.purple,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await _connectivity.checkConnectivity();
              if (result == ConnectivityResult.wifi) {
                print("wifi");
              } else if (result == ConnectivityResult.mobile) {
                print('mobile');
              } else if (result == ConnectivityResult.none) {
                print('none');
              } else {
                print('anything else');
              }

              if (this.result == ConnectivityResult.wifi) {
                print("wifi");
              } else if (this.result == ConnectivityResult.mobile) {
                print('mobile');
              } else if (this.result == ConnectivityResult.none) {
                print('none');
              } else {
                print('anything else');
              }
            },
          ),
        ),
      );
    });
  }
}

void func(int a, int b, int Function(int a, int b) operation) {
  print(operation(a, b));
}

int sum(int a, int b) {
  String? name = Person().name;
  int? age = Person.age;
  return a + b;
}

class Person {
  String? name;
  static int? age;

  Person({this.name});
}
