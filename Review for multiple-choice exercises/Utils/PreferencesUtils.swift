//
//  PreferencesUtils.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 20/01/2021.
//

import Foundation

class PreferencesUtils {
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
    
    public static func set(key: String, value: Any) {
        let preferences = UserDefaults.standard
        preferences.setValue(value, forKey: key)
        //Save references to disk
        let didSave = preferences.synchronize()
        if !didSave {
            fatalError("Can not caching user information")
        }
    }
    
    public static func get(key: String) -> Any? {
        let preferences = UserDefaults.standard
        return preferences.object(forKey: key)
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
    
    
}
