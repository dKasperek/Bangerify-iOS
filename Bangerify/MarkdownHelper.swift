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
        text = AttributedString(rawString)
    }
    return text
}

public func enableMentions(rawString: String) -> String {
    let pattern = "(\\B@\\w+)"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])

    let matches = regex?.matches(in: rawString, options: [], range: NSRange(location: 0, length: rawString.utf16.count))
    var modifiedString = rawString

    matches?.forEach { match in
        guard let range = Range(match.range, in: rawString) else { return }
        let username = String(rawString[range])
        let link = "[\(username)](\(username.dropFirst()))"
        modifiedString = modifiedString.replacingOccurrences(of: username, with: link)
    }
    return modifiedString
}
