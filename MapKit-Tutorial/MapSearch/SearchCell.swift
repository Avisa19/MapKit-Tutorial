//
//  SearchCell.swift
//  MapKit-Tutorial
//
//  Created by Avisa on 20/8/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "test"
        return label
    }()
    
    let detailTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "detail test"
        return label
    }()
    
    let separatorLineView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        addSubview(textLabel)
        textLabel.anchor(top: self.topAnchor, paddingTop: 0, left: self.leftAnchor, paddingLeft: 8, bottom: nil, paddingBottom: 0, right: self.rightAnchor, paddingRight: 0, width: 0, height: 50, centerX: nil, centerY: nil)
        
        addSubview(detailTextLabel)
        detailTextLabel.anchor(top: textLabel.bottomAnchor, paddingTop: 0, left: self.leftAnchor, paddingLeft: 8, bottom: nil, paddingBottom: 0, right: self.rightAnchor, paddingRight: 0, width: 0, height: 50, centerX: nil, centerY: nil)
        
        addSubview(separatorLineView)
        separatorLineView.anchor(top: nil, paddingTop: 0, left: self.leftAnchor, paddingLeft: 0, bottom: self.bottomAnchor, paddingBottom: 0, right: self.rightAnchor, paddingRight: 0, width: 0, height: 0.5, centerX: nil, centerY: nil)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
