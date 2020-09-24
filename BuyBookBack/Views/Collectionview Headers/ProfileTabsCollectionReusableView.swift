//
//  ProfileTabsCollectionReusableView.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-22.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate: AnyObject {
    func didTapGridButtonTab()
    func didTapTaggedButtonTab()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileTabsCollectionReusableView"
    
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate?
    
    struct Constants {
        static let padding: CGFloat = 8
    }
    private let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        return button
    }()
    
    private let taggedButton: UIButton = {
          let button = UIButton()
          button.clipsToBounds = true
          button.tintColor = .secondarySystemBackground
          button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
          return button
      }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(gridButton)
        addSubview(taggedButton)
        
        gridButton.addTarget(self, action: #selector(didTapGridsButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTapTaggedsButton), for: .touchUpInside)
    }
    
    @objc private func didTapGridsButton() {
        gridButton.tintColor = .systemBlue
        taggedButton.tintColor = .lightGray
           delegate?.didTapGridButtonTab()
       }
    
    @objc private func didTapTaggedsButton() {
        gridButton.tintColor = .lightGray
        taggedButton.tintColor = .systemBlue
           delegate?.didTapGridButtonTab()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height - (Constants.padding * 2)
        let gridButtonX = ((width / 2) - size)/2
        gridButton.frame = CGRect(
            x: gridButtonX,
            y: Constants.padding,
            width: size,
            height: size
        ).integral
        
        taggedButton.frame = CGRect(
                   x: gridButtonX + (width/2),
                   y: Constants.padding,
                   width: size,
                   height: size
               ).integral
    }
}
