//
//  DefaultButtonModel.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import UIKit

struct DefaultButtonModel {
    let title: String
    let titleColor: UIColor
    let buttonColor: UIColor
    var buttonTapHandler: (() -> Void)?
    var font: UIFont?
}
