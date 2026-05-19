import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/core/widgets/audience_badge.dart';
import 'package:hciiii/core/widgets/primary_button.dart';
import 'package:hciiii/features/stories/data/story_repository.dart';
import 'package:hciiii/features/stories/domain/story.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  XFile? _selectedImage;
  Uint8List? _previewBytes;
  StoryAudience? _audience;
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _selectedImage = picked;
      _previewBytes = bytes;
      _audience = null;
    });
  }

  Future<void> _selectAudience() async {
    final audience = await showModalBottomSheet<StoryAudience>(
      context: context,
      builder: (context) => const _AudienceSheet(),
    );
    if (audience != null) {
      setState(() => _audience = audience);
    }
  }

  Future<void> _postStory() async {
    if (_selectedImage == null || _audience == null) return;

    setState(() => _isUploading = true);
    final repo = ref.read(storyRepositoryProvider);
    try {
      await repo.uploadStory(_selectedImage!, _audience!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Story posted')),
        );
        setState(() {
          _selectedImage = null;
          _previewBytes = null;
          _audience = null;
          _isUploading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $error')),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = _selectedImage != null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              const _CameraTopBar(),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.1,
                    ),
                  ),
                  child: hasImage && _previewBytes != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.memory(
                                _previewBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            if (_audience != null)
                              Positioned(
                                left: 16,
                                top: 16,
                                child: AudienceBadge(
                                  label: _audience!.label,
                                ),
                              ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.camera_alt, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                'Ready to snap',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Capture or upload a story',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              _CaptureRow(
                onCapture: () => _pickImage(ImageSource.camera),
                onGallery: () => _pickImage(ImageSource.gallery),
              ),
              if (hasImage) ...[
                const SizedBox(height: 16),
                _AudiencePanel(
                  audience: _audience,
                  onSelect: _selectAudience,
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: _isUploading ? 'Posting...' : 'Post story',
                  icon: Icons.send,
                  onPressed: _isUploading ? null : _postStory,
                  fullWidth: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraTopBar extends StatelessWidget {
  const _CameraTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.flash_on),
          tooltip: 'Flash',
        ),
        const Spacer(),
        Text(
          'Camera',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
          tooltip: 'Camera settings',
        ),
      ],
    );
  }
}

class _CaptureRow extends StatelessWidget {
  const _CaptureRow({required this.onCapture, required this.onGallery});

  final VoidCallback onCapture;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onCapture,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Icon(
              Icons.camera_alt,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCapture,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Capture'),
          ),
        ),
      ],
    );
  }
}

class _AudiencePanel extends StatelessWidget {
  const _AudiencePanel({required this.audience, required this.onSelect});

  final StoryAudience? audience;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audience visibility',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  audience?.label ?? 'Select who can view this story',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSelect,
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

class _AudienceSheet extends StatelessWidget {
  const _AudienceSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: StoryAudience.values
            .map(
              (audience) => ListTile(
                title: Text(audience.label),
                subtitle: Text(audience.description),
                leading: const Icon(Icons.visibility),
                onTap: () => Navigator.pop(context, audience),
              ),
            )
            .toList(),
      ),
    );
  }
}
