//
//  MovieViewVC.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import UIKit
import Kingfisher

protocol MovieView: BaseView {
    var presenter: MoviePresenter? { get set }
    var id: String {get set}
    var navTitle: String {get set}
    
    func update(with movies: MovieBodyResponse)
    func update(with error: String)
}

class MovieViewVC: BaseVC, MovieView {
    
    @IBOutlet weak var movieCollection: UICollectionView!
    
    var movies: [MovieResult]? = []
    
    var presenter: MoviePresenter?
    
    var navTitle: String = ""
    var id: String = ""
    var currentPage = 1
    var totalPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        setupNavBarSquareArrow(title: "\(navTitle) Movies", back: backToPreviousVC)
    }
    
    private func setupCollection() {
        movieCollection.delegate = self
        movieCollection.dataSource = self
        movieCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        movieCollection.reloadData()
    }
    
    func update(with movies: MovieBodyResponse) {
        DispatchQueue.main.async {
            self.currentPage = movies.page
            self.totalPage = movies.total_pages
            if self.currentPage <= 1 {
                self.movies = movies.results ?? []
            } else {
                movies.results?.forEach{ (data) in
                    self.movies?.append(data)
                }
            }
            
            
            self.movieCollection.reloadData()
        }
    }
    
    func update(with error: String) {
        print(error)
    }
}

extension MovieViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if currentPage < totalPage {
                currentPage += 1
                presenter?.interactor?.getMovieList(id: id, page: currentPage)
            }
            self.movieCollection.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: ((collectionView.frame.width / 5) - 20), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let resourceImage = ImageResource(downloadURL: URL(string: movies?[indexPath.row].poster_path.setURL() ?? "")!)
        cell.backgroundImage.kf.setImage(with: resourceImage, options: [.forceRefresh])
        cell.titleLabel.text = movies?[indexPath.row].original_title
        cell.descLabel.text = movies?[indexPath.row].release_date
        
        cell.viewWrapper.tapGesture{
            let id = self.movies?[indexPath.row].id.codingKey.stringValue ?? ""
            let movieRouter = MovieDetailRouters.start(id: id, navTitle: self.movies?[indexPath.row].title ?? "")
            let vc = movieRouter.entry
            
            self.pushVC(vc as? MovieDetailVC ?? BaseVC())
        }
        
        return cell
    }
}
