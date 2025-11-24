//
//  ChatMessageCell.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 21/11/25.
//

import UIKit

final class ChatMessageCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let reuseIdentifier = "ChatMessageCell"
    
    // MARK: - UI Components
    private let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Theme.Fonts.body
        return label
    }()
    
    // MARK: - Constraints
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with message: ChatMessage) {
        configureText(with: message.content)
        configureStyle(isFromUser: message.isFromUser)
    }

    private func configureText(with content: String) {
        if let attributedText = try? NSAttributedString(
            markdown: content,
            options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) {
            messageLabel.attributedText = attributedText
        } else {
            messageLabel.text = content
        }
    }
    
    private func configureStyle(isFromUser: Bool) {
        if isFromUser {
            bubbleView.backgroundColor = Theme.Colors.accent
            messageLabel.textColor = .white
            
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            bubbleView.backgroundColor = Theme.Colors.separator
            messageLabel.textColor = Theme.Colors.primaryText
            
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        let standard = Theme.Spacing.standard
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75)
        ])
        
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standard)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standard)
        trailingConstraint.priority = .defaultHigh
    }
}
