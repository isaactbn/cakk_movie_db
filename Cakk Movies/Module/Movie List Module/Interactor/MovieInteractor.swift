//
//  MovieInteractor.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

protocol MovieInteractor {
    var presenter: MoviePresenter? { get set }
    
    func getMovieList(id: String, page: Int)
}

class MovieInteractors: MovieInteractor {
    var presenter: MoviePresenter?
    
    func getMovieList(id: String, page: Int) {
        let repo = CARequestService<MovieBodyResponse>()
        let path = page == 0 ? "&with_genres=\(id)" : "&with_genres=\(id)&page=\(page)"
        repo.request(api: "/discover/movie", path: path, onSuccess: { (response) in
            self.presenter?.onGetMovieList(with: .success(response))
        }) { (error) in
            self.presenter?.onGetMovieList(with: .failure(error))
        }
    }
}
     
