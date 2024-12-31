//
//  EnvironmentValues+Extension.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/24.
//

import SwiftUI

struct HideKeyboardKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var hideKeyboard: () -> Void {
        get { self[HideKeyboardKey.self] }
        set { self[HideKeyboardKey.self] = newValue }
    }
}
