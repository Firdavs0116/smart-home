class PhoneFormatter {
  // +998901234567 → 998901234567
  static String removeCountryCode(String phone) {
    return phone.replaceAll('+', '');
  }

  // 901234567 → +998901234567
  static String addCountryCode(String phone, String dialCode) {
    if (phone.startsWith('+')) return phone;
    return '$dialCode$phone';
  }

  // +998901234567 → +998 90 123 45 67
  static String formatForDisplay(String phone) {
    if (!phone.startsWith('+998')) return phone;
    
    final digits = phone.substring(4); // Remove +998
    if (digits.length != 9) return phone;
    
    return '+998 ${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 7)} ${digits.substring(7)}';
  }

  // Validate Uzbekistan phone number
  static bool isValidUzbekPhone(String phone) {
    // Remove all non-digit characters
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    // Should be 12 digits (998 + 9 digits)
    if (cleaned.length != 12) return false;
    
    // Should start with 998
    if (!cleaned.startsWith('998')) return false;
    
    // Second part should start with 9 (mobile)
    final mobileCode = cleaned.substring(3, 4);
    return mobileCode == '9';
  }
}