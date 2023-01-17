//
//  MovieDetailRouter.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation
import UIKit

typealias MovieDetailEntryPoint = MovieDetailView & BaseVC

protocol MovieDetailRouter {
    var entry: MovieDetailEntryPoint? { get }
    
    static func start(id: String, navTitle: String) -> MovieDetailRouter
}

class MovieDetailRouters: MovieDetailRouter {
    var entry: MovieDetailEntryPoint?
    
    static func start(id: String, navTitle: String) -> MovieDetailRouter {
        let router = MovieDetailRouters()
        
        // Assign VIP
        var view: MovieDetailView = MovieDetailVC()
        var presenter: MovieDetailPresenter = MovieDetailPresentation()
        var interactor: MovieDetailInteractor = MovieDetailInteractors()
        
        view.onLoading()
        view.presenter = presenter
//        view.id = id
        view.navTitle = navTitle
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.id = id
        presenter.view = view as? MovieDetailVC
        presenter.interactor = interactor
        
        router.entry = view as? MovieDetailEntryPoint
        
        return router
    }
    
}
