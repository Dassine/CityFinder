//
//  SearchFooterView.swift
//  GeolocalizedCitiesList
//
//  Created by D. on 2018-05-05.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class SearchFooterView: UIView {
    let label: UILabel = UILabel()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        backgroundColor = .black
        alpha = 0.0
        
        // Configure label
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }
    
    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }
    
    //MARK: - Animation
    
    fileprivate func hideFooter() {
        UIView.animate(withDuration: 0.7) {[unowned self] in
            self.alpha = 0.0
        }
    }
    
    fileprivate func showFooter() {
        UIView.animate(withDuration: 0.7) {[unowned self] in
            self.alpha = 1.0
        }
    }
}

extension SearchFooterView {
    //MARK: - Public API
    
    public func setNotFiltering() {
        label.text = ""
        hideFooter()
    }
    
    public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        if (filteredItemCount == totalItemCount) {
            setNotFiltering()
        } else if (filteredItemCount == 0) {
            label.text = "No items match your query"
            showFooter()
        } else {
            label.text = "\(filteredItemCount) of \(totalItemCount)"
            showFooter()
        }
    }
    
}
