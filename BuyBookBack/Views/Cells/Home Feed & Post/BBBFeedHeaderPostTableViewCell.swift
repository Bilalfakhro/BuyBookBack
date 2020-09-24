//
//  BBBFeedHeaderPostTableViewCell.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-22.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import UIKit
import SDWebImage

protocol BBBFeedHeaderPostTableViewCellDelegate: AnyObject {
    func didTapMoreButton()
}

class BBBFeedHeaderPostTableViewCell: UITableViewCell {
    static let identifier = "BBBFeedHeaderPostTableViewCell"
    
    weak var delegate: BBBFeedHeaderPostTableViewCellDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        delegate?.didTapMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: User) {
        usernameLabel.text = model.username
        profilePhotoImageView.image = UIImage(systemName: "person.circle")
        //        profilePhotoImageView.sd_setImage(with: model.profilePhoto, completed: nil)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        let size = contentView.height - 4
        profilePhotoImageView.frame = CGRect(
            x: 2,
            y: 2,
            width: size,
            height: size
        )
        profilePhotoImageView.layer.cornerRadius = size / 2 
        
        usernameLabel.frame = CGRect(
            x: profilePhotoImageView.right + 10,
            y: 2,
            width: contentView.width - (size * 2) - 15,
            height: contentView.height - 4
        )
        
        moreButton.frame = CGRect(
            x: contentView.width - size,
            y: 2,
            width: size,
            height: size
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profilePhotoImageView.image = nil
    }
}
