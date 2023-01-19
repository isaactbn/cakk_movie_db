//
//  GenreViewController.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import UIKit
import STPopup

protocol GenreView: BaseView {
    var presenter: GenrePresenter? { get set }
    
    func update(with genres: [GenreBodyFullResponse])
    func connectionError(with error: Int)
    func update(with error: String)
}

class GenreViewController: BaseVC, GenreView {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var genres: [GenreBodyFullResponse]? = []
    
    var presenter: GenrePresenter?
    
    var popUpVC: STPopupController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.showNavigationBar()
    }
    
    private func setupCollection() {
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    func update(with genres: [GenreBodyFullResponse]) {
        DispatchQueue.main.async {
            self.genres = genres
            self.genreCollectionView.reloadData()
        }
    }
    
    func connectionError(with error: Int) {
        let viewController = ConnectionLostVC(nibName: "ConnectionLostVC", bundle: nil)
        self.popUpVC = STPopupController(rootViewController: viewController)
        self.popUpVC?.style = .formSheet
        self.popUpVC?.containerView.backgroundColor = UIColor.clear
        self.popUpVC?.navigationBarHidden = true
        DispatchQueue.main.async {
            self.popUpVC?.present(in: self)
        }
    }
    
    func update(with error: String) {
        print(error)
    }
}

extension GenreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: ((collectionView.frame.width / 5) - 20), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = genres?[indexPath.row].name
        
        cell.viewWrapper.tapGesture{ [self] in
            let id = genres?[indexPath.row].id.codingKey.stringValue ?? ""
            let movieRouter = MovieRouters.start(id: id, navTitle: genres?[indexPath.row].name ?? "")
            let vc = movieRouter.entry
            
            pushVC(vc as? MovieViewVC ?? BaseVC())
        }
        
        return cell
    }
}
