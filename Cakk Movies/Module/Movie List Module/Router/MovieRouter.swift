//
//  MovieRouter.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation
import UIKit

typealias MovieEntryPoint = MovieView & BaseVC

protocol MovieRouter {
    var entry: MovieEntryPoint? { get }
    
    static func start(id: String, navTitle: String) -> MovieRouter
}

class MovieRouters: MovieRouter {
    var entry: MovieEntryPoint?
    
    static func start(id: String, navTitle: String) -> MovieRouter {
        let router = MovieRouters()
        
        // Assign VIP
        var view: MovieView = MovieViewVC()
        var presenter: MoviePresenter = MoviePresentation()
        var interactor: MovieInteractor = MovieInteractors()
        
        view.onLoading()
        view.presenter = presenter
        view.id = id
        view.navTitle = navTitle
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.id = id
        presenter.view = view as? MovieViewVC
        presenter.interactor = interactor
        
        router.entry = view as? MovieEntryPoint
        
        return router
    }
    
}
