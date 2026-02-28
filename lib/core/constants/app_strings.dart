/// All Arabic UI strings — centralized for maintainability
abstract final class AppStrings {
  // ── App ──────────────────────────────────────────────
  static const String appName = 'ميني ستور';

  // ── Auth ─────────────────────────────────────────────
  static const String login = 'تسجيل الدخول';
  static const String welcome = 'مرحباً بك';
  static const String welcomeSubtitle = 'سجّل دخولك للمتابعة';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String phoneNumber = 'رقم الهاتف';
  static const String loginWithEmail = 'الدخول بالبريد الإلكتروني';
  static const String loginWithPhone = 'الدخول برقم الهاتف';
  static const String enterEmail = 'أدخل بريدك الإلكتروني';
  static const String enterPassword = 'أدخل كلمة المرور';
  static const String enterPhone = 'أدخل رقم الهاتف';
  static const String continueText = 'متابعة';
  static const String or = 'أو';

  // ── OTP ──────────────────────────────────────────────
  static const String otpVerification = 'التحقق من الرمز';
  static const String otpSubtitle = 'أدخل رمز التحقق المرسل إلى';
  static const String verifyCode = 'تحقق';
  static const String resendCode = 'إعادة إرسال الرمز';
  static const String didntReceiveCode = 'لم تستلم الرمز؟';

  // ── Home ─────────────────────────────────────────────
  static const String home = 'الرئيسية';
  static const String products = 'المنتجات';
  static const String allCategories = 'الكل';
  static const String searchProducts = 'ابحث عن منتج...';
  static const String featuredProducts = 'منتجات مميزة';
  static const String explore = 'استكشف';
  static const String greeting = 'أهلاً بك 👋';

  // ── Product ──────────────────────────────────────────
  static const String productDetails = 'تفاصيل المنتج';
  static const String price = 'السعر';
  static const String description = 'الوصف';
  static const String addToCart = 'أضف للسلة';
  static const String addedToCart = 'تمت الإضافة للسلة';
  static const String reviews = 'تقييم';

  // ── Categories ───────────────────────────────────────
  static const String electronics = 'إلكترونيات';
  static const String jewelery = 'مجوهرات';
  static const String mensClothing = 'ملابس رجالية';
  static const String womensClothing = 'ملابس نسائية';

  // ── Error / State ────────────────────────────────────
  static const String errorOccurred = 'حدث خطأ';
  static const String retry = 'إعادة المحاولة';
  static const String noInternetConnection = 'لا يوجد اتصال بالإنترنت';
  static const String serverError = 'خطأ في الخادم';
  static const String unexpectedError = 'خطأ غير متوقع';
  static const String loading = 'جاري التحميل...';
  static const String emptyProducts = 'لا توجد منتجات';

  // ── Validation ───────────────────────────────────────
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidEmail = 'بريد إلكتروني غير صالح';
  static const String invalidPhone = 'رقم هاتف غير صالح';
  static const String passwordTooShort = 'كلمة المرور قصيرة جداً';
  static const String invalidOtp = 'رمز التحقق غير صحيح';

  // ── Logout ───────────────────────────────────────────
  static const String logout = 'تسجيل الخروج';
  static const String logoutConfirm = 'هل أنت متأكد من تسجيل الخروج؟';
  static const String yes = 'نعم';
  static const String no = 'لا';
}
