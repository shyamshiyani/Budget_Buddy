import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/Helper/Api_Helper_Class.dart';
import '../../models/Spending_model.dart';
import '../../models/category_model_class.dart';

class SpendingComponent extends StatefulWidget {
  const SpendingComponent({super.key});

  @override
  State<SpendingComponent> createState() => _SpendingComponentState();
}

class _SpendingComponentState extends State<SpendingComponent> {
  String? selectedType = "Expense";
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  int? initialIndex;
  double? amount;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModelClass>>(
        future: ApiHelperClass.apiHelperClass.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            var categories = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Amount",
                        labelText: "Amount",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Choose Expense/Income",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RadioListTile<String>(
                    value: "Expense",
                    groupValue: selectedType,
                    onChanged: (val) {
                      setState(() {
                        selectedType = val;
                      });
                    },
                    title: const Text("Expense"),
                  ),
                  RadioListTile(
                    value: "Income",
                    groupValue: selectedType,
                    onChanged: (val) {
                      setState(() {
                        selectedType = val;
                      });
                    },
                    title: const Text("Income"),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: categories.isEmpty
                        ? Center(
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              Uint8List? imageBytes;

                              if (category.image != null) {
                                imageBytes = category.image as Uint8List?;
                              }

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (initialIndex == index) {
                                      initialIndex = null;
                                    } else {
                                      initialIndex = index;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.grey[100],
                                      border: (initialIndex == index)
                                          ? Border.all(
                                              color: Colors.black, width: 2.0)
                                          : null),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      imageBytes == null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 48.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 36.0,
                                              backgroundImage:
                                                  MemoryImage(imageBytes),
                                              backgroundColor: Colors.grey[200],
                                            ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        category.name,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            amount = double.tryParse(amountController.text);
                            if (amount != null) {
                              SpendingModel spending = SpendingModel(
                                spending_amount: amount,
                                spending_type: selectedType,
                                spending_category: initialIndex,
                              );
                              ApiHelperClass.apiHelperClass
                                  .insertSpending(spending: spending)
                                  .then((_) {
                                setState(() {
                                  selectedType = "Expense";
                                  initialIndex = null;
                                  amountController.clear();
                                  amount = null;
                                  Get.snackbar(
                                    'Success',
                                    'Spending record added successfully.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                });
                              }).catchError((error) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to add spending record.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              });
                            } else {
                              Get.snackbar(
                                'Error',
                                'Invalid amount value.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
                        },
                        label: const Text("Add Amount"),
                        icon: const Icon(Icons.add),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedType = "Expense";
                            initialIndex = null;
                            amountController.clear();
                            amount = null;
                          });
                        },
                        label: const Text("Reset"),
                        icon: const Icon(Icons.refresh),
                      )
                    ],
                  )
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
