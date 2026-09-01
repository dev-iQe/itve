import UIKit

final class HeroCell: UICollectionViewCell {
    static let reuseID = "HeroCell"

    var onPlay: (() -> Void)?
    var onInfo: (() -> Void)?

    private let imageView = UIImageView()
    private let gradient = CAGradientLayer()
    private let titleLabel = UILabel()
    private let metaLabel = UILabel()
    private let overviewLabel = UILabel()
    private let playButton = UIButton(configuration: .filled())
    private let infoButton = GlassIconButton(systemImage: "info.circle", pointSize: 18)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        gradient.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.55).cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 0.55, 1]
        imageView.layer.addSublayer(gradient)

        titleLabel.font = .systemFont(ofSize: 30, weight: .black)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        metaLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        metaLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        metaLabel.textAlignment = .center

        overviewLabel.font = .systemFont(ofSize: 13, weight: .regular)
        overviewLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        overviewLabel.numberOfLines = 2
        overviewLabel.textAlignment = .center

        var playConfig = UIButton.Configuration.filled()
        playConfig.title = "تشغيل"
        playConfig.image = UIImage(systemName: "play.fill")
        playConfig.imagePadding = 6
        playConfig.baseBackgroundColor = .white
        playConfig.baseForegroundColor = .black
        playConfig.cornerStyle = .capsule
        playButton.configuration = playConfig
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)

        infoButton.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, metaLabel, overviewLabel])
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.alignment = .center

        let buttonsStack = UIStackView(arrangedSubviews: [infoButton, playButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [textStack, buttonsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            mainStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -24),
            mainStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),

            playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 130),
            playButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = imageView.bounds
    }

    func configure(with item: MediaItem) {
        titleLabel.text = item.title
        metaLabel.text = "\(item.year)  ·  ⭐️ \(item.ratingText)"
        overviewLabel.text = item.overview
        ImageLoader.shared.load(item.backdropURL(width: 1280), into: imageView)
    }

    @objc private func playTapped() { onPlay?() }
    @objc private func infoTapped() { onInfo?() }
}
