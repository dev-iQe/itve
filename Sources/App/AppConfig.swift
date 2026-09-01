import Foundation

/// إعدادات عامة للتطبيق.
///
/// ملاحظة مهمة: بيانات الأفلام/المسلسلات (الصور، التقييمات، الوصف) تأتي من TMDB
/// لأغراض العرض والتصفح فقط. أما التشغيل الفعلي فيتم حصراً عبر موقع الشركة
/// الخاص بكم (siteBaseURL)، عبر فتح صفحة بحث بعنوان العمل داخل WebView.
enum AppConfig {

    /// رابط موقع الأفلام الفعلي الذي تملكه الشركة. غيّره إلى الرابط الحقيقي.
    static let siteBaseURL = "https://www.themoviedb.org"

    /// يبني رابط بحث على موقع الشركة باسم العمل (فيلم/مسلسل).
    static func searchURL(for title: String) -> URL? {
        guard var comps = URLComponents(string: siteBaseURL) else { return nil }
        comps.path = "/"
        comps.queryItems = [URLQueryItem(name: "s", value: title)]
        return comps.url
    }

    // MARK: - بيانات التطبيق / المطوّر (تظهر في شاشتي "الإعدادات" و"مطور التطبيق")

    static let appName = "MoviesApp"
    static let appVersion = "1.0.0"

    /// غيّر هذه القيم لتعرض بيانات المطوّر الفعلية.
    static let developerName = "انور العزاوي / Dev"
    static let developerEmail = "devazawy@gmail.com"
    static let developerWebsite = "https://www.instagram.com/eng_azawy"
}
