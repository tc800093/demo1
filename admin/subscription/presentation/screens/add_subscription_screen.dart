import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_dropdown_list_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/features/admin/subscription/domain/model/subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/add_subscription_plan_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/update_subscription_plan_usecase.dart';
import 'package:poweriot/features/admin/subscription/presentation/provider/subscription_provider.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';

class AddSubscriptionScreen extends StatefulWidget {
  final SubscriptionModel? subscription;

  const AddSubscriptionScreen({super.key, this.subscription});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  String _plan = 'Monthly'.toUpperCase();
  bool _isActive = true;

  final List<String> planType = [
    'Monthly'.toUpperCase(),
    'Yearly'.toUpperCase(),
  ];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    if (widget.subscription != null) {
      _nameController = TextEditingController(
        text: widget.subscription?.planName ?? '',
      );

      _descriptionController = TextEditingController(
        text: widget.subscription?.description ?? '',
      );

      _priceController = TextEditingController(
        text: widget.subscription?.amount.toString() ?? '',
      );

      // _deviceLimitController = TextEditingController(
      //   text: widget.subscription?.deviceLimit.toString() ?? '',
      // );

      // _userLimitController = TextEditingController(
      //   text: widget.subscription?.userLimit.toString() ?? '',
      // );

      _plan = widget.subscription?.planType ?? 'Monthly'.toUpperCase();

      _isActive = widget.subscription?.active ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateSubscription() async {
    if (_formKey.currentState!.validate()) {
      context.read<SubscriptionProvider>().updateSubscriptionPlanMethod(
        params: UpdateSubscriptionParams(
          planId: widget.subscription!.planId.toString(),
          isActive: _isActive,
          planName: _nameController.text.toString(),
          planDescription: _descriptionController.text.toString(),
          planPrice: _priceController.text.toString(),
          plaType: _plan,
        ),
      );
    } else {
      print('in else ');
    }
  }

  void _saveSubscription() {
    if (_formKey.currentState!.validate()) {
      context.read<SubscriptionProvider>().addSubscriptionPlanMethod(
        params: AddSubscriptionParams(
          planName: _nameController.text.toString(),
          planDescription: _descriptionController.text.toString(),
          planPrice: _priceController.text.toString(),
          plaType: _plan,
        ),
      );
    }
  }

  InputDecoration decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: .circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.subscription != null;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: V3AppBarWidget(
        title: isEdit
            ? "${AppLocale.update.getString(context)} ${AppLocale.subscription.getString(context)}"
            : "${AppLocale.add.getString(context)} ${AppLocale.subscription.getString(context)}",
        accountType: "2",
        userName: "",
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: .all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: .all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: .centerLeft,
                        child: Text(
                          "${AppLocale.plan.getString(context)} ${AppLocale.details.getString(context)}",
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: AppSizes.height(2)),
                      CustomTextfieldWidget(
                        title: AppLocale.planName.getString(context),
                        controller: _nameController,
                        prefixIconData: Icons.subscriptions,
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Plan Name";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppSizes.height(2)),

                      CustomTextfieldWidget(
                        title: AppLocale.description.getString(context),
                        controller: _descriptionController,
                        maxLines: 3,
                        prefixIconData: Icons.description,
                      ),

                      SizedBox(height: AppSizes.height(2)),

                      CustomTextfieldWidget(
                        title: AppLocale.price.getString(context),
                        controller: _priceController,
                        inputKeyBoard: .number,
                        prefixIconData: Icons.currency_rupee,
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Price";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppSizes.height(2)),
                      CustomDropdownWidget(
                        title: AppLocale.planType.getString(context),
                        items: planType,
                        itemLabelBuilder: (item) => item.toString(),
                        value: _plan,
                        onChanged: (v) {
                          setState(() {
                            _plan = v!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSizes.height(2)),

              /// Status
              Card(
                child: SwitchListTile(
                  title: Text(
                    '${AppLocale.plan.getString(context)} ${AppLocale.active.getString(context)}',
                  ),
                  subtitle: Text(
                    AppLocale.planActiveDescription.getString(context),
                  ),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ),

              SizedBox(height: AppSizes.height(3)),

              Consumer<SubscriptionProvider>(
                builder: (context, planProvide, child) {
                  if (planProvide.addStatus == .success ||
                      planProvide.updateStatus == .success) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AppSnackbar.success(
                        context,
                        isEdit ? "Subscrption Updated" : "Subscription Created",
                      );
                      context.pop();
                    });
                  }
                  return CustomButtonWidget(
                    isLoading: false,
                    title: isEdit
                        ? "${AppLocale.update.getString(context)} ${AppLocale.subscription.getString(context)}"
                        : "${AppLocale.create.getString(context)} ${AppLocale.subscription.getString(context)}",
                    theme: theme,
                    onPressedFunction: () {
                      if (isEdit) {
                        _updateSubscription();
                      } else {
                        _saveSubscription();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
