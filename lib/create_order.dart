import 'package:fix_it/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
// import 'package:graduation/app_colors.dart';i
import 'package:latlong2/latlong.dart';
import 'package:fix_it/location_picker_page.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/providers/order_provider.dart';

class CreateOrder extends StatefulWidget {
 final OrderModel? order ;
  const CreateOrder({super.key,this.order});

  @override
  State<CreateOrder> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrder> {
  final _formKey = GlobalKey<FormState>();
  bool get isEditMode => widget.order != null; //*if order null =>new order else updae torder 
  LatLng? _selectedLocation;

  // String? _selectedSpecialization;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // final List<String> _specializations = [
  //   "كهرباء",
  //   "سباكة",
  //   "أجهزة منزلية",
  //   "تكييف وتبريد",
  // ];
  // final ApiService _apiService = ApiService();

  // List<SpecializationModel> _specializations = [];
  int? _selectedSpecializationId;

  // bool _isLoadingSpecializations = true;
  // String? _specializationsError;
  @override
void initState() {
  super.initState();

  final order = widget.order;

  if (order != null) {
    _selectedSpecializationId = order.specializationId;

    _titleController.text = order.description.split('\n').first;

    _descriptionController.text =
        order.description.contains('\n')
            ? order.description.substring(
                order.description.indexOf('\n') + 1,
              )
            : order.description;

    _selectedLocation = LatLng(
      order.latitude,
      order.longitude,
    );
  }

  Future.microtask(() {
    context.read<OrderProvider>().getSpecializations();
  });
}

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "إنشاء طلب صيانة جديد",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context), // العودة إلى الصفحة السابقة
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // إضافة padding حول المحتوى
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "يرجى ملء تفاصيل العطل بدقة لمساعدة الفنيين في تقديم عروض مناسبة.",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 1. حقل اختيار التخصص
              const Text(
                "تخصص الصيانة المطلوب",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  if (orderProvider.isLoadingSpecializations) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (orderProvider.errorMessage != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderProvider.errorMessage!,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.red,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            context.read<OrderProvider>().getSpecializations();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    );
                  }
                  if (orderProvider.specializations.isEmpty) {
                    return const Text(
                      'لا توجد تخصصات متاحة حاليًا',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textSecondary,
                      ),
                    );
                  }

                  return DropdownButtonFormField<int>(
                    value: _selectedSpecializationId,
                    hint: const Text(
                      "اختر التخصص من القائمة",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    dropdownColor: AppColors.surface,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Color.fromARGB(255, 185, 54, 54),
                      ),
                      fillColor: AppColors.surface,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.05),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    items: orderProvider.specializations.map((specialization) {
                      return DropdownMenuItem<int>(
                        value: specialization.id,
                        child: Text(
                          specialization.name,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecializationId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "الرجاء اختيار التخصص أولاً";
                      }

                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              // 2. حقل عنوان الطلب
              const Text(
                "عنوان مختصر للطلب",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color.fromARGB(255, 185, 54, 54),
                  ),
                  hintText: "مثال: عطل في لوحة الكهرباء الرئيسية",
                  hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  fillColor: AppColors.surface,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) =>
                    value == null ||
                        value
                            .trim()
                            .isEmpty // the trim check if user make space in start or end
                    // of the text and check after the trim if it is empty
                    ? "الرجاء إدخال عنوان للطلب"
                    : null,
              ),

              const SizedBox(height: 20),

              // 3. حقل تفاصيل المشكلة
              const Text(
                "تفاصيل العطل أو المشكلة",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color.fromARGB(255, 185, 54, 54),
                  ),
                  hintText:
                      "يرجى كتابة تفاصيل واضحة عن العطل لمساعدة الفنيين في تقديم عروض أسعار دقيقة بالملي...",
                  hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  fillColor: AppColors.surface,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "الرجاء شرح تفاصيل المشكلة,"
                    : null,
              ),
              const SizedBox(height: 20),

              const Text(
                "موقع الصيانة",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: () async {
                  final result = await Navigator.push<LatLng>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationPickerPage(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      _selectedLocation = result;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedLocation == null
                              ? "اختر موقع الصيانة على الخريطة"
                              : "تم اختيار الموقع: ${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}",
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 4. زر نشر الطلب النهائي بالتدرج الذهبي الفخم
              SizedBox(
                width: double.infinity,
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFFC69214)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                   onPressed: () async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (_selectedLocation == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'الرجاء اختيار الموقع',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final orderProvider = context.read<OrderProvider>();

  final description =
      '${_titleController.text.trim()}\n${_descriptionController.text.trim()}';

  bool success;

  if (isEditMode) {
    success = await orderProvider.updateOrder(
      orderId: widget.order!.id,
      specializationId: _selectedSpecializationId!,
      description: description,
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      addressText:
          widget.order!.addressText ?? 'موقع محدد من الخريطة',
    );
  } else {
    success = await orderProvider.createOrder(
      specializationId: _selectedSpecializationId!,
      description: description,
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      addressText: 'موقع محدد من الخريطة',
    );
  }

  if (!mounted) return;

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditMode
              ? 'تم تعديل الطلب بنجاح'
              : 'تم إنشاء الطلب بنجاح',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditMode
              ? orderProvider.updateOrderError ?? 'فشل تعديل الطلب'
              : orderProvider.createOrderError ?? 'فشل إنشاء الطلب',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // to make the gradient visible (شفافة)
                      shadowColor: Colors.transparent, // لإزالة الظل الافتراضي

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Consumer<OrderProvider>(
                      builder: (context, orderProvider, child) {
                        if (orderProvider.isCreatingOrder) {
                          return const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          );
                        }

                        return const Text(
                          'نشر الطلب الآن',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
