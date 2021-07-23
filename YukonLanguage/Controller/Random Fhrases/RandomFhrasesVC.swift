//
//  RandomFhrasesVC.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import UIKit
import Social
import AVKit
import AVFoundation
import Social
import UserNotifications

class RandomFhrasesVC: UIViewController {
    
    @IBOutlet weak var leadBtn3C: NSLayoutConstraint!
    @IBOutlet weak var btnBackOut: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var trailV: NSLayoutConstraint!
    @IBOutlet weak var leadBtnC: NSLayoutConstraint!
    @IBOutlet weak var botV: NSLayoutConstraint!
    @IBOutlet weak var topUp: NSLayoutConstraint!
    @IBOutlet weak var topLine: NSLayoutConstraint!
    @IBOutlet weak var topNote: NSLayoutConstraint!
    @IBOutlet weak var topLaA: NSLayoutConstraint!
    @IBOutlet weak var leadLaA: NSLayoutConstraint!
    @IBOutlet weak var topTitle: NSLayoutConstraint!
    @IBOutlet weak var leadBtnA: NSLayoutConstraint!
    @IBOutlet weak var topBtnA: NSLayoutConstraint!
    @IBOutlet weak var heightIn: NSLayoutConstraint!
    @IBOutlet weak var trailingPlay: NSLayoutConstraint!
    @IBOutlet weak var leadPlay: NSLayoutConstraint!
    @IBOutlet weak var topPlay: NSLayoutConstraint!
    @IBOutlet weak var topviewIn: NSLayoutConstraint!
    @IBOutlet weak var topViewBack: NSLayoutConstraint!
    @IBOutlet weak var topBtn1C: NSLayoutConstraint!
    @IBOutlet weak var leadBtn1C: NSLayoutConstraint!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLanguageB: UILabel!
    @IBOutlet weak var lblLanguageA: UILabel!
    @IBOutlet weak var viewInside: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    var idRandom = Int.random(in: 1...6015)
    var randomData: [ItemsModel] = []
    var idRandomNext: Int = 0
    var strTitle: String = ""
    var strNote: String = ""
    var code: String = ""
    
    var scale = DEVICE_WIDTH / 414
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewBackground)
        viewBackground.addSubview(viewInside)
        btnBackOut.isHidden = true
        viewBackground.layer.cornerRadius = 10 * scale
        viewInside.layer.cornerRadius = 10 * scale
        lblName.text = "Random Phrases"
        lblLanguageB.text = "English"
        scaleToFill()
        reloadBackground()
        AdmobManager.shared.loadBannerView(inVC: self)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.sendNotification()
            default:
                break // Do nothing
            }
        }
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
        leadBtn1C.constant = 32 * scale
        topBtn1C.constant = 61 * scale
        topViewBack.constant = 34 * scale
        topviewIn.constant = 16 * scale
        topPlay.constant = 56 * scale
        leadPlay.constant = 84 * scale
        trailingPlay.constant = 84 * scale
        heightIn.constant = 243 * scale
        topBtnA.constant = 10 * scale
        leadBtnA.constant = 10 * scale
        topTitle.constant = 38 * scale
        leadLaA.constant = 5 * scale
        topLaA.constant = 70 * scale
        topNote.constant = 15 * scale
        topLine.constant = 7 * scale
        topUp.constant = 15 * scale
        botV.constant = 3 * scale
        leadBtnC.constant = 15 * scale
        trailV.constant = 15 * scale
        leadBtn3C.constant = 10 * scale
    }
    
    func setBackgroundImageForBtnFavorite(){
        if self.randomData[0].fav == "false" {
            btnFavorite.setImage(UIImage(named: "Vector"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(named: "Vector Red"), for: .normal)
        }
    }
    
    func reloadBackground () {
        randomData = ItemsEntity.shared.getDataId(idRandom)
        print(idRandom)
        lblTitle.text = randomData[0].title
        strTitle = randomData[0].title
        strNote = randomData[0].locaziation()
        lblNote.text = randomData[0].locaziation()
        lblLanguageB.getLabelNote()
        setBackgroundImageForBtnFavorite()
    }
    
    @IBAction func btn_Back(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabbar: TabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//        self.present(tabbar, animated: true, completion: nil)
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
        if randomData[0].fav == "false" {
            _ = ItemsEntity.shared.updateFavData("true", idRandom)
            randomData[0].fav = "true"
            print(randomData[0].fav)
        } else {
            _ = ItemsEntity.shared.updateFavData("false", idRandom)
            randomData[0].fav = "false"
            print(randomData[0].fav)
        }
        setBackgroundImageForBtnFavorite()
    }
    
    @IBAction func btn_Preview(_ sender: Any) {
        idRandom = Int.random(in: 1...6015)
        reloadBackground()
    }
    
    @IBAction func btn_Next(_ sender: Any) {
        idRandom = Int.random(in: 1...6015)
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
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("Yes")
            } else {
                print("No")
            }
        }
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = randomData[0].title
        content.body = randomData[0].locaziation()
        content.sound = UNNotificationSound.default

        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)

        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
