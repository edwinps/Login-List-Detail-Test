//
//  ImageLoaderService.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import Foundation
import Combine

protocol ImageLoaderServiceType: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<Data?, Never>
}

final class ImageLoaderService: ImageLoaderServiceType {
    func loadImage(from url: URL) -> AnyPublisher<Data?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> Data? in
                return data
            }
            .catch { error in return Just(nil) }
            .eraseToAnyPublisher()
    }
}
