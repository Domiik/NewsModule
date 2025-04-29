//
//  APError.swift
//  CHSURasp
//
//  Created by Domiik on 09.01.2023.
//

import SwiftUI

enum APError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case internetConnection
}
