//
//  SettingCVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/4/20.
//

import UIKit

class SettingCVC: UICollectionViewCell {

    @IBOutlet weak var leadLblC: NSLayoutConstraint!
    @IBOutlet weak var leadImgC: NSLayoutConstraint!
    @IBOutlet weak var topImgC: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    var scale = DEVICE_WIDTH / 414
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topImgC.constant = 9 * scale
        leadImgC.constant = 20 * scale
        leadLblC.constant = 30 * scale
        lblName.font = lblName.font.withSize(23 * scale)
    }

}
