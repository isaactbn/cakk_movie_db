//
//  ConnecntionLostVC.swift
//  Cakk Movies
//
//  Created by Isaac on 1/20/23.
//

import UIKit

class ConnectionLostVC: BaseVC {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var reloadButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        containerView.setupRadius(type: .custom(24))
        reloadButton.setupRadius(type: .custom(12))
        reloadButton.layer.applySketchShadow(color: #colorLiteral(red: 0, green: 0.1333333333, blue: 0.4235294118, alpha: 1), alpha: 0.08, x: -1, y: 1, blur: 6, spread: 0)
    }

    @IBAction func reloadButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let genreRouter = GenreRouters.start()
        let initialVC = genreRouter.entry ?? UIViewController()
        pushVC(initialVC as? MovieViewVC ?? BaseVC())
    }
}
