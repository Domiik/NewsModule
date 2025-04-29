//
//  StoriesHorizontalView.swift
//  CHSURasp
//
//  Created by Владимир Иванов on 28.04.2025.
//

import SwiftUI


struct StoriesHorizontalView: View {
    @ObservedObject var viewModel: StoriesViewModel
    @Binding var presentStories: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.arrayStories, id: \.id) { story in
                    Button {
                        presentStories.toggle()
                    } label: {
                        StoriesCell(title: story.name, imageString: story.image)
                    }
                    .sheet(isPresented: $presentStories) {
                        StoriesView(urlApp: story.url)
                    }
                }
            }
            .padding([.top, .leading])
        }
    }
}
