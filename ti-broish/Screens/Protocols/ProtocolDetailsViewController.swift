//
//  ProtocolDetailsViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class ProtocolDetailsViewController: BaseCollectionViewController {
    
    var viewModel = ProtocolDetailsViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        collectionView.register(cellNames: ["ImageCell"])
        
        collectionView.register(
            DetailsHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailsHeaderReusableView.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupViews() {
        setupCollectionView()
    }
}

// MARK: - UICollectionViewDataSource

extension ProtocolDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.protocolItem?.pictures.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellIdentifier, for: indexPath)
        
        guard let imageCell = reusableCell as? ImageCell else {
            return UICollectionViewCell()
        }
        
        imageCell.configure(picture: viewModel.protocolItem?.pictures[indexPath.row])
        
        return imageCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailsHeaderReusableView.reuseIdentifier,
            for: indexPath
        ) as? DetailsHeaderReusableView
        
        guard let detailsHeaderView = headerView else {
            return UICollectionReusableView()
        }
        
        detailsHeaderView.loadProtocol(viewModel.protocolItem)
            
        return detailsHeaderView
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let detailsHeaderView = DetailsHeaderReusableView()
        detailsHeaderView.loadProtocol(viewModel.protocolItem)
        
        return detailsHeaderView.headerSize
    }
}
