//
//  AlertViewController.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import UIKit

class AlertViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    func showNoResults() {
        render(viewModel: AlertViewModel.noResults)
    }

    func showDataLoadingError() {
        render(viewModel: AlertViewModel.dataLoadingError)
    }


}
// MARK: - Inner methods

private extension AlertViewController {
    func render(viewModel: AlertViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
    }

    func setupLayout() {
        imageView.accessibilityIdentifier = "alert image"
        titleLabel.accessibilityIdentifier = "alert title"
    }
}
