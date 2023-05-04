//
//  ModuleAssembly.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import UIKit

protocol ModuleAssembler {
    associatedtype Context
    associatedtype ViewController: UIViewController

    func build(with context: Self.Context) throws -> ViewController
}

extension ModuleAssembler where Context == Void {
    func build() throws -> ViewController {
        try build(with: ())
    }
}

extension ModuleAssembler where Context == Any? {
    func build() throws -> ViewController {
        try build(with: nil)
    }
}
