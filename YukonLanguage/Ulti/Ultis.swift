//
//  Ultis.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import UIKit
import Foundation
import AVKit
import AVFoundation
import Social

enum Language: Int {
    case france = 1
    case english = 2
    case japan = 3
    case italy = 4
    case turkey = 5
    case russia = 6
    case arabia = 7
    case korea = 8
    case greece = 9
    case kazakhstan = 10
    case somail = 11
    case haiti = 12
    case swahili = 13
    case china = 14
    case vietnam = 15
    case germany = 16
    case slovenia = 17
    case nauy = 18
    case portugal = 19
    case netherlands = 20
    case poland = 21
    case india = 22
    
    func toString() -> String {
        switch self {
        case .france:
            return "fr"
        case .english:
            return "en"
        case .japan:
            return "ja"
        case .italy:
            return "it"
        case .turkey:
            return "tr"
        case .russia:
            return "ru"
        case .arabia:
            return "ar"
        case .korea:
            return "ko"
        case .greece:
            return "el"
        case .kazakhstan:
            return "kk"
        case .somail:
            return "so"
        case .haiti:
            return "ht"
        case .swahili:
            return "sw"
        case .china:
            return "zh"
        case .vietnam:
            return "vi"
        case .germany:
            return "de"
        case .slovenia:
            return "sl"
        case .nauy:
            return "no"
        case .portugal:
            return "pt"
        case .netherlands:
            return "nl"
        case .poland:
            return "pl"
        case .india:
            return "hi"
        }
    }
}

extension UILabel {
    func checkLanguage() -> String {
        switch LanguageEntity.shared.languageDefaulCode() {
        case Language.france.toString():
            return "France"
        case Language.english.toString():
            return "English"
        case Language.japan.toString():
            return "Japan"
        case Language.italy.toString():
            return "Italy"
        case Language.turkey.toString():
            return "Turkey"
        case Language.russia.toString():
            return "Russia"
        case Language.arabia.toString():
            return "Saudi Aribia"
        case Language.korea.toString():
            return "Korea"
        case Language.greece.toString():
            return "Greece"
        case Language.kazakhstan.toString():
            return "Kazakhstan"
        case Language.somail.toString():
            return "Somail"
        case Language.haiti.toString():
            return "Haiti"
        case Language.swahili.toString():
            return "Swahili"
        case Language.china.toString():
            return "China"
        case Language.vietnam.toString():
            return "Vietnam"
        case Language.germany.toString():
            return "Germany"
        case Language.slovenia.toString():
            return "Slovenia"
        case Language.nauy.toString():
            return "Nauy"
        case Language.portugal.toString():
            return "Portugal"
        case Language.netherlands.toString():
            return "Netherlands"
        case Language.poland.toString():
            return "Poland"
        case Language.india.toString():
            return "India"
        default:
            return "Japan"
        }
    }
    func getLabelNote() {
        self.text = checkLanguage()
    }
    
}

extension UIImageView {
    func checkLanguage() -> String {
        switch LanguageEntity.shared.languageDefaulCode() {
        case Language.france.toString():
            return "france_logo"
        case Language.english.toString():
            return "english_logo"
        case Language.japan.toString():
            return "japan_logo"
        case Language.italy.toString():
            return "italy_logo"
        case Language.turkey.toString():
            return "turkey_logo"
        case Language.russia.toString():
            return "russia_logo"
        case Language.arabia.toString():
            return "arabia_logo"
        case Language.korea.toString():
            return "korea_logo"
        case Language.greece.toString():
            return "greece_logo"
        case Language.kazakhstan.toString():
            return "kazakhstan_logo"
        case Language.somail.toString():
            return "somail_logo"
        case Language.haiti.toString():
            return "haiti_logo"
        case Language.swahili.toString():
            return "swahili_logo"
        case Language.china.toString():
            return "china_logo"
        case Language.vietnam.toString():
            return "vietnam_logo"
        case Language.germany.toString():
            return "germany_logo"
        case Language.slovenia.toString():
            return "slovenia_logo"
        case Language.nauy.toString():
            return "nauy_logo"
        case Language.portugal.toString():
            return "portugal_logo"
        case Language.netherlands.toString():
            return "netherlands_logo"
        case Language.poland.toString():
            return "poland_logo"
        case Language.india.toString():
            return "india_logo"
        default:
            return "japan_logo"
        }
    }
    func getImage() {
        self.image = UIImage(named: checkLanguage())
    }
}

extension String {
    func checkLanguage() -> String {
        switch LanguageEntity.shared.languageDefaulCode() {
        case Language.france.toString():
            return "fr"
        case Language.english.toString():
            return "en"
        case Language.japan.toString():
            return "ja"
        case Language.italy.toString():
            return "it"
        case Language.turkey.toString():
            return "tr"
        case Language.russia.toString():
            return "ru"
        case Language.arabia.toString():
            return "ar"
        case Language.korea.toString():
            return "ko"
        case Language.greece.toString():
            return "el"
        case Language.kazakhstan.toString():
            return "kk"
        case Language.somail.toString():
            return "so"
        case Language.haiti.toString():
            return "ht"
        case Language.swahili.toString():
            return "en"
        case Language.china.toString():
            return "zh-Hant"
        case Language.vietnam.toString():
            return "vi"
        case Language.germany.toString():
            return "de"
        case Language.slovenia.toString():
            return "sl"
        case Language.nauy.toString():
            return "no"
        case Language.portugal.toString():
            return "pt"
        case Language.netherlands.toString():
            return "nl"
        case Language.poland.toString():
            return "pl"
        case Language.india.toString():
            return "hi"
        default:
            return "ja"
        }
    }
    func getCode() -> String {
        return checkLanguage()
    }
    func localized() -> String {
        let lang = LanguageEntity.shared.languageDefaulCode()
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj"){
            let bundle = Bundle(path: path)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        } else {
            return self
        }
    }
    func highlightWordIn(_ subString: String) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: subString, options: .caseInsensitive)
        let result = NSMutableAttributedString(string: self)
        result.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        return result
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension NSObject {

    func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
    var className: String {
        
        return String(describing: type(of: self))
    }
    
    class var className: String {
        
        return String(describing: self)
    }

}



