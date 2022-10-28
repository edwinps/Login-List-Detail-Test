//
//  ViewModelType.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
