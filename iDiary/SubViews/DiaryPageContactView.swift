//
//  DiaryPageContactView.swift
//  iDiary
//
//  Created by Bibin Benny on 01/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct DiaryPageContactView: View {
    
    var contact : Contact
    
    var contactName : String
    {
        return contact.name
    }
    var contactImage : Image?
    {
        return contact.imageDataAvailble ? Image(uiImage: UIImage(data: contact.imageData)!) : nil
    }
    
    
    var body: some View {
       
        VStack
            {
                
                VStack{
                    
                    if contactImage != nil
                    {
                        
                        VStack {
                            contactImage?.resizable().aspectRatio(contentMode: ContentMode.fill)
                        }
                        
    
                        
                    }
                    else
                    {
                        VStack {
                            HStack(spacing : 0) {
                                
                            Text("\(String(contactName.first!.description).uppercased())")
                            .font(.system(.headline, design : .rounded))
                            .fontWeight(.medium)
                            .lineLimit(1)

                            if (!String(contactName.secondName).isEmpty)
                            {
                            Text("\(String(contactName.secondName.first!.description).uppercased())")
                            .font(.system(.headline, design : .rounded))
                            .fontWeight(.medium)
                                          .lineLimit(1)
                                           }
                                
                            }
                        .padding()
                            .background(Color(.systemGray5))
                                
                        .clipShape(Circle())
                           
                        }
                        
                    }
                }
            
                    .clipShape(Circle())
                       .padding(4)
                    .overlay(Circle().stroke(Color(.systemYellow), lineWidth : 1))
                    
                .frame(width : 60, height : 60)
                
                Text(contactName.components(separatedBy: " ").first!)
                    .font(.system(.caption, design : .rounded))
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.top, (self.contactImage != nil) ? 0 : 8.2)
                .lineLimit(1)
                
        }
   
    
    
    }
}
