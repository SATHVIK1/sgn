import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:sgnetflix/api/client.dart';
import 'package:sgnetflix/data/store.dart';

class AccountProvider extends ChangeNotifier {
  User? _current;
  User? get current => _current;

  Session? _session;
  Session? get session => _session;

  Future<Session?> get _cachedSession async {
    final cached = await Store.get("session");
    if (cached == null) return null;
    return Session.fromMap(json.decode(cached));
  }

  Future<bool> isValid() async {
    if (_session == null) {
      final cached = await _cachedSession;
      if (cached == null) return false;
      _session = cached;
    }
    return _session != null;
  }

  Future<void> register(String email, String password, String? name) async {
    try {
      final user = await ApiClient.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      _current = user;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to register: $e");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final result = await ApiClient.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      _session = result;
      Store.set("session", json.encode(result.toMap()));
      notifyListeners();
    } catch (e) {
      _session = null;
      throw Exception("Login failed: $e");
    }
  }

  Future<void> logout() async {
    try {
      await ApiClient.account.deleteSession(sessionId: 'current');
      _session = null;
      _current = null;
      await Store.remove("session");
      notifyListeners();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      final user = await ApiClient.account.get();
      _current = user;
      notifyListeners();
    } catch (_) {
      _current = null;
    }
  }
}
