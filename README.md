# MoviesApp

تطبيق iOS بواجهة زجاجية (Liquid Glass): شريط تبويبات سفلي (الرئيسية / أفلام /
مسلسلات / المكتبة / بحث)، وصفحة رئيسية فيها Hero متنقل وصفوف "رائج الآن"،
مع بيانات (صور، تقييمات، أوصاف) من TMDB. **التشغيل الفعلي للفيديو يتم حصراً
عبر موقعكم الخاص** — زر "تشغيل" يفتح صفحة بحث باسم العمل داخل WebView على
موقعكم. لا يوجد أي تجميع لمصادر خارجية أخرى داخل التطبيق.

يُبنى ملف IPA تلقائياً عبر GitHub Actions بدون الحاجة لحاسوب أو Mac.

## 1) قبل الرفع

### أ) رابط موقعكم
في `Sources/App/AppConfig.swift` غيّر:
```swift
static let siteBaseURL = "https://example.com"
```
وتحقق من صيغة رابط البحث (`?s=`) في `searchURL(for:)` لتطابق موقعكم الفعلي.

### ب) مفتاح TMDB (مطلوب لعرض الأفلام والمسلسلات)
1. أنشئ حساباً مجانياً على https://www.themoviedb.org
2. من إعدادات الحساب → API، فعّل واحصل على **API Key (v3 auth)**.
3. في مستودع GitHub اذهب إلى: **Settings → Secrets and variables → Actions → New repository secret**
   - Name: `TMDB_API_KEY`
   - Value: المفتاح الذي حصلت عليه
4. لا تضع المفتاح مباشرة في الكود — الـ workflow يحقنه تلقائياً أثناء البناء.

### ج) Bundle ID
في `project.yml` غيّر:
```yaml
PRODUCT_BUNDLE_IDENTIFIER: com.yourcompany.moviesapp
```

## 2) رفع المشروع من الجوال (بدون حاسوب)
1. أنشئ Repository جديد على GitHub (Public أو Private).
2. **Add file → Upload files**، وارفع كل محتويات هذا المجلد بنفس بنية المجلدات
   (`Sources/`, `.github/workflows/`, `project.yml`, إلخ).
3. لا تنسَ إضافة الـ Secret (الخطوة 1-ب) **قبل** أول تشغيل، وإلا ستظهر الشاشات فارغة.
4. اضغط **Commit changes** — سيشغّل هذا الـ workflow تلقائياً.

## 3) متابعة البناء وتحميل الـ IPA
1. تبويب **Actions** → افتح آخر تشغيل → انتظر ✅.
2. تحت **Artifacts** حمّل `MoviesApp-unsigned-ipa` (zip يحوي `MoviesApp-unsigned.ipa`).

## 4) التوقيع بواسطة ESign
الملف **غير موقّع** (التوقيع يحتاج Apple ID/شهادة خاصة بك لا يمكن تضمينها في كود عام):
1. افتح **ESign** على آيفونك واستورد `MoviesApp-unsigned.ipa`.
2. سجّل دخولك بـ Apple ID الخاص بك واختر **Sign** ثم **Install**.
3. عند ظهور "Untrusted Developer": **الإعدادات → عام → إدارة الجهاز (VPN & Device Management)** ثم وثّق الحساب.

## بنية المشروع
```
Sources/
  App/            AppDelegate, SceneDelegate, MainTabBarController, AppConfig
  Networking/      TMDBService, نماذج البيانات، محمّل الصور
  Data/            تخزين المفضلة (المكتبة) محلياً
  UI/
    Components/    GlassView, GlassIconButton, PosterCell, SectionHeaderView
    Home/          الصفحة الرئيسية (Hero + Trending)
    Catalog/       شاشة أفلام / مسلسلات (شبكة + تصفح صفحات)
    Library/       المكتبة (المفضلة)
    Search/        البحث
    Detail/        تفاصيل العمل + زر تشغيل/إضافة للمكتبة
    Player/        شاشة تشغيل الفيديو (WebView على موقعكم فقط)
```

## ملاحظات
- كل push جديد على `main` يعيد بناء الـ IPA تلقائياً؛ أو استخدم **Run workflow** يدوياً.
- بيانات TMDB لأغراض العرض فقط، حسب شروط استخدام TMDB يُفضّل ذكر أن التطبيق
  "يستخدم TMDB API لكنه غير معتمد أو مصدّق من TMDB" في شاشة إعدادات لاحقاً إن رغبتم.
- الشكل الزجاجي (Liquid Glass) في هذا المشروع مبني بتأثيرات ضبابية قياسية
  (`UIBlurEffect` + حدود شفافة) متوافقة مع كل إصدارات iOS 15+، وليس عبر
  واجهات iOS 26 الحصرية (`UIGlassEffect`) — لتفادي فشل البناء إن لم يتوفر
  Xcode 26 على عامل GitHub Actions.
