import 'package:smile_cell/data/models/telco_model.dart';

const phoneProviders = [
  ProviderModel(
    id: TypeProvider.telkomsel,
    name: 'Telkomsel', 
    logoAsset: 'assets/logo-telkomsel-40x40.png', 
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
    logoAsset: 'assets/logo-indosat-40x40.png', 
    prefix: [
    ]
  ),
  ProviderModel(
    id: TypeProvider.xl,
    name: 'XL',
    logoAsset: 'assets/logo-xl-40x40.png', 
    prefix: [
    ]
  ),
  ProviderModel(
    id: TypeProvider.smartfren,
    name: 'Smartfren',
    logoAsset: 'assets/logo-smartfren-40x40.png', 
    prefix: [
    ]
  ),
];