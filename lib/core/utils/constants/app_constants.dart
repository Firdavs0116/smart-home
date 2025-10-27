class AppConstants {
  // Firebase Collections
  static const String usersCollection = 'users';
  
  // Phone number format
  static const String defaultCountryCode = 'UZ';
  static const String defaultDialCode = '+998';
  
  // OTP
  static const int otpLength = 6;
  static const Duration otpTimeout = Duration(seconds: 60);
  
  // Error messages
  static const String networkError = "Internet ulanishi yo'q";
  static const String unknownError = "Noma'lum xato yuz berdi";
  static const String invalidPhoneError = "Telefon raqam noto'g'ri";
  static const String invalidOtpError = "SMS kod noto'g'ri";
}