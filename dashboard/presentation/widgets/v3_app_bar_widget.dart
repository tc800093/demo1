import 'package:flutter/material.dart';

class V3AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String accountType;
  final String userName;
  final String title;
  const V3AppBarWidget({
    super.key,
    required this.accountType,
    required this.userName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (accountType == '2' || accountType == '3') {
      return AppBar(
        backgroundColor: theme.colorScheme.primary,
        iconTheme: theme.iconTheme.copyWith(color: Colors.white),
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          // Padding(
          //   padding: .only(right: 16.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       shape: .circle,
          //       border: Border.all(
          //         color: Colors.blue.withValues(alpha: 0.2),
          //         width: 2,
          //       ),
          //       color: Colors.white,
          //     ),
          //     child: IconButton(
          //       icon: accountType == '3'
          //           ? Stack(
          //               children: [
          //                 const Icon(
          //                   Icons.notifications_none,
          //                   color: Colors.blueAccent,
          //                 ),
          //                 Positioned(
          //                   top: 2,
          //                   right: 2,
          //                   child: Container(
          //                     width: 8,
          //                     height: 8,
          //                     decoration: const BoxDecoration(
          //                       color: Colors.red,
          //                       shape: BoxShape.circle,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             )
          //           : const Icon(
          //               Icons.settings_outlined,
          //               color: Colors.blueAccent,
          //             ),
          //       onPressed: () {},
          //     ),
          //   ),
          // ),
        ],
      );
    } else {
      return AppBar(
        // backgroundColor: const Color(0xFFF4F7FB),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dashboard',
                  style: theme.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 16.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       border: Border.all(
          //         color: Colors.blue.withValues(alpha: 0.2),
          //         width: 2,
          //       ),
          //       color: Colors.white,
          //     ),
          //     child: IconButton(
          //       icon: const Icon(Icons.notifications_none, color: Colors.blue),
          //       onPressed: () {},
          //     ),
          //   ),
          // ),
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
