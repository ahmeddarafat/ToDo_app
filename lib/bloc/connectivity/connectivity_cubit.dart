import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial());

  static ConnectivityCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final _connectivity = Connectivity();
  bool? hasConnection;

  ///  the function I need to execute when run the app
  Future<void> initializeConnectivity() async{
    ///  to open stream subscription for connection change 
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    
    /// to just  check the connection when initailizeConnectivity methods called ( when app run) 
    /// not necessery 
    // _checkConnection(await _connectivity.checkConnectivity());   
  }

  void _connectionChange(ConnectivityResult result) {
    _checkConnection(result);
  }

  Future<bool?> _checkConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      hasConnection = false;
      _connectionChangeController(hasConnection!);

      return hasConnection;
    }

    try {
      /// to make sure that internet is active by test on site
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
        _connectionChangeController(hasConnection!);
      } else {
        if (hasConnection == null) {
          hasConnection = false;
          _connectionChangeController(hasConnection!);
        }
      }
    } on SocketException catch (_) {
      hasConnection = false;
      _connectionChangeController(hasConnection!);
    }

    return hasConnection;
  }

  void _connectionChangeController(bool _hasConnection) {
    if (_hasConnection) {
      emit(ConnectivityOnlineState());
    } else {
      emit(ConnectivityOfflineState());
    }
  }
}
