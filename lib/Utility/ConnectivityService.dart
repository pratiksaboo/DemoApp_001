import 'dart:async';

import 'package:connectivity/connectivity.dart';


enum NetworkStatus { Online, Offline }

class NetworkStatusService {
  StreamController<NetworkStatus> networkStatusController =
  StreamController<NetworkStatus>();

  NetworkStatusService() {
    Connectivity().onConnectivityChanged.listen((status){
      networkStatusController.add(getNetworkStatus(status));
    });
  }

  NetworkStatus getNetworkStatus(ConnectivityResult status) {
    return status == ConnectivityResult.mobile || status == ConnectivityResult.wifi ? NetworkStatus.Online : NetworkStatus.Offline;
  }
}
