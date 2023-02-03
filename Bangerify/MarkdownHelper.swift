//
//  MarkdownHelper.swift
//  Bangerify
//
//  Created by David Kasperek on 03/02/2023.
//

import Foundation

public func divideToArray(rawString: String) -> [String] {
    let componentsOfString = rawString.split(separator: "![")
    var markupList: [String] = []

    for (index, element) in componentsOfString.enumerated() {
        if index == 0 {
            markupList.append(String(element))
        }
        if index != 0 {
            let newElement = "![" + element
            if let index = newElement.firstIndex(of: ")") {
                markupList.append(String(newElement[..<index]))
                markupList.append(String(newElement[newElement.index(after: index)...]))
            }
        }
    }

    markupList = markupList.filter { (element: String) -> Bool in
        return !element.isEmpty }
    
    return markupList
}
