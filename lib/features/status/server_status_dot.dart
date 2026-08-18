import 'package:flutter/material.dart';

import 'server_status.dart';

/// AppBar o'ng tomonidagi holat nuqtasi (PM qarori).
class ServerStatusDot extends StatelessWidget {
  const ServerStatusDot({super.key, required this.controller});
  final ServerStatusController controller;

  static const colors = {
    ServerStatus.ok: Color(0xFF2F9E44),
    ServerStatus.down: Color(0xFFD64545),
    ServerStatus.checking: Color(0xFF9E9E9E),
  };

  static const labels = {
    ServerStatus.ok: 'Server ishlayapti',
    ServerStatus.down: 'Server bilan aloqa yo`q',
    ServerStatus.checking: 'Tekshirilmoqda…',
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final status = controller.status;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Tooltip(
              message: labels[status]!,
              child: Container(
                key: const Key('server_status_dot'),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[status],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
