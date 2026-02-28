/// Form validators for email, phone, password, OTP
abstract final class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!regex.hasMatch(value.trim())) return 'بريد إلكتروني غير صالح';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
    if (value.length < 6) return 'كلمة المرور قصيرة جداً';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
    if (value.trim().length < 8) return 'رقم هاتف غير صالح';
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }
}
