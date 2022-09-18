//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/12.
//

import UIKit
import MapKit

class SearchTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(result: MKLocalSearchCompletion) {
        let string = result.title + " (" + result.subtitle + ")"
        let attribtuedString = NSMutableAttributedString(string: string)
        let range = result.titleHighlightRanges
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.gray, range: (string as NSString).range(of: string))
        attribtuedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: (string as NSString).range(of: string))
        range.forEach{
            attribtuedString.addAttribute(.foregroundColor, value: UIColor.black, range: $0.rangeValue)
            attribtuedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: $0.rangeValue)
        }
        self.textLabel?.attributedText = attribtuedString
        self.backgroundColor = .clear
    }
}
