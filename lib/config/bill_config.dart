import 'package:flutter/material.dart';
import 'package:smile_cell/data/models/bill_model.dart';
import 'package:smile_cell/helpers/navigation.dart';
import 'package:smile_cell/pages/bill_screen.dart';
import 'package:smile_cell/pages/input_bill_screen.dart';

// ====================
// Biller Data
// ====================

const _pdamBiller = <Biller>[
  Biller(
    id: 'pdam-bandung', 
    name: 'PDAM Bandung', 
    logoAsset: 'pdam-logo.png',
    rule: BillerInputRule(minLength: 5, maxLength: 12)
  ),
  Biller(
    id: 'pdam-surakarta', 
    name: 'PDAM Surakarta', 
    logoAsset: 'pdam-logo.png',
    rule: BillerInputRule(minLength: 5, maxLength: 12)
  ),
  Biller(
    id: 'pdam-sukoharjo', 
    name: 'PDAM Sukoharjo', 
    logoAsset: 'pdam-logo.png',
    rule: BillerInputRule(minLength: 5, maxLength: 12)
  ),
];

const _plnBiller = <Biller>[
  Biller(
    id: 'pln-prabayar', 
    name: 'PLN Prabayar', 
    logoAsset: 'pln-logo.png',
    rule: BillerInputRule(minLength: 11, maxLength: 12)
  ),
  Biller(
    id: 'pln-pascabayar', 
    name: 'PLN Pascabayar', 
    logoAsset: 'pln-logo.png',
    rule: BillerInputRule(minLength: 11, maxLength: 12)
  ),
  Biller(
    id: 'pln-nontaglis', 
    name: 'PLN Non Taglis', 
    logoAsset: 'pln-logo.png',
    rule: BillerInputRule(minLength: 11, maxLength: 12)
  ),
];

const _bpjsBiller = <Biller>[
  Biller(
    id: 'bpjs-kesehatan', 
    name: 'BPJS Kesehatan', 
    logoAsset: 'bpjs-logo.png',
    rule: BillerInputRule(minLength: 5, maxLength: 12)
  ),
  Biller(
    id: 'bpjs-surakarta', 
    name: 'BPJS Ketenagakerjaan', 
    logoAsset: 'bpjs-ketenagakerjaan-logo.png',
    rule: BillerInputRule(minLength: 5, maxLength: 12)
  ),
  Biller(
    id: 'bpjs-sukoharjo', 
    name: 'BPJS Denda', 
    logoAsset: 'bpjs-logo.png',
    rule: BillerInputRule(minLength: 5, maxLength: 12)
  ),
];

// ====================
// Registry
// ====================

class BillCategories {
  const BillCategories._();

  static final pdam = BillCategory(
    id: 'pdam', 
    title: 'PDAM', 
    billers: _pdamBiller, 
    onBillerSelected: (context, biller) => pushSlide(
      context,
      InputBillScreen(biller: biller)
    ),
  );

  static final pln = BillCategory(
    id: 'pln', 
    title: 'PLN', 
    billers: _plnBiller, 
    onBillerSelected: (context, biller) => pushSlide(
      context,
      InputBillScreen(biller: biller)
    ),
  );

  static final bpjs = BillCategory(
    id: 'bpjs', 
    title: 'BPJS', 
    billers: _bpjsBiller, 
    onBillerSelected: (context, biller) => pushSlide(
      context,
      InputBillScreen(biller: biller)
    ),
  );

  static final all = <BillCategory>[pdam, pln, bpjs];
} 

Future<void> openBillScreen(BuildContext context, BillCategory category) {
  return pushSlide(context, BillScreen(category: category));
}