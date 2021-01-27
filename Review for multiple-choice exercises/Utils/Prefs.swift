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
    
    public static func getCachedUserModel() -> UserModel? {
        let preferences = UserDefaults.standard
        let userModel = UserModel()
        guard let userId = preferences.object(forKey: UserPreference.PREFERENCE_USERID) as? Int else {
            print("Have not cached any user model")
            return nil
        }
        
        let email = preferences.object(forKey: UserPreference.PREFERENCE_EMAIL) as? String
        let name = preferences.object(forKey: UserPreference.PREFERENCE_NAME) as? String
        let avatar = preferences.object(forKey: UserPreference.PREFERENCE_AVATAR) as? String
        let phone = preferences.object(forKey: UserPreference.PREFERENCE_PHONE) as? String
        
        userModel.userId = userId
        userModel.email = email!
        userModel.name = name!
        userModel.avatar = avatar!
        userModel.phone = phone!
        
        return userModel
    }
    
    public static func cacheUserModel(model user: UserModel) {
        let preferences = UserDefaults.standard
        
        
        preferences.setValue(user.userId, forKey: UserPreference.PREFERENCE_USERID)// Require preferrence to mark whether user logged in or not
        
        //Other optional preferences
        preferences.setValue(user.avatar, forKey: UserPreference.PREFERENCE_AVATAR)
        preferences.setValue(user.email, forKey: UserPreference.PREFERENCE_EMAIL)
        preferences.setValue(user.name, forKey: UserPreference.PREFERENCE_NAME)
        preferences.setValue(user.phone, forKey: UserPreference.PREFERENCE_PHONE)
        
        //Save references to disk
        let didSave = preferences.synchronize()
        if !didSave {
            fatalError("Can not caching user information")
        }
    }
    
    public static func removeCachedUserModel() {
        let preferences = UserDefaults.standard
        
        guard (preferences.object(forKey: UserPreference.PREFERENCE_USERID) as? Int) != nil else {
            print("Have not cached any user model")
            return
        }
    
        preferences.removeObject(forKey: UserPreference.PREFERENCE_USERID)
        preferences.removeObject(forKey: UserPreference.PREFERENCE_NAME)
        preferences.removeObject(forKey: UserPreference.PREFERENCE_AVATAR)
        preferences.removeObject(forKey: UserPreference.PREFERENCE_PHONE)
        preferences.removeObject(forKey: UserPreference.PREFERENCE_EMAIL)
    }
    
    public static func cacheExamModel(model exam: ExamModel) {
        let preferences = UserDefaults.standard
        
        
        preferences.setValue(exam.examId, forKey: ExamPreference.PREFERENCE_EXAMID)// Require preferrence to mark whether user is in an exam or not
        
        //Other optional preferences
        preferences.setValue(exam.examId, forKey: ExamPreference.PREFERENCE_EXAMID)
        preferences.setValue(exam.userId, forKey: ExamPreference.PREFERENCE_USERID)
        preferences.setValue(exam.subjectId, forKey: ExamPreference.PREFERENCE_SUBJECTID)
        preferences.setValue(exam.createDate, forKey: ExamPreference.PREFERENCE_CREATEDATE)
        preferences.setValue(exam.closeDate, forKey: ExamPreference.PREFERENCE_CLOSEDATE)
        preferences.setValue(exam.nbQuestion, forKey: ExamPreference.PREFERENCE_NBQUESTION)
        preferences.setValue(exam.duration, forKey: ExamPreference.PREFERENCE_DURATION)
        preferences.setValue(exam.score, forKey: ExamPreference.PREFERENCE_SCORE)
        
        //Save references to disk
        let didSave = preferences.synchronize()
        if !didSave {
            fatalError("Can not caching user information")
        }
    }
    
    public static func getCachedExamModel() -> ExamModel? {
        let preferences = UserDefaults.standard
        let examModel = ExamModel()
        guard let userId = preferences.object(forKey: UserPreference.PREFERENCE_USERID) as? Int else {
            print("Have not cached any user model")
            return nil
        }
        
        guard let examId = preferences.object(forKey: ExamPreference.PREFERENCE_EXAMID) as? Int else {
            print("Have not cached any exam model")
            return nil
        }
        
        let examUserId = preferences.object(forKey: ExamPreference.PREFERENCE_USERID) as? Int
        
        if examUserId != userId {
            return nil
        }
        
        
        let subjectId = preferences.object(forKey: ExamPreference.PREFERENCE_SUBJECTID) as? Int
        let createDate = preferences.object(forKey: ExamPreference.PREFERENCE_CREATEDATE) as? String
        let closeDate = preferences.object(forKey: ExamPreference.PREFERENCE_CLOSEDATE) as? String
        let nbQuestion = preferences.object(forKey: ExamPreference.PREFERENCE_NBQUESTION) as? Int
        let duration = preferences.object(forKey: ExamPreference.PREFERENCE_DURATION) as? Int
        let score = preferences.object(forKey: ExamPreference.PREFERENCE_SCORE) as? Float
        
        
        
        examModel.examId = examId
        examModel.userId = userId
        examModel.subjectId = subjectId!
        examModel.createDate = createDate!
        examModel.closeDate = closeDate!
        examModel.nbQuestion = nbQuestion!
        examModel.duration = duration!
        examModel.score = score!
      
        
        return examModel
    }
}
