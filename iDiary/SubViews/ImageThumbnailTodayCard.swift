//
//  ImageThumbnailTodayCard.swift
//  iDiary
//
//  Created by Bibin Benny on 30/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation


struct ImageThumbnailTodayCard: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    @ObservedObject var photo : Photo
     
    var image : UIImage
    {
        UIImage(data: self.photo.image)!
    }
    
    var size : CGSize
    {
        let ratio = min( 60 / self.image.size.width, 60 / self.image.size.height)
        return CGSize(width: self.image.size.width * ratio, height: self.image.size.height * ratio)
    }
    
    var ifStringisLong : Bool
    {
        if (self.photo.caption.count > 30)
        {return true}
        else
        {return false}
    }
    
    var stringArray : [String]
    {
        
        if (ifStringisLong)
        {
            return splitString(string: String(self.photo.caption.prefix(60)))
        }
        else
        {return []}
    }
    
    
    
    var colors : [Color]
    {
        [ Color(.systemGray4),Color(.systemGray)]
    }
    
    var color2 : [Color]
    {
        [Color(.systemGreen).opacity(0.9), Color(.systemGreen).opacity(0.5)]
    }
    
    /// gradient
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: .leading , endPoint: .trailing)
    }
    
    
    
    var body: some View {
        
        
        
        HStack( spacing : (self.photo.caption != "") ? 8 : 0){
            
            Image(uiImage: self.image)
                .resizable()
                //  .aspectRatio(contentMode: ContentMode.fit)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 1))
                .frame(width : self.size.width, height : self.size.height)
                .padding(3)
            
            if self.photo.caption != "" {
                
                if (!self.ifStringisLong)
                {
                    Text("\(self.photo.caption.firstCapitalized)")
                        .font(.system(.footnote, design : .rounded))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .padding(.trailing, 4)
                        .shadow(radius: 0.3)
                }
                else
                {
                    VStack {
                        Text("\(self.stringArray[0])")
                            .font(.system(.footnote, design : .rounded))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .padding(.trailing, 4)
                            .shadow(radius: 0.3)
                        Text("\(self.stringArray[1])")
                            .font(.system(.footnote, design : .rounded))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .padding(.trailing, 4)
                            .shadow(radius: 0.3)
                    }
                    
                }
                
                
                
            }
            
            Button(action: {
                
                self.managedObjectcontext.delete(self.photo)
                
            }) {
                
                Image(systemName : "trash")
                    .font(.caption)
                    .foregroundColor(Color(.darkText))
                    .padding(7)
                    .background(Color(.white))
                    .clipShape(Circle())
                    .padding(.trailing, 3)
                
            }
            
            
        }
            
        .background(RoundedRectangle(cornerRadius: (self.photo.caption == "") ? 50 : 15).fill(gradient))
        
        
    }
    
}
