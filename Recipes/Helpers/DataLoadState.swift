//
//  DataLoadState.swift
//  Recipes
//
//  Created by Spencer Curtis on 2/5/25.
//

import SwiftUI

enum DataLoadState<T> {
    case success(T)
    case loading
    case error(Error?)

    var isErrorState: Bool {
        switch self {
        case .success, .loading:
            return false
        case .error:
            return true
        }
    }

    var isSuccessState: Bool {
        switch self {
        case .success:
            return true
        case .error, .loading:
            return false
        }
    }

    var isLoadingState: Bool {
        switch self {
        case .success, .error:
            return false
        case .loading:
            return true
        }
    }
}
