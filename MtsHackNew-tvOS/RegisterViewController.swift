//
//  RegisterViewController.swift
//  MtsHackNew-tvOS
//
//  Created by  Даниил on 29.03.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController, UITextFieldDelegate {
    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нажми меня", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .init(red: 186/255, green: 157/255, blue: 90/255, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    
    var navigator: BaseNavigatorProtocol
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: RegisterViewModel, navigator: BaseNavigatorProtocol) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    var viewModel: RegisterViewModel!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.addSubview(acceptButton)
        
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acceptButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acceptButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupFocusGuide() {
        let focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        
        focusGuide.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        focusGuide.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        focusGuide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        focusGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        focusGuide.preferredFocusEnvironments = [acceptButton]
    }
    
    private func setupBindings() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(acceptButtonTapped))
        acceptButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func acceptButtonTapped() {
        viewModel.navigator.toFilmVC()
    }
}
    

