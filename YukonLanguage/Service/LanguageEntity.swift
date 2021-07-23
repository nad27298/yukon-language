//
//  LanguageEntity.swift
//  YukonLanguage
//
//  Created by nguyenhuyson2 on 12/1/20.
//

import Foundation
import SQLite
class LanguageEntity{
    static let shared = LanguageEntity()
    private let tbl = Table("tblLanguage")
    
    private let code = Expression<String>("code")
    private let name = Expression<String>("name")
    private let image = Expression<String>("image")
    private let isSelected = Expression<String>("isSelected")
    
    private init(){
        do{
            if let connection = SqlDataBase.shared.connectionData {
                try connection.run(tbl.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    table.column(code, primaryKey: true)
                    table.column(name)
                    table.column(image)
                    table.column(isSelected)
                }))
            }
        } catch{
            print("Canont create to table language, Error is: \(error)")
        }
    }
    
    func insert(code: String, name: String, image: String, isSelected: String) -> Int64? {
        do {
            let insert = tbl.insert(self.code <- code,
                                    self.name <- name,
                                    self.image <- image,
                                    self.isSelected <- isSelected)
            let insertedId = try SqlDataBase.shared.connectionData!.run(insert)
            return insertedId
        } catch {
            let nserror = error as NSError
            print("Cannot insert new tblNotes. Error is: \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    func getData() -> [LanguageModel]{
        var listData = [LanguageModel]()
        do {
            if let listCate = try  SqlDataBase.shared.connectionData?.prepare(self.tbl) {
                for item in listCate {
                    listData.append(LanguageModel(name: item[name], code: item[code], image: item[image], isSelected: item[isSelected]))
                }
            }
        } catch {
            print("Cannot get data from table lanuage, Error is: \(error)")
        }
        return listData
    }
    func languageDefaulCode() -> String {
        do {
            if let listCate = try  SqlDataBase.shared.connectionData?.prepare(self.tbl.filter(self.isSelected == "true")) {
                for item in listCate {
                    return try item.get(code)
                }
            }
        } catch {
            print("Cannot get data from table lanuage, Error is: \(error)")
        }
        return "not found"
    }
    
    func updateLanguage(code: String, isSelected: String) -> Bool {
        do{
            if SqlDataBase.shared.connectionData == nil{
                return false
            }
            //update true -> false

            let tblFilterTrue = self.tbl.filter(self.isSelected == "true")
            var setterTrue: [SQLite.Setter] = [SQLite.Setter]()
            setterTrue.append(self.isSelected <- "false")
            let tblUpdateTrue = tblFilterTrue.update(setterTrue)
            if try SqlDataBase.shared.connectionData!.run(tblUpdateTrue) <= 0 {
                 print("Update all language to FALSE")
            }
                        
            let tblFilter = self.tbl.filter(self.code == code)
            var setter: [SQLite.Setter] = [SQLite.Setter]()
            setter.append(self.code <- code)
            setter.append(self.isSelected <- isSelected)
            
            let tblUpdate = tblFilter.update(setter)
            if try SqlDataBase.shared.connectionData!.run(tblUpdate) <= 0 {
                return false
            }
            return true
        }catch
        {
            let nsError = error as NSError
            print("Cannot update data from table lanuage, Error is: \(nsError), \(nsError)")
            return false
        }
    }
}
