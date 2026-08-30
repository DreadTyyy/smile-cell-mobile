import 'package:flutter/material.dart';

class BillerInputRule {
  const BillerInputRule({
    this.minLength = 4,
    this.maxLength = 12,
  });

  final int minLength;
  final int maxLength;
}

class Biller {
  const Biller({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.rule
  });

  final String id;
  final String name;
  final String logoAsset;
  final BillerInputRule rule;
}

class SavedBill {
  const SavedBill({
    required this.id,
    required this.biller,
    required this.numberBill,
  });

  final String id;
  final Biller biller;
  final String numberBill;
}

class BillCategory {
  const BillCategory({
    required this.id,
    required this.title,
    required this.logoAsset,
    required this.billers,
    required this.onBillerSelected,
    this.searchHint = 'Cari penyedia layanan/tagihan'
  });

  final String id;
  final String title;
  final String logoAsset;
  final List<Biller> billers;
  final void Function(BuildContext context, Biller biller) onBillerSelected;
  final String? searchHint;
}