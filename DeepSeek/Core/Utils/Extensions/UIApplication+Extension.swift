//
//  UIApplication+Extension.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/23.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
