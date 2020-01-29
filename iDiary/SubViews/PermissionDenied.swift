//
//  PermissionDenied.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

import SwiftUI

struct PermissionDenied: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var permissin : String
    
    var body: some View {
       
            VStack {
                Image(systemName : "exclamationmark.shield")
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
                    .padding([.leading, .trailing, .top, .bottom])
                
                //Divider().padding(5)
                
                Text("\(self.permissin) permission is denied, please enable them in settings to continue using this feature.")
                    .font(.system(.body, design : .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.label))
                    .padding([.trailing, .leading, .bottom])
                
                Divider()

                
            }
                
            .background(Color(.quaternarySystemFill))
        .cornerRadius(10)
        .padding()
        
    }
}

struct PermissionDenied_Previews: PreviewProvider {
    static var previews: some View {
        PermissionDenied(permissin: "Contact")
    }
}
