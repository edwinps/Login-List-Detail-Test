//
//  LoadImageUseCase.swift
//  CodeTest
//
//  Created by Edwin Peña on 7/10/22.
//

import Foundation
import Combine

protocol LoadImageUseCaseProtocol {
    // Loads image for the given url
    func loadImage(for url: String?) -> AnyPublisher<Data?, Never>
}

final class LoadImageUseCase: LoadImageUseCaseProtocol {
    private let imageLoaderService: ImageLoaderServiceType

    init(imageLoaderService: ImageLoaderServiceType) {
        self.imageLoaderService = imageLoaderService
    }

    func loadImage(for urlString: String?) -> AnyPublisher<Data?, Never> {
        return Deferred { return Just(urlString) }
        .flatMap({ [unowned self] url -> AnyPublisher<Data?, Never> in
            guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return .just(nil)
            }
            return self.imageLoaderService.loadImage(from: url)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }
}
