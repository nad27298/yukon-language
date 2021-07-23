//
//  ItemsModel.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/2/20.
//

import Foundation
class ItemsModel {
    var id: Int = 0
    var id_cat: Int = 0
    var cat_name: String = ""
    var title: String = ""
    var france: String = ""
    var english: String = ""
    var japan: String = ""
    var italy: String = ""
    var turkey: String = ""
    var russia: String = ""
    var arabia: String = ""
    var fav: String = ""
    var korea: String = ""
    var greece: String = ""
    var kazakhstan: String = ""
    var somail: String = ""
    var haiti: String = ""
    var swahili: String = ""
    var china: String = ""
    var vietnam: String = ""
    var germany: String = ""
    var slovenia: String = ""
    var nauy: String = ""
    var portugal: String = ""
    var netherlands: String = ""
    var poland: String = ""
    var india: String = ""
    
    init(id: Int, id_cat: Int, cat_name: String, title: String, france: String, english: String, japan: String, italy: String, turkey: String, russia: String, arabia: String, fav: String, korea: String, greece: String, kazakhstan: String, somail: String, haiti: String, swahili: String, china: String, vietnam: String, germany: String, slovenia: String, nauy: String, portugal: String, netherlands: String, poland: String, india: String) {
        self.id = id
        self.id_cat = id_cat
        self.cat_name = cat_name
        self.title = title
        self.france = france
        self.english = english
        self.japan = japan
        self.italy = italy
        self.russia = russia
        self.turkey = turkey
        self.arabia = arabia
        self.fav = fav
        self.korea = korea
        self.greece = greece
        self.kazakhstan = kazakhstan
        self.somail = somail
        self.haiti = haiti
        self.swahili = swahili
        self.china = china
        self.vietnam = vietnam
        self.germany = germany
        self.slovenia = slovenia
        self.nauy = nauy
        self.portugal = portugal
        self.netherlands = netherlands
        self.poland = poland
        self.india = india
    }
}

extension ItemsModel {
    func locaziation() -> String {
        switch LanguageEntity.shared.languageDefaulCode() {
        case Language.france.toString():
            return france
        case Language.english.toString():
            return english
        case Language.japan.toString():
            return japan
        case Language.italy.toString():
            return italy
        case Language.turkey.toString():
            return turkey
        case Language.russia.toString():
            return russia
        case Language.arabia.toString():
            return arabia
        case Language.korea.toString():
            return korea
        case Language.greece.toString():
            return greece
        case Language.kazakhstan.toString():
            return kazakhstan
        case Language.somail.toString():
            return somail
        case Language.haiti.toString():
            return haiti
        case Language.swahili.toString():
            return swahili
        case Language.china.toString():
            return china
        case Language.vietnam.toString():
            return vietnam
        case Language.germany.toString():
            return germany
        case Language.slovenia.toString():
            return slovenia
        case Language.nauy.toString():
            return nauy
        case Language.portugal.toString():
            return portugal
        case Language.netherlands.toString():
            return netherlands
        case Language.poland.toString():
            return poland
        case Language.india.toString():
            return india
        default:
            return japan
        }
    }
    
}
