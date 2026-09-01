import Foundation

enum TMDBError: Error {
    case missingAPIKey
    case badResponse
}

/// طبقة الاتصال بـ TMDB API لجلب بيانات الأفلام/المسلسلات (للعرض فقط).
/// مفتاح الـ API يُقرأ من Info.plist، ويُحقن أثناء البناء عبر GitHub Secrets
/// (راجع README لمعرفة كيفية إضافته).
final class TMDBService {
    static let shared = TMDBService()

    private let apiKey: String
    private let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    private init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDBAPIKey") as? String ?? ""
    }

    private func makeURL(path: String, query: [String: String] = [:]) -> URL {
        var comps = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        var items = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "ar")
        ]
        for (key, value) in query {
            items.append(URLQueryItem(name: key, value: value))
        }
        comps.queryItems = items
        return comps.url!
    }

    private func fetch<T: Decodable>(_ url: URL) async throws -> T {
        guard !apiKey.isEmpty else { throw TMDBError.missingAPIKey }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw TMDBError.badResponse
        }
        return try decoder.decode(T.self, from: data)
    }

    func trendingMovies(page: Int = 1) async throws -> [MediaItem] {
        let url = makeURL(path: "trending/movie/day", query: ["page": "\(page)"])
        let paged: TMDBPagedResponse<TMDBMovieDTO> = try await fetch(url)
        return paged.results.map { $0.toMediaItem() }
    }

    func trendingShows(page: Int = 1) async throws -> [MediaItem] {
        let url = makeURL(path: "trending/tv/day", query: ["page": "\(page)"])
        let paged: TMDBPagedResponse<TMDBShowDTO> = try await fetch(url)
        return paged.results.map { $0.toMediaItem() }
    }

    func popularMovies(page: Int = 1) async throws -> [MediaItem] {
        let url = makeURL(path: "movie/popular", query: ["page": "\(page)"])
        let paged: TMDBPagedResponse<TMDBMovieDTO> = try await fetch(url)
        return paged.results.map { $0.toMediaItem() }
    }

    func popularShows(page: Int = 1) async throws -> [MediaItem] {
        let url = makeURL(path: "tv/popular", query: ["page": "\(page)"])
        let paged: TMDBPagedResponse<TMDBShowDTO> = try await fetch(url)
        return paged.results.map { $0.toMediaItem() }
    }

    func search(query: String, page: Int = 1) async throws -> [MediaItem] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }
        let url = makeURL(path: "search/multi", query: ["query": query, "page": "\(page)"])
        let paged: TMDBPagedResponse<TMDBMultiDTO> = try await fetch(url)
        return paged.results.compactMap { $0.toMediaItem() }
    }
}
