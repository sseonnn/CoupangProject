//
//  HomeViewController.swift
//  Cproject
//
//  Created by 이정선 on 6/2/24.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private enum Section: Int {
        case banner
        case horizontalProduct
        case seperateLine1
        case couponButton
        case verticalProductItem
        case seperateLine2
        case theme
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private lazy var datasource: DataSource = setDataSource()
    private lazy var composotionalLayout: UICollectionViewCompositionalLayout = setCompositonalLayout()
    private var homeViewModel = HomeViewModel()
    private var cancelable: Set<AnyCancellable> = []
    private var currentSection: [Section] {
        datasource.snapshot().sectionIdentifiers as [Section]
    }
    private var didTapCouponDownload = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingViewModel()
        collectionView.collectionViewLayout = composotionalLayout
        homeViewModel.process(action: .loadData)
        homeViewModel.process(action: .loadCoupon)
        collectionView.delegate = self
    }
    
    private func setCompositonalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch self?.currentSection[section] {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
            case .horizontalProduct:
                return HomeProductCollectionViewCell.horizontalProductLayout()
            case .couponButton:
                return HomeCouponButtonCollectionViewCell.couponLayout()
            case .verticalProductItem:
                return HomeProductCollectionViewCell.verticalProductLayout()
            case .seperateLine1, .seperateLine2:
                return HomeSeperateLineCollectionViewCell.seperateLineLayout()
            case .theme:
                return HomeThemeCollectionViewCell.seperateLineLayout()
            case .none: return nil
            }
        }
    }
    
    private func bindingViewModel() {
        homeViewModel.state.$collectionViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapShot()
            }
            .store(in: &cancelable)
        
        didTapCouponDownload
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.homeViewModel.process(action: .didTapCouponButton)
            }
            .store(in: &cancelable)
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, model in
            switch self?.currentSection[indexPath.section] {
            case .banner:
                return self?.bannerCell(collectionView, indexPath, model)
            case .couponButton:
                return self?.couponCell(collectionView, indexPath, model)
            case .horizontalProduct, .verticalProductItem:
                return self?.productCell(collectionView, indexPath, model)
            case .seperateLine1, .seperateLine2 :
                return self?.seperateLineCell(collectionView, indexPath, model)
            case .theme:
                return self?.themeCell(collectionView, indexPath, model)
            case .none:
                return .init()
            }
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let model = self?.homeViewModel.state.collectionViewModels.themeModels?.headerModels else {return nil}
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeThemeHeaderCollectionReusableView.reusableId, for: indexPath) as? HomeThemeHeaderCollectionReusableView
            headerView?.setModel(model)
            return headerView
        }
        
        return dataSource
    }
    
    private func applySnapShot() {
        var snapShot = SnapShot()
        
        if let bannerModels = homeViewModel.state.collectionViewModels.bannerModels {
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerModels, toSection: .banner)
        }
        
        if let horizontalProductModels = homeViewModel.state.collectionViewModels.horizontalProductModels {
            snapShot.appendSections([.horizontalProduct])
            snapShot.appendItems(horizontalProductModels, toSection: .horizontalProduct)
            
            snapShot.appendSections([.seperateLine1])
            snapShot.appendItems(homeViewModel.state.collectionViewModels.seperateLine1Models, toSection: .seperateLine1)
        }
        
        if let couponModels =
            homeViewModel.state.collectionViewModels.couponModels {
            snapShot.appendSections([.couponButton])
            snapShot.appendItems(couponModels, toSection: .couponButton)
        }
        
        if let verticalProductModels = homeViewModel.state.collectionViewModels.verticalProductModels {
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalProductModels, toSection: .verticalProductItem)
        }
        
        if let themeModels =
            homeViewModel.state.collectionViewModels.themeModels?.items {
            snapShot.appendSections([.seperateLine2])
            snapShot.appendItems(homeViewModel.state.collectionViewModels.seperateLine2Models, toSection: .seperateLine2)
            
            snapShot.appendSections([.theme])
            snapShot.appendItems(themeModels, toSection: .theme)
        }
        
        datasource.apply(snapShot)
    }
    
    private func bannerCell(_ collectioView: UICollectionView, _ indexPath: IndexPath, _ model: AnyHashable) -> UICollectionViewCell {
        guard let model = model as? HomeBannerModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCollectionViewCell.reusableId, for: indexPath) as? HomeBannerCollectionViewCell else { return .init() }
        cell.setModel(model)
        return cell
    }
    
    private func productCell(_ collectioView: UICollectionView, _ indexPath: IndexPath, _ model: AnyHashable) -> UICollectionViewCell {
        guard let model = model as? HomeProductCellModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeProductCollectionViewCell.reusableId, for: indexPath) as? HomeProductCollectionViewCell else { return .init() }
        cell.setModel(model)
        return cell
    }
    
    private func couponCell(_ collectioView: UICollectionView, _ indexPath: IndexPath, _ model: AnyHashable) -> UICollectionViewCell {
        guard let model = model as? HomeCouponButtonCollectionViewCellModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCouponButtonCollectionViewCell.reusableId, for: indexPath) as? HomeCouponButtonCollectionViewCell else { return .init() }
        cell.setModel(model, didTapCouponDownload)
        return cell
    }
    
    private func seperateLineCell(_ collectioView: UICollectionView, _ indexPath: IndexPath, _ model: AnyHashable) -> UICollectionViewCell {
        guard let model = model as? HomeSeperateLineCollectionViewCellModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSeperateLineCollectionViewCell.reusableId, for: indexPath) as? HomeSeperateLineCollectionViewCell else { return .init() }
        cell.setModel(model)
        return cell
    }
    
    private func themeCell(_ collectioView: UICollectionView, _ indexPath: IndexPath, _ model: AnyHashable) -> UICollectionViewCell {
        guard let model = model as? HomeThemeCollectionViewCellModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeThemeCollectionViewCell.reusableId, for: indexPath) as? HomeThemeCollectionViewCell else { return .init() }
        cell.setModel(model)
        return cell
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Favorite", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSection[indexPath.section] {
        case .banner:
            break
        case .horizontalProduct, .verticalProductItem:
            let sb = UIStoryboard(name: "Detail", bundle: nil)
            guard let vc = sb.instantiateInitialViewController() else { return }
            navigationController?.pushViewController(vc, animated: true)
        case .seperateLine1:
            break
        case .couponButton:
            break
        case .seperateLine2:
            break
        case .theme:
            break
        }
    }
}
