import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black

        let home = wrap(HomeViewController(), title: "الرئيسية", icon: "house.fill")
        let movies = wrap(CatalogViewController(mode: .movies), title: "أفلام", icon: "film.fill")
        let shows = wrap(CatalogViewController(mode: .tv), title: "مسلسلات", icon: "play.tv.fill")
        let library = wrap(LibraryViewController(), title: "المكتبة", icon: "bookmark.fill")
        let search = wrap(SearchViewController(), title: "بحث", icon: "magnifyingglass")

        viewControllers = [home, movies, shows, library, search]
        configureAppearance()
    }

    private func wrap(_ vc: UIViewController, title: String, icon: String) -> UIViewController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), selectedImage: nil)
        nav.navigationBar.isHidden = true
        nav.overrideUserInterfaceStyle = .dark
        return nav
    }

    /// شريط تبويب زجاجي شفاف (Liquid Glass) عبر UITabBarAppearance + تأثير ضبابي.
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        appearance.shadowColor = .clear

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
    }
}
