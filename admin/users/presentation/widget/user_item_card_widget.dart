import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_provider.dart';
import 'package:provider/provider.dart';

class UserItemCardWidget extends StatelessWidget {
  const UserItemCardWidget({super.key, required this.theme, this.user});
  final UserModel? user;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(20),
        border: .all(color: Colors.grey),
        boxShadow: [],
      ),
      child: InkWell(
        onTap: () {
          context.read<UserDeviceProvider>().fetchSourceInfo(
            deviceID: user!.userId.toString(),
          );
          context.pushNamed(adminUserDetailScreen, extra: user);
        },
        child: Padding(
          padding: .all(15),
          child: Row(
            crossAxisAlignment: .start,
            mainAxisAlignment: .start,
            children: [
              SizedBox(
                child: Row(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .start,
                  children: [
                    SizedBox(
                      child: CircleAvatar(
                        radius: 23,
                        child: Text(
                          user != null && user!.fullName!.isNotEmpty
                              ? user!.fullName![0]
                              : '',
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.width(2)),
                    SizedBox(
                      width: AppSizes.width(60),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            user!.fullName ?? '',
                            maxLines: 2,
                            overflow: .ellipsis,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: .start,
                              children: [
                                Icon(Icons.email, color: theme.primaryColor),
                                SizedBox(width: AppSizes.width(1)),
                                SizedBox(
                                  width: AppSizes.width(52),
                                  child: Text(
                                    user!.email.toString(),
                                    style: theme.textTheme.bodyLarge,
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: .start,
                              children: [
                                Icon(Icons.phone, color: theme.primaryColor),
                                SizedBox(width: AppSizes.width(1)),
                                Text(
                                  user!.mobileNumber ?? '',
                                  style: theme.textTheme.bodyLarge,
                                  maxLines: 2,
                                  overflow: .ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
