import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/subscription/presentation/provider/subscription_provider.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_provider.dart';
import 'package:poweriot/features/admin/users/presentation/widget/user_detail_header_section_widget.dart';
import 'package:poweriot/features/admin/users/presentation/widget/user_detail_loading_widget.dart';
import 'package:poweriot/features/settings/presentation/widgets/subscripton_plan_widget.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// The main user detail screen (v2 — active version).
///
/// Displays user profile, power source devices (with generator/mains specs),
/// and subscription plan in expandable sections.
///
/// All API calls are parallelised using [Future.wait] in [fetchUserByID].
class UserDetailScreenV2 extends StatefulWidget {
  final UserModel? userModel;
  const UserDetailScreenV2({super.key, required this.userModel});

  @override
  State<UserDetailScreenV2> createState() => _UserDetailScreenV2State();
}

class _UserDetailScreenV2State extends State<UserDetailScreenV2> {
  // Controllers for the edit-user bottom sheet form.
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    // Trigger all API calls after the first frame so context is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchAll());
  }

  @override
  void dispose() {
    // Fix: dispose controllers to prevent memory leaks.
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    // Fix: reset provider state so the next user's screen starts clean.
    if (mounted) {
      context.read<UserProvider>().resetDetailState();
      context.read<UserDeviceProvider>().resetState();
    }
    super.dispose();
  }

  /// Fires all 3 independent API calls in parallel using [Future.wait].
  ///
  /// - [UserProvider.fetchUserByIDMethod] — user profile
  /// - [UserProvider.fetchSubscriptionByUserIDMethod] — subscription info
  /// - [SubscriptionProvider.fetchSubscriptionListMethod] — available plans
  /// - [UserDeviceProvider.fetchSourceInfo] — device + generator/mains data
  void _fetchAll() {
    final userId = widget.userModel!.userId.toString();
    final up = context.read<UserProvider>();
    final udp = context.read<UserDeviceProvider>();
    final sp = context.read<SubscriptionProvider>();

    Future.wait([
      up.fetchUserByIDMethod(userID: userId),
      up.fetchSubscriptionByUserIDMethod(userId: userId),
      sp.fetchSubscriptionListMethod(),
      udp.fetchSourceInfo(deviceID: userId),
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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          // ----- Show full-screen skeleton while initial user fetch is loading -----
          if (userProvider.fetchByIDUserStatus == Status.loading ||
              userProvider.fetchByIDUserStatus == Status.init) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: UserDetailLoadingWidget(),
            );
          }

          // ----- Show error state -----
          if (userProvider.fetchByIDUserStatus == Status.failed) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_off_outlined, size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'User data not available',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _fetchAll,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ----- Success: show full detail -----
          final user = userProvider.userData;

          // Pre-fill edit form controllers once data arrives.
          if (_nameController.text.isEmpty) {
            _nameController.text = user.fullName ?? '';
            _emailController.text = user.email ?? '';
            _contactController.text = user.mobileNumber ?? '';
          }

          // Show update-success snackbar and pop sheet if update finished.
          if (userProvider.updateUserStatus == Status.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) {
                AppSnackbar.success(context, 'Profile Updated');
                Navigator.of(context).pop();
              }
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── 1. Profile Card ──────────────────────────────────────────
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

                // ── 2. Power Sources ─────────────────────────────────────────
                CustomExpansionCard(
                  title: 'Power Sources',
                  iconData: Icons.electrical_services_outlined,
                  child: _PowerSourcesSection(userId: user.userId ?? ''),
                ),
                SizedBox(height: AppSizes.height(2.5)),

                // ── 3. Subscription Plan ─────────────────────────────────────
                CustomExpansionCard(
                  title: 'Subscription Plan',
                  iconData: Icons.workspace_premium_outlined,
                  child: _SubscriptionSection(
                    userProvider: userProvider,
                    userId: user.userId ?? '',
                  ),
                ),
                SizedBox(height: AppSizes.height(3)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Edit User Bottom Sheet
  // ---------------------------------------------------------------------------

  /// Shows a draggable bottom sheet for editing user profile fields.
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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

// =============================================================================
// Power Sources Section Widget
// =============================================================================

/// Renders the list of IoT devices belonging to the user, each expanded to
/// show its available power sources (generator / mains / both).
///
/// Shows a shimmer skeleton while [UserDeviceProvider.fetchSourceStatus] is loading.
/// Shows an "Add Power Source" button at the bottom of the list.
class _PowerSourcesSection extends StatelessWidget {
  final String userId;
  const _PowerSourcesSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserDeviceProvider>(
      builder: (context, udp, _) {
        // Loading skeleton
        if (udp.fetchSourceStatus == Status.loading ||
            udp.fetchSourceStatus == Status.init) {
          return Skeletonizer(
            enabled: true,
            child: _DeviceSourceCard(
              device: DeviceModel(
                deviceName: 'Loading Device',
                applicationType: 'MG',
                deviceCode: 'DEV001',
                locationName: 'Loading...',
              ),
            ),
          );
        }

        // Error / empty state
        if (udp.fetchSourceStatus == Status.failed || udp.devices.isEmpty) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'No devices found for this user.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.height(1.5)),
              _AddSourceButton(userId: userId),
            ],
          );
        }

        // Device list
        return Column(
          children: [
            SizedBox(height: AppSizes.height(1)),
            ...udp.devices.map((device) => _DeviceSourceCard(device: device)),
            SizedBox(height: AppSizes.height(1)),
            _AddSourceButton(userId: userId),
          ],
        );
      },
    );
  }
}

