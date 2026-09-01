import UIKit

/// زر دائري بخلفية زجاجية، يُستخدم في الأشرطة العلوية. يدعم تعيين
/// `menu` + `showsMenuAsPrimaryAction = true` لعرض قائمة منسدلة أصلية
/// (بنفس مظهر الزجاج الشفاف الذي يوفره النظام تلقائياً لقوائم UIMenu).
final class GlassIconButton: UIButton {
    private let glass = GlassView(cornerRadius: 19)

    init(systemImage: String, pointSize: CGFloat = 15) {
        super.init(frame: .zero)

        glass.isUserInteractionEnabled = false
        glass.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(glass, at: 0)
        NSLayoutConstraint.activate([
            glass.topAnchor.constraint(equalTo: topAnchor),
            glass.leadingAnchor.constraint(equalTo: leadingAnchor),
            glass.trailingAnchor.constraint(equalTo: trailingAnchor),
            glass.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .semibold)
        setImage(UIImage(systemName: systemImage, withConfiguration: symbolConfig), for: .normal)
        tintColor = .white

        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 38).isActive = true
        heightAnchor.constraint(equalToConstant: 38).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
