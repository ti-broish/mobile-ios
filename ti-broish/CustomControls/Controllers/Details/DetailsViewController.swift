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
        addObservers()
        viewModel.start()
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
    
    private func observeReloadDataPublisher() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] error in
                    view.hideLoading()

                    if let error = error as? APIError {
                        switch error {
                        case .requestFailed(let responseErrors):
                            view.showMessage(responseErrors.message.first ?? LocalizedStrings.Errors.defaultError)
                        case .protocolNotFound:
                            view.showMessage(LocalizedStrings.Errors.protocolNotFound, position: .center)
                        case .violationNotFound:
                            view.showMessage(LocalizedStrings.Errors.violationNotFound, position: .center)
                        default:
                            view.showMessage(LocalizedStrings.Errors.defaultError, position: .center)
                        }
                    } else {
                        collectionView.reloadData()
                    }
                })
    }
    
    private func observeLoadingPublisher() {
        loadingSubscription = viewModel.loadingPublisher.sink(receiveValue: { [unowned self] isLoading in
            isLoading ? view.showLoading() : view.hideLoading()
        })
    }
    
    private func addObservers() {
        observeReloadDataPublisher()
        observeLoadingPublisher()
    }
}

// MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellIdentifier, for: indexPath)
        
        guard let imageCell = reusableCell as? ImageCell else {
            return UICollectionViewCell()
        }
        
        imageCell.configure(picture: viewModel.pictures[indexPath.row])
        
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
        
        showImage(viewModel.pictures[indexPath.row])
    }
    
    // MARK: - Private methods (UICollectionViewDelegate)
    
    private func showImage(_ picture: Picture?) {
        let viewController = ImagePreviewViewController.init(nibName: ImagePreviewViewController.nibName, bundle: nil)
        viewController.picture = picture

        present(viewController, animated: true, completion: nil)
    }
}

