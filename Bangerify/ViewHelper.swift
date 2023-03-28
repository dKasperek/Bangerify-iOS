//
//  ViewHelper.swift
//  Bangerify
//
//  Created by David Kasperek on 05/02/2023.
//

import Foundation
import SwiftUI

public func formatDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "dd.MM.yyyy / HH:mm"
    return dateFormatter.string(from: date!)
}

public func getGradeColor(grade: Int) -> Color {
    switch grade {
    case 1: // Mod
        return Color(red: 134/255, green: 252/255, blue: 80/255)
    case 2: // Admin
        return Color(red: 14/255, green: 126/255, blue: 201/255)
    case 3: // HeadAdmin
        return Color(red: 66/255, green: 148/255, blue: 255/255)
    case 4: // Creator
        return Color(red: 30/255, green: 34/255, blue: 255/255)
    case 348: // Gigachad
        return Color(red: 255/255, green: 178/255, blue: 78/255)
    default: // User
        return Color.primary
    }
}

extension View {
    func cardboardStyle() -> some View {
        self.padding(.horizontal)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .shadow(radius: 1)
            .padding(.vertical, 8)
    }
    
    func backgroundStyle() -> some View {
        self.padding(.horizontal)
            .background(Color(.systemGroupedBackground))
    }
    
    func headerTitleStyle() -> some View {
        self.font(.custom("LondrinaSolid-Regular", size: 30))
            .padding(12)
            .background(Color(.black))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    
    func sentButtonStyle() -> some View {
        self.font(.custom("LondrinaSolid-Regular", size: 30).bold())
            .padding(8)
            .background(Color(.black))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    func cancelButtonStyle() -> some View {
        self.font(.custom("LondrinaSolid-Regular", size: 17).bold())
            .padding(8)
            .background(Color(.black))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}
