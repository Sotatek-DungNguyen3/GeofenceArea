//
//  StringExtension.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import Foundation

extension String {
    func trimSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
