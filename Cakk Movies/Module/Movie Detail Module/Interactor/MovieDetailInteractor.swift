//
//  MovieDetailInteractor.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

protocol MovieDetailInteractor {
    var presenter: MovieDetailPresenter? { get set }
    
    func getMovieDetail(id: String)
    func getMovieReview(id: String)
    func getMovieTrailer(id: String)
}

class MovieDetailInteractors: MovieDetailInteractor {
    var presenter: MovieDetailPresenter?
    
    func getMovieDetail(id: String) {
        let repo = CARequestService<MovieDetailBodyResponse>()
        repo.request(api: "/movie/\(id)", path: "", onSuccess: { (response) in
            self.presenter?.onGetMovieDetail(with: .success(response))
        }) { (error) in
            self.presenter?.onGetMovieDetail(with: .failure(error))
        }
    }
    
    func getMovieReview(id: String) {
        let repo = CARequestService<MovieReviewBodyResponse>()
        repo.request(api: "/movie/\(id)/reviews", path: "", onSuccess: { (response) in
            self.presenter?.onGetMovieReview(with: .success(response))
        }) { (error) in
            self.presenter?.onGetMovieReview(with: .failure(error))
        }
    }
    
    func getMovieTrailer(id: String) {
        let repo = CARequestService<MovieTrailerBodyResponse>()
        repo.request(api: "/movie/\(id)/videos", path: "", onSuccess: { (response) in
            self.presenter?.onGetMovieTrailer(with: .success(response))
        }) { (error) in
            self.presenter?.onGetMovieTrailer(with: .failure(error))
        }
    }
}
