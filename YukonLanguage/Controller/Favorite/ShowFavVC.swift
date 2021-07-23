//
//  ShowFavVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/3/20.
//

import UIKit
import SQLite
import AVKit
import AVFoundation
import Social

class ShowFavVC: UIViewController {
    
    @IBOutlet weak var trailFav: NSLayoutConstraint!
    @IBOutlet weak var leadBTN3: NSLayoutConstraint!
    @IBOutlet weak var topUp: NSLayoutConstraint!
    @IBOutlet weak var botView: NSLayoutConstraint!
    @IBOutlet weak var leadBTN2: NSLayoutConstraint!
    @IBOutlet weak var topLine: NSLayoutConstraint!
    @IBOutlet weak var topNote: NSLayoutConstraint!
    @IBOutlet weak var leadBTN: NSLayoutConstraint!
    @IBOutlet weak var topLaA: NSLayoutConstraint!
    @IBOutlet weak var leadLaA: NSLayoutConstraint!
    @IBOutlet weak var topTitle: NSLayoutConstraint!
    @IBOutlet weak var leadVoice: NSLayoutConstraint!
    @IBOutlet weak var topVoice: NSLayoutConstraint!
    @IBOutlet weak var heightIn: NSLayoutConstraint!
    @IBOutlet weak var trailPlay: NSLayoutConstraint!
    @IBOutlet weak var leadPlay: NSLayoutConstraint!
    @IBOutlet weak var topPlay: NSLayoutConstraint!
    @IBOutlet weak var topIn: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var topBackground: NSLayoutConstraint!
    @IBOutlet weak var leadBack: NSLayoutConstraint!
    @IBOutlet weak var topBack: NSLayoutConstraint!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLanguageB: UILabel!
    @IBOutlet weak var lblLanguageA: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var viewInside: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    var onComplete: (() -> ())?
    var checkData: Int = 0
    var showDataFav: [ItemsModel] = []
    var strTitle: String = ""
    var strNote: String = ""
    var code: String = ""
    
    var scale = DEVICE_WIDTH / 414
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewBackground)
        viewBackground.addSubview(viewInside)
        viewBackground.layer.cornerRadius = 10
        viewInside.layer.cornerRadius = 10
        lblName.text = "Favorite"
        lblLanguageA.text = "English"
        scaleToFill()
        reloadBackground()
        AdmobManager.shared.loadBannerView(inVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PaymentManager.shared.isPurchase(){
            
        } else {
            AdmobManager.shared.loadAdFull(inVC: self)
        }
    }
    
    func scaleToFill() {
        lblName.font = lblName.font.withSize(20 * scale)
        lblTitle.font = lblTitle.font.withSize(16 * scale)
        lblNote.font = lblNote.font.withSize(16 * scale)
        lblLanguageA.font = lblLanguageA.font.withSize(14 * scale)
        lblLanguageB.font = lblLanguageB.font.withSize(14 * scale)
        topBack.constant = 61 * scale
        leadBack.constant = 32 * scale
        topBackground.constant = 34 * scale
        topIn.constant = 16 * scale
        topPlay.constant = 56 * scale
        leadPlay.constant = 84 * scale
        trailPlay.constant = 84 * scale
        heightIn.constant = 243 * scale
        topVoice.constant = 10 * scale
        leadVoice.constant = 10 * scale
        topTitle.constant = 38 * scale
        leadLaA.constant = 5 * scale
        topLaA.constant = 70 * scale
        leadBTN.constant = 10 * scale
        topNote.constant = 15 * scale
        topLine.constant = 7 * scale
        leadBTN2.constant = 10 * scale
        botView.constant = 3 * scale
        topUp.constant = 15 * scale
        leadBTN3.constant = 15 * scale
        trailFav.constant = 15 * scale
    }
    
    func setBackgroundImageForBtnFavorite(){
        if self.showDataFav[checkData].fav == "false" {
            btnFavorite.setImage(UIImage(named: "Vector"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(named: "Vector Red"), for: .normal)
        }
    }
    
    func reloadBackground() {
        print(checkData)
        lblTitle.text = showDataFav[checkData].title
        setBackgroundImageForBtnFavorite()
        strTitle = showDataFav[checkData].title
        strNote = showDataFav[checkData].locaziation()
        lblNote.text = showDataFav[checkData].locaziation()
        lblLanguageB.getLabelNote()
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
        if showDataFav[checkData].fav == "false" {
            _ = ItemsEntity.shared.updateFavData("true", showDataFav[checkData].id)
            showDataFav[checkData].fav = "true"
            print(showDataFav[checkData].fav)
        } else {
            _ = ItemsEntity.shared.updateFavData("false", showDataFav[checkData].id)
            showDataFav[checkData].fav = "false"
            print(showDataFav[checkData].fav)
        }
        setBackgroundImageForBtnFavorite()
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        onComplete?()
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_Preview(_ sender: Any) {
        self.checkData -= 1
        if checkData < 0 {
            self.checkData = showDataFav.count - 1
        }
        reloadBackground()
    }
    
    @IBAction func btn_Next(_ sender: Any) {
        self.checkData += 1
        if checkData == showDataFav.count {
            self.checkData = 0
        }
        lblTitle.text = showDataFav[checkData].title
        setBackgroundImageForBtnFavorite()
        strTitle = showDataFav[checkData].title
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
