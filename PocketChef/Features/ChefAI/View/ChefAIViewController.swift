//
//  ChefAIViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 21/11/25.
//

import Foundation
import UIKit
import Combine

final class ChefAIViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ChefAIViewModelProtocol
    private lazy var chatView = ChefAIChatView()
    private var cancellables = Set<AnyCancellable>()
    private var inputContainerBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    init(viewModel: ChefAIViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupBindings()
        setupKeyboardHandling()
        addInitialMessage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.title = "Chef AI"
    }
    
    private func setupTableView() {
        chatView.tableView.dataSource = self
        chatView.tableView.delegate = self
        chatView.tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseIdentifier)
    }
    
    private func setupBindings() {
        
        viewModel.messagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleMessagesUpdate()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: chatView.inputTextView)
            .compactMap { ($0.object as? UITextView)?.text }
            .sink { [weak self] newText in
                self?.viewModel.currentInput = newText
                self?.updateSendButtonState(text: newText)
            }
            .store(in: &cancellables)

        chatView.sendButton.addAction(UIAction { [weak self] _ in
            self?.sendButtonTapped()
        }, for: .touchUpInside)
    
        updateSendButtonState(text: "")
        
        inputContainerBottomConstraint = chatView.inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputContainerBottomConstraint?.isActive = true
    }
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    private func addInitialMessage() {
        viewModel.loadInitialMessages()
    }
    
    private func sendButtonTapped() {
        Task {
            chatView.inputTextView.text = ""
            updateSendButtonState(text: "")
            
            await viewModel.sendMessage()
        }
    }
    
    // MARK: - UI Updates
    private func handleMessagesUpdate() {
        chatView.tableView.reloadData()
        
        if !viewModel.messages.isEmpty {
            let lastIndexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
            chatView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    private func updateSendButtonState(text: String) {
        let isInputValid = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        chatView.sendButton.isEnabled = isInputValid
        chatView.sendButton.alpha = isInputValid ? 1.0 : 0.5
    }

    // MARK: - Keyboard Handling
    @objc private func handleKeyboardNotification(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
        let keyboardHeight = isShowing ? keyboardFrame.height - view.safeAreaInsets.bottom : 0
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.inputContainerBottomConstraint?.constant = -keyboardHeight
            self.view.layoutIfNeeded()
            
            if isShowing && self.viewModel.messages.count > 0 {
                let lastRow = self.viewModel.messages.count - 1
                self.chatView.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: false)
            }
        }, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ChefAIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.reuseIdentifier, for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }
        
        let message = viewModel.messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChefAIViewController: UITableViewDelegate {
}
