//
//  ItemsEntity.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/2/20.
//

import Foundation
import SQLite

class ItemsEntity {
    static let shared = ItemsEntity()
    private let tbl = Table("items")

    private let id = Expression<Int>("id")
    private let id_cat = Expression<Int>("id_cat")
    private let cat_name = Expression<String?>("cat_name")
    private let title = Expression<String?>("title")
    private let france = Expression<String?>("france")
    private let english = Expression<String?>("english")
    private let japan = Expression<String?>("japan")
    private let italy = Expression<String?>("italy")
    private let turkey = Expression<String?>("turkey")
    private let russia = Expression<String?>("russia")
    private let arabia = Expression<String?>("arabia")
    private let fav = Expression<String?>("fav")
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
                    table.column(id_cat, primaryKey: true)
                    table.column(cat_name)
                    table.column(title)
                    table.column(france)
                    table.column(english)
                    table.column(japan)
                    table.column(italy)
                    table.column(turkey)
                    table.column(russia)
                    table.column(arabia)
                    table.column(fav)
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
    
    // Gett All Data
    func getData() -> [ItemsModel]{
        var listData = [ItemsModel]()
        do {
            if let listCate = try SqlDataBase.shared.connectionData?.prepare(self.tbl) {
                for item in listCate {
                    listData.append(ItemsModel(id: item[id], id_cat: item[id_cat], cat_name: item[cat_name] ?? "", title: item[title] ?? "", france: item[france] ?? "", english: item[english] ?? "", japan: item[japan] ?? "", italy: item[italy] ?? "", turkey: item[turkey] ?? "", russia: item[russia] ?? "", arabia: item[arabia] ?? "", fav: item[fav] ?? "", korea: item[korea] ?? "", greece: item[greece] ?? "", kazakhstan: item[kazakhstan] ?? "", somail: item[somail] ?? "", haiti: item[haiti] ?? "", swahili: item[swahili] ?? "", china: item[china] ?? "", vietnam: item[vietnam] ?? "", germany: item[germany] ?? "", slovenia: item[slovenia] ?? "", nauy: item[nauy] ?? "", portugal: item[portugal] ?? "", netherlands: item[netherlands] ?? "", poland: item[poland] ?? "", india: item[india] ?? ""))
                }
            }
        } catch {
            print("Cannot get data from \(self.tbl), Error is: \(error)")
        }
        return listData
    }
    
    // Get Data theo value
    func getDataCatId(_ id_cat: Int) -> [ItemsModel] {
         var listData = [ItemsModel]()
         for item in self.getData() {
            if item.id_cat == id_cat  {
                 listData.append(item)
             }
         }
         return listData
     }
    
    func getDataId(_ id: Int) -> [ItemsModel] {
         var listData = [ItemsModel]()
         for item in self.getData() {
            if item.id == id  {
                 listData.append(item)
             }
         }
         return listData
     }
    
    func getFavData() -> [ItemsModel] {
         var listData = [ItemsModel]()
         for item in self.getData() {
            if item.fav == "true"  {
                 listData.append(item)
             }
         }
         return listData
     }
    
    func getTitleData(_ title: String) -> [ItemsModel] {
        var listData = [ItemsModel]()
        for item in self.getData() {
           if item.title == title  {
                listData.append(item)
            }
        }
        return listData
    }
    
    
    // Update Data theo valua, filter id
    func updateFavData(_ favData: String, _ id: Int) -> Bool {
        do{
            if SqlDataBase.shared.connectionData == nil{
                return false
            }
            let tblFilter = self.tbl.filter(self.id == id)
            var setter: [SQLite.Setter] = [SQLite.Setter]()
            setter.append(self.fav <- favData)
            let tblUpdate = tblFilter.update(setter)
            if try SqlDataBase.shared.connectionData!.run(tblUpdate) <= 0
            {
                return false
            }
            return true
        }catch {
            let nsError = error as NSError
            print("Cannot update data from table phrase, Error is: \(nsError), \(nsError)")
            return false
        }
    }
    
    // Update Data thep value, filter title
    func updateFavDataTilte(_ favData: String, _ title: String) -> Bool {
        do{
            if SqlDataBase.shared.connectionData == nil{
                return false
            }
            let tblFilter = self.tbl.filter(self.title == title)
            var setter: [SQLite.Setter] = [SQLite.Setter]()
            setter.append(self.fav <- favData)
            let tblUpdate = tblFilter.update(setter)
            if try SqlDataBase.shared.connectionData!.run(tblUpdate) <= 0
            {
                return false
            }
            return true
        }catch {
            let nsError = error as NSError
            print("Cannot update data from table phrase, Error is: \(nsError), \(nsError)")
            return false
        }
    }
        
}
