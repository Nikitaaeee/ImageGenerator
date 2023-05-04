//
//  QueryTextField.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 04.05.2023.
//

import UIKit

final class QueryTextField: UITextField {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private

private extension QueryTextField {
    func configureTextField() {
        autocorrectionType = .no
        backgroundColor = .lightText
        textColor = .black
        placeholder = "Введите запрос"
        tintColor = .gray
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.1, height: 2)
        layer.shadowRadius = 40
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        rightView = paddingView2
        rightViewMode = .always
    }
}
