import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/services.dart';
import '../../services/provider_service.dart';
import '../../services/upload_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _selectedService;
  final _bioController = TextEditingController();
  final _expController = TextEditingController();
  File? _idProof;
  bool _loading = false;
  String _error = '';

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _idProof = File(picked.path));
  }

  Future<void> _submit() async {
    if (_selectedService == null) { setState(() => _error = 'Please select your service.'); return; }
    if (_expController.text.isEmpty) { setState(() => _error = 'Please enter years of experience.'); return; }
    if (_idProof == null) { setState(() => _error = 'Please upload your ID proof.'); return; }
    setState(() { _loading = true; _error = ''; });
    try {
      final url = await UploadService().uploadFile(_idProof!, 'documents');
      await ProviderService().register(serviceId: _selectedService!, bio: _bioController.text, experienceYears: int.parse(_expController.text), idProofUrl: url);
      if (mounted) context.go('/onboarding/pending');
    } catch (e) { setState(() => _error = e.toString()); }
    finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Set up your profile', style: AppTypography.h1),
            const SizedBox(height: 4),
            Text('Tell us about your skills', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Text('What service do you provide?', style: AppTypography.bodyLarge),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: services.map((s) => GestureDetector(
              onTap: () => setState(() { _selectedService = s.id; _error = ''; }),
              child: Container(
                width: (MediaQuery.of(context).size.width - 72) / 4,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedService == s.id ? AppColors.primaryLight : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _selectedService == s.id ? AppColors.primary : AppColors.border, width: 1.5),
                ),
                child: Column(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: s.iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(s.icon, color: s.iconColor, size: 24)),
                  const SizedBox(height: 4),
                  Text(s.name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _selectedService == s.id ? AppColors.primary : AppColors.textSecondary), textAlign: TextAlign.center),
                ]),
              ),
            )).toList()),
            const SizedBox(height: 20),
            Text('About you (optional)', style: AppTypography.bodyLarge),
            const SizedBox(height: 8),
            TextField(controller: _bioController, maxLines: 3, maxLength: 500, decoration: const InputDecoration(hintText: 'Describe your expertise...')),
            const SizedBox(height: 16),
            Text('Years of experience', style: AppTypography.bodyLarge),
            const SizedBox(height: 8),
            TextField(controller: _expController, keyboardType: TextInputType.number, maxLength: 2, decoration: const InputDecoration(hintText: 'e.g. 5', counterText: '')),
            const SizedBox(height: 16),
            Text('Upload ID proof', style: AppTypography.bodyLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity, padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryMid, width: 1.5, style: BorderStyle.solid)),
                child: _idProof != null
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check_circle, color: AppColors.success), const SizedBox(width: 8), Text('Photo selected', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600))])
                  : Column(children: [const Icon(Icons.cloud_upload_outlined, size: 32, color: AppColors.primary), const SizedBox(height: 6), Text('Tap to upload', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500))]),
              ),
            ),
            if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error, style: TextStyle(color: AppColors.error, fontSize: 13), textAlign: TextAlign.center)),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Submit for review'))),
          ]),
        ),
      ),
    );
  }
}
