//
//  DatabaseManager.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-20.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    // MARK: - Public
    
    
    /// Check if user or email is available
    /// - Parameters
    ///     - email: String represting email
    ///     - username: String represting username
    
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    /// Insert New user to Firebase Database
      /// - Parameters
      ///     - email: String represting email
      ///     - username: String represting username
    ///     - completion: Async callback for result if database entry succeded
    public func InsertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
            if error == nil {
                // succeded
                completion(true)
                return
            }
            else {
                // failed
                completion(false)
                return
            }
        }
          
      }
   
}
