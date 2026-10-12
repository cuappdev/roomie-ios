//
//  LoadState.swift
//  Roomie
//
//  Created by jiwon jeong on 10/11/26.
//

import Foundation

/// The lifecycle of a content screen's data. Content screens drive their body off one of
/// these instead of a pile of booleans.
enum LoadState<Value> {
    case loading
    case loaded(Value)
    case empty
    case error(String)
}
