//
//  SearchBar.swift
//  iDiary
//
//  Created by Bibin Benny on 05/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text : String
    var placeHolder : String = "Search"
    
    var body: some View {
        HStack {
            Image(systemName : "magnifyingglass")
                .foregroundColor(Color(.secondaryLabel))
            TextField(self.placeHolder, text: $text)
        }
        .padding(8)
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding([.top,.trailing,.leading], 9)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
