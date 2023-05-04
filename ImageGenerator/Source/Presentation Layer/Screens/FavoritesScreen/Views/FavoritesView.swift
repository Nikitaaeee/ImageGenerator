//
//  FavoritesView.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import UIKit

protocol DisplaysFavorites: UIView {
    func configure(with viewModel: FavoritesDataFlow.ViewModel)
    var delegate: FavoritesViewDelegate? { get set }
}

protocol FavoritesViewDelegate: AnyObject {
    func deleteCell(with model: GeneratedImageModel)
}

final class FavoritesView: UIView {
    
    // MARK: - Properties
    
    let tableManager: FavoritesTableViewManagerProtocol
    weak var delegate: FavoritesViewDelegate?
    
    //MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.identifier)
        tableView.delegate = tableManager
        tableView.dataSource = tableManager
        
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    init(tableManager: FavoritesTableViewManagerProtocol) {
        self.tableManager = tableManager
        super.init(frame: .zero)
        tableManager.delegate = self
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - DisplaysFavorites

extension FavoritesView: DisplaysFavorites {
    func configure(with viewModel: FavoritesDataFlow.ViewModel) {
        tableManager.cells = viewModel.cells
        tableView.reloadData()
    }
}

//MARK: - FavoritesTableViewManagerDelegate

extension FavoritesView: FavoritesTableViewManagerDelegate {
    func deleteCell(with model: GeneratedImageModel) {
        delegate?.deleteCell(with: model)
    }
}

//MARK: - Private

private extension FavoritesView {
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func configureConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
    
