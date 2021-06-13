//
//  DetailsViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import UIKit

final class DetailsViewController: BaseCollectionViewController {
    
    var viewModel = DetailsViewModel()
    
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

extension DetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagesCount
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
        
        if let protocolItem = viewModel.protocolItem {
            detailsHeaderView.loadProtocol(protocolItem)
        } else if let violation = viewModel.violation {
            detailsHeaderView.loadViolation(violation)
        } else {
            return UICollectionReusableView()
        }
            
        return detailsHeaderView
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let detailsHeaderView = DetailsHeaderReusableView()
        
        if let protocolItem = viewModel.protocolItem {
            detailsHeaderView.loadProtocol(protocolItem)
        } else if let violation = viewModel.violation {
            detailsHeaderView.loadViolation(violation)
        }
        
        return detailsHeaderView.headerSize
    }
}

// MARK: - UICollectionViewDelegate

extension DetailsViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImage(viewModel.protocolItem?.pictures[indexPath.row])
    }
    
    // MARK: - Private methods (UICollectionViewDelegate)
    
    private func showImage(_ picture: Picture?) {
        let viewController = ImagePreviewViewController.init(nibName: ImagePreviewViewController.nibName, bundle: nil)
        viewController.picture = picture

        present(viewController, animated: true, completion: nil)
    }
}

