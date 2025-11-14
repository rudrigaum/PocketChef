//
//  SkeletonCell.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 12/11/25.
//

import Foundation
import UIKit

final class SkeletonCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let reuseIdentifier = "SkeletonCell"
    
    // MARK: - UI Components
    private let imagePlaceholder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Colors.separator
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let textPlaceholder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Colors.separator
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        startShimmering()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubview(imagePlaceholder)
        contentView.addSubview(textPlaceholder)
    
        let standardSpacing = Theme.Spacing.standard
        let mediumSpacing = Theme.Spacing.medium
        
        NSLayoutConstraint.activate([
            imagePlaceholder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardSpacing),
            imagePlaceholder.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imagePlaceholder.widthAnchor.constraint(equalToConstant: 90),
            imagePlaceholder.heightAnchor.constraint(equalToConstant: 60),
            
            imagePlaceholder.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: mediumSpacing),
            imagePlaceholder.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -mediumSpacing),
            
            textPlaceholder.leadingAnchor.constraint(equalTo: imagePlaceholder.trailingAnchor, constant: standardSpacing),
            textPlaceholder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardSpacing),
            textPlaceholder.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textPlaceholder.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func startShimmering() {
        let baseAlpha: CGFloat = 0.5
        let pulseAlpha: CGFloat = 1.0
        
        self.imagePlaceholder.alpha = baseAlpha
        self.textPlaceholder.alpha = baseAlpha
        
        UIView.animate(
            withDuration: 0.9,
            delay: 0.0,
            options: [.curveEaseInOut, .repeat, .autoreverse],
            animations: {
                self.imagePlaceholder.alpha = pulseAlpha
                self.textPlaceholder.alpha = pulseAlpha
            }
        )
    }
}
