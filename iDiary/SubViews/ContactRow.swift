//
//  ContactRow.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct ContactRow: View {
    
    var name : String
    
    var image : Image?
    
    var body: some View {
        
        
        HStack {
            if image != nil
            {
                image?
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fill)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemYellow), lineWidth: 1))
                    .frame(width : 25, height : 25)
            }
            else
            {
                ZStack
                    {
                        Circle().fill(Color(.tertiarySystemFill))
                            .overlay(Circle().stroke(Color(.systemYellow), lineWidth: 1))
                        
                        Text("\(name.first?.description ?? "")")
                            .font(.system(.headline, design : .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color(.secondaryLabel))
                        
                }
                .frame(width : 25, height : 25)
            }
            
            Text(self.name)
                .font(.system(.subheadline, design : .rounded))
                .foregroundColor(Color(.label))
                .lineLimit(1)
                .padding([.leading, .trailing], 5)
            
            Spacer()
            
            
            }.contentShape(Rectangle())
            
        .padding([.bottom, .top], 5)
        
        
        
        
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(name: "Bibin Benny"
            ,image: Image("bibin")
        )
    }
}
