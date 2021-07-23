//
//  LanguegaModel.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import Foundation
class LanguageModel {
    var name: String = ""
    var code: String = ""
    var image: String = ""
    var isSelected: String = ""
    
    init(name: String, code: String, image: String, isSelected: String) {
        self.name = name
        self.code = code
        self.image = image
        self.isSelected = isSelected
    }
}
