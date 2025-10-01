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
    
    static let reuseIdentifier = "MealCell"
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with mealName: String, imageURL: URL?) {
        mealNameLabel.text = mealName
        ImageLoader.shared.loadImage(into: mealImageView, from: imageURL)
    }
    
    private func setupView() {
        contentView.addSubview(mealImageView)
        contentView.addSubview(mealNameLabel)
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mealImageView.widthAnchor.constraint(equalToConstant: 90),
            mealImageView.heightAnchor.constraint(equalToConstant: 60),
            
            mealImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            mealImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            mealNameLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 16),
            mealNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mealNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
