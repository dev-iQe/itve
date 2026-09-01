import Foundation

/// إعدادات عامة للتطبيق.
///
/// ملاحظة مهمة: بيانات الأفلام/المسلسلات (الصور، التقييمات، الوصف) تأتي من TMDB
/// لأغراض العرض والتصفح فقط. أما التشغيل الفعلي فيتم حصراً عبر موقع الشركة
/// الخاص بكم (siteBaseURL)، عبر فتح صفحة بحث بعنوان العمل داخل WebView.
enum AppConfig {

    /// رابط موقع الأفلام الفعلي الذي تملكه الشركة. غيّره إلى الرابط الحقيقي.
    static let siteBaseURL = "https://instagram.com/eng_azawy"

    /// يبني رابط بحث على موقع الشركة باسم العمل (فيلم/مسلسل).
    /// الصيغة الافتراضية "?s=" شائعة في مواقع ووردبريس، عدّلها لتطابق
    /// آلية البحث الفعلية في موقعكم إن اختلفت (مثلاً /search/<title>).
    static func searchURL(for title: String) -> URL? {
        guard var comps = URLComponents(string: siteBaseURL) else { return nil }
        comps.path = "/"
        comps.queryItems = [URLQueryItem(name: "s", value: title)]
        return comps.url
    }
}
