//
//  GenreEntity.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

struct GenreBodyResponse: Codable {
    let genres: [GenreBodyFullResponse]?
}

struct GenreBodyFullResponse: Codable {
    let id: Int
    let name: String
}
