import UIKit

/// حاوية بخلفية زجاجية شبه شفافة (تأثير Liquid-Glass) تُستخدم للأزرار
/// والأشرطة العلوية والسفلية. تعتمد على UIVisualEffectView (متوفر منذ iOS 13)
/// مع حدّ رفيع شبه شفاف يعطي لمعان الحافة الزجاجية.
final class GlassView: UIView {
    private let blur: UIVisualEffectView
    private let tint = UIView()

    init(cornerRadius: CGFloat = 20, style: UIBlurEffect.Style = .systemUltraThinMaterialDark) {
        blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        super.init(frame: .zero)

        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        layer.borderWidth = 0.75
        layer.borderColor = UIColor.white.withAlphaComponent(0.18).cgColor

        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: topAnchor),
            blur.leadingAnchor.constraint(equalTo: leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        tint.backgroundColor = UIColor.white.withAlphaComponent(0.04)
        tint.translatesAutoresizingMaskIntoConstraints = false
        blur.contentView.addSubview(tint)
        NSLayoutConstraint.activate([
            tint.topAnchor.constraint(equalTo: blur.contentView.topAnchor),
            tint.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor),
            tint.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor),
            tint.bottomAnchor.constraint(equalTo: blur.contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
