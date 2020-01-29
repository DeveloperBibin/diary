//
//  LocationThumbailTodayCard.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
struct LocationThumbailTodayCard: View {
    
    @ObservedObject var location : Location
    @Environment(\.managedObjectContext) var managedObjectcontext
    var colors : [Color]
    {
        [ Color(.systemGray4),Color(.systemGray)]
    }
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: .leading , endPoint: .trailing)
    }
    var body: some View {
        
        HStack(){
            
            Image(systemName : "mappin.and.ellipse")
                .font(.system(.callout , design : .rounded))
                .foregroundColor(Color(.systemGray6))
            Text(self.location.title)
                .font(.system(.footnote, design : .rounded))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            Button(action: {
                
                self.managedObjectcontext.delete(self.location)
                
                
            }) {
                
                Image(systemName : "trash")
                    .font(.caption)
                    .foregroundColor(Color(.darkText))
                    .padding(7)
                    .background(Color(.white))
                    .clipShape(Circle())
                
            }
            
            
        }
        .padding(7)
        .background(RoundedRectangle(cornerRadius: 10).fill(gradient))
        //.cornerRadius(10)
    }
}

struct LocationThumbailTodayCard_Previews: PreviewProvider {
    static var previews: some View {
        LocationThumbailTodayCard(location : Location())
    }
}
