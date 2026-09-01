import UIKit

final class DetailViewController: UIViewController {
    private let item: MediaItem
    private var favButton: UIButton?

    init(item: MediaItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        buildUI()
    }

    private func buildUI() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scroll.topAnchor),
            content.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scroll.widthAnchor)
        ])

        let backdrop = UIImageView()
        backdrop.contentMode = .scaleAspectFill
        backdrop.clipsToBounds = true
        backdrop.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(backdrop)
        ImageLoader.shared.load(item.backdropURL(width: 1280), into: backdrop)

        let backButton = GlassIconButton(systemImage: "chevron.backward")
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(backButton)

        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2

        let metaLabel = UILabel()
        metaLabel.text = "\(item.year)  ·  ⭐️ \(item.ratingText)  ·  \(item.mediaType == .movie ? "فيلم" : "مسلسل")"
        metaLabel.font = .systemFont(ofSize: 14, weight: .medium)
        metaLabel.textColor = UIColor.white.withAlphaComponent(0.7)

        let overviewLabel = UILabel()
        overviewLabel.text = item.overview.isEmpty ? "لا يوجد وصف متاح." : item.overview
        overviewLabel.font = .systemFont(ofSize: 15)
        overviewLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        overviewLabel.numberOfLines = 0

        var playConfig = UIButton.Configuration.filled()
        playConfig.title = "تشغيل"
        playConfig.image = UIImage(systemName: "play.fill")
        playConfig.imagePadding = 8
        playConfig.baseBackgroundColor = .white
        playConfig.baseForegroundColor = .black
        playConfig.cornerStyle = .capsule
        let playButton = UIButton(configuration: playConfig)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)

        let isFav = FavoritesStore.shared.isFavorite(id: item.id, mediaType: item.mediaType.rawValue)
        var favConfig = UIButton.Configuration.tinted()
        favConfig.title = isFav ? "في المكتبة" : "أضف للمكتبة"
        favConfig.image = UIImage(systemName: isFav ? "bookmark.fill" : "bookmark")
        favConfig.imagePadding = 8
        favConfig.baseForegroundColor = .white
        favConfig.cornerStyle = .capsule
        let favButton = UIButton(configuration: favConfig)
        favButton.addTarget(self, action: #selector(favTapped(_:)), for: .touchUpInside)
        self.favButton = favButton

        let buttonsStack = UIStackView(arrangedSubviews: [playButton, favButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.distribution = .fillEqually

        let textStack = UIStackView(arrangedSubviews: [titleLabel, metaLabel, buttonsStack, overviewLabel])
        textStack.axis = .vertical
        textStack.spacing = 12
        textStack.setCustomSpacing(16, after: metaLabel)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(textStack)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: content.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            backdrop.heightAnchor.constraint(equalTo: backdrop.widthAnchor, multiplier: 0.65),

            backButton.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            textStack.topAnchor.constraint(equalTo: backdrop.bottomAnchor, constant: 20),
            textStack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            textStack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            textStack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -32),

            playButton.heightAnchor.constraint(equalToConstant: 46),
            favButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func playTapped() {
        navigationController?.pushViewController(PlayerViewController(url: AppConfig.searchURL(for: item.title)), animated: true)
    }

    @objc private func favTapped(_ sender: UIButton) {
        FavoritesStore.shared.toggle(item)
        let isFav = FavoritesStore.shared.isFavorite(id: item.id, mediaType: item.mediaType.rawValue)
        var config = sender.configuration
        config?.title = isFav ? "في المكتبة" : "أضف للمكتبة"
        config?.image = UIImage(systemName: isFav ? "bookmark.fill" : "bookmark")
        sender.configuration = config
    }
}
