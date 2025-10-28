//
//  RandomMealView.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 26/10/25.
//

import Foundation
import UIKit

final class RandomMealView: UIView {

    // MARK: - UI Components
    let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = Theme.Colors.separator
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .light)
        imageView.image = UIImage(systemName: "dice", withConfiguration: config)
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    let surpriseMeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Surprise Me!"
        config.image = UIImage(systemName: "dice.fill")
        config.imagePadding = Theme.Spacing.small
        config.baseBackgroundColor = Theme.Colors.accent
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = Theme.Fonts.headline
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewDetailsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "View Full Recipe"
        config.image = UIImage(systemName: "book.pages")
        config.imagePadding = Theme.Spacing.small
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = Theme.Colors.primaryText
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Theme.Spacing.large
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

    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = Theme.Colors.background
        
        mainStackView.addArrangedSubview(mealImageView)
        mainStackView.addArrangedSubview(surpriseMeButton)
        mainStackView.addArrangedSubview(viewDetailsButton)
        
        addSubview(mainStackView)
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            mealImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),
            
            mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: Theme.Spacing.standard),
            mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -Theme.Spacing.standard),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
