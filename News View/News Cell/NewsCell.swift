//
//  NewsCell.swift
//  CHSURasp
//
//  Created by Domiik on 21.02.2023.
//

import SwiftUI
import Kingfisher

struct NewsCell: View {
    //MARK: - Properties
    @State var titleText: String
    @State var date: String
    @State var imageUrl: String
    @State var code: String
    @State var tag: String
    
    let alignments: [TextAlignment] = [.leading, .center, .trailing]
    // Like for favorite
    //@State private var isLiked = false
    

    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    //MARK: - View
    var body: some View {
        VStack {
            VStack(alignment: .center) {
               KingFisherImageView(urlString: imageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 300)
                        .mask(TopRoundedRectangle())
                        .clipped()
                HStack {
                    Text("#\(tag)")
                        .foregroundColor(Color(asset: .textColor))
                        .font(AppFont.subLine.font)
                        .padding(4)
                        .background(.red)
                        .opacity(0.85)
                        .cornerRadius(8.0)
                    Spacer()
                }
                .padding(.horizontal, 5)
                HStack {
                    Text(titleText)
                        .font(AppFont.headLine.font)
                        .foregroundColor(Color(asset: .textColor))
                        Spacer()
                }
                .padding(.horizontal, 7)
            }
            .padding(.bottom, 6)
            HStack {
                Text(date)
                    .font(AppFont.subLine.font)
                    .foregroundColor(Color(asset: .textColor))
                    .padding(.bottom, 10.0)
                    .padding(.leading, 20.0)
                Spacer()
                HStack {
                    VStack {
                        if #available(iOS 16.0, *) {
                            ShareLink(item: URL(string: Constants.baseForNewsShare + code)!) {
                                Image(system: .share)
                                    .foregroundColor(Color(asset: .textColor))
                                    .font(AppFont.title1.font)
                            }
                            .buttonStyle(LikeButtonStyle())
                        } else {
                            // Fallback on earlier versions
                            Button(action: {
                                let shareURL = URL(string: Constants.baseForNewsShare + code)!
                                
                                let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
                                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                            }) {
                                Image(system: .share)
                                    .foregroundColor(Color(asset: .textColor))
                                    .font(AppFont.title1.font)
                            }
                            .buttonStyle(LikeButtonStyle())
                        }
                    }
                    
                }
                .padding(.bottom, 10.0)
                .padding(.trailing, 15.0)
            }
            
            
        }
        .frame(minHeight: 400)
        .background(Color(asset: .cellColor))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


struct TopRoundedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 20
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius), control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}


struct OverlayForImage: View {
    
    @State var  text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .font(AppFont.subLine.font)
                .foregroundColor(Color(asset: .textColor))
                .padding(4)
        }
    }
}

