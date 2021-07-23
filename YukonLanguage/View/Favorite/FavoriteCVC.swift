//
//  FavoriteCVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/3/20.
//

import UIKit

protocol SmartDelegate: class {
    func updateAnswer()
}

class FavoriteCVC: UICollectionViewCell {

    @IBOutlet weak var leadFavC2: NSLayoutConstraint!
    @IBOutlet weak var botFav: NSLayoutConstraint!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var imgCopy: UIImageView!
    @IBOutlet weak var trailCLV: NSLayoutConstraint!
    @IBOutlet weak var leadCon: NSLayoutConstraint!
    @IBOutlet weak var topUp: NSLayoutConstraint!
    @IBOutlet weak var leadLaBC: NSLayoutConstraint!
    @IBOutlet weak var leadUpC: NSLayoutConstraint!
    @IBOutlet weak var leadLaAC: NSLayoutConstraint!
    @IBOutlet weak var botFavC: NSLayoutConstraint!
    @IBOutlet weak var topLineC: NSLayoutConstraint!
    @IBOutlet weak var topNoteC: NSLayoutConstraint!
    @IBOutlet weak var topTitleC: NSLayoutConstraint!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var imgLanguegaB: UIImageView!
    @IBOutlet weak var imgLanguegaA: UIImageView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var scale = DEVICE_WIDTH / 414
    var strNote: String = ""
    var strFavorite: String = ""
    var strID: Int = 0
    
    weak var delegate: SmartDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topTitleC.constant = 5 * scale
        topNoteC.constant = 8 * scale
        topLineC.constant = 8 * scale
        botFavC.constant = 3 * scale
        leadLaAC.constant = 12 * scale
        leadUpC.constant = 7 * scale
        leadLaBC.constant = 7 * scale
        topUp.constant = 8 * scale
        leadCon.constant = 10 * scale
        trailCLV.constant = 15 * scale
        botFav.constant = 3 * scale
        leadFavC2.constant = 16 * scale
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
        delegate?.updateAnswer()
    }
    
    func fillData(_ data: ItemsModel) {
        strNote = data.locaziation()
        strFavorite = data.fav
        strID = data.id
    }
    

}
