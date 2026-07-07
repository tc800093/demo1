import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poweriot/core/common/provider/device_provider.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/common/widgets/no_data_widget.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/features/admin/subscription/presentation/provider/subscription_provider.dart';
import 'package:poweriot/features/admin/transactions/presentation/provider/transaction_provider.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_provider.dart';
import 'package:poweriot/features/admin/users/presentation/widget/admin_service_history_widget.dart';
import 'package:poweriot/features/admin/users/presentation/widget/power_source_section.dart';
import 'package:poweriot/core/common/widgets/refeul_history_widget.dart';
import 'package:poweriot/core/common/widgets/service_history_widget.dart';
import 'package:poweriot/features/admin/users/presentation/widget/subscription_section_widget.dart';
import 'package:poweriot/features/admin/users/presentation/widget/transaction_history_widget.dart';
import 'package:poweriot/features/admin/users/presentation/widget/user_detail_header_section_widget.dart';
import 'package:poweriot/features/admin/users/presentation/widget/user_detail_loading_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';

/// Display user detail screen
class UserDetailScreenV3 extends StatefulWidget {
  final UserModel? userModel;
  const UserDetailScreenV3({super.key, required this.userModel});

  @override
  State<UserDetailScreenV3> createState() => _UserDetailScreenV3State();
}

class _UserDetailScreenV3State extends State<UserDetailScreenV3> {
  // Controllers for the edit-user bottom sheet form.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final UserProvider _userProvider = service<UserProvider>();
  final UserDeviceProvider _userDeviceProvider = service<UserDeviceProvider>();

  @override
  void initState() {
    super.initState();
    // Trigger all API calls after the first frame so context is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchAll());
  }

  @override
  void dispose() {
    // dispose controllers to prevent memory leaks.
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    // reset provider state so the next user's screen starts clean.
    // if (mounted) {
    _userProvider.resetDetailState();
    _userDeviceProvider.resetState();
    // }
    super.dispose();
  }

  /// calling all 3 function using [Future.wait]
  void _fetchAll() {
    final userId = widget.userModel!.userId.toString();
    final up = context.read<UserProvider>();
    final udp = context.read<UserDeviceProvider>();
    final sp = context.read<SubscriptionProvider>();
    final dp = context.read<DeviceProvider>();
    final tp = context.read<TransactionProvider>();

    Future.wait([
      up.fetchUserByIDMethod(userID: userId),
      up.fetchSubscriptionByUserIDMethod(userId: userId),
      sp.fetchSubscriptionListMethod(),
      udp.fetchSourceInfo(deviceID: userId),
      tp.fetchTransactionHistoryByUserIDMethod(userID: userId),
      dp.resetStatus(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: V3AppBarWidget(
        accountType: '2',
        userName: '',
        title: widget.userModel?.fullName ?? 'User Detail',
      ),
      body: Consumer2<UserProvider, DeviceProvider>(
        builder: (context, userProvider, deviceProvider, _) {
          // ----- Show full-screen skeleton while initial user fetch is loading -----

          if (deviceProvider.deleteDeviceStatus == .success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fetchAll();
            });
          }
          if (userProvider.fetchByIDUserStatus == Status.loading ||
              userProvider.fetchByIDUserStatus == .init) {
            return SingleChildScrollView(
              padding: .all(16),
              child: UserDetailLoadingWidget(),
            );
          }

          if (userProvider.fetchByIDUserStatus == .failed) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_off_outlined, size: 56, color: Colors.grey),
                  SizedBox(height: 12),
                  NoDataWidget(
                    iconData: Icons.person_off,
                    title: "User not found",
                  ),
                  SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _fetchAll,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final user = userProvider.userData;

          if (_nameController.text.isEmpty) {
            _nameController.text = user.fullName ?? '';
            _emailController.text = user.email ?? '';
            _contactController.text = user.mobileNumber ?? '';
          }
          if (userProvider.updateUserStatus == Status.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) {
                AppSnackbar.success(context, 'Profile Updated');
                Navigator.of(context).pop();
              }
            });
          }

          return SingleChildScrollView(
            padding: .all(16),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                UserDetailHeaderSectionWidget(
                  name: user.fullName,
                  email: user.email,
                  contactNo: user.mobileNumber,
                  onPressed: () => _showEditBottomSheet(
                    theme: theme,
                    userData: user,
                    userProvider: userProvider,
                  ),
                ),
                SizedBox(height: AppSizes.height(2.5)),

                CustomExpansionCard(
                  title: 'Power Sources',
                  iconData: Icons.electrical_services_outlined,
                  child: PowerSourcesSection(userId: user.userId ?? ''),
                ),
                SizedBox(height: AppSizes.height(2.5)),

                CustomExpansionCard(
                  title: 'Subscription Plan',
                  iconData: Icons.workspace_premium_outlined,
                  child: SubscriptionSectionWidget(
                    userProvider: userProvider,
                    userId: user.userId ?? '',
                  ),
                ),
                SizedBox(height: AppSizes.height(3)),
                CustomExpansionCard(
                  title: 'Subscription History',
                  iconData: Icons.workspace_premium_outlined,
                  child: TransactionHistoryWidget(userId: user.userId ?? ''),
                ),
                SizedBox(height: AppSizes.height(3)),
                CustomExpansionCard(
                  title: 'Service History',
                  iconData: Icons.handyman_outlined,
                  child: AdminServiceHistoryWidget(
                    userID: widget.userModel!.userId.toString(),
                  ),
                ),
                SizedBox(height: AppSizes.height(3)),
                CustomExpansionCard(
                  title: 'Refuel History',
                  iconData: Icons.local_gas_station_outlined,
                  child: RefuelHistorySection(userId: user.userId ?? ''),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditBottomSheet({
    required ThemeData theme,
    required UserModel userData,
    required UserProvider userProvider,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: .circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: .only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Text(
                'Edit Profile',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.height(2)),
              CustomTextfieldWidget(
                prefixIconData: Icons.person_outline,
                controller: _nameController,
                title: 'Full Name',
              ),
              SizedBox(height: AppSizes.height(2)),
              CustomTextfieldWidget(
                prefixIconData: Icons.email_outlined,
                controller: _emailController,
                title: 'Email',
              ),
              SizedBox(height: AppSizes.height(2)),
              CustomTextfieldWidget(
                prefixIconData: Icons.phone_outlined,
                controller: _contactController,
                inputKeyBoard: TextInputType.phone,
                title: 'Contact No.',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: AppSizes.height(2.5)),
              // Fix: was labelled "Add" — now correctly says "Update"
              CustomButtonWidget(
                onPressedFunction: () {
                  context.read<UserProvider>().updateUserByIDMethod(
                    user: userData.copyWith(
                      fullName: _nameController.text.trim(),
                      mobileNumber: _contactController.text.trim(),
                      email: _emailController.text.trim(),
                    ),
                  );
                  Navigator.of(ctx).pop();
                },
                isLoading: userProvider.updateUserStatus == Status.loading,
                title: 'Update',
                theme: theme,
              ),
            ],
          ),
        );
      },
    );
  }
}
