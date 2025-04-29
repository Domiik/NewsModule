//
//  NewsCellPlaceholder.swift
//  CHSURasp
//
//  Created by Владимир Иванов on 25.04.2025.
//

import SwiftUI

struct NewsCellPlaceholder: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 300)
                .mask(TopRoundedRectangle())
                .blur(radius: 4)
                .shimmer() // кастомный эффект, ниже покажу

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 60)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)

            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 15)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
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
    NewsCellPlaceholder()
}
