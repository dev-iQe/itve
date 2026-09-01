import Foundation

struct FavoriteItem: Codable, Hashable {
    let id: Int
    let mediaType: String
    let title: String
    let posterPath: String?
}

/// تخزين محلي بسيط (UserDefaults) لعناصر "المكتبة" التي يحفظها المستخدم.
final class FavoritesStore {
    static let shared = FavoritesStore()

    private let key = "favorites.v1"
    private(set) var items: [FavoriteItem] = []

    private init() { load() }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([FavoriteItem].self, from: data) else { return }
        items = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func isFavorite(id: Int, mediaType: String) -> Bool {
        items.contains { $0.id == id && $0.mediaType == mediaType }
    }

    func toggle(_ item: MediaItem) {
        if isFavorite(id: item.id, mediaType: item.mediaType.rawValue) {
            items.removeAll { $0.id == item.id && $0.mediaType == item.mediaType.rawValue }
        } else {
            items.append(FavoriteItem(id: item.id, mediaType: item.mediaType.rawValue,
                                       title: item.title, posterPath: item.posterPath))
        }
        save()
    }
}
