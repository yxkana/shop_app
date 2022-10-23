import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exceptions.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireTime;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expireTime != null &&
        _expireTime!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUP(String? email, String? password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDGAwhX3A2YH9qy28fFccvxHUucpQM4ayU");

    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
    } catch (error) {
      throw error;
    }
  }

  Future<void> loginUP(String? email, String? password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDGAwhX3A2YH9qy28fFccvxHUucpQM4ayU");

    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));

      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw ErrorDescription(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expireTime = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "idToken": _token,
        "userId": _userId,
        "expireTime": _expireTime?.toIso8601String()
      });
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expireTime = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpire = _expireTime?.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(
      const Duration(seconds: 600),
      () => logout(),
    );
  }

  Future<bool> tryAutoLogin() async {
    print("priiiiiintiiiing");
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    final expireDate = DateTime.parse(extractedData["expireTime"]);

    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData["idToken"];
    _userId = extractedData["userId"];
    _expireTime = expireDate;
    notifyListeners();
    autoLogout();
    print("55555555555555");
    return true;
  }
}
