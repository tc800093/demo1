import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_dropdown_list_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/validator.dart';
import 'package:poweriot/features/admin/users/domain/usecase/add_user_usecase.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  String? selectedRole;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Status? _previousAddUserStatus;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    companyController.dispose();
    super.dispose();
  }

  void clearAll() {
    nameController.clear();
    emailController.clear();
    contactController.clear();
    contactController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: V3AppBarWidget(
        accountType: '2',
        userName: 'userName',
        title:
            '${AppLocale.add.getString(context)} ${AppLocale.user.getString(context)}',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: .symmetric(horizontal: 15, vertical: 10),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_previousAddUserStatus != userProvider.addUserStatus) {
                  if (userProvider.addUserStatus == .success) {
                    clearAll();
                    // context.read<UserDeviceProvider>().fetchSourceInfo(
                    //   deviceID: userProvider.addedUserData!.userId.toString(),
                    // );
                    AppSnackbar.success(context, 'User Added');
                    context.pushNamed(
                      adminUserDetailScreen,
                      extra: userProvider.addedUserData,
                    );
                  }
                  if (userProvider.addUserStatus == .failed) {
                    AppSnackbar.error(context, 'Failed to add user');
                  }
                  _previousAddUserStatus = userProvider.addUserStatus;
                }
              });
              return Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircleAvatar(
                              child: Text(
                                "U",
                                style: theme.textTheme.headlineLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: .all(8),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: .circle,
                                border: .all(color: Colors.white, width: 3),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.height(2)),
                    CustomTextfieldWidget(
                      prefixIconData: Icons.person_outline,
                      controller: nameController,
                      title: '* ${AppLocale.fullName.getString(context)}',
                      validatorFunction: (value) => Validator.text(value),
                    ),
                    SizedBox(height: AppSizes.height(2)),
                    CustomTextfieldWidget(
                      prefixIconData: Icons.email_outlined,
                      controller: emailController,
                      title: '* ${AppLocale.email.getString(context)}',
                      validatorFunction: (value) => Validator.email(value),
                    ),
                    SizedBox(height: AppSizes.height(2)),
                    CustomTextfieldWidget(
                      prefixIconData: Icons.phone_outlined,
                      controller: contactController,
                      inputKeyBoard: .phone,
                      title: '* ${AppLocale.contactNo.getString(context)}',
                      validatorFunction: (value) => Validator.phone(value),
                    ),
                    SizedBox(height: AppSizes.height(2)),

                    CustomTextfieldWidget(
                      prefixIconData: Icons.business_center_outlined,
                      controller: companyController,
                      title: '*${AppLocale.comanyName.getString(context)}',
                      validatorFunction: (value) => Validator.text(value),
                    ),

                    SizedBox(height: AppSizes.height(2)),
                    CustomDropdownWidget<String>(
                      title:
                          "* ${AppLocale.select.getString(context)} ${AppLocale.role.getString(context)}",
                      items: ['ADMIN', 'USER'],
                      value: selectedRole,
                      itemLabelBuilder: (role) => role.toString(),
                      onChanged: (role) {
                        setState(() {
                          selectedRole = role!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select a role";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizes.height(2)),
                    CustomButtonWidget(
                      onPressedFunction: () {
                        if (_globalKey.currentState!.validate()) {
                          context.read<UserProvider>().addUserMethod(
                            params: AddUserParams(
                              email: emailController.text.toString(),
                              fullName: nameController.text.toString(),
                              organizationName: companyController.text
                                  .toString(),
                              mobileNumber: contactController.text.toString(),
                              password: '123456',
                              role: selectedRole!,
                            ),
                          );
                        }
                      },
                      isLoading: false,
                      title: AppLocale.add.getString(context),
                      theme: theme,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
