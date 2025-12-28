import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:smartcare/profile/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ProfileController controller = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController aboutCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController clinicNameCtrl;
  late TextEditingController clinicAddressCtrl;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: controller.name);
    aboutCtrl = TextEditingController(text: controller.about);
    phoneCtrl = TextEditingController(text: controller.phone);
    clinicNameCtrl = TextEditingController(text: controller.clinicName);
    clinicAddressCtrl = TextEditingController(text: controller.clinicAddress);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    aboutCtrl.dispose();
    phoneCtrl.dispose();
    clinicNameCtrl.dispose();
    clinicAddressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (picked != null) {
      await controller.uploadAvatar(File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      BotToast.showText(text: "يرجى تصحيح الحقول");
      return;
    }

    final success = await controller.updateProfileApi(
      fullName: nameCtrl.text.trim(),
      bio: aboutCtrl.text.trim(),
    );

    if (success) {
      controller.phone = phoneCtrl.text.trim();
      controller.clinicName = clinicNameCtrl.text.trim();
      controller.clinicAddress = clinicAddressCtrl.text.trim();
      controller.update();

      BotToast.showText(text: "تم حفظ التعديلات بنجاح");
      Get.back();
    } else {
      BotToast.showText(text: "فشل حفظ التعديلات");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تعديل الملف الشخصي"),
          backgroundColor: const Color(0xFF2B7BE4),
        ),
        body: GetBuilder<ProfileController>(
          builder: (c) {
            final ImageProvider? image = _buildImage(c);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: image,
                        child: image == null
                            ? const Icon(Icons.camera_alt, size: 32)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _field("الاسم الكامل", nameCtrl, required: true),
                    _field("نبذة عني", aboutCtrl, maxLines: 3),
                    _field("رقم الهاتف", phoneCtrl,
                        keyboard: TextInputType.phone),
                    _field("اسم العيادة", clinicNameCtrl),
                    _field("عنوان العيادة", clinicAddressCtrl),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B7BE4),
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "حفظ التعديلات",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  ImageProvider? _buildImage(ProfileController c) {
    if (c.imagePath.isNotEmpty) {
      return FileImage(File(c.imagePath));
    }
    if (c.avatarUrl.isNotEmpty &&
        !c.avatarUrl.contains("example.com")) {
      return NetworkImage(c.avatarUrl);
    }
    return null;
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: required
            ? (v) => v == null || v.isEmpty ? "هذا الحقل مطلوب" : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
