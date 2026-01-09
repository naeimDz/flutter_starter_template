import 'dart:io';
import 'package:flutter_starter_template/controllers/base_controller.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';
import 'package:flutter_starter_template/data/services/profile_service.dart';

/// Controller for profile management.
class ProfileController extends BaseController {
  final ProfileService _service;

  ProfileController({required ProfileService service}) : _service = service;

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> loadProfile() async {
    final result = await _service.getProfile();
    if (result.isSuccess && result.data != null) {
      _user = result.data;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({String? name, String? avatarUrl}) async {
    final result =
        await _service.updateProfile(name: name, avatarUrl: avatarUrl);

    if (result.isSuccess) {
      // Reload profile
      await loadProfile();
      return true;
    }
    return false;
  }

  Future<String?> uploadAvatar(File image) async {
    final result = await _service.uploadAvatar(image);
    return result.isSuccess ? result.data : null;
  }

  Future<bool> removeAvatar() async {
    final result = await _service.removeAvatar();
    if (result.isSuccess) {
      await loadProfile();
      return true;
    }
    return false;
  }
}
