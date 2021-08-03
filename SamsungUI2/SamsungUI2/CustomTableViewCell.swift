//
//  CustomTableViewCell.swift
//  SamsungUI2
//
//  Created by Hemant Sharma on 04/08/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    private lazy var containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        internal lazy var productImageView: UIImageView = {
            let productImage = UIImageView()
            productImage.translatesAutoresizingMaskIntoConstraints = false
            return productImage
        }()
        
        internal var productName: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            return label
        }()

        internal lazy var productPrice: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()

        internal lazy var productOfferPrice: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = label.font.withSize(16)
            return label
        }()
        
        internal lazy var productStrikeThroughPriceDisplay: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = label.font.withSize(12)
            label.textColor = .red
            return label
        }()
        
        internal lazy var productBookButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Book", for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            return button
        }()


        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            styleView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func styleView()
        {
            contentView.addSubview(containerView)
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            
            containerView.addSubview(productImageView)
            NSLayoutConstraint.activate([
                productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                productImageView.widthAnchor.constraint(equalToConstant: 100),
                productImageView.heightAnchor.constraint(equalToConstant: 100),
                productImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
            containerView.addSubview(productName)
            NSLayoutConstraint.activate([
                productName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                productName.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
                productName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
            ])
            productName.numberOfLines = 0
            productName.font = UIFont.systemFont(ofSize: 18)
            
            containerView.addSubview(productPrice)
            NSLayoutConstraint.activate([
                productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 8),
                productPrice.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
                productPrice.widthAnchor.constraint(equalToConstant: 120)
            ])
            productName.font = UIFont.systemFont(ofSize: 16)

            containerView.addSubview(productOfferPrice)
            NSLayoutConstraint.activate([
                productOfferPrice.topAnchor.constraint(equalTo: productPrice.bottomAnchor, constant: 8),
                productOfferPrice.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
                productOfferPrice.widthAnchor.constraint(equalToConstant: 120)
            ])
            productOfferPrice.font = UIFont.systemFont(ofSize: 14)
            
            containerView.addSubview(productStrikeThroughPriceDisplay)
            NSLayoutConstraint.activate([
                productStrikeThroughPriceDisplay.topAnchor.constraint(equalTo: productOfferPrice.bottomAnchor, constant: 8),
                productStrikeThroughPriceDisplay.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
                productStrikeThroughPriceDisplay.widthAnchor.constraint(equalToConstant: 120)
            ])
            productStrikeThroughPriceDisplay.font = UIFont.systemFont(ofSize: 12)
            
            containerView.addSubview(productBookButton)
            NSLayoutConstraint.activate([
                productBookButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
                productBookButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
                productBookButton.widthAnchor.constraint(equalToConstant: 80),
                productBookButton.heightAnchor.constraint(equalToConstant: 40)

            ])
        }
        
        
        func configure(images: String?, name: String?, priceDisplay: String?, offerPriceDisplay: String?, strikeThroughPriceDisplay: String?) {
            productImageView.downloaded(from: images)
            productName.text = name
            productPrice.text = priceDisplay
            productOfferPrice.text = offerPriceDisplay
            productStrikeThroughPriceDisplay.attributedText = strikeThroughPriceDisplay?.strikeThroughText()
        }
    }


    extension UIImageView {
        func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
        func downloaded(from link: String?, contentMode mode: ContentMode = .scaleAspectFit) {
            if let link = link {
                guard let url = URL(string: link) else { return }
                downloaded(from: url, contentMode: mode)
            }
        }
    }

    extension String {
        func strikeThroughText() -> NSAttributedString {
            let attributeString =  NSMutableAttributedString(string: self)
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                   value: NSUnderlineStyle.single.rawValue,
                       range:NSMakeRange(0,attributeString.length))
            return attributeString
        }
    }
