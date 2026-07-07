import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/routes/app_route_paths.dart';

/// "Add Power Source" button shown at the bottom of the power sources section.
class AddSourceButton extends StatelessWidget {
  final String userId;
  const AddSourceButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        context.pushNamed(
          adminAddDeviceScreen,
          extra: UserDeviceEditOrAdd(userID: userId, isEdit: false),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Power Source'),
    );
  }
}
