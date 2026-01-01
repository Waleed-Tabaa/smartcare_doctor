import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bot_toast/bot_toast.dart';
import 'profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ProfileController c = Get.find();
  final form = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController startCtrl;
  late TextEditingController endCtrl;

  final days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: c.name);
    bioCtrl = TextEditingController(text: c.about);

    startCtrl = TextEditingController(
      text:
          c.startTime.contains(":") ? c.startTime.substring(0, 5) : c.startTime,
    );

    endCtrl = TextEditingController(
      text: c.endTime.contains(":") ? c.endTime.substring(0, 5) : c.endTime,
    );

    selectedDays = List.from(c.workingDays);
  }

  Future pickTime(TextEditingController ctrl) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (t != null) {
      ctrl.text =
          "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
    }
  }

  Future pickImage() async {
    final img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (img != null) {
      c.setLocalAvatar(img.path);
    }
  }

  Future save() async {
    if (!form.currentState!.validate()) return;

    final result = await c.updateProfileApi(
      fullName: nameCtrl.text.trim(),
      bio: bioCtrl.text.trim(),
      days: selectedDays,
      start: startCtrl.text.trim(),
      end: endCtrl.text.trim(),
    );

    if (result["ok"] == true) {
      BotToast.showText(text: "تم التحديث بنجاح");
      Get.back();
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("حدث خطأ"),
              content: Text("${result["msg"]}\n\n${result["details"] ?? ""}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("حسناً"),
                ),
              ],
            ),
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    const mainBlue = Color(0xFF2B7BE4);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تعديل الملف الشخصي",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainBlue,
      ),
      body: GetBuilder<ProfileController>(
        builder: (c) {
          ImageProvider? img;

          if (c.imagePath.isNotEmpty) {
            img = FileImage(File(c.imagePath));
          } else if (c.avatarUrl.isNotEmpty) {
            img = NetworkImage(c.avatarUrl);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: form,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: img,
                      child:
                          img == null
                              ? const Icon(Icons.camera_alt, size: 34)
                              : null,
                    ),
                  ),

                  const SizedBox(height: 18),

                  field("الاسم الكامل", nameCtrl, required: true),
                  field("نبذة عني", bioCtrl, maxLines: 3),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "أيام الدوام",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Wrap(
                    spacing: 6,
                    children:
                        days.map((d) {
                          final sel = selectedDays.contains(d);

                          return ChoiceChip(
                            label: Text(d),
                            selected: sel,
                            onSelected: (_) {
                              setState(() {
                                sel
                                    ? selectedDays.remove(d)
                                    : selectedDays.add(d);
                              });
                            },
                          );
                        }).toList(),
                  ),

                  field(
                    "بداية الدوام",
                    startCtrl,
                    readOnly: true,
                    onTap: () => pickTime(startCtrl),
                  ),
                  field(
                    "نهاية الدوام",
                    endCtrl,
                    readOnly: true,
                    onTap: () => pickTime(endCtrl),
                  ),

                  const SizedBox(height: 22),

                  ElevatedButton(
                    onPressed: save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    child: const Text(
                      "حفظ التعديلات",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    bool readOnly = false,
    bool required = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: ctrl,
        readOnly: readOnly,
        maxLines: maxLines,
        validator:
            required
                ? (v) => v == null || v.isEmpty ? "هذا الحقل مطلوب" : null
                : null,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
