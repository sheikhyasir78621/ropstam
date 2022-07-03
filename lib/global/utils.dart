import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:ropstam/global/constants.dart';
import 'package:ropstam/models/posts.dart';

class DataUtil {
  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Login(username, password) async {
    String? deviceId = await getId();
    print(username.toString());
    Map mappedData = {
      'email': username,
      'password': password,
      'device_token': deviceId.toString(),
    };

    final response = await http.post(Uri.parse(loginApiUrl), body: mappedData);
    final jsonData = jsonDecode(response.body);

    return jsonData;
  }

  static List<Posts> posts = [];
  static Future<List<Posts>> fetchPostsList() async {
    try {
      http.Response response = await http.get(Uri.parse(postsApiUrl));

      print(response.body.toString());
      final jsonData = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        posts =
            List.from(jsonData).map<Posts>((e) => Posts.fromJson(e)).toList();
      }

      return posts;
    } catch (e) {
      rethrow;
    }
  }
}
