//
//  FavoriteViewController.swift
//  Cproject
//
//  Created by 이정선 on 6/11/24.
//

import UIKit
import Combine

final class FavoriteViewController: UIViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Section, AnyHashable>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    @IBOutlet private weak var tableView: UITableView!
    
    enum Section {
        case favorite
    }
    
    private lazy var dataSource: DataSource = setDataSource()
    private var currentSection: [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    private var viewModel: FavoriteViewModel = FavoriteViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindingViewModel()
        viewModel.process(.getFavoriteFromApi)
    }
    
    private func bindingViewModel() {
        viewModel.state.$tableViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }
            .store(in: &subscriptions)
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, viewModel in
            switch self?.currentSection[indexPath.section] {
            case .favorite:
                return self?.favoriteCell(tableView, indexPath, viewModel)
            case .none: return .init()
            }
        })
        
        return dataSource
    }
    
    private func favoriteCell(_ tableView: UITableView, _ indexPath: IndexPath, _ viewModel: AnyHashable) -> UITableViewCell {
        guard let viewModel = viewModel as? FavoriteItemTableViewCellViewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteItemTableViewCell.reusableId, for: indexPath) as? FavoriteItemTableViewCell else { return .init() }
        cell.setViewModel(viewModel)
        return cell
    }

    private func applySnapShot() {
        var snapShot: SnapShot = SnapShot()
        
        if let favorite = viewModel.state.tableViewModel {
            snapShot.appendSections([.favorite])
            snapShot.appendItems(favorite, toSection: .favorite)
        }
        dataSource.apply(snapShot)
    }
}
