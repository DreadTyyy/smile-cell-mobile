import 'package:flutter/material.dart';
import 'package:smile_cell/component/feature_box.dart';
import 'package:smile_cell/config/bill_config.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smile_cell/component/transaction_tile.dart';
import "package:smile_cell/config/telco_config.dart";
import "package:smile_cell/data/models/telco_model.dart";
import "package:smile_cell/config/transaction_config.dart";
import "package:smile_cell/data/models/transaction_model.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceHidden = false;
  bool _isTransactionExpanded = false;

  static const _collapsedCount = 3;
  static const _visibleCountWhenExpanded = 6;
  static const _tileHeight = 48.0;
  static const _tileGap = 8.0;

  static const _expandedMaxHeight =
      (_tileHeight * _visibleCountWhenExpanded) +
      (_tileGap * (_visibleCountWhenExpanded - 1));

  List<TransactionModel> get _pendingTransactions =>
      getPendingTransactions(dummyTransactions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset("assets/Vector.png", height: 36.0),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Smile",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Cell",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat pagi,",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Lebron James",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFDDDDDD),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceBox(),
              SizedBox(height: 24.0),
              Text(
                "Top Up",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  FeatureBox(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSmartphoneWifi,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.0,
                    ),
                    title: "Paket Data",
                    onTap: () => openTelcoScreen(context, TelcoType.data),
                  ),
                  SizedBox(width: 16.0),
                  FeatureBox(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedHoldPhone,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.0,
                    ),
                    title: "Paket Pulsa",
                    onTap: () => openTelcoScreen(context, TelcoType.pulsa),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Tagihan",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.0),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  for (final category in BillCategories.all)
                    FeatureBox(
                      icon: Image.asset(
                        "assets/${category.logoAsset}",
                        fit: BoxFit.contain,
                      ),
                      title: category.title,
                      onTap: () => openBillScreen(context, category),
                    ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Transaksi Berlangsung",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16.0),
              _buildTransactionBox(),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          padding: EdgeInsets.all(12.0),
          child: _pendingTransactions.isEmpty
              ? _buildEmptyTransaction()
              : _buildTransactionList(),
        ),
      ),
    );
  }

  Widget _buildEmptyTransaction() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Text(
          "Belum ada transaksi berlangsung",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final pending = _pendingTransactions;
    final hasMore = pending.length > _collapsedCount;

    final visible = _isTransactionExpanded
        ? pending
        : pending.take(_collapsedCount).toList();

    final list = Column(
      children: [
        for (int i = 0; i < visible.length; i++) ...[
          TransactionTile(transaction: visible[i], onTap: () {}),
          if (i < visible.length - 1) SizedBox(height: _tileGap),
        ],
      ],
    );

    return Column(
      children: [
        if (_isTransactionExpanded && hasMore)
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: _expandedMaxHeight),
            child: NotificationListener<OverscrollNotification>(
              onNotification: (notification) => true,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: list,
              ),
            ),
          )
        else
          list,
        if (hasMore) ...[SizedBox(height: 8.0), _buildToggleButton()],
      ],
    );
  }

  Widget _buildToggleButton() {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () =>
            setState(() => _isTransactionExpanded = !_isTransactionExpanded),
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isTransactionExpanded ? "Sembunyikan" : "Lainnya",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 6.0),
              Icon(
                _isTransactionExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Theme.of(context).colorScheme.surface),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Color(0xFF1B6A94),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jumlah Saldo Kamu",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            _isBalanceHidden ? "Rp•••••••" : "Rp100.000",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () => setState(
                              () => _isBalanceHidden = !_isBalanceHidden,
                            ),
                            child: Icon(
                              _isBalanceHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).colorScheme.surface,
                              size: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildBalanceAction(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedPlusSignSquare,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        ),
                        label: "Isi Saldo",
                        onTap: () {},
                      ),
                      SizedBox(width: 20.0),
                      _buildBalanceAction(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedMoneySend02,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        ),
                        label: "Kirim Saldo",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceAction({
    required Widget icon,
    required String label,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            icon,
            SizedBox(height: 6.0),
            Text(label, style: TextStyle(fontSize: 12.0, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}