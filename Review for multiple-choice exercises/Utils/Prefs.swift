//
//  Prefs.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/14/21.
//

import Foundation
import  UIKit

// Gọi: Prefs.shared.getValueSettingSync()
class Prefs {
    static let shared = Prefs()
    
    static func set(key:String, value: Any){
        UserDefaults.standard.set(value, forKey: key)
    }
    static func get(key:String) -> Any?{
        return UserDefaults.standard.value(forKey: key)
    }
    private static let kCurrentLocale = "CurrentLocale"
    private static let kDefaultLocale = "LangEN"
    private static let PREFERENCE_SETTING_LANG = "PREFERENCE_SETTING_LANG"
    private static let PREFERENCE_TOKEN = "PREFERENCE_TOKEN"

    
    // ****** Đa ngôn ngữ ******
    func currentLocale() -> String {
        if let locale = UserDefaults.standard.value(forKey: Prefs.kCurrentLocale) {
            return locale as! String
        }
        return Prefs.kDefaultLocale
    }
    
    func setCurrentLocale(_ locale: String) {
        UserDefaults.standard.set(locale, forKey: Prefs.kCurrentLocale)
        UserDefaults.standard.synchronize()
    }
    
    // ---- -- -- --- Ngôn ngữ -- ---- -- --
    func setValueSettingLang(_ value: Int){
        UserDefaults.standard.set(value, forKey: Prefs.PREFERENCE_SETTING_LANG)
        UserDefaults.standard.synchronize()
    }
    func getValueSettingLang() -> Int{
        if UserDefaults.standard.object(forKey: Prefs.PREFERENCE_SETTING_LANG) == nil{
            Prefs.shared.setValueSettingLang(1)// giá trị mặc định là tiếng anh
        }
        return UserDefaults.standard.value(forKey: Prefs.PREFERENCE_SETTING_LANG) as! Int
    }
    
    func setToken(token: String){
        set(key: Prefs.PREFERENCE_TOKEN, value: token)
    }
    /*
    func getToken() -> Token?{
        let value = get(key: Prefs.PREFERENCE_TOKEN) as? String
        return Token.deserialize(from: value)
    }
    */
    private func set(key: String, value: Any?){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func get(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
}
