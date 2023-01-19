//
//  MoviePresenter.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

protocol MoviePresenter {
    var router: MovieRouter? { get set }
    var interactor: MovieInteractor? { get set }
    var view: MovieViewVC? { get set }
    var id: String {get set}
    
    func onGetMovieList(with result: Result<MovieBodyResponse, Error>)
}

class MoviePresentation: MoviePresenter {
    var router: MovieRouter?
    
    var id: String = ""
    var currentPage: Int = 1
    
    var interactor: MovieInteractor? {
        didSet {
            view?.onLoading()
            interactor?.getMovieList(id: id, page: currentPage)
        }
    }
     
    var view: MovieViewVC?
    
    func onGetMovieList(with result: Result<MovieBodyResponse, Error>) {
        switch result {
        case.success(let output):
            var item: [MovieResult] = []
            output.results?.forEach{ (data) in
                let newItem = MovieResult(adult: data.adult, backdrop_path: data.backdrop_path, id: data.id, original_language: data.original_language, original_title: data.original_title, overview: data.overview, popularity: data.popularity, poster_path: data.poster_path, release_date: data.release_date, title: data.title, video: data.video, vote_average: data.vote_average, vote_count: data.vote_count)
                item.append(newItem)
            }
            
            let model = MovieBodyResponse(page: output.page, results: item, total_pages: output.total_pages, total_results: output.total_results)
            
            view?.onFinishLoading()
            view?.update(with: model)
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
