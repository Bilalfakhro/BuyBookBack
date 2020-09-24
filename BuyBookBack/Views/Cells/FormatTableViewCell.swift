//
//  FormatTableViewCell.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-22.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import UIKit

protocol FormatTableViewCellDelegate: AnyObject {
    func formatTableViewCell(_ cell: FormatTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormatTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "FormatTableViewCell"
    
    private var model: EditProfileFormModel?
    
    public weak var delegate: FormatTableViewCellDelegate?
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: EditProfileFormModel) {
        self.model = model
        formLabel.text = model.label
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    // Empty fields on app save
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Assign frames
        formLabel.frame = CGRect(
            x: 5,
            y: 0,
            width: contentView.width / 3,
            height: contentView.height
        )
        field.frame = CGRect(
            x: formLabel.right + 5,
            y: 0,
            width: contentView.width - 10 - formLabel.width,
            height: contentView.height
        )
    }
    
    // MARK: - Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.formatTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
    
}
