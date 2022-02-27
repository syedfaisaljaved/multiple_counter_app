import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FireStoreUtils {

  //singleton static
  FireStoreUtils._privateConstructor();

  static final FireStoreUtils instance = FireStoreUtils._privateConstructor();

  static const String _counters = "counters";

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> init() async {
    DocumentReference docRef = await userDeviceRef;
    if(!(await docRef.get()).exists){
      await docRef.set({
        "counter1": 0,
        "counter2": 0,
        "counter3": 0,
      });
    }
  }

  CollectionReference get countersCollection {
    return FirebaseFirestore.instance.collection(_counters);
  }

  Future<DocumentReference<Object?>> get userDeviceRef async {
    return countersCollection.doc(await _getUniqueId());
  }

  Future<String?> _getUniqueId() async {
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      debugPrint("not found");
    }
    return "-";
  }


}