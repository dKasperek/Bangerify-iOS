//
//  MarkdownHelper.swift
//  Bangerify
//
//  Created by David Kasperek on 03/02/2023.
//

import Foundation

public func divideMarkdownTextToArray(rawString: String) -> [String] {
    var markupList: [String] = []
    
    if rawString.contains("!["){
        let componentsOfString = rawString.split(separator: "![")

        for (index, element) in componentsOfString.enumerated() {
            if index == 0 && componentsOfString.count > 1 {
                markupList.append(String(element))
            }
            else {
                let newElement = "![" + element
                if let index = newElement.firstIndex(of: ")") {
                    markupList.append(String(newElement[..<index]))
                    markupList.append(String(newElement[newElement.index(after: index)...]))
                }
            }
        }

        markupList = markupList.filter { (element: String) -> Bool in
            return !element.isEmpty }
    } else {
        markupList.append(rawString)
    }
    
    return markupList
}

public func divideMentionsFromText(rawString: String) -> [String] {
    var markupList: [String] = []
    
    if rawString.contains("@") {
        let componentsOfString = rawString.split(separator: "@")

        for (index, element) in componentsOfString.enumerated() {
            if index == 0 && componentsOfString.count > 1 {
                markupList.append(String(element))
            } else {
                let newElement = "@" + element
                if let index = newElement.firstIndex(of: " ") {
                    markupList.append(String(newElement[..<index]))
                    markupList.append(String(newElement[newElement.index(after: index)...]))
                } else {
                    markupList.append(String(newElement))
                }
            }
        }

        markupList = markupList.filter { !$0.isEmpty }
    } else {
        markupList.append(rawString)
    }
    
    return markupList
}

public func makeAttributedText(rawString: String) -> AttributedString {
    var text: AttributedString = ""
    do {
        text = try AttributedString(markdown: rawString)
    } catch {
        print("Failed to create attributed string")
    }
    return text
}
