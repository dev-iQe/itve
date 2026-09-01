import Foundation

/// عنصر موحّد يمثل فيلماً أو مسلسلاً، بغض النظر عن شكل استجابة TMDB الأصلية.
struct MediaItem: Hashable {
    enum MediaType: String {
        case movie, tv
    }

    let id: Int
    let mediaType: MediaType
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let dateString: String?
    let voteAverage: Double

    var year: String {
        guard let d = dateString, d.count >= 4 else { return "—" }
        return String(d.prefix(4))
    }

    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }

    func posterURL(width: Int = 342) -> URL? {
        guard let p = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w\(width)\(p)")
    }

    func backdropURL(width: Int = 780) -> URL? {
        guard let p = backdropPath ?? posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w\(width)\(p)")
    }
}

struct TMDBPagedResponse<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

struct TMDBMovieDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

    func toMediaItem() -> MediaItem {
        MediaItem(id: id, mediaType: .movie, title: title, overview: overview,
                  posterPath: posterPath, backdropPath: backdropPath,
                  dateString: releaseDate, voteAverage: voteAverage ?? 0)
    }
}

struct TMDBShowDTO: Decodable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
    }

    func toMediaItem() -> MediaItem {
        MediaItem(id: id, mediaType: .tv, title: name, overview: overview,
                  posterPath: posterPath, backdropPath: backdropPath,
                  dateString: firstAirDate, voteAverage: voteAverage ?? 0)
    }
}

/// عنصر من نتائج البحث المُختلط (search/multi) الذي قد يكون فيلماً أو مسلسلاً أو شخصاً.
struct TMDBMultiDTO: Decodable {
    let id: Int
    let mediaType: String
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case title, name, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
    }

    func toMediaItem() -> MediaItem? {
        guard mediaType == "movie" || mediaType == "tv" else { return nil }
        let type: MediaItem.MediaType = mediaType == "movie" ? .movie : .tv
        return MediaItem(id: id, mediaType: type,
                          title: title ?? name ?? "",
                          overview: overview ?? "",
                          posterPath: posterPath, backdropPath: backdropPath,
                          dateString: releaseDate ?? firstAirDate,
                          voteAverage: voteAverage ?? 0)
    }
}
