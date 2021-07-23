//
//  CategoryEntity.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import Foundation
import SQLite

class CategoryEntity{
    static let shared = CategoryEntity()
    private let tbl = Table("category")

    private let id = Expression<Int>("id")
    private let title = Expression<String?>("title")
    private let france = Expression<String?>("france")
    private let english = Expression<String?>("english")
    private let japan = Expression<String?>("japan")
    private let italy = Expression<String?>("italy")
    private let turkey = Expression<String?>("turkey")
    private let russia = Expression<String?>("russia")
    private let arabia = Expression<String?>("arabia")
    private let image = Expression<String?>("image")
    private let korea = Expression<String?>("korea")
    private let greece = Expression<String?>("greece")
    private let kazakhstan = Expression<String?>("kazakhstan")
    private let somail = Expression<String?>("somail")
    private let haiti = Expression<String?>("haiti")
    private let swahili = Expression<String?>("swahili")
    private let china = Expression<String?>("china")
    private let vietnam = Expression<String?>("vietnam")
    private let germany = Expression<String?>("germany")
    private let slovenia = Expression<String?>("slovenia")
    private let nauy = Expression<String?>("nauy")
    private let portugal = Expression<String?>("portugal")
    private let netherlands = Expression<String?>("netherlands")
    private let poland = Expression<String?>("poland")
    private let india = Expression<String?>("india")

    private init(){
        do{
            if let connection = SqlDataBase.shared.connectionData{
                try connection.run(tbl.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(id, primaryKey: true)
                    table.column(title)
                    table.column(france)
                    table.column(english)
                    table.column(japan)
                    table.column(italy)
                    table.column(turkey)
                    table.column(russia)
                    table.column(arabia)
                    table.column(image)
                    table.column(korea)
                    table.column(greece)
                    table.column(kazakhstan)
                    table.column(somail)
                    table.column(haiti)
                    table.column(swahili)
                    table.column(china)
                    table.column(vietnam)
                    table.column(germany)
                    table.column(slovenia)
                    table.column(nauy)
                    table.column(portugal)
                    table.column(netherlands)
                    table.column(poland)
                    table.column(india)
                }))
            }
        } catch{
            print("Cannot create to Table, Error is: \(error)")
        }
    }
    
    // Get AllData
    func getData() -> [CategoryModel]{
        var listData = [CategoryModel]()
        do {
            if let listCate = try SqlDataBase.shared.connectionData?.prepare(self.tbl) {
                for item in listCate {
                    listData.append(CategoryModel(id: item[id], title: item[title] ?? "", france: item[france] ?? "", english: item[english] ?? "", japan: item[japan] ?? "", italy: item[italy] ?? "", turkey: item[turkey] ?? "", russia: item[russia] ?? "", arabia: item[arabia] ?? "", image: item[image] ?? "", korea: item[korea] ?? "", greece: item[greece] ?? "", kazakhstan: item[kazakhstan] ?? "", somail: item[somail] ?? "", haiti: item[haiti] ?? "", swahili: item[swahili] ?? "", china: item[china] ?? "", vietnam: item[vietnam] ?? "", germany: item[germany] ?? "", slovenia: item[slovenia] ?? "", nauy: item[nauy] ?? "", portugal: item[portugal] ?? "", netherlands: item[netherlands] ?? "", poland: item[poland] ?? "", india: item[india] ?? ""))
                }
            }
        } catch {
            print("Cannot get data from \(self.tbl), Error is: \(error)")
        }
        return listData
    }
    
    // Get Data theo filter
    func getTitleData(_ searchString: String) -> [CategoryModel]{
        var listData = [CategoryModel]()
        do {
            if let listCate = try SqlDataBase.shared.connectionData?.prepare(self.tbl.filter(self.title == searchString)) {
                for item in listCate {
                    listData.append(CategoryModel(id: item[id], title: item[title] ?? "", france: item[france] ?? "", english: item[english] ?? "", japan: item[japan] ?? "", italy: item[italy] ?? "", turkey: item[turkey] ?? "", russia: item[russia] ?? "", arabia: item[arabia] ?? "", image: item[image] ?? "", korea: item[korea] ?? "", greece: item[greece] ?? "", kazakhstan: item[kazakhstan] ?? "", somail: item[somail] ?? "", haiti: item[haiti] ?? "", swahili: item[swahili] ?? "", china: item[china] ?? "", vietnam: item[vietnam] ?? "", germany: item[germany] ?? "", slovenia: item[slovenia] ?? "", nauy: item[nauy] ?? "", portugal: item[portugal] ?? "", netherlands: item[netherlands] ?? "", poland: item[poland] ?? "", india: item[india] ?? ""))
                }
            }
        } catch {
            print("Cannot get data from \(self.tbl), Error is: \(error)")
        }
        return listData
    }
    
}

