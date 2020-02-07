//
//  FrequentLocationViewSearch.swift
//  iDiary
//
//  Created by Bibin Benny on 06/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct FrequentLocationViewSearch: View {
    
    var location : Location
    
    var body: some View {
       
        VStack{
        
            MapThumbNailView(location : self.location).cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 0.5))

            Text(location.title)
                .font(.caption)
                .foregroundColor(.primary)
            .lineLimit(1)
        }
        .frame(width : 100, height : 115)
        
    }
}

struct FrequentLocationViewSearch_Previews: PreviewProvider {
    
    static var previews: some View {
        FrequentLocationViewSearch(location : Location())
    }
}
