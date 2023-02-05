//
//  ViewHelper.swift
//  Bangerify
//
//  Created by David Kasperek on 05/02/2023.
//

import Foundation

public func formatDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "dd.MM.yyyy / HH:mm"
    return dateFormatter.string(from: date!)
}
