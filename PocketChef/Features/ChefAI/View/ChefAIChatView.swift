//
//  ChefAIChatView.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 21/11/25.
//

import Foundation
import UIKit

final class ChefAIChatView: UIView {
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Colors.background
        view.layer.borderColor = Theme.Colors.separator.cgColor
        view.layer.borderWidth = 1.0 / UIScreen.main.scale
        return view
    }()
    
    let inputTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = Theme.Fonts.body
        textView.layer.cornerRadius = 18
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = Theme.Colors.separator.cgColor
        textView.enablesReturnKeyAutomatically = true
        textView.isScrollEnabled = false
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = Theme.Fonts.headline
        button.tintColor = Theme.Colors.accent
        return button
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
        
        addSubview(tableView)
        addSubview(inputContainerView)
        
        inputContainerView.addSubview(inputTextView)
        inputContainerView.addSubview(sendButton)
        
        let standard = Theme.Spacing.standard
        let small = Theme.Spacing.small
        
        NSLayoutConstraint.activate([
            inputContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -standard),
            sendButton.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -small),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalToConstant: 60),

            inputTextView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: standard),
            inputTextView.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: small),
            inputTextView.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: -small),
            inputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -small),
            inputTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
            inputTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
    }
}
