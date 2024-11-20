//
//  StuffStoreError.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 20/11/2024.
//

import Foundation

enum StuffStoreError: Swift.Error {
    case duplicate
    case sameName
    case notFound
}
