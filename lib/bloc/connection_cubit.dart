import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionStatus { checking, connected, notConnected }

class ConnectionCubit extends Cubit<ConnectionStatus> {
  StreamSubscription? subscription;

  final Connectivity _connectivity = Connectivity();

  ConnectionCubit() : super(ConnectionStatus.checking) {
    initConnectivity();
    emit(ConnectionStatus.checking);
  }

  Future<void> initConnectivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        emit(ConnectionStatus.connected);
      } else {
        emit(ConnectionStatus.notConnected); 
      }
    });
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      emit(ConnectionStatus.notConnected);
    } else {
      emit(ConnectionStatus.connected);
    }
  }
}
