//
//  ViewController.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-18.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModels {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModels]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register Cells
        tableView.register(BBBFeedPostTableViewCell.self, forCellReuseIdentifier: BBBFeedPostTableViewCell.identifier)
        tableView.register(BBBFeedHeaderPostTableViewCell.self, forCellReuseIdentifier: BBBFeedHeaderPostTableViewCell.identifier)
        tableView.register(BBBFeedPostActionsTableViewCell.self, forCellReuseIdentifier: BBBFeedPostActionsTableViewCell.identifier)
        tableView.register(BBBFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: BBBFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createMockModels() {
        let user = User(
            username: "@John_Rambo",
            bio: "",
            name: (first: "", last: ""),
            profilePhoto: URL(string: "https//:www.google.com")!,
            birthDate: Date(),
            gender: .male,
            counts: UserCounts(
                followers: 1,
                followings: 1,
                posts: 1
            ),
            joinDate: Date()
        )
        let post = UserPost(
            identifier: "",
            postType: .photo,
            thumbnailImage: URL(string: "https//:www.google.com")!,
            postURL: URL(string: "https//:www.google.com")!,
            caption: nil,
            likeCount: [],
            comments: [],
            createdDate: Date(),
            taggUsers: [],
            price: [],
            owner: user
        )
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(
                PostComment(
                    identifier: "\(x)",
                    username: "@jenny",
                    text: "This is the best post i´ve seen!",
                    createdDate: Date(),
                    likes: []
                )
            )
        }
        for x in 0..<5 {
            let viewModel = HomeFeedRenderViewModels(
                header: PostRenderViewModel(renderType: .header(provider: user)),
                post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                actions: PostRenderViewModel(renderType: .actions(provider: "")),
                comments: PostRenderViewModel(renderType: .comments(comments: comments))
            )
            feedRenderModels.append(viewModel)
        }
    }
    
    private func handleNotAuthenticated() {
        
        // Check Auth status
        if Auth.auth().currentUser == nil {
            // Show login screen
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModels
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let positon = x % 4 == 0 ? x / 4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[positon]
        }
        let subSection = x % 4
        if subSection == 0 {
            // Header
            return 1
        }
        else if subSection == 1 {
            // Post
            return 1
        }
        else if subSection == 2 {
            // Actions
            return 1
        }
        else if subSection == 3 {
            // Comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .header, .actions, .primaryContent: return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModels
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let positon = x % 4 == 0 ? x / 4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[positon]
        }
        let subSection = x % 4
        if subSection == 0 {
            // Header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedHeaderPostTableViewCell.identifier, for: indexPath) as! BBBFeedHeaderPostTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 1 {
            // Post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedPostTableViewCell.identifier, for: indexPath) as! BBBFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            // Actions
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedPostActionsTableViewCell.identifier, for: indexPath) as! BBBFeedPostActionsTableViewCell
                cell.delegate = self
                return cell
            case .comments, .header, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 3 {
            // Comments
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: BBBFeedPostGeneralTableViewCell.identifier, for: indexPath) as! BBBFeedPostGeneralTableViewCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        if subSection == 0 {
            // Header
            return 70
        }
        else  if subSection == 1 {
            // Post
            return tableView.width
        }
        else  if subSection == 2 {
            // Actions(like, comments)
            return 60
        }
        else  if subSection == 3 {
            // Comments Row
            return 50
        }
        return 0
    }
    
    // Empty Section Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0 
    }
}

extension HomeViewController: BBBFeedHeaderPostTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated:  true)
    }
    
    func reportPost() {
    }
}

extension HomeViewController: BBBFeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        print("Like Button")
    }
    
    func didTapCommentButton() {
        print("Comment Button")
    }
    
    func didTapSendButton() {
        print("Send Button")
    }
    
    
}
