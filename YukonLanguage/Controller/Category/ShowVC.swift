//
//  ShowVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/2/20.
//

import UIKit
import SQLite
import AVKit
import AVFoundation
import Social
import GoogleMobileAds
import FBAudienceNetwork

class ShowVC: UIViewController {

    @IBOutlet weak var heightV: NSLayoutConstraint!
    @IBOutlet weak var trailingBtnIn: NSLayoutConstraint!
    @IBOutlet weak var leadBtnIn: NSLayoutConstraint!
    @IBOutlet weak var topBtnIn: NSLayoutConstraint!
    @IBOutlet weak var topInside: NSLayoutConstraint!
    @IBOutlet weak var trailingView: NSLayoutConstraint!
    @IBOutlet weak var topUpC: NSLayoutConstraint!
    @IBOutlet weak var leadBtn3: NSLayoutConstraint!
    @IBOutlet weak var leadBtn2C: NSLayoutConstraint!
    @IBOutlet weak var botView: NSLayoutConstraint!
    @IBOutlet weak var topLine: NSLayoutConstraint!
    @IBOutlet weak var topNoteC: NSLayoutConstraint!
    @IBOutlet weak var topBtn2C: NSLayoutConstraint!
    @IBOutlet weak var leadLaA: NSLayoutConstraint!
    @IBOutlet weak var topTitleC: NSLayoutConstraint!
    @IBOutlet weak var leadBtn1C: NSLayoutConstraint!
    @IBOutlet weak var topBtn1C: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLanguegaB: UILabel!
    @IBOutlet weak var lblLanguageA: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var viewInside: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    var checkData: Int = 0
    var checkId: Int = 0
    var showData: [ItemsModel] = []
    var name: String = ""
    var strTitle: String = ""
    var strNote: String = ""
    var code: String = ""
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    
    let scale = DEVICE_WIDTH / 414
   
    override func viewDidLoad() {
        super.viewDidLoad()
        showData = ItemsEntity.shared.getDataCatId(checkId)
        view.addSubview(viewBackground)
        viewBackground.addSubview(viewInside)
        viewBackground.layer.cornerRadius = 10 * scale
        viewInside.layer.cornerRadius = 10 * scale
        lblName.text = name
        lblLanguageA.text = "English"
        reloadBackground()
        scaleToFill()
        AdmobManager.shared.loadBannerView(inVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadBackground()
    }
    
    
    func scaleToFill() {
        topBtn1C.constant = 10 * scale
        leadBtn1C.constant = 10 * scale
        topTitleC.constant = 38 * scale
        leadLaA.constant = 5 * scale
        topBtn2C.constant = 70 * scale
        topNoteC.constant = 15 * scale
        topLine.constant = 7 * scale
        botView.constant = 3 * scale
        leadBtn2C.constant = 10 * scale
        leadBtn3.constant = 15 * scale
        topUpC.constant = 15 * scale
        trailingView.constant = 17 * scale
        topInside.constant = 16 * scale
        topBtnIn.constant = 56 * scale
        leadBtnIn.constant = 84 * scale
        trailingBtnIn.constant = 84 * scale
        lblName.font = lblName.font.withSize(20 * scale)
        lblTitle.font = lblTitle.font.withSize(16 * scale)
        lblNote.font = lblNote.font.withSize(16 * scale)
        lblLanguageA.font = lblLanguageA.font.withSize(14 * scale)
        lblLanguegaB.font = lblLanguegaB.font.withSize(14 * scale)
        heightV.constant = 243 * scale
    }
    
    func setBackgroundImageForBtnFavorite(){
        if showData[checkData].fav == "false" {
            btnFavorite.setImage(UIImage(named: "Vector"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(named: "Vector Red"), for: .normal)
        }
    }
    
    func reloadBackground() {
        lblTitle.text = showData[checkData].title
        strTitle = showData[checkData].title
        strNote = showData[checkData].locaziation()
        lblNote.text = showData[checkData].locaziation()
        lblLanguegaB.getLabelNote()
        setBackgroundImageForBtnFavorite()
    }
    
    @IBAction func btn_Copy(_ sender: Any) {
        if PaymentManager.shared.isPurchase() {
            UIPasteboard.general.string = strNote
            let alert: UIAlertController = UIAlertController(title: "", message: "Copied", preferredStyle: .alert)
            let btn_OK: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btn_OK)
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                let premium = self.storyboard?.instantiateViewController(withIdentifier: PremiumVC.className) as! PremiumVC
                premium.modalPresentationStyle = .fullScreen
                self.present(premium, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btn_Connect(_ sender: Any) {
        let text = strNote
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btn_Favorite(_ sender: Any) {
        if showData[checkData].fav == "false" {
            _ = ItemsEntity.shared.updateFavData("true", showData[checkData].id)
            showData[checkData].fav = "true"
            print(showData[checkData].fav)
        } else {
            _ = ItemsEntity.shared.updateFavData("false", showData[checkData].id)
            showData[checkData].fav = "false"
            print(showData[checkData].fav)
        }
        setBackgroundImageForBtnFavorite()
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_Preview(_ sender: Any) {
        self.checkData -= 1
        if checkData < 0 {
            self.checkData = showData.count - 1
        }
        reloadBackground()
    }
    
    @IBAction func btn_Next(_ sender: Any) {
        self.checkData += 1
        if checkData == showData.count {
            self.checkData = 0
        }
        reloadBackground()
    }
    
    func getSpeechLanguage(_ str: String,_ codename: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: str)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: codename)
        synthesizer.speak(utterance)
    }
    
    @IBAction func btn_Play(_ sender: Any) {
        if PaymentManager.shared.isPurchase() {
            getSpeechLanguage(strNote, code.getCode())
        } else {
            DispatchQueue.main.async {
                let premium = self.storyboard?.instantiateViewController(withIdentifier: PremiumVC.className) as! PremiumVC
                premium.modalPresentationStyle = .fullScreen
                self.present(premium, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btn_VoiceA(_ sender: Any) {
        getSpeechLanguage(strTitle, "en")
    }
    
    @IBAction func btn_VoiceB(_ sender: Any) {
        if PaymentManager.shared.isPurchase() {
            getSpeechLanguage(strNote, code.getCode())
        } else {
            DispatchQueue.main.async {
                let premium = self.storyboard?.instantiateViewController(withIdentifier: PremiumVC.className) as! PremiumVC
                premium.modalPresentationStyle = .fullScreen
                self.present(premium, animated: true, completion: nil)
            }
        }
    }
}
