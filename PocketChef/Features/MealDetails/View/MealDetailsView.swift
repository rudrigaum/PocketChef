//
//  MealDetailsView.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation
import UIKit

final class MealDetailsView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Theme.Spacing.large
        return stackView
    }()
    
    let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Theme.Colors.separator
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return imageView
    }()
    
    private let ingredientsHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.headline
        label.textColor = Theme.Colors.primaryText
        label.text = "Ingredients"
        return label
    }()
    
    private let ingredientsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Theme.Spacing.small
        return stackView
    }()
    
    private let instructionsHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.headline
        label.textColor = Theme.Colors.primaryText
        label.text = "Instructions"
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.primaryText
        label.numberOfLines = 0
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
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
    func displayIngredients(_ ingredients: [MealDetails.Ingredient]) {
        ingredientsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for ingredient in ingredients {
            let label = UILabel()
            label.font = Theme.Fonts.body
            label.textColor = Theme.Colors.primaryText
            label.numberOfLines = 0
            label.text = "• \(ingredient.measure) \(ingredient.name)"
            ingredientsStackView.addArrangedSubview(label)
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        addSubview(activityIndicator)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(mealImageView)
        mainStackView.addArrangedSubview(ingredientsHeaderLabel)
        mainStackView.addArrangedSubview(ingredientsStackView)
        mainStackView.addArrangedSubview(instructionsHeaderLabel)
        mainStackView.addArrangedSubview(instructionsLabel)
        
        let standardSpacing = Theme.Spacing.standard
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standardSpacing),
        
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