/// A card for a single IoT device showing its power source(s).
///
/// Application type determines which tiles render:
/// - `MG` → Generator + Mains Power
/// - `DG` → Generator only
/// - `MSEB`/`Mains` → Mains Power only
class _DeviceSourceCard extends StatelessWidget {
  final DeviceModel device;
  const _DeviceSourceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appType = (device.applicationType ?? '').toLowerCase();

    final hasGenerator = appType == 'mg' || appType == 'dg';
    final hasMains = appType == 'mg' || appType == 'mains' || appType == 'mseb';

    final sourceLabel = _sourceLabel(appType);
    final sourceColor = _sourceColor(appType, theme);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: sourceColor.withOpacity(0.12),
          child: Icon(Icons.memory_outlined, color: sourceColor),
        ),
        title: Text(
          device.deviceName ?? 'Device',
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Row(
          children: [
            Text(
              device.deviceCode ?? '',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: sourceColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                sourceLabel,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: sourceColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          if (device.locationName != null && device.locationName!.isNotEmpty)
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: device.locationName!,
            ),
          if (hasGenerator) ...[
            const Divider(height: 20),
            _SourceTile(
              icon: Icons.power_outlined,
              title: 'Generator',
              subtitle: device.generatorModel != null
                  ? '${device.generatorModel!.generatorName ?? 'N/A'}'
                      ' · ${device.generatorModel!.generatorCapacityKva ?? '--'} KVA'
                  : 'Info not available',
              color: Colors.orange,
              details: device.generatorModel == null
                  ? null
                  : [
                      _InfoRow(
                        icon: Icons.precision_manufacturing_outlined,
                        label: 'Manufacturer',
                        value: device.generatorModel!.manufacturer ?? 'N/A',
                      ),
                      _InfoRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Model No.',
                        value: device.generatorModel!.modelNumber ?? 'N/A',
                      ),
                      _InfoRow(
                        icon: Icons.local_gas_station_outlined,
                        label: 'Fuel Tank',
                        value:
                            '${device.generatorModel!.fuelTankCapacity ?? '--'} L',
                      ),
                      _InfoRow(
                        icon: Icons.event_outlined,
                        label: 'Next Maintenance',
                        value: device.generatorModel!.nextMaintenanceDate
                                    ?.toString() !=
                                null
                            ? DateFormat('dd MMM yyyy').format(
                                device.generatorModel!.nextMaintenanceDate!,
                              )
                            : 'N/A',
                      ),
                    ],
            ),
          ],
          if (hasMains) ...[
            const Divider(height: 20),
            _SourceTile(
              icon: Icons.bolt_outlined,
              title: 'Mains Power',
              subtitle: device.mainPowerModel != null
                  ? '${device.mainPowerModel!.connectionName ?? 'N/A'}'
                      ' · ${device.mainPowerModel!.phaseType ?? '--'}'
                  : 'Info not available',
              color: Colors.blue,
              details: device.mainPowerModel == null
                  ? null
                  : [
                      _InfoRow(
                        icon: Icons.numbers_outlined,
                        label: 'Meter No.',
                        value: device.mainPowerModel!.meterNumber ?? 'N/A',
                      ),
                      _InfoRow(
                        icon: Icons.electric_meter_outlined,
                        label: 'Board',
                        value:
                            device.mainPowerModel!.electricityBoard?.toString() ??
                                'N/A',
                      ),
                      _InfoRow(
                        icon: Icons.cable_outlined,
                        label: 'Phase Type',
                        value: device.mainPowerModel!.phaseType ?? 'N/A',
                      ),
                    ],
            ),
          ],
        ],
      ),
    );
  }

  String _sourceLabel(String appType) {
    switch (appType) {
      case 'mg':
        return 'Main + Generator';
      case 'dg':
        return 'Generator Only';
      case 'mseb':
      case 'mains':
        return 'Mains Only';
      default:
        return appType.toUpperCase();
    }
  }

  Color _sourceColor(String appType, ThemeData theme) {
    switch (appType) {
      case 'mg':
        return Colors.purple;
      case 'dg':
        return Colors.orange;
      case 'mseb':
      case 'mains':
        return Colors.blue;
      default:
        return theme.colorScheme.primary;
    }
  }
}

