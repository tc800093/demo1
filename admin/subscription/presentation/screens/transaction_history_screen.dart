import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/subscription/domain/model/user_subscription_model.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/v3_app_bar_widget.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Static mockup transactions data
  final List<UserSubscriptionModel> _allTransactions = [
    UserSubscriptionModel(
      subscriptionId: "sub-101",
      userId: "user-123",
      userName: "Tejas Patil",
      planId: "plan-2",
      planName: "Enterprise Yearly",
      amount: 9999.0,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      expiryDate: DateTime.now().add(const Duration(days: 355)),
      status: "success",
      paymentType: "Online",
      paymentMode: "UPI",
      paymentDate: DateTime.now().subtract(const Duration(days: 10)),
      transactionId: "TXN-883920194",
      remarks: "Annual renewal for office generator unit.",
    ),
    UserSubscriptionModel(
      subscriptionId: "sub-102",
      userId: "user-456",
      userName: "Vasundhara Dev",
      planId: "plan-1",
      planName: "Basic Monthly",
      amount: 999.0,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      status: "success",
      paymentType: "Online",
      paymentMode: "Card",
      paymentDate: DateTime.now().subtract(const Duration(days: 15)),
      transactionId: "TXN-104928103",
      remarks: "Monthly subscription for generator set only.",
    ),
    UserSubscriptionModel(
      subscriptionId: "sub-103",
      userId: "user-789",
      userName: "Rahul Shinde",
      planId: "plan-1",
      planName: "Basic Monthly",
      amount: 999.0,
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      expiryDate: DateTime.now().subtract(const Duration(days: 15)),
      status: "expired",
      paymentType: "Online",
      paymentMode: "Net Banking",
      paymentDate: DateTime.now().subtract(const Duration(days: 45)),
      transactionId: "TXN-382910382",
      remarks: "Monthly subscription for mains power only.",
    ),
    UserSubscriptionModel(
      subscriptionId: "sub-104",
      userId: "user-789",
      userName: "Rahul Shinde",
      planId: "plan-1",
      planName: "Basic Monthly",
      amount: 999.0,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      expiryDate: DateTime.now().add(const Duration(days: 25)),
      status: "success",
      paymentType: "Online",
      paymentMode: "UPI",
      paymentDate: DateTime.now().subtract(const Duration(days: 5)),
      transactionId: "TXN-493019381",
      remarks: "Plan renewal for Rahul Shinde.",
    ),
  ];

  List<UserSubscriptionModel> get _filteredTransactions {
    if (_searchQuery.trim().isEmpty) {
      return _allTransactions;
    }
    return _allTransactions.where((txn) {
      final name = txn.userName.toString().toLowerCase();
      final id = txn.transactionId.toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || id.contains(query);
    }).toList();
  }

  double get _totalVolume {
    return _allTransactions
        .where((txn) => txn.status == "success")
        .fold(0.0, (sum, txn) => sum + (txn.amount ?? 0.0));
  }

  int get _successCount {
    return _allTransactions.where((txn) => txn.status == "success").length;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  void _showTransactionDetails(UserSubscriptionModel txn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Transaction Details',
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                "Transaction ID",
                txn.transactionId ?? 'N/A',
                theme,
              ),
              _buildDetailRow("User Name", txn.userName ?? 'N/A', theme),
              _buildDetailRow(
                "Subscription Plan",
                txn.planName ?? 'N/A',
                theme,
              ),
              _buildDetailRow(
                "Amount Paid",
                "₹${txn.amount ?? 0.0}",
                theme,
                isBoldValue: true,
              ),
              _buildDetailRow(
                "Payment Date",
                _formatDate(txn.paymentDate),
                theme,
              ),
              _buildDetailRow("Payment Type", txn.paymentType ?? 'N/A', theme),
              _buildDetailRow("Payment Mode", txn.paymentMode ?? 'N/A', theme),
              _buildDetailRow("Start Date", _formatDate(txn.startDate), theme),
              _buildDetailRow(
                "Expiry Date",
                _formatDate(txn.expiryDate),
                theme,
              ),
              _buildDetailRow("Remarks", txn.remarks ?? 'N/A', theme),
              const SizedBox(height: 10),
              Center(
                child: Chip(
                  label: Text(
                    txn.status?.toUpperCase() ?? 'PENDING',
                    style: TextStyle(
                      color: txn.status == "success"
                          ? Colors.green.shade700
                          : txn.status == "expired"
                          ? Colors.amber.shade800
                          : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: txn.status == "success"
                      ? Colors.green.shade50
                      : txn.status == "expired"
                      ? Colors.amber.shade400
                      : Colors.red.shade50,
                  side: BorderSide.none,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Close"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    ThemeData theme, {
    bool isBoldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall!.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall!.copyWith(
              fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
              color: isBoldValue ? theme.colorScheme.primary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredList = _filteredTransactions;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: V3AppBarWidget(
        title:
            '${AppLocale.transaction.getString(context)} ${AppLocale.history.getString(context)}',
        accountType: "2",
        userName: "",
      ),
      body: Column(
        children: [
          // Stat Analytics Grid Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _statItem(
                      "Total Volume",
                      "₹${_totalVolume.toStringAsFixed(0)}",
                      Icons.account_balance_wallet_outlined,
                    ),
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  Expanded(
                    child: _statItem(
                      "Transactions",
                      _allTransactions.length.toString(),
                      Icons.receipt_outlined,
                    ),
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  Expanded(
                    child: _statItem(
                      "Success Rate",
                      "${((_successCount / _allTransactions.length) * 100).toStringAsFixed(0)}%",
                      Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomTextfieldWidget(
              controller: _searchController,
              onChangedFunction: (v) {
                setState(() {
                  _searchQuery = v.toString();
                });
              },
              title: 'Search by User Name or TXN ID...',
              suffixIconData: Icons.search_outlined,
            ),
          ),
          const SizedBox(height: 12),

          // Transactions List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "No transactions found matching query",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final txn = filteredList[index];
                      final isSuccess = txn.status == "success";
                      final isExpired = txn.status == "expired";

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: InkWell(
                          onTap: () => _showTransactionDetails(txn),
                          borderRadius: BorderRadius.circular(16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Icon Circle Indicator
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSuccess
                                        ? Colors.green.shade50
                                        : isExpired
                                        ? Colors.amber.shade50
                                        : Colors.red.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isSuccess
                                        ? Icons.check_circle_outline
                                        : isExpired
                                        ? Icons.history
                                        : Icons.error_outline,
                                    color: isSuccess
                                        ? Colors.green.shade600
                                        : isExpired
                                        ? Colors.amber.shade700
                                        : Colors.red.shade600,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Txn Info Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        txn.userName ?? 'Unknown User',
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        txn.planName ?? 'Standard Plan',
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(
                                              color: Colors.grey.shade600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        txn.transactionId ?? 'TXN-N/A',
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Amount & Status Chip Column
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₹${txn.amount ?? 0.0}",
                                      style: theme.textTheme.titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isSuccess
                                                ? theme.colorScheme.primary
                                                : Colors.grey.shade800,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSuccess
                                            ? Colors.green.shade50
                                            : isExpired
                                            ? Colors.amber.shade50
                                            : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        txn.status?.toUpperCase() ?? 'PENDING',
                                        style: TextStyle(
                                          color: isSuccess
                                              ? Colors.green.shade700
                                              : isExpired
                                              ? Colors.amber.shade800
                                              : Colors.red.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}
