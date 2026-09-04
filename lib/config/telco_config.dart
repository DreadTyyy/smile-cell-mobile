import 'package:flutter/material.dart';
import 'package:smile_cell/data/models/telco_model.dart';
import 'package:smile_cell/helpers/navigation.dart';
import 'package:smile_cell/pages/telco_screen.dart';

const phoneProviders = [
  ProviderModel(
    id: TypeProvider.telkomsel,
    name: 'Telkomsel', 
    logoAsset: 'logo-telkomsel-40x40.png', 
    prefix: [
      '0811',
      '0812',
      '0813',
      '0821',
      '0822',
      '0823',
      '0851',
      '0852',
      '0853',
    ]
  ),
  ProviderModel(
    id: TypeProvider.indosat,
    name: 'Indosat',  
    logoAsset: 'logo-indosat-40x40.png', 
    prefix: [
      '0814',
      '0815',
      '0816',
      '0855',
      '0856',
      '0857',
      '0858',
    ]
  ),
  ProviderModel(
    id: TypeProvider.xl,
    name: 'XL',
    logoAsset: 'logo-xl-40x40.png', 
    prefix: [
      '0817',
      '0818',
      '0819',
      '0859',
      '0877',
      '0878',
    ]
  ),
  ProviderModel(
    id: TypeProvider.smartfren,
    name: 'Smartfren',
    logoAsset: 'logo-smartfren-40x40.png', 
    prefix: [
      '0881',
      '0882',
      '0883',
      '0884',
      '0885',
      '0886',
      '0887',
      '0888',
      '0889',
    ]
  ),
];

Future<void> openTelcoScreen(BuildContext context, TelcoType type) {
  return pushSlide(context, TelcoScreen(type: type));
}