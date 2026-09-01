import UIKit

/// محمّل صور بسيط مع ذاكرة تخزين مؤقت (NSCache)، لتحميل بوسترات وخلفيات TMDB.
final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private let session = URLSession.shared

    func load(_ url: URL?, into imageView: UIImageView) {
        imageView.image = nil
        guard let url = url else { return }

        if let cached = cache.object(forKey: url as NSURL) {
            imageView.image = cached
            return
        }

        let token = url.absoluteString
        imageView.accessibilityIdentifier = token

        let task = session.dataTask(with: url) { [weak self, weak imageView] data, _, _ in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                // تأكد أن الخلية لم تُعَد استخدامها لصورة أخرى أثناء التحميل
                guard imageView?.accessibilityIdentifier == token else { return }
                imageView?.image = image
            }
        }
        task.resume()
    }
}
