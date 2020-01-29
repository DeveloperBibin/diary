//
//  ContactThumbnailTodayCard.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

import SwiftUI
import Foundation
import Contacts

struct ContactThumbnailTodayCard: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    @ObservedObject var contact : Contact
   
    @State var clicked : Bool = false
    
    @EnvironmentObject var contactStore : ContactsFetcher
    var colors : [Color]
    {
        [ Color(.systemGray4),Color(.systemGray)]
    }
    /// gradient
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: .leading , endPoint: .trailing)
    }
    
    
    
    var body: some View {

        
        HStack(spacing : 0)
        {
            VStack()
                {
                    if self.contact.imageDataAvailble {
                        Image(uiImage: UIImage(data: self.contact.imageData)!)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            
                            .clipShape(Circle())
                            .padding(1.5)
                        
                    }
                    else
                    {
                        HStack(spacing : 0) {
                            Text("\(String(self.contact.name.first?.description ?? "").uppercased())")
                                .font(.system(.caption, design : .rounded))
                                .fontWeight(.bold)
                                .lineLimit(1)
                        
                            if (!String(self.contact.name.secondName).isEmpty)
                            {
                                Text("\(String(self.contact.name.secondName.first?.description ?? "").uppercased())")
                                    .font(.system(.caption, design : .rounded))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                            }
                            
                        }
                        .padding(5)
                        .background(Color(.quaternarySystemFill))
                        .clipShape(Circle())
                    }
                    
            }.frame(width : 30, height : 30)
                .padding([.trailing, .leading] ,5)
            
            
            HStack{ Text("\(String(self.contact.name).firstName.firstUppercased)")
                .font(.system(.footnote, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(Color(.white))
                .layoutPriority(1)
                Text("\(String(self.contact.name).secondName.firstUppercased)")
                    .fontWeight(.bold)
                    
                    .lineLimit(1)
                    
                    .font(.system(.footnote, design: .rounded))
                    
                    .foregroundColor(Color(.white))
                
                
            }
            
            
            
            HStack {
                Button(action: {
                    self.managedObjectcontext.delete(self.contact)
                    
                    
                }) {
                    
                    
                    Image(systemName : "trash")
                        .font(.caption)
                        .foregroundColor(Color(.darkText))
                        .padding(7)
                        .background(Color(.white))
                        .clipShape(Circle())
                    
                    
                    
                }
            }
            .padding([.leading,.trailing], 5)
        }
        .frame(height : 35)
            
        .background(RoundedRectangle(cornerRadius: 10).fill(gradient))
        
        
        
        
        //.shadow(radius : 5)
    }
    
    
    
}


class tempImage : Identifiable
{
    
    var image : Image?
    var name : String
    
    init(image : String, name : String) {
        if image == ""
        {
            self.image = nil
        }
        else
        {
            self.image = Image(image)}
        self.name = name
    }
    
}



