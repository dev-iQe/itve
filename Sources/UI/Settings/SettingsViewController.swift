import UIKit

final class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        buildUI()
    }

    private func buildUI() {
        let backButton = GlassIconButton(systemImage: "chevron.backward")
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)

        let titleLabel = UILabel()
        titleLabel.text = "الإعدادات"
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white

        let siteRow = makeInfoRow(title: "موقع التشغيل", value: AppConfig.siteBaseURL)
        let versionRow = makeInfoRow(title: "إصدار التطبيق", value: AppConfig.appVersion)

        var clearConfig = UIButton.Configuration.tinted()
        clearConfig.title = "مسح المكتبة (المفضلة)"
        clearConfig.image = UIImage(systemName: "trash")
        clearConfig.imagePadding = 8
        clearConfig.baseForegroundColor = .white
        clearConfig.cornerStyle = .capsule
        let clearButton = UIButton(configuration: clearConfig)
        clearButton.addTarget(self, action: #selector(clearLibraryTapped), for: .touchUpInside)

        let attributionLabel = UILabel()
        attributionLabel.text = "بيانات الأفلام والمسلسلات (الصور، التقييمات، الأوصاف) مقدَّمة عبر TMDB API، ولا يُعدّ هذا التطبيق معتمداً أو مصدّقاً من TMDB."
        attributionLabel.font = .systemFont(ofSize: 12)
        attributionLabel.textColor = UIColor.white.withAlphaComponent(0.45)
        attributionLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, siteRow, versionRow, clearButton, attributionLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.setCustomSpacing(32, after: titleLabel)
        stack.setCustomSpacing(28, after: clearButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            stack.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            clearButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func makeInfoRow(title: String, value: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.5)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 0

        let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        row.axis = .vertical
        row.spacing = 4
        return row
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func clearLibraryTapped() {
        let alert = UIAlertController(title: "مسح المكتبة",
                                       message: "سيتم حذف جميع العناصر المحفوظة في المكتبة. هل تريد المتابعة؟",
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel))
        alert.addAction(UIAlertAction(title: "حذف", style: .destructive) { _ in
            FavoritesStore.shared.clearAll()
        })
        present(alert, animated: true)
    }
}
