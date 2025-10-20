//
//  VideosViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/10/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class VideosViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: VideosViewModelProtocol
    weak var delegate: VideosViewControllerDelegate?

    private var customView: VideosView? {
        return view as? VideosView
    }
    
    private var videos: [VideoItem] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(viewModel: VideosViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = VideosView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.fetchVideos()
        }
    }
    
    // MARK - Private Methods
    private func setupUI() {
        title = "Recipe Videos"
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
        customView?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VideoCell")
    }

    private func setupBindings() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &cancellables)
    }
    
    private func handle(state: VideosState) {
        switch state {
        case .loading:
            customView?.activityIndicator.startAnimating()
            customView?.emptyStateView.isHidden = true
            
        case .loaded(let videos):
            customView?.activityIndicator.stopAnimating()
            self.videos = videos
            customView?.emptyStateView.configure(with: "No videos found.", iconName: "play.tv.fill")
            customView?.emptyStateView.isHidden = !videos.isEmpty
            customView?.tableView.reloadData()
            
        case .error(let message):
            customView?.activityIndicator.stopAnimating()
            self.videos = []
            customView?.emptyStateView.configure(with: message, iconName: "exclamationmark.triangle")
            customView?.emptyStateView.isHidden = false
            customView?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension VideosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
        let video = videos[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = video.snippet.title
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension VideosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedVideo = videos[indexPath.row]
        delegate?.videosViewController(self, didSelectVideo: selectedVideo)
    }
}
