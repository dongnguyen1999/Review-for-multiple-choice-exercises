//
//  PagingView.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 21/01/2021.
//

import UIKit

class PagingView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dotContainerView: UIStackView!
    @IBOutlet weak var prevButton: UIImageView!
    @IBOutlet weak var nextButton: UIImageView!
    
    let type = PagingViewType.THREE_DOT
    
    var onChangePageCallback: ((Int) -> Void)?
    
    var totalPage = 1
    var activePage: Int = 4 {
        didSet {
            onChangePageCallback!(activePage)
        }
    }
    
    
    
    var dotViews = [UIImageView]()
    
    let nextAvailableImage = UIImage(named: "icon_arrow_next_outline")
    let nextUnavailableImage = UIImage(named: "icom_arrow_next")
    let prevAvailableImage = UIImage(named: "icon_arrow_prev_outline")
    let prevUnavailableImage = UIImage(named: "icon_arrow_prev")
    let grayDotImage = UIImage(named: "icon_pageble_dot_gray")
    let orangeDotImage = UIImage(named: "icon_pageable_dot_orange")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadLayout()
    }
    
    func loadLayout() {
        let viewFromXib = Bundle.main.loadNibNamed("PagingView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        viewFromXib.boxShadow(offsetX: 0.0, offsetY: -0.3, opacity: 0.2, radius: 25)
        addSubview(viewFromXib)
        nextButton.setOnTapListener(context: self, action: #selector(nextTapped(sender:)))
        prevButton.setOnTapListener(context: self, action: #selector(prevTapped(sender:)))
        
    }
    
    func setNumberOfPage(totalPage n: Int) {
        totalPage = n
        initPagingDots()
        render()
    }
    
    
    
    func initPagingDots() {
        dotViews.removeAll()
        for i in 0..<totalPage {
            let dot = UIImageView()
            dot.image = grayDotImage
            dot.heightAnchor.constraint(equalTo: dot.widthAnchor, multiplier: 1.0/1.0).isActive = true
            dot.setOnTapListener(context: self, action: #selector(dotTapped(sender:)))
            dot.restorationIdentifier = "\(i)"
            dotViews.append(dot)
        }
        activePage = 0
    }
    
    @objc func dotTapped(sender: UITapGestureRecognizer)
    {
        let tappedImage = sender.view as! UIImageView
        let selectedPageNumber = Int(tappedImage.restorationIdentifier!)
        activePage = selectedPageNumber!
        render()
    }
    
    @objc func nextTapped(sender: UITapGestureRecognizer)
    {
        let tappedImage = sender.view as! UIImageView
        let isAvailable = Bool(tappedImage.restorationIdentifier!)
        if isAvailable == true {
            activePage += 1
            render()
        }
    }
    
    @objc func prevTapped(sender: UITapGestureRecognizer)
    {
        let tappedImage = sender.view as! UIImageView
        let isAvailable = Bool(tappedImage.restorationIdentifier!)
        if isAvailable == true {
            activePage -= 1
            render()
        }
    }
    
    
    func render() {
        dotContainerView.subviews.forEach({$0.removeFromSuperview()})
        
        if type == PagingViewType.THREE_DOT {
            var insertedMid = false
            for i in 0..<totalPage {
                let dot = dotViews[i]
                dot.image = grayDotImage
                
                if i > 0 && i < totalPage-1 && insertedMid == false {
                    for j in 1..<totalPage-1 {
                        if j == activePage {
                            dot.image = orangeDotImage
                        }
                    }
                    dotContainerView.addArrangedSubview(dot)
                    insertedMid = true
                } else if i == 0 || i == totalPage-1 {
                    if i == activePage {
                        dot.image = orangeDotImage
                    }
                    dotContainerView.addArrangedSubview(dot)
                }
            }
        } else if type == PagingViewType.MULTIDOT {
            for i in 0..<totalPage {
                let dot = dotViews[i]
                dot.image = grayDotImage
                if i == activePage {
                    dot.image = orangeDotImage
                }
                dotContainerView.addArrangedSubview(dot)
            }
        }
        
        
        
        if activePage == 0 {
            prevButton.restorationIdentifier = "false"
            prevButton.image = prevUnavailableImage
        } else {
            prevButton.restorationIdentifier = "true"
            prevButton.image = prevAvailableImage
        }
        
        if activePage == totalPage - 1 {
            nextButton.restorationIdentifier = "false"
            nextButton.image = nextUnavailableImage
        } else {
            nextButton.restorationIdentifier = "true"
            nextButton.image = nextAvailableImage
            
        }
        
    }
    
}
