//
//  Storage+extensions.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 05/09/2023.
//

import Foundation
import FirebaseStorage

enum FirebaseStorageBuckets: String {
    case photos
    case attachments
}

extension Storage {
    func uploadData(for key: String, data: Data, bucket: FirebaseStorageBuckets) async throws -> URL {
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child("\(bucket.rawValue)/\(key)")
        
        let _ = try await photoRef.putDataAsync(data)
        let downloadURL = try await photoRef.downloadURL()
        return downloadURL
    }
}