/// A single power source row within a device card (generator or mains).
class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Widget>? details;

  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (details != null) ...[
          const SizedBox(height: 10),
          ...details!,
        ],
      ],
    );
  }
}

/// A single label + value row inside an expanded device card.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// "Add Power Source" button shown at the bottom of the power sources section.
class _AddSourceButton extends StatelessWidget {
  final String userId;
  const _AddSourceButton({required this.userId});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        context.pushNamed('adminAddDeviceScreen', extra: userId);
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Power Source'),
    );
  }
}

// =============================================================================
// Subscription Section Widget
// =============================================================================

/// Renders the subscription plan section with a loading skeleton and null safety.
class _SubscriptionSection extends StatelessWidget {
  final UserProvider userProvider;
  final String userId;

  const _SubscriptionSection({
    required this.userProvider,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Loading state for subscription
    if (userProvider.fetchSubscriptionByIDStatus == Status.loading ||
        userProvider.fetchSubscriptionByIDStatus == Status.init) {
      return Skeletonizer(
        enabled: true,
        child: _subscriptionCard(
          theme: theme,
          planName: 'Premium Plan',
          expiry: 'dd MMM yyyy',
          status: 'Active',
          amount: '₹0',
        ),
      );
    }

    // No subscription / failed
    if (userProvider.fetchSubscriptionByIDStatus == Status.failed ||
        userProvider.userSubscriptionModel == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'No active subscription found.',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1.5)),
          FilledButton.icon(
            onPressed: () => _showSubscriptionPlans(context, userId),
            icon: const Icon(Icons.add),
            label: const Text('Assign Plan'),
          ),
        ],
      );
    }

    // Success — safe to read
    final sub = userProvider.userSubscriptionModel!;
    final expiryStr = sub.expiryDate != null
        ? DateFormat('dd MMM yyyy').format(sub.expiryDate!)
        : 'N/A';
    final startStr = sub.startDate != null
        ? DateFormat('dd MMM yyyy').format(sub.startDate!)
        : 'N/A';
    final isExpired = sub.expiryDate != null &&
        sub.expiryDate!.isBefore(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subscriptionCard(
          theme: theme,
          planName: sub.planName?.toString() ?? 'N/A',
          expiry: expiryStr,
          status: isExpired ? 'Expired' : (sub.status?.toString() ?? 'Active'),
          amount: '₹${sub.amount?.toString() ?? '--'}',
          isExpired: isExpired,
          purchaseDate: startStr,
        ),
        SizedBox(height: AppSizes.height(1.5)),
        FilledButton.icon(
          onPressed: () => _showSubscriptionPlans(context, userId),
          icon: const Icon(Icons.upgrade_outlined),
          label: const Text('Change Plan'),
        ),
      ],
    );
  }

  void _showSubscriptionPlans(BuildContext context, String userid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SubscriptonPlanWidget(userId: userid),
    );
  }

  Widget _subscriptionCard({
    required ThemeData theme,
    required String planName,
    required String expiry,
    required String status,
    required String amount,
    bool isExpired = false,
    String? purchaseDate,
  }) {
    final statusColor = isExpired ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: theme.colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(planName, style: theme.textTheme.titleMedium),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: statusColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _SubInfoRow(label: 'Amount', value: amount, theme: theme),
          if (purchaseDate != null)
            _SubInfoRow(
              label: 'Purchase Date',
              value: purchaseDate,
              theme: theme,
            ),
          _SubInfoRow(
            label: 'Expiry Date',
            value: expiry,
            theme: theme,
            valueColor: isExpired ? Colors.red : null,
          ),
        ],
      ),
    );
  }
}

class _SubInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final Color? valueColor;

  const _SubInfoRow({
    required this.label,
    required this.value,
    required this.theme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
