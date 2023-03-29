//
//  RegisterViewModel.swift
//  MtsHackNew
//
//  Created by  Даниил on 29.03.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class RegisterViewModel: ViewModelType {
    
    private let navigator: BaseNavigatorProtocol
    
    init(navigator:BaseNavigatorProtocol) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let register = input.registerTrigger
            .do(onNext: { [unowned self] value in
                self.navigator.toFilmVC()
            })
                let phoneStatus = input.phoneString.map { phone  -> Bool in
                    let valid = !phone.isEmpty
                    print("#OGO", valid)
                    return true
                }
                return Output(submitEnabled: phoneStatus, toFilm: register)
                }
    
}


extension RegisterViewModel {
    struct Input {
        let registerTrigger: Driver<Void>
        let phoneString: Driver<String>
    }
    struct Output {
        let submitEnabled: Driver<Bool>
        let toFilm: Driver<Void>
    }
}


