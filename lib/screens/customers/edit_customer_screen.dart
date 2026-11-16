import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../services/customer_service.dart';

class EditCustomerScreen extends StatefulWidget {
  final CustomerModel customer;

  const EditCustomerScreen({
    super.key,
    required this.customer,
  });

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final CustomerService _customerService = CustomerService();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController schoolController;
  late TextEditingController cityController;

  late String selectedGender;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.customer.name,
    );

    phoneController = TextEditingController(
      text: widget.customer.phone,
    );

    schoolController = TextEditingController(
      text: widget.customer.schoolName,
    );

    cityController = TextEditingController(
      text: widget.customer.city,
    );

    selectedGender = widget.customer.gender.isEmpty
        ? "Male"
        : widget.customer.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    schoolController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> updateCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await _customerService.updateCustomer(
      documentId: widget.customer.id,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      schoolName: schoolController.text.trim(),
      gender: selectedGender,
      city: cityController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter customer name"
                    : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter phone number"
                    : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: schoolController,
                decoration: const InputDecoration(
                  labelText: "School Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter school name"
                    : null,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Male",
                    child: Text("Male"),
                  ),
                  DropdownMenuItem(
                    value: "Female",
                    child: Text("Female"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter city"
                    : null,
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateCustomer,
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text("Update Customer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}