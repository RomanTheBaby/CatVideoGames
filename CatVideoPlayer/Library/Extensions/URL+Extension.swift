//
//  URL+Extension.swift
//  CatVideoPlayer
//
//  Created by Roman on 2021-06-24.
//

import Foundation


extension URL: Identifiable {
    public var id: Int {
        hashValue
    }
}
