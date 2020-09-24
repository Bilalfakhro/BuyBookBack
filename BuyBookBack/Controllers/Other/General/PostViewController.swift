//
//  PostViewController.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-20.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import UIKit

/*
 
 Section
 - Header model
 Section
 - Post cell model
 Section
 - Action button cell model
 Section
 - Number of generals model of comments
 
 */

/// States of a render cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) // post
    case actions(provider: String) // Like, comment, share
    case comments(comments: [PostComment])
}

/// Model of rended post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {
    
    private let model: UserPost?
    
    private var renderModels = [PostRenderViewModel ]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register Cells
        tableView.register(BBBFeedPostTableViewCell.self, forCellReuseIdentifier: BBBFeedPostTableViewCell.identifier)
        tableView.register(BBBFeedHeaderPostTableViewCell.self, forCellReuseIdentifier: BBBFeedHeaderPostTableViewCell.identifier)
        tableView.register(BBBFeedPostActionsTableViewCell.self, forCellReuseIdentifier: BBBFeedPostActionsTableViewCell.identifier)
        tableView.register(BBBFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: BBBFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Init
    
    init(model: UserPost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    private func configureModels() {
        guard let userPostModel = self.model else {
            return
        }
        // Header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        // Posts
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        // Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        // 4 Comments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(
                PostComment(
                    identifier: "123_\(x)",
                    username: "@John",
                    text: "Great post",
                    createdDate: Date(),
                    likes: []
                )
            )
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .header(_): return 1
        case .primaryContent(_): return 1
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        switch model.renderType {
            
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedHeaderPostTableViewCell.identifier, for: indexPath) as! BBBFeedHeaderPostTableViewCell
            return cell
            
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedPostTableViewCell.identifier, for: indexPath) as! BBBFeedPostTableViewCell
            return cell
            
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedPostActionsTableViewCell.identifier, for: indexPath) as! BBBFeedPostActionsTableViewCell
            return cell
            
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedPostGeneralTableViewCell.identifier, for: indexPath) as! BBBFeedPostGeneralTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        
        switch model.renderType {
        case .header(_): return 70
        case .primaryContent(_): return tableView.width
        case .actions(_): return 60
        case .comments(_): return 50
        }
    }
}
