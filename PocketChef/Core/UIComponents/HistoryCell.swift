//
//  HistoryCell.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 02/10/25.
//

import Foundation
import UIKit

final class HistoryCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let reuseIdentifier = "HistoryCell"
    
    // MARK: - Callback
    var onDeleteButtonTapped: (() -> Void)?
    
    // MARK: - UI Components
    private let clockIconImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(textStyle: .body)
        imageView.image = UIImage(systemName: "clock", withConfiguration: config)
        imageView.tintColor = Theme.Colors.secondaryText
        imageView.contentMode = .center
        return imageView
    }()
    
    private let termLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.primaryText
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .body)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .tertiaryLabel
        return button
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Theme.Spacing.medium
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupActions()
        setupAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with term: String) {
        termLabel.text = term
        accessibilityLabel = term
        accessibilityHint = "Double-tap to search again. Swipe up for actions."
    }
    
    // MARK: - Private Methods
    private func setupView() {
        var backgroundConfig = UIBackgroundConfiguration.listCell()
        backgroundConfig.backgroundColor = .clear
        self.backgroundConfiguration = backgroundConfig
        
        mainStackView.addArrangedSubview(clockIconImageView)
        mainStackView.addArrangedSubview(termLabel)
        mainStackView.addArrangedSubview(deleteButton)
        
        contentView.addSubview(mainStackView)
        
        let iconWidth: CGFloat = 24
        
        let standardSpacing = Theme.Spacing.standard
        let mediumSpacing = Theme.Spacing.medium
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: mediumSpacing),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -mediumSpacing),
            
            clockIconImageView.widthAnchor.constraint(equalToConstant: iconWidth),
            deleteButton.widthAnchor.constraint(equalToConstant: iconWidth)
        ])
    }
    
    private func setupActions() {
        deleteButton.addTarget(self, action: #selector(deleteButtonWasTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonWasTapped() {
        onDeleteButtonTapped?()
    }
    
    private func setupAccessibility() {
        let deleteAction = UIAccessibilityCustomAction(
            name: "Delete",
            target: self,
            selector: #selector(deleteButtonWasTapped)
        )
        
        accessibilityCustomActions = [deleteAction]
    }
}
