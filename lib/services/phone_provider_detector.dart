import 'package:smile_cell/config/telco_config.dart';
import 'package:smile_cell/data/models/telco_model.dart';

class PhoneProviderDetector {
  static ProviderModel? detect(
    String phoneNumber
  ) {
    final number = phoneNumber;
    
    for (final telco in phoneProviders) {
      for (final prefix in telco.prefix) {
        if (number.startsWith(prefix)) {
          return telco;
        }
      }
    }

    return null;
  }
}