import "package:flutter/material.dart";
import "package:smile_cell/component/activity_tile.dart";
import "package:smile_cell/component/tab_bar_section.dart";
import "package:smile_cell/config/transaction_config.dart";
import "package:smile_cell/data/models/transaction_model.dart";

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          "Aktivitas",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0.0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFDDDDDD),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBarSection(
              controller: _tabController,
              tabs: const ["Riwayat", "Berlangsung"],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _HistoryList(
                    transactions: getHistoryTransactions(dummyTransactions),
                  ),
                  _OngoingList(
                    transactions: getPendingTransactions(dummyTransactions),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.transactions});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const _EmptyActivityState(
        message: "Belum ada riwayat transaksi",
      );
    }

    final grouped = groupByMonth(transactions);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
      children: [
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          for (final transaction in entry.value) ...[
            ActivityTile(transaction: transaction, onTap: () {}),
            const SizedBox(height: 10.0),
          ],
          const SizedBox(height: 10.0),
        ],
      ],
    );
  }
}

class _OngoingList extends StatelessWidget {
  const _OngoingList({required this.transactions});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const _EmptyActivityState(
        message: "Belum ada transaksi berlangsung",
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
      itemBuilder: (context, index) {
        return ActivityTile(transaction: transactions[index], onTap: () {});
      },
    );
  }
}

class _EmptyActivityState extends StatelessWidget {
  const _EmptyActivityState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}