import UIKit

final class DeveloperViewController: UIViewController {

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

        let iconView = UIView()
        iconView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        iconView.layer.cornerRadius = 40
        iconView.layer.cornerCurve = .continuous
        let iconImage = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        iconImage.tintColor = .white
        iconImage.contentMode = .scaleAspectFit
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconView.addSubview(iconImage)
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = AppConfig.developerName
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center

        var emailConfig = UIButton.Configuration.tinted()
        emailConfig.title = AppConfig.developerEmail
        emailConfig.image = UIImage(systemName: "envelope.fill")
        emailConfig.imagePadding = 8
        emailConfig.baseForegroundColor = .white
        emailConfig.cornerStyle = .capsule
        let emailButton = UIButton(configuration: emailConfig)
        emailButton.addTarget(self, action: #selector(emailTapped), for: .touchUpInside)

        var websiteConfig = UIButton.Configuration.tinted()
        websiteConfig.title = AppConfig.developerWebsite
        websiteConfig.image = UIImage(systemName: "globe")
        websiteConfig.imagePadding = 8
        websiteConfig.baseForegroundColor = .white
        websiteConfig.cornerStyle = .capsule
        let websiteButton = UIButton(configuration: websiteConfig)
        websiteButton.addTarget(self, action: #selector(websiteTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [iconView, nameLabel, emailButton, websiteButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.setCustomSpacing(24, after: iconView)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            iconView.widthAnchor.constraint(equalToConstant: 80),
            iconView.heightAnchor.constraint(equalToConstant: 80),
            iconImage.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 48),
            iconImage.heightAnchor.constraint(equalToConstant: 48),

            emailButton.heightAnchor.constraint(equalToConstant: 44),
            websiteButton.heightAnchor.constraint(equalToConstant: 44),

            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func emailTapped() {
        guard let url = URL(string: "mailto:\(AppConfig.developerEmail)") else { return }
        UIApplication.shared.open(url)
    }

    @objc private func websiteTapped() {
        guard let url = URL(string: AppConfig.developerWebsite) else { return }
        UIApplication.shared.open(url)
    }
}
