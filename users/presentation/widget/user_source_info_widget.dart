import 'package:flutter/material.dart';

class DeviceExpansionTile extends StatelessWidget {
  final String deviceName;
  final String serialNumber;

  final bool hasSource1;
  final bool hasSource2;

  final String? source1Name;
  final String? source2Name;

  final VoidCallback? onEdit;

  const DeviceExpansionTile({
    super.key,
    required this.deviceName,
    required this.serialNumber,
    required this.hasSource1,
    required this.hasSource2,
    this.source1Name,
    this.source2Name,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(Icons.memory, color: theme.colorScheme.primary),
        ),
        title: Text(deviceName, style: theme.textTheme.titleMedium),
        subtitle: Text(serialNumber),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          /// Available Sources
          Row(
            children: [
              if (hasSource1)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: const Text("Source 1"),
                    avatar: const Icon(Icons.bolt, size: 18),
                  ),
                ),

              if (hasSource2)
                Chip(
                  label: const Text("Source 2"),
                  avatar: const Icon(Icons.power, size: 18),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (hasSource1)
            _SourceCard(
              title: source1Name ?? "Source 1",
              icon: Icons.bolt,
              status: "Online",
            ),

          if (hasSource2)
            _SourceCard(
              title: source2Name ?? "Source 2",
              icon: Icons.power,
              status: "Online",
            ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;

  const _SourceCard({
    required this.title,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(status),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
