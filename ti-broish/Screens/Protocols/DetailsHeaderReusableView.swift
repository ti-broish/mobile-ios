//
//  DetailsHeaderReusableView.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.06.21.
//

import UIKit

final class DetailsHeaderReusableView: UICollectionReusableView {
    
    private let stackViewConstraintOffset: CGFloat = 16.0
    private var stackView = UIStackView()
    private (set) var headerSize: CGSize = .zero
    
    static var reuseIdentifier: String {
        return "\(String(describing: self))"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadProtocol(_ protocolItem: Protocol?) {
        guard let protocolItem = protocolItem else {
            return
        }
        
        stackView.addArrangedSubview(
            makeLabel(prefix: LocalizedStrings.Protocols.ProtocolDetails.status, text: protocolItem.statusLocalized)
        )
        
        stackView.addArrangedSubview(
            makeLabel(prefix: LocalizedStrings.Protocols.ProtocolDetails.protocolId, text: protocolItem.id)
        )
        
        stackView.addArrangedSubview(
            makeLabel(prefix: LocalizedStrings.Protocols.ProtocolDetails.sectionNumber, text: protocolItem.section.id)
        )
        
        stackView.addArrangedSubview(
            makeLabel(prefix: LocalizedStrings.Protocols.ProtocolDetails.location, text: protocolItem.section.place)
        )
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: stackViewConstraintOffset),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: stackViewConstraintOffset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -stackViewConstraintOffset)
        ])
    }
    
    private func makeLabel(prefix: String, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(250.0), for: .vertical)
        label.numberOfLines = 0
        label.attributedText = StringUtils.makeAttributedText(prefix: prefix, text: text)
        
        let textSize = label.attributedText?.boundingRect(
            with: CGSize(width: 200.0, height: 0.0),
            options: .usesLineFragmentOrigin,
            context: nil
        )
        
        headerSize.height += textSize?.height ?? 0.0
        
        return label
    }
}
