import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smile_cell/component/tab_bar_section.dart';
import 'package:smile_cell/data/models/bill_model.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({
    super.key,
    required this.category
  });

  final BillCategory category;

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> 
  with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _query = ""; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onQueryChanged);
    super.dispose();
  }

  void _onQueryChanged() {
    final next = _searchController.text.trim().toLowerCase();
    if (next == _query) return;
    setState(() {
      _query = next;
    });
  }

  List<Biller> get _filteredBiller {
    if (_query.isEmpty) return widget.category.billers;
    return widget.category.billers
      .where((bill) => bill.name.toLowerCase().contains(_query))
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          category.title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600
          ),  
        ),
        centerTitle: true,
        elevation: 0.0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_rounded)
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), 
          child: Divider(height: 1.0, thickness: 1.0, color: Color(0xFFDDDDDD),)
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SearchField(controller: _searchController),
            TabBarSection(
              controller: _tabController,
              tabs: ["Pilih Layanan", "Tersimpan"]
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BillerList(
                    billers: _filteredBiller,
                    onTap: (biller) => category.onBillerSelected(context, biller),
                  ),
                  _SavedList(
                    bills: [],
                    onTap: null,
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          hintText: "Cari penyedia layanan/tagihan",
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: Colors.black.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.0),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8.0),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Colors.black.withValues(alpha: 0.6),
              size: 20.0
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          enabledBorder: _border(Color(0xFFDDDDDD)),
          focusedBorder: _border(Theme.of(context).colorScheme.primary),
          border: _border(Color(0xFFDDDDDD))
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: color, width: 1.0)
  );
}

class _BillerList extends StatelessWidget {
  const _BillerList ({
    required this.billers, 
    required this.onTap,
  });

  final List<Biller> billers;
  final void Function(Biller) onTap;

  @override
  Widget build(BuildContext context) {
    if (billers.isEmpty) {
      return Center(
        child: Text(
          "Penyedia layanan tidak ditemukan"
        ),
      );
    } 
    
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: billers.length,
      separatorBuilder: (_, __) => Divider(height: 1.0, thickness: 1.0, color: Color(0xFFDDDDDD)), 
      itemBuilder: (context, index) {
        final biller = billers[index];
        return _BillerTile(
          biller: biller,
          onTap: onTap,
        );
      }, 
    );
  }
}

class _BillerTile extends StatelessWidget {
  const _BillerTile ({
    required this.biller, 
    required this.onTap
  });

  final Biller biller;
  final void Function(Biller) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(biller),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            spacing: 16.0,
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/${biller.logoAsset}",
                  width: 32.0,
                  height: 32.0,
                  semanticLabel: "Logo PDAM",
                ),
              ),
              Expanded(
                child: Text(
                  biller.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                  )
                )
              )
            ],
          ),
        )
      ),
    );
  }  
}

class _SavedList extends StatelessWidget {
  const _SavedList ({
    required this.bills, 
    required this.onTap,
  });

  final List<SavedBill> bills;
  final void onTap;

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) {
      return Center(
        child: Text(
          "Tagihan tersimpan tidak ditemukan"
        ),
      );
    }

    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        itemCount: bills.length,
        separatorBuilder: (_, __) => Divider(height: 1.0, thickness: 1.0, color: Color(0xFFDDDDDD)), 
        itemBuilder: (context, index) {
          final bill = bills[index];
          return _SavedTile(
            bill: bill,
            onTap: onTap
          );
        }, 
      )
    );
  }
}

class _SavedTile extends StatelessWidget {
  const _SavedTile ({
    required this.bill,
    required this.onTap
  });

  final SavedBill bill;
  final void onTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(bill.id),
      endActionPane: ActionPane(
        motion: ScrollMotion(), 
        extentRatio: 0.3,
        children: [
          SlidableAction(
            flex: 1,
            onPressed: null,
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: "Delete"
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: null,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 16.0,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/${bill.biller.logoAsset}",
                          width: 40.0,
                          height: 40.0,
                          semanticLabel: "Logo PDAM",
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill.numberBill,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            bill.biller.name,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withValues(alpha: 0.6)
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(9999)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Text(
                    "Cek Tagihan",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}