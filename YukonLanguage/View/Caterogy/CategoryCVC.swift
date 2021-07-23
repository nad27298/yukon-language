//
//  CategoryCVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import UIKit

class CategoryCVC: UICollectionViewCell {
    
    @IBOutlet weak var trailingSeach: NSLayoutConstraint!
    @IBOutlet weak var topSearch: NSLayoutConstraint!
    @IBOutlet weak var leadImg: NSLayoutConstraint!
    @IBOutlet weak var topImg: NSLayoutConstraint!
    @IBOutlet weak var topNote: NSLayoutConstraint!
    @IBOutlet weak var leadNote: NSLayoutConstraint!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var topTitle: NSLayoutConstraint!
    @IBOutlet weak var leadTitle: NSLayoutConstraint!
    @IBOutlet weak var imgZoom: UIImageView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var imgHinh: UIImageView!
    @IBOutlet weak var viewBot: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var scale = DEVICE_WIDTH / 414
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leadTitle.constant = 88 * scale
        topTitle.constant = 15 * scale
        leadNote.constant = 88 * scale
        topNote.constant = 5 * scale
        leadImg.constant = 17 * scale
        topImg.constant = 14 * scale
        trailingSeach.constant = 21 * scale
        topSearch.constant = 23 * scale
        lblTitle.font = lblTitle.font.withSize(16 * scale)
        lblNote.font = lblNote.font.withSize(16 * scale)
    }
    
}
