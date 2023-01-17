//
//  UIViewController+Extension.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import UIKit

extension UIViewController {
    func hideNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func showNavigationBar() {
        navigationController?.extendedLayoutIncludesOpaqueBars = true
        navigationController?.isNavigationBarHidden = false
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    func navItem(icon: String = "", title: String = "", color: UIColor = .black, onTap: (() -> Void)?) -> UIBarButtonItem? {
        if !icon.elementsEqual("") {
            let image = UIImage(named: icon)
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            button.tapGesture(action: onTap)
            button.setTitle(" \(title)", for: .normal)
            button.setTitleColor(color, for: .normal)
            let item = UIBarButtonItem(customView: button)
            return item
        } else {return nil}
    }
    
    func setupNavBarSquareArrow(title: String = "", color: UIColor = .white, back: (()->Void)? = nil){
        guard let nav = navigationController else {
            
            return
            
        }
        
        nav.navigationBar.tintColor = .white
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        extendedLayoutIncludesOpaqueBars = true
        self.title = title
        tabBarController?.tabBar.barTintColor = UIColor.brown
        
        //nav.navigationBar.titleTextAttributes = []
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "WorkSans-Bold", size: 18)]
        let back = navItem(icon: "back-square", color: color, onTap: back ?? backToPreviousVC)
        navigationItem.leftBarButtonItem = back
    }
    
    func pushVC<V: BaseVC>(_ vc: V) {
        if navigationController?.viewControllers.count ?? 0 > 0{
            NotificationCenter.default.post(name: Notification.Name("ShowTab"), object: nil)
        }
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func backToPreviousVC() {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count <= 2{
                NotificationCenter.default.post(name: Notification.Name("ShowTab"), object: nil)
            }
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
}
