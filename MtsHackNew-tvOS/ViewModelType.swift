//
//  ViewModelType.swift
//  MtsHackNew-tvOS
//
//  Created by  Даниил on 29.03.2023.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
