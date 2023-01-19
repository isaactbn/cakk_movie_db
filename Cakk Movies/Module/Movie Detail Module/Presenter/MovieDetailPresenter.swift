//
//  MovieDetailPresenter.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

protocol MovieDetailPresenter {
    var router: MovieDetailRouter? { get set }
    var interactor: MovieDetailInteractor? { get set }
    var view: MovieDetailVC? { get set }
    var id: String {get set}
    
    func onGetMovieDetail(with result: Result<MovieDetailBodyResponse, Error>)
    func onGetMovieReview(with result: Result<MovieReviewBodyResponse, Error>)
    func onGetMovieTrailer(with result: Result<MovieTrailerBodyResponse, Error>)
}

class MovieDetailPresentation: MovieDetailPresenter {
    var router: MovieDetailRouter?
    
    var id: String = ""
    
    var interactor: MovieDetailInteractor? {
        didSet {
            view?.onLoading()
            interactor?.getMovieDetail(id: id)
            interactor?.getMovieReview(id: id)
            interactor?.getMovieTrailer(id: id)
        }
    }
     
    var view: MovieDetailVC?
    
    func onGetMovieDetail(with result: Result<MovieDetailBodyResponse, Error>) {
        switch result {
        case.success(let output):
            
            let model = MovieDetailBodyResponse(adult: output.adult, backdrop_path: output.backdrop_path, id: output.id, imdb_id: output.imdb_id, original_language: output.original_language, original_title: output.original_title, overview: output.overview, popularity: output.popularity, poster_path: output.poster_path, release_date: output.release_date, revenue: output.revenue, runtime: output.runtime, title: output.title, video: output.video, vote_average: output.vote_average, vote_count: output.vote_count)
            
            view?.update(with: model)
        case .failure:
            view?.onFinishLoading()
            view?.update(with: "Something went wrong")
        }
    }
    
    func onGetMovieReview(with result: Result<MovieReviewBodyResponse, Error>) {
        switch result {
        case.success(let output):
            
            var reviewModel: [ReviewResult] = []
            output.results?.forEach{ (data) in
                let result = ReviewResult(author: data.author, author_details: data.author_details, content: data.content, created_at: data.created_at, id: data.id, updated_at: data.updated_at, url: data.url)
                reviewModel.append(result)
            }
            
            let model = MovieReviewBodyResponse(id: output.id, page: output.page, results: reviewModel, total_pages: output.total_pages, total_results: output.total_results)
            
            view?.updateReview(with: model)
        case .failure:
            view?.onFinishLoading()
            view?.updateReview(with: "Something went wrong")
        }
    }
    
    func onGetMovieTrailer(with result: Result<MovieTrailerBodyResponse, Error>) {
        switch result {
        case.success(let output):
            
            var trailerModel: [TrailerResult] = []
            output.results?.forEach{ (data) in
                let result = TrailerResult(name: data.name, key: data.key, site: data.site, size: data.size, type: data.type, id: data.id)
                trailerModel.append(result)
            }
            
            let model = MovieTrailerBodyResponse(id: output.id, results: trailerModel)
            
            view?.onFinishLoading()
            view?.updateTrailer(with: model)
        case .failure(let err as NSError):
            DispatchQueue.main.async {
                if err.code == 523 {
                    self.view?.onFinishLoading()
                    self.view?.connectionError(with: err.code)
                } else {
                    self.view?.onFinishLoading()
                    self.view?.showError(msg: "Something went wrong")
                }
            }
        }
    }
}
