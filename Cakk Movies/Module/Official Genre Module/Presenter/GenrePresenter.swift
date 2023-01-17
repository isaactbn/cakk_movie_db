//
//  GenrePresenter.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

protocol GenrePresenter {
    var router: GenreRouter? { get set }
    var interactor: GenreInteractor? { get set }
    var view: GenreView? { get set }
    
    func onGetGenreList(with result: Result<GenreBodyResponse, Error>)
}

class GenrePresentation: GenrePresenter {
    var router: GenreRouter?
    
    var interactor: GenreInteractor? {
        didSet {
            interactor?.getGenreList()
        }
    }
     
    var view: GenreView?
    
    func onGetGenreList(with result: Result<GenreBodyResponse, Error>) {
        switch result {
        case.success(let output):
            var model: [GenreBodyFullResponse] = []
            
            output.genres?.forEach{ (data) in
                let newModel = GenreBodyFullResponse(id: data.id, name: data.name)
                model.append(newModel)
            }
            
            view?.onFinishLoading()
            view?.update(with: model)
        case .failure:
            view?.onFinishLoading()
            view?.update(with: "Something went wrong")
        }
    }
}
