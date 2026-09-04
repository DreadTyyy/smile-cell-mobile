import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(
      icon: HugeIcons.strokeRoundedHome03,
      label: "Beranda",
    ),
    _NavItem(
      icon: HugeIcons.strokeRoundedReceiptText,
      label: "Aktivitas",
    ),
    _NavItem(
      icon: HugeIcons.strokeRoundedDiscount01,
      label: "Promo",
    ),
    _NavItem(
      icon: HugeIcons.strokeRoundedUser,
      label: "Profil",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (int i = 0; i < _items.length; i++)
              Expanded(child: _buildNavItem(context, i)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final item = _items[index];
    final isActive = index == currentIndex;
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Colors.black.withValues(alpha: 0.4);

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12.0, bottom: 2.0),
            decoration: BoxDecoration(
              gradient: isActive
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        activeColor.withValues(alpha: 0.18),
                        activeColor.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.8],
                    )
                  : null,
              border: isActive
                  ? Border(
                      top: BorderSide(color: activeColor, width: 3.0),
                    )
                  : null,
            ),
            child: HugeIcon(
              icon: item.icon,
              color: isActive ? activeColor : inactiveColor,
              size: 24.0,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? Colors.black : inactiveColor,
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}

class _NavItem {
  final dynamic icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}