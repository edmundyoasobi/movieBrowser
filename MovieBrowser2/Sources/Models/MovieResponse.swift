//
//  MovieResponse.swift
//  MovieBrowser2
//
//  Created by Edmund Cheong on 25/12/2024.
//

import Foundation

// Movie model
struct Movie: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int
    let genreIDs: [Int]
    let popularity: Double
    let adult: Bool
    
    enum CodingKeys: String, CodingKey {
            case id
            case title
            case originalTitle = "original_title"
            case overview
            case releaseDate = "release_date"
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case genreIDs = "genre_ids"
            case popularity
            case adult
        }
}

// Response model
struct MovieResponse: Decodable {
    let dates: DateRange?
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys : String , CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct DateRange: Decodable {
    let maximum: String
    let minimum: String
}

