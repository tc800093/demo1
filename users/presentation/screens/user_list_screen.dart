import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/common/widgets/customer_header_widget.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_provider.dart';
import 'package:poweriot/features/admin/users/presentation/widget/user_item_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    fetchAllUsers();
    super.initState();
  }

  void fetchAllUsers() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchAllUserMethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(adminAddUserScreen);
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomerHeaderWidget(
              title: AppLocale.customers.getString(context),
              iconData: Icons.person,
            ),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Expanded(
                  child: Padding(
                    padding: .symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children: [
                        CustomTextfieldWidget(
                          controller: searchController,
                          title:
                              ' ${AppLocale.search.getString(context)} ${AppLocale.user.getString(context)}....',
                          onChangedFunction: (v) {
                            context.read<UserProvider>().searchUsers(v);
                          },
                          prefixIconData: Icons.search,
                        ),
                        SizedBox(height: AppSizes.height(2)),
                        userProvider.fetchUserStatus == .success
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: userProvider.userList.length,
                                  itemBuilder: (context, index) {
                                    UserModel user =
                                        userProvider.userList[index];
                                    return UserItemCardWidget(
                                      theme: theme,
                                      user: user,
                                    );
                                  },
                                ),
                              )
                            : SizedBox.shrink(),

                        userProvider.fetchUserStatus == .failed
                            ? Expanded(
                                child: Center(
                                  child: Text(userProvider.message.toString()),
                                ),
                              )
                            : SizedBox.shrink(),
                        userProvider.fetchUserStatus == .loading
                            ? Expanded(
                                child: Skeletonizer(
                                  enabled: true,
                                  child: ListView.builder(
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return UserItemCardWidget(
                                        theme: theme,
                                        user: UserModel(
                                          active: false,
                                          deviceId: "",
                                          email: "",
                                          fullName: "",
                                          mobileNumber: "",
                                          role: "",
                                          userId: "",
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
