//
//  MovieEntity.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

struct MovieBodyResponse: Codable {
    let page: Int
    let results: [MovieResult]?
    let total_pages: Int
    let total_results: Int
}

struct MovieResult: Codable {
    let adult: Bool
    let backdrop_path: String
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Float
    let poster_path: String
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}

//struct MovieBodyResponse: Codable {
//    let created_by: String
//    let description: String
//    let favorite_count: Int
//    let id: String
//    let items: [MovieItems]?
//    let item_count: Int
//    let iso_639_1: String
//    let name: String
//    let poster_path: String
//}
//
//struct MovieItems: Codable {
//    let adult: Bool
//    let backdrop_path: String
//    let id: Int
//    let media_type: String
//    let original_language: String
//    let original_title: String
//    let overview: String
//    let popularity: Float
//    let poster_path: String
//    let release_date: String
//    let title: String
//    let video: Bool
//    let vote_average: Float
//    let vote_count: Int
//}
