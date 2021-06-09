//
//  CollectionReusableIdentifier.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import UIKit

protocol CollectionReusableIdentifier {}

extension CollectionReusableIdentifier {
  static var reuseIdentifier: String { String(describing: self) }
}
extension UICollectionReusableView: CollectionReusableIdentifier {}

extension UICollectionView {

  func dequeueAndConfigureReusableCell<Cell: ViewModelInjectable & UICollectionViewCell>(with viewModel: Cell.ViewModel, at indexPath: IndexPath) -> Cell {
    register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    return dequeue(with: viewModel, at: indexPath)
  }

  private func dequeue<Cell: ViewModelInjectable & UICollectionViewCell>(with viewModel: Cell.ViewModel, at indexPath: IndexPath) -> Cell {
    let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    cell.configureWithViewModel(viewModel)
    return cell
  }
}
