//
//  RegisterViewController.swift
//  MtsHackNew
//
//  Created by  Даниил on 29.03.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let textField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 8
        field.layer.borderColor = UIColor.black.cgColor
        field.backgroundColor = .white
        return field
    }()
    
    var viewModel: RegisterViewModel!
    var bag = DisposeBag()
    
    let logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "kionLogo")
        return view
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона любого оператора"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .init(red: 186/255, green: 157/255, blue: 90/255, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OGO")
        view.backgroundColor = .init(red: 29/255, green: 51/255, blue: 74/255, alpha: 1)
        setupTextField()
        setupUI()
        makeSubviewsLayout()
        setupBindings()
        
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.frame = CGRect(x: 50, y: 50, width: 200, height: 30)
        view.addSubview(textField)
    }
    
    private func setupUI() {
        view.addSubview(logo)
        view.addSubview(numberLabel)
        view.addSubview(acceptButton)
    }
    private func makeSubviewsLayout() {
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.centerX.equalToSuperview()
        }
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().inset(48)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(20)
            make.height.equalTo(52)
            make.width.equalTo(272)
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().inset(48)
            make.centerX.equalToSuperview()
        }
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(24)
            make.height.equalTo(52)
            make.width.equalTo(272)
            make.centerX.equalToSuperview()
        }
        
    }
    private func setupBindings() {
        let input = RegisterViewModel.Input(registerTrigger: acceptButton.rx.tap.asDriver(),
                                            phoneString: textField.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input: input)
        [
            output.submitEnabled.drive(acceptButton.rx.isEnabled),
            output.toFilm.drive(),
        ]
            .forEach({$0.disposed(by: bag)})
    }
    
    func format(with mask: String, phone: String) -> String {
        var numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if numbers.first == "8" {
            numbers = "7" + numbers.dropFirst()
        }
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+X (XXX) XXX-XXXX", phone: newString)
        return false
    }
}
