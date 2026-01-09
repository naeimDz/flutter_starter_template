import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_starter_template/controllers/profile_controller.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/di/service_locator.dart';
import 'package:flutter_starter_template/core/utils/validators.dart';
import 'package:flutter_starter_template/shared/helpers/snackbar_helper.dart';
import 'package:flutter_starter_template/shared/widgets/app_text_field.dart';
import 'package:flutter_starter_template/shared/widgets/custom_button.dart';

/// Profile Edit Screen with avatar upload.
class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  late final ProfileController _controller;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _controller = sl<ProfileController>();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _controller.loadProfile();
    if (_controller.user != null) {
      _nameController.text = _controller.user!.name ?? '';
      _emailController.text = _controller.user!.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading && _controller.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSizes.spacing24),

                  // Avatar Section
                  _buildAvatarSection(),

                  const SizedBox(height: AppSizes.spacing32),

                  // Name Field
                  AppTextField(
                    controller: _nameController,
                    label: 'Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: Validators.compose([
                      Validators.required(message: 'Name is required'),
                      Validators.minLength(2,
                          message: 'Name must be at least 2 characters'),
                    ]),
                  ),

                  const SizedBox(height: AppSizes.spacing16),

                  // Email Field (Read-only)
                  AppTextField(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    enabled: false,
                    hint: 'Email cannot be changed',
                  ),

                  const SizedBox(height: AppSizes.spacing32),

                  // Save Button
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: _handleSave,
                    isLoading: _controller.isLoading || _isUploading,
                  ),

                  const SizedBox(height: AppSizes.spacing16),

                  // Cancel Button
                  CustomButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    type: ButtonType.outline,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection() {
    final currentAvatarUrl = _controller.user?.avatarUrl;
    final hasAvatar = _selectedImage != null || currentAvatarUrl != null;

    return Column(
      children: [
        // Avatar Display
        GestureDetector(
          onTap: _showImageSourceOptions,
          child: Hero(
            tag: 'user_avatar',
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : currentAvatarUrl != null
                            ? Image.network(
                                currentAvatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildAvatarPlaceholder(),
                              )
                            : _buildAvatarPlaceholder(),
                  ),
                ),
                // Edit Badge
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSizes.spacing16),

        // Change/Remove Avatar Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _showImageSourceOptions,
              icon: const Icon(Icons.photo_camera),
              label: Text(_selectedImage != null || currentAvatarUrl != null
                  ? 'Change Photo'
                  : 'Add Photo'),
            ),
            if (hasAvatar) ...[
              const SizedBox(width: AppSizes.spacing8),
              TextButton.icon(
                onPressed: _handleRemoveAvatar,
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                label: Text(
                  'Remove',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Center(
      child: Text(
        _controller.user?.initials ?? '?',
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showSnackbar(
          context,
          message: 'Failed to pick image: $e',
          isError: true,
        );
      }
    }
  }

  void _handleRemoveAvatar() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String? avatarUrl;

    // Upload avatar if changed
    if (_selectedImage != null) {
      setState(() => _isUploading = true);

      avatarUrl = await _controller.uploadAvatar(_selectedImage!);

      setState(() => _isUploading = false);

      if (avatarUrl == null) {
        if (mounted) {
          SnackbarHelper.showSnackbar(
            context,
            message: _controller.errorMessage ?? 'Failed to upload avatar',
            isError: true,
          );
        }
        return;
      }
    }

    // Update profile
    final success = await _controller.updateProfile(
      name: _nameController.text.trim(),
      avatarUrl: avatarUrl,
    );

    if (mounted) {
      if (success) {
        SnackbarHelper.showSnackbar(
          context,
          message: 'Profile updated successfully',
        );
        Navigator.of(context).pop();
      } else {
        SnackbarHelper.showSnackbar(
          context,
          message: _controller.errorMessage ?? 'Failed to update profile',
          isError: true,
        );
      }
    }
  }
}
