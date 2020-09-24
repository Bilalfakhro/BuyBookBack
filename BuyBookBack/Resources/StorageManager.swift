//
//  StorageManager.swift
//  BuyBookBack
//
//  Created by Bilal Fakhro on 2020-09-20.
//  Copyright © 2020 Bilal Fakhro. All rights reserved.
//

import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public enum BBBStorageManagerError: Error {
        case failedDownload
    }
    
    // MARK: - Public
    
    public func uploadUserPost(model: UserPost, completion: @escaping (Result <URL, Error>) -> Void) {
        
    }
    
    public func downloadImage(with reference: String, completrion:  @escaping (Result <URL, BBBStorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completrion(.failure(.failedDownload))
                return
            }
           completrion(.success(url))
            })
         
    }
    
   
}


