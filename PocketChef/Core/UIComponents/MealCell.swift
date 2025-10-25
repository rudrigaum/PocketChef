//
//  MealCell.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 25/09/25.
//

import Foundation
// Em: Core/UIComponents/MealCell.swift

import UIKit

final class MealCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let reuseIdentifier = "MealCell"
    
    // MARK: - UI Components
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = Theme.Colors.separator
        return imageView
    }()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.Fonts.body
        label.textColor = Theme.Colors.primaryText
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with mealName: String, imageURL: URL?) {
        mealNameLabel.text = mealName
        ImageLoader.shared.loadImage(into: mealImageView, from: imageURL)
        
        accessibilityLabel = mealName
        accessibilityHint = "Double-tap to see recipe details."
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubview(mealImageView)
        contentView.addSubview(mealNameLabel)
        
        let standardSpacing = Theme.Spacing.standard
        let mediumSpacing = Theme.Spacing.medium
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            mealImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mealImageView.widthAnchor.constraint(equalToConstant: 90),
            mealImageView.heightAnchor.constraint(equalToConstant: 60),
            
            mealImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: mediumSpacing),
            mealImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -mediumSpacing),
            
            mealNameLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: standardSpacing),
            mealNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            mealNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
}
