import 'package:flutter_attendace/data/models/response/auth_response_model.dart';
import 'package:flutter_attendace/data/models/response/user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', data.toJson());
  }

  Future<void> updateAuthData(UserResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    final authData = await getAuthData();
    if (authData != null) {
      final updatedData = authData.copyWith(user: data.user);
      await pref.setString('auth_data', updatedData.toJson());
    }
  }

  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('auth_data');
  }

  Future<AuthResponseModel?> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    if (data != null) {
      return AuthResponseModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<bool> isAuth() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    return data != null;
  }

  Future<void> removeTokenIfFriday() async {
    final pref = await SharedPreferences.getInstance();
    final authData = await getAuthData();
    if (authData != null) {
      final currentDate = DateTime.now();
      final formatter = DateFormat('EEEE');
      final currentDayOfWeek = formatter.format(currentDate);
      if (currentDayOfWeek == 'Friday') {
        await removeAuthData();
      }
    }
  }
}
