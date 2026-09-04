import 'package:flutter/material.dart';

class TabBarSection extends StatelessWidget {
  const TabBarSection({
    super.key, 
    required this.controller,
    required this.tabs
  });

  final TabController controller;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TabBar(
        controller: controller,
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        tabs: [
          for (final tab in tabs)
            Tab(height: 46, text: tab),
        ]
      ),
    );
  }
}
