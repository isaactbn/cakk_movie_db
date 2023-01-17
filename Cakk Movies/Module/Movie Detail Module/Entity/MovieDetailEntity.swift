//
//  MovieDetailEntity.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

//MARK: -FOR MOVIE DETAIL
struct MovieDetailBodyResponse: Codable {
    let adult: Bool
    let backdrop_path: String
    let id: Int
    let imdb_id: String
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Float
    let poster_path: String
    let release_date: String
    let revenue: Int
    let runtime: Int
    let title: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}

//MARK: -FOR MOVIE REVIEW
struct MovieReviewBodyResponse: Codable {
    let id: Int
    let page: Int
    let results: [ReviewResult]?
    let total_pages: Int
    let total_results: Int
}

struct ReviewResult: Codable {
    let author: String
    let author_details: AuthorModel?
    let content: String
    let created_at: String
    let id: String
    let updated_at: String
    let url: String
}

struct AuthorModel: Codable {
    let name: String
    let username: String
    let avatar_path: String
    let rating: Float
}

//MARK: -FOR MOVIE TRAILER
struct MovieTrailerBodyResponse: Codable {
    let id: Int
    let results: [TrailerResult]?
}

struct TrailerResult: Codable {
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let id: String
}
