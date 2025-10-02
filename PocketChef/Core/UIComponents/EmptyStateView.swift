//
//  EmptyStateView.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 02/10/25.
//

import Foundation
import UIKit

final class EmptyStateView: UIView {
    
    // MARK: - UI Components
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .light)
        imageView.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with message: String, iconName: String) {
        messageLabel.text = message
        
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .light)
        iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(messageLabel)
        
        addSubview(stackView)
        
        let padding: CGFloat = 40
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
    }
}
