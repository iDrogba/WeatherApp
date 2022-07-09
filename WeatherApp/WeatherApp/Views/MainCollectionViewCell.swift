//
//  mainCollectionViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MainCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
//        let cellConstraints = [
//        ]
    }
}