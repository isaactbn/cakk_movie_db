//
//  BaseView.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import Foundation

protocol BaseView {
    func showError(msg: String)
    func onLoading()
    func onFinishLoading()
}
