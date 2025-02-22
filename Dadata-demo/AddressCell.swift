//
//  AddressCell.swift
//  Dadata-demo
//
//  Created by Rishat Zakirov on 05.02.2025.
//

import UIKit
class AddressCell: UITableViewCell {
    
    static let reuseId = "AddressCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Москва"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(address: SuggestAddress) {
        addressLabel.text = address.value
    }
}

extension AddressCell {
    func setupViews() {
        contentView.addSubview(addressLabel)
    }
    
    func setupConstraints() {
        addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
