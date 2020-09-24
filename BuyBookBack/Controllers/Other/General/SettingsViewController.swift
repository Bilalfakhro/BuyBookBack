//
//  SettingsViewController.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-20.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import UIKit
import FirebaseAuth
import SafariServices

struct SettingsCellModal {
    let title: String
    let handler: (() -> Void)
}
/// View Controller to show user settings
final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingsCellModal]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels(){
        data.append([
            SettingsCellModal(title: "Edit Profile"){ [weak self] in
                self?.didTapEditProfile()
            },
            SettingsCellModal(title: "Invite Friends"){ [weak self] in
                self?.didTapInviteFriends()
            },
            SettingsCellModal(title: "Save Original Posts"){ [weak self] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        
        data.append([
            SettingsCellModal(title: "Term of Service"){ [weak self] in
                self?.openURL(type: .terms)
            },
            SettingsCellModal(title: "Privacy Policy"){ [weak self] in
                self?.openURL(type: .privacy)
            },
            SettingsCellModal(title: "Help / Feedback"){ [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            SettingsCellModal(title: "Logg Out"){ [weak self] in
                self?.didTapLogOut()
            }
        ])
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends() {
        
    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType) {
        let urlString: String
        switch type {
        case .terms: urlString = "https://help.instagram.com/581066165581870?%3F__hstc=20629287.2f3f33a24b44870ec4a577029c49e44b.1585353600091.1585353600092.1585353600093.1&__hssc=192971698.1.1585872000174&__hsfp=3071927421&_ga=2.67531538.2090819656.1556546632-504387059.1544696302"
        case .privacy: urlString = "https://help.instagram.com/519522125107875"
        case .help: urlString = "https://help.instagram.com/"
        }
        guard  let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapLogOut(){
        let actionSheet = UIAlertController(
            title: "Log Out",
            message: "Are you sure yoy want to log out?",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: { succes in
                DispatchQueue.main.async {
                    if succes {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        // error accured
                        fatalError("Could not log out user")
                    }
                }
                
            })
        }))
        
        // Ipad
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}
