//
//  FavoritesTableViewManager.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import UIKit

protocol FavoritesTableViewManagerProtocol: UITableViewDelegate, UITableViewDataSource {
    var cells: [GeneratedImageModel] { get set }
    var delegate: FavoritesTableViewManagerDelegate? { get set }
}

protocol FavoritesTableViewManagerDelegate: AnyObject {
    func deleteCell(with model: GeneratedImageModel)
}

final class FavoritesTableViewManager: NSObject, FavoritesTableViewManagerProtocol {
    
    //MARK: - Properties

    var cells: [GeneratedImageModel] = []
    weak var delegate: FavoritesTableViewManagerDelegate?
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as? FavoritesCell else { return UITableViewCell() }
        let viewModel = cells[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.deleteCell(with: cells[indexPath.row])
            cells.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

//MARK: - Constants

private extension FavoritesTableViewManager {
    enum Constants {
        static let cellHeight: CGFloat = 80
    }
}
