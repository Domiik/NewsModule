//
//  NewsImagePlaceholder.swift
//  CHSURasp
//
//  Created by Владимир Иванов on 25.04.2025.
//

import SwiftUI

struct NewsImagePlaceholder: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 300)
                .mask(TopRoundedRectangle())
                .blur(radius: 4)
                .shimmer() // кастомный эффект, ниже покажу
            
        }
        .frame(minHeight: 400)
        .background(Color(asset: .cellColor))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 8)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    NewsImagePlaceholder()
}
