import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/employer_service.dart';
import 'package:go_router/go_router.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  
  final _salaryController = TextEditingController();
  final _descriptionController = TextEditingController();

  final EmployerService _service = EmployerService();

  bool loading = false;
  bool _uploadingLogo = false;

  File? _companyLogo;
  String? _logoUrl;

  String employmentType = "دوام كامل";
  String experience = "لا يشترط";
  String category = "تقنية";
  String city = "بغداد";

  final employmentTypes = [
    "دوام كامل",
    "دوام جزئي",
    "عن بعد",
    "تدريب"
  ];

  final experienceLevels = [
    "لا يشترط",
    "حديث تخرج",
    "سنة",
    "سنتان",
    "3 سنوات+",
    "5 سنوات+"
  ];

  final categories = [
    "تقنية",
    "إدارية",
    "محاسبة",
    "تعليم",
    "طبية",
    "تسويق",
    "مبيعات",
    "خدمة عملاء",
    "أخرى"
  ];
  final cities = [
  "بغداد",
  "البصرة",
  "نينوى",
  "أربيل",
  "دهوك",
  "السليمانية",
  "النجف",
  "كربلاء",
  "بابل",
  "واسط",
  "ذي قار",
  "ميسان",
  "المثنى",
  "القادسية",
  "الأنبار",
  "صلاح الدين",
  "ديالى",
  "كركوك",
];

  InputDecoration dec(String t) => InputDecoration(
        labelText: t,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  Future<void> pickCompanyLogo() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _companyLogo = File(image.path);
      _uploadingLogo = true;
    });

    try {
      final url = await _service.uploadCompanyLogo(_companyLogo!);

      setState(() {
        _logoUrl = url;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("فشل رفع الشعار\n$e"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingLogo = false;
        });
      }
    }
  }

  Future<void> saveJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await _service.addJob(
        title: _titleController.text.trim(),
        company: _companyController.text.trim(),
        city: city,
        description: _descriptionController.text.trim(),
        salary: _salaryController.text.trim(),
        employmentType: employmentType,
        experience: experience,
        category: category,
        imageUrl: _logoUrl,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم نشر الوظيفة"),
        ),
      );

WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.pop(); 
        }
      });
      
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة وظيفة"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: GestureDetector(
                onTap: _uploadingLogo ? null : pickCompanyLogo,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: _companyLogo != null
                      ? FileImage(_companyLogo!)
                      : null,
                  child: _companyLogo == null
                      ? const Icon(
                          Icons.business,
                          size: 40,
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: TextButton.icon(
                onPressed: _uploadingLogo ? null : pickCompanyLogo,
                icon: const Icon(Icons.photo),
                label: Text(
                  _uploadingLogo
                      ? "جاري رفع الشعار..."
                      : "اختيار شعار الشركة",
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _titleController,
              decoration: dec("عنوان الوظيفة"),
              validator: (v) =>
                  v == null || v.isEmpty ? "مطلوب" : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _companyController,
              decoration: dec("اسم الشركة"),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: employmentType,
              decoration: dec("نوع الدوام"),
              items: employmentTypes
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (v) =>
                  setState(() => employmentType = v!),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: experience,
              decoration: dec("الخبرة"),
              items: experienceLevels
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (v) =>
                  setState(() => experience = v!),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: category,
              decoration: dec("التصنيف"),
              items: categories
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (v) =>
                  setState(() => category = v!),
            ),

            const SizedBox(height: 16),

DropdownButtonFormField<String>(
  value: city,
  decoration: dec("المحافظة"),
  items: cities
      .map(
        (e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      )
      .toList(),
  onChanged: (v) {
    setState(() {
      city = v!;
    });
  },
),

            const SizedBox(height: 16),

            TextFormField(
              controller: _salaryController,
              decoration: dec("الراتب"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: dec("وصف الوظيفة"),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : saveJob,
                child: Text(
                  loading
                      ? "جاري النشر..."
                      : "نشر الوظيفة",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}