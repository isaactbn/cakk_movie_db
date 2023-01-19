//
//  MovieDetailVC.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import UIKit
import Kingfisher
import STPopup

protocol MovieDetailView: BaseView {
    var presenter: MovieDetailPresenter? { get set }
    var id: String {get set}
    var navTitle: String {get set}
    
    func update(with movies: MovieDetailBodyResponse)
    func connectionError(with error: Int)
    func update(with error: String)
    
    func updateReview(with reviews: MovieReviewBodyResponse)
    func updateReview(with error: String)
    
    func updateTrailer(with trailer: MovieTrailerBodyResponse)
    func updateTrailer(with error: String)
}

class MovieDetailVC: BaseVC, MovieDetailView {
    
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var backdropFrontView: UIView!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var reviewCardView: UIView!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var noReviewLabel: UILabel!
    @IBOutlet weak var readAllReviewsLabel: UILabel!
    
    @IBOutlet weak var trailerHeightTable: NSLayoutConstraint!
    @IBOutlet weak var trailerTableView: UITableView!
    @IBOutlet weak var noTrailerLabel: UILabel!
    
    var presenter: MovieDetailPresenter?
    
    var popUpVC: STPopupController?
    var data: MovieDetailBodyResponse?
    var dataReview: MovieReviewBodyResponse?
    var dataTrailer: MovieTrailerBodyResponse?
    var navTitle: String = ""
    var id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()
        setupTrailerTable()
    }
    
    private func setupView() {
        let cardView = [reviewCardView]
        cardView.forEach{ (view) in
            view?.layer.applySketchShadow(color: #colorLiteral(red: 0.9023359418, green: 0.8988109827, blue: 0.8893814683, alpha: 1), alpha: 0.2, x: -1, y: 1, blur: 4, spread: 0)
        }
        
        backdropFrontView.backgroundColor = UIColor.fromGradientWithDirection(.leftToRight, frame: backdropFrontView.frame, colors: [#colorLiteral(red: 0.03921568627, green: 0.1254901961, blue: 0.03921568627, alpha: 0.85), #colorLiteral(red: 0.16615206, green: 0.2343401313, blue: 0.1666736901, alpha: 0.75)])
        
        setupData()
    }
    
    private func setupTable() {
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        reviewTableView.reloadData()
    }
    
    private func setupTrailerTable() {
        trailerTableView.delegate = self
        trailerTableView.dataSource = self
        trailerTableView.register(UINib(nibName: "TrailerCell", bundle: nil), forCellReuseIdentifier: "TrailerCell")
        trailerTableView.reloadData()
    }
    
    private func setupData() {
        if data != nil {
            let resourceImage = ImageResource(downloadURL: URL(string: data?.backdrop_path.setURL() ?? "")!)
            backDropImage.kf.setImage(with: resourceImage, placeholder: UIImage(named: "backdrop-profile"), options: [.forceRefresh])
            
            let movieImage = ImageResource(downloadURL: URL(string: data?.poster_path.setURL() ?? "")!)
            movieImg.kf.setImage(with: movieImage, placeholder: UIImage(named: "backdrop-profile"), options: [.forceRefresh])
            
            movieTitleLabel.text = "\(data?.original_title ?? "") (\(data?.release_date.formatedDate(from: .dateWithStripReversed, format: .year) ?? ""))"
            overviewLabel.text = data?.overview
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        setupNavBarSquareArrow(title: "\(navTitle)", back: backToPreviousVC)
    }
    
    func update(with movies: MovieDetailBodyResponse) {
        data = movies
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
    
    func updateReview(with reviews: MovieReviewBodyResponse) {
        dataReview = reviews
    }
    
    func updateReview(with error: String) {
        print(error)
    }
    
    func updateTrailer(with trailer: MovieTrailerBodyResponse) {
        dataTrailer = trailer
    }
    
    func updateTrailer(with error: String) {
        print(error)
    }
}

extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.reviewTableView {
            let dataCount = dataReview?.results?.count ?? 0
            if dataCount == 0 {
                reviewTableView.isHidden = true
                readAllReviewsLabel.isHidden = true
                noReviewLabel.isHidden = false
            } else {
                reviewTableView.isHidden = false
                readAllReviewsLabel.isHidden = false
                noReviewLabel.isHidden = true
            }
            
            return dataCount > 2 ? 2 : dataCount
        } else {
            let dataCount = dataTrailer?.results?.count ?? 0
            if dataCount == 0 {
                trailerTableView.isHidden = true
                noTrailerLabel.isHidden = false
            } else {
                trailerTableView.isHidden = false
                noTrailerLabel.isHidden = true
            }
            
            return dataCount
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if tableView == self.reviewTableView {
                self.heightTable.constant = self.reviewTableView.contentSize.height
            } else {
                self.trailerHeightTable.constant = self.trailerTableView.contentSize.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.reviewTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
                return UITableViewCell()
            }
            
            let dataTable = dataReview?.results?[indexPath.row]
            
            var imgURL = dataTable?.author_details?.avatar_path
            if imgURL?.first == "/" {
                imgURL = String(imgURL?.dropFirst() ?? "")
            }
                
            let resourceImage = ImageResource(downloadURL: URL(string: imgURL ?? "")!)
            cell.profileImage.kf.setImage(with: resourceImage, placeholder: UIImage(named: "backdrop-profile"), options: [.forceRefresh])
            
            cell.reviewerName.text = "A review by \(dataTable?.author_details?.name ?? "-")"
            cell.rateLabel.text = "\(String(Int(dataTable?.author_details?.rating ?? 0.0))).0"
            cell.infoLabel.text = "Written by \(dataTable?.author_details?.name ?? "") on \(dataTable?.updated_at.formatedDate(from: .ISO, format: .britishDate) ?? "")"
            cell.descLabel.text = dataTable?.content
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath) as? TrailerCell else {
                return UITableViewCell()
            }
            
            cell.nameLabel.text = dataTrailer?.results?[indexPath.row].name
            cell.loadYoutube(videoID: dataTrailer?.results?[indexPath.row].key ?? "")
            
            return cell
        }
    }
    
}
