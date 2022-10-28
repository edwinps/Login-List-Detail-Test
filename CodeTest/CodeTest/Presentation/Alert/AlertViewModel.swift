//
//  AlertViewModel.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation
import UIKit.UIImage

struct AlertViewModel {
    let title: String
    let image: UIImage

    static var noResults: AlertViewModel {
        let title = NSLocalizedString("No articles found!", comment: "No articles found!")
        let image = UIImage(named: "error") ?? UIImage()
        return AlertViewModel(title: title, image: image)
    }

    static var dataLoadingError: AlertViewModel {
        let title = NSLocalizedString("There was a problem, please try again",
                                      comment: "There was a problem, please try again")
        let image = UIImage(named: "error") ?? UIImage()
        return AlertViewModel(title: title, image: image)
    }
}
