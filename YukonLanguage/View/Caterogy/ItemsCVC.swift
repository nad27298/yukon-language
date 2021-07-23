//
//  ItemsCVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/2/20.
//

import UIKit

protocol LoadDelegate: class {
    func updateAnswerFav()
}

class ItemsCVC: UICollectionViewCell {

    @IBOutlet weak var trailingFavC: NSLayoutConstraint!
    @IBOutlet weak var botFavC: NSLayoutConstraint!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var imgCopy: UIImageView!
    @IBOutlet weak var leadFav: NSLayoutConstraint!
    @IBOutlet weak var leadCopy: NSLayoutConstraint!
    @IBOutlet weak var topUpdate: NSLayoutConstraint!
    @IBOutlet weak var leadLogoBC: NSLayoutConstraint!
    @IBOutlet weak var trailingLogoAC: NSLayoutConstraint!
    @IBOutlet weak var leadLogoAC: NSLayoutConstraint!
    @IBOutlet weak var botItems: NSLayoutConstraint!
    @IBOutlet weak var topLineC: NSLayoutConstraint!
    @IBOutlet weak var topNoteC: NSLayoutConstraint!
    @IBOutlet weak var topTitleC: NSLayoutConstraint!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var imgLogoB: UIImageView!
    @IBOutlet weak var imgLogoA: UIImageView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    let scale = DEVICE_WIDTH / 414
    var strNote: String = ""
    var strFavorite: String = ""
    var strID: Int = 0
    
    weak var delegate: LoadDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topTitleC.constant = 5 * scale
        topNoteC.constant = 8 * scale
        topLineC.constant = 8 * scale
        botItems.constant = 3 * scale
        leadLogoAC.constant = 12 * scale
        trailingLogoAC.constant = 7 * scale
        leadLogoBC.constant = 7 * scale
        topUpdate.constant = 8 * scale
        leadCopy.constant = 16 * scale
        leadFav.constant = 16 * scale
        botFavC.constant = 3 * scale
        trailingFavC.constant = 15 * scale
        lblNote.font = lblNote.font.withSize(14 * scale)
        lblTitle.font = lblTitle.font.withSize(14 * scale)
        let tapCopy = UITapGestureRecognizer(target: self, action: #selector(imageTappedCopy(tapCopy:)))
        imgCopy.isUserInteractionEnabled = true
        imgCopy.addGestureRecognizer(tapCopy)
        let tapShare = UITapGestureRecognizer(target: self, action: #selector(imageTappedShare(tapShare:)))
        imgShare.isUserInteractionEnabled = true
        imgShare.addGestureRecognizer(tapShare)
        let tapFavorite = UITapGestureRecognizer(target: self, action: #selector(imageTappedFavorite(tapFavorite:)))
        imgFavorite.isUserInteractionEnabled = true
        imgFavorite.addGestureRecognizer(tapFavorite)
    }
    
    func setImageFavorite() {
        if strFavorite == "false" {
            imgFavorite.image = UIImage(named: "Vector")
        } else {
            imgFavorite.image = UIImage(named: "Vector Red")
        }
    }
    
    @objc func imageTappedCopy(tapCopy: UITapGestureRecognizer) {
        let vc = self.parentViewController
        if PaymentManager.shared.isPurchase() {
            UIPasteboard.general.string = strNote
            let alert: UIAlertController = UIAlertController(title: "", message: "Copied", preferredStyle: .alert)
            let btn_OK: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btn_OK)
            vc?.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                let premium = vc?.storyboard?.instantiateViewController(withIdentifier: PremiumVC.className) as! PremiumVC
                premium.modalPresentationStyle = .fullScreen
                vc?.present(premium, animated: true, completion: nil)
            }
        }
    }
    
    @objc func imageTappedShare(tapShare: UITapGestureRecognizer) {
        let vc = self.parentViewController
        let text = strNote
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc?.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        // present the view controller
        vc?.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func imageTappedFavorite(tapFavorite: UITapGestureRecognizer) {
        if strFavorite == "false" {
            _ = ItemsEntity.shared.updateFavData("true", strID)
            strFavorite = "true"
            print(strFavorite)
        } else {
            _ = ItemsEntity.shared.updateFavData("false", strID)
            strFavorite = "false"
            print(strFavorite)
        }
        setImageFavorite()
        delegate?.updateAnswerFav()
    }
    
    func fillData(_ data: ItemsModel) {
        strNote = data.locaziation()
        strFavorite = data.fav
        strID = data.id
    }
    

}
