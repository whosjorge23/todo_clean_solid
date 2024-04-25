import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_clean_solid/models/todo.dart';

class SharedPreferenceService {
  Future<T?> getValue<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (T == String) {
        return prefs.getString(key) as T;
      }
      if (T == bool) {
        return prefs.getBool(key) as T;
      }
      if (T == ThemeMode) {
        String? themeModeString = prefs.getString(key);
        if (themeModeString != null) {
          // Convert the stored string back to a ThemeMode enum
          switch (themeModeString) {
            case 'system':
              return ThemeMode.system as T;
            case 'light':
              return ThemeMode.light as T;
            case 'dark':
              return ThemeMode.dark as T;
            default:
              return ThemeMode.system as T; // Default to system if unknown
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> setValue<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (value is String) {
        await prefs.setString(key, value);
      }
      if (value is bool) {
        await prefs.setBool(key, value);
      }
      if (value is ThemeMode) {
        // Convert ThemeMode to its string representation
        String themeModeString = _themeModeToString(value);
        await prefs.setString(key, themeModeString);
      }
    } catch (e) {
      return;
    }
    return;
  }

  Future<Map<String, dynamic>> getJSON(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final mapJSON = prefs.getString(key);
      return Map<String, dynamic>.from(jsonDecode(mapJSON ?? '{}'));
    } catch (e) {
      return {};
    }
  }

  Future<void> saveJSON(
    String key,
    Map<String, dynamic> map,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(map));
  }

  Future<void> removeValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove(key);
    } catch (e) {
      return;
    }
    return;
  }

  // Future<void> saveObjectsList(String key, List<Todo> todos) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> jsonList = todos.map((obj) => jsonEncode(obj.toJson())).toList();
  //   await prefs.setStringList(key, jsonList);
  // }
  //
  // Future<List<Todo>?> getObjectsList(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? jsonList = prefs.getStringList(key);
  //   if (jsonList != null) {
  //     return jsonList.map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr))).toList();
  //   }
  //   return null;
  // }

  String _themeModeToString(ThemeMode themeMode) {
    // Convert ThemeMode to a string representation
    switch (themeMode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system'; // Default to system if unknown
    }
  }
}
