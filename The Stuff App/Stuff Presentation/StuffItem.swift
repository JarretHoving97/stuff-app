//
//  StuffItem.swift
//  The Stuff App
//
//  Created by Jarret Hoving on 24/10/2024.
//

import Foundation
import SwiftUI

struct StuffItem: Hashable, Identifiable {
    let id = UUID()
    let color: Color
    let name: String
}
