//
//  RegisterViewModel.swift
//  MtsHackNew-tvOS
//
//  Created by  Даниил on 29.03.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class RegisterViewModel: ViewModelType {
    
     let navigator: BaseNavigatorProtocol
    
    init(navigator:BaseNavigatorProtocol) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let register = input.registerTrigger
            .do(onNext: { [unowned self] value in
                self.navigator.toFilmVC()
            })
                return Output(toFilm: register)
                }
    
}


extension RegisterViewModel {
    struct Input {
        let registerTrigger: Driver<Void>
    }
    struct Output {
        let toFilm: Driver<Void>
    }
}


