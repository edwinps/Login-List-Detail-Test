//
//  ArticleCell.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import UIKit
import Combine

class ArticleCell: UITableViewCell, NibProvidable, ReusableView  {
    @IBOutlet private var title: UILabel!
    @IBOutlet private var summary: UILabel!
    @IBOutlet private var date: UILabel!
    @IBOutlet private var imageArticle: UIImageView!
    private var cancellable: AnyCancellable?

    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }

    func bind(to viewModel: ArticleViewModel) {
        cancelImageLoading()
        title.text = viewModel.title
        summary.text = viewModel.summary
        date.text = viewModel.date?.dateFormatter()
        cancellable = viewModel.imageData
            .sink { [weak self] data in
                self?.showImage(image: UIImage(data: data ?? Data()))
            }
    }
}

// MARK: - Inner methods

private extension ArticleCell {
    func showImage(image: UIImage?) {
        cancelImageLoading()
        UIView.transition(with: self.imageArticle,
        duration: 0.3,
        options: [.curveEaseOut, .transitionCrossDissolve],
        animations: {
            self.imageArticle.image = image
        })
    }

    func cancelImageLoading() {
        imageArticle.image = nil
        cancellable?.cancel()
    }
}
