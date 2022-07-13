//
//  mainCollectionViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MainCollectionViewCell"
    
    private let temperatuerLabel: UILabel = {
        let temperatuerLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        temperatuerLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatuerLabel.text = "25°"
        temperatuerLabel.font = .systemFont(ofSize: 48, weight: .medium)
        temperatuerLabel.textColor = .white
        
        return temperatuerLabel
    }()
    
    private let regionLabel: UILabel = {
        let regionLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        regionLabel.text = "포항시"
        regionLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        regionLabel.textColor = .white
        
        return regionLabel
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(regionLabel)
        self.addSubview(temperatuerLabel)
        self.backgroundColor = .gray
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.setConstraints()
        }
    }
    
    func setUI() {
        self.layer.cornerRadius = 4
        imageView.image = UIImage(named: "surf2.png")
    }
    
    func setConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        let regionLabelConstraints = [
            regionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            regionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        ]
        let temperatureLabelConstraints = [
            temperatuerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            temperatuerLabel.topAnchor.constraint(equalTo: regionLabel.topAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(regionLabelConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
    }
}
