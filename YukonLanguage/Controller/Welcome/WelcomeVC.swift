//
//  WelcomeVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/19/20.
//

import UIKit
import StoreKit
import UserNotifications
import AVKit
import AVFoundation

class WelcomeVC: UIViewController {

    @IBOutlet weak var trailingFav: NSLayoutConstraint!
    @IBOutlet weak var leadConnect: NSLayoutConstraint!
    @IBOutlet weak var botCopy: NSLayoutConstraint!
    @IBOutlet weak var leadCopy: NSLayoutConstraint!
    @IBOutlet weak var topLine: NSLayoutConstraint!
    @IBOutlet weak var topUpdate: NSLayoutConstraint!
    @IBOutlet weak var topNote: NSLayoutConstraint!
    @IBOutlet weak var topLB: NSLayoutConstraint!
    @IBOutlet weak var leadLaA: NSLayoutConstraint!
    @IBOutlet weak var topTitle: NSLayoutConstraint!
    @IBOutlet weak var topLA: NSLayoutConstraint!
    @IBOutlet weak var leadLA: NSLayoutConstraint!
    @IBOutlet weak var heightIn: NSLayoutConstraint!
    @IBOutlet weak var topNext: NSLayoutConstraint!
    @IBOutlet weak var topPlay: NSLayoutConstraint!
    @IBOutlet weak var topToday: NSLayoutConstraint!
    @IBOutlet weak var topIn: NSLayoutConstraint!
    @IBOutlet weak var heightOut: NSLayoutConstraint!
    @IBOutlet weak var topName: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblLanguageB: UILabel!
    @IBOutlet weak var lblLanguageA: UILabel!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var imgHinh: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewInside: UIView!
    @IBOutlet weak var viewOutside: UIView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    var welcomeData: [ItemsModel] = []
    var strTitle: String = ""
    var strNote: String = ""
    var code: String = ""
    
    var scale = DEVICE_WIDTH / 414
    var scaleIpad = DEVICE_WIDTH / 1024
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewOutside)
        viewOutside.addSubview(viewInside)
        let title = UserDefaults.standard.string(forKey: "TITLE") ?? "Hi!"
        welcomeData = ItemsEntity.shared.getTitleData(title)
        strTitle = welcomeData[0].title
        strNote = welcomeData[0].locaziation()
        lblTitle.text = strTitle
        lblNote.text = strNote
        lblLanguageB.getLabelNote()
        setBackgroundImageForBtnFavorite()
        scaleToFill()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    func scaleToFill() {
        if IS_IPAD {
            botCopy.constant = 3 * scaleIpad
            topLA.constant = 17 * scaleIpad
            topNote.constant = 23 * scaleIpad
            topUpdate.constant = 23 * scaleIpad
            topLine.constant = 23 * scaleIpad
            topLB.constant = 70 * scaleIpad
            topTitle.constant = 50 * scaleIpad
            topPlay.constant = 15 * scaleIpad
            topNext.constant = 15 * scaleIpad
            topToday.constant = 18 * scaleIpad
            topIn.constant = 14 * scaleIpad
            topName.constant = 10 * scaleIpad
            heightOut.constant = 750 * scaleIpad
            heightIn.constant = 450 * scaleIpad
            lblName.font = lblName.font.withSize(70 * scaleIpad)
            lblToday.font = lblToday.font.withSize(38 * scaleIpad)
            lblTitle.font = lblTitle.font.withSize(30 * scaleIpad)
            lblNote.font = lblNote.font.withSize(30 * scaleIpad)
            lblLanguageA.font = lblLanguageA.font.withSize(26 * scaleIpad)
            lblLanguageB.font = lblLanguageB.font.withSize(26 * scaleIpad)
            btnNext.titleLabel?.font = btnNext.titleLabel?.font.withSize(38 * scaleIpad)
            imgHinh.image = UIImage(named: "Welcome Ipad")
        } else {
            botCopy.constant = 3 * scale
            topLA.constant = 10 * scale
            topNote.constant = 15 * scale
            topUpdate.constant = 15 * scale
            topLine.constant = 15 * scale
            topLB.constant = 55 * scale
            topTitle.constant = 38 * scale
            topPlay.constant = 15 * scale
            topNext.constant = 15 * scale
            topToday.constant = 18 * scale
            topIn.constant = 14 * scale
            heightOut.constant = 435 * scale
            heightIn.constant = 243 * scale
            topName.constant = 35 * scale
            lblName.font = lblName.font.withSize(45 * scale)
            lblToday.font = lblToday.font.withSize(20 * scale)
            lblTitle.font = lblTitle.font.withSize(16 * scale)
            lblNote.font = lblNote.font.withSize(16 * scale)
            lblLanguageA.font = lblLanguageA.font.withSize(14 * scale)
            lblLanguageB.font = lblLanguageB.font.withSize(14 * scale)
            btnNext.titleLabel?.font = btnNext.titleLabel?.font.withSize(20 * scale)
            imgHinh.image = UIImage(named: "Welcome")
        }
        leadLA.constant = 10 * scale
        leadLaA.constant = 5 * scale
        leadCopy.constant = 10 * scale
        leadConnect.constant = 15 * scale
        trailingFav.constant = 15 * scale
        imgHinh.layer.cornerRadius = 10 * scale
        viewInside.layer.cornerRadius = 10 * scale
        viewOutside.layer.cornerRadius = 10 * scale
        btnNext.layer.borderWidth = 2 * scale
        btnNext.layer.cornerRadius = 10 * scale
        btnNext.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    }
    
    func setBackgroundImageForBtnFavorite(){
        if welcomeData[0].fav == "false" {
            btnFavorite.setImage(UIImage(named: "Vector"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(named: "Vector Red"), for: .normal)
        }
    }
    
    @IBAction func btn_Copy(_ sender: Any) {
        UIPasteboard.general.string = strNote
        let alert: UIAlertController = UIAlertController(title: "", message: "Copied", preferredStyle: .alert)
        let btn_OK: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(btn_OK)
        self.present(alert, animated: true, completion: nil)
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
        if welcomeData[0].fav == "false" {
            _ = ItemsEntity.shared.updateFavDataTilte("true", strTitle)
            welcomeData[0].fav = "true"
            print(welcomeData[0].fav)
        } else {
            _ = ItemsEntity.shared.updateFavDataTilte("false", strTitle)
            welcomeData[0].fav = "false"
            print(welcomeData[0].fav)
        }
        setBackgroundImageForBtnFavorite()
    }
    
    func getSpeechLanguage(_ str: String,_ codename: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: str)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: codename)
        synthesizer.speak(utterance)
    }
    
    @IBAction func btn_VoiceA(_ sender: Any) {
        getSpeechLanguage(strTitle, "en")
    }
    
    @IBAction func btn_VoiceB(_ sender: Any) {
        getSpeechLanguage(strNote, code.getCode())
    }
    
    @IBAction func btn_Play(_ sender: Any) {
        getSpeechLanguage(strNote, code.getCode())
    }
    
    @IBAction func btn_Next(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar: TabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.present(tabbar, animated: false, completion: nil)
    }
    
}
