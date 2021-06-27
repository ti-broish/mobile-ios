//
//  PhotosPickerViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 18.06.21.
//

import UIKit
import Combine

protocol PhotosPickerDelegate: AnyObject {
    
    func didSelectPhotos(_ photos: [UIImage], sender: PhotosPickerViewController)
}

final class PhotosPickerViewController: BaseCollectionViewController {
    
    @IBOutlet private weak var selectedPhotosLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    
    private let viewModel = PhotosPickerViewModel()
    private var selectedPhotosCountSubscription: AnyCancellable?
    
    weak var delegate: PhotosPickerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedPhotosCountSubscription?.cancel()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        let theme = TibTheme()
        collectionView.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Private methods
    
    private func setupSelectedPhotosLabel() {
        selectedPhotosLabel.font = .semiBoldFont(size: 16.0)
        selectedPhotosLabel.textColor = TibTheme().darkTextColor
        selectedPhotosLabel.isHidden = true
    }
    
    private func setupCloseButton() {
        closeButton.configureButton(title: LocalizedStrings.Search.doneButton, theme: TibTheme())
    }
    
    private func setupCollectionView() {
        collectionView.register(cellNames: ["ImageCell"])

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupViews() {
        setupSelectedPhotosLabel()
        setupCloseButton()
        setupCollectionView()
    }
    
    private func observeReloadDataPublisher() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { [unowned self] error in
                    print("reload data failed \(error)")
                    collectionView.reloadData()
                },
                receiveValue: { [unowned self] _ in
                    print("reload data finished")
                    collectionView.reloadData()
                })
    }
    
    private func observeSelectedPhotosCountPublisher() {
        selectedPhotosCountSubscription = viewModel.selectedPhotosCountPublisher.sink(receiveValue: {
            [unowned self] value in
            selectedPhotosLabel.isHidden = value == 0
            selectedPhotosLabel.text = "\(LocalizedStrings.Photos.selected): \(value)"
        })
    }
    
    private func addObservers() {
        observeReloadDataPublisher()
        observeSelectedPhotosCountPublisher()
    }
    
    @IBAction private func handleCloseButton(_ sender: UIButton) {
        delegate?.didSelectPhotos(viewModel.selectedPhotos, sender: self)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosPickerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellIdentifier, for: indexPath)
        
        guard let imageCell = reusableCell as? ImageCell else {
            return UICollectionViewCell()
        }
        
        imageCell.configure(asset: viewModel.allPhotos.object(at: indexPath.row))
        
        return imageCell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotosPickerViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCell,
            let photo = cell.imageView.image
        else {
            return
        }
        
        if viewModel.hasPhoto(photo) {
            viewModel.deselectPhoto(photo)
            cell.setSelected(false)
        } else {
            viewModel.selectPhoto(photo)
            cell.setSelected(true)
        }
    }
}

