enum PhoneValidationError {
  empty,
  invalidCharacter,
  invalidPrefix,
  invalidLength
}

class PhoneValidationResult {
  final bool isValid;
  final PhoneValidationError? error;

  const PhoneValidationResult({
    required this.isValid,
    this.error
  });

  const PhoneValidationResult.valid()
    : isValid = true,
    error = null;

  const PhoneValidationResult.invalid(this.error)
    : isValid = false;
}

class PhoneNumberValidator {
  static PhoneValidationResult validate(String phoneNumber) {
    final phone = phoneNumber.trim();

    if (phone.isEmpty) {
      return PhoneValidationResult.invalid(
        PhoneValidationError.empty
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return PhoneValidationResult.invalid(
        PhoneValidationError.invalidCharacter
      );
    }

    if (phone.length > 2 && !phone.startsWith("08")) {
      return PhoneValidationResult.invalid(
        PhoneValidationError.invalidPrefix
      );
    }

    if (phone.length <= 8) {
      return PhoneValidationResult.invalid(
        PhoneValidationError.invalidLength
      );
    }

    return PhoneValidationResult.valid();
  }
}