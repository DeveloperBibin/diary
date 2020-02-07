//
//  LocationResultModel.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI


struct LocationResultModel: View {
    
    var title : String = ""
    var desc : String = ""
    
    var body: some View {
        
        VStack()
            {
                HStack{
                    Image(systemName : "mappin.and.ellipse")
                        .font(.headline)
                        .foregroundColor(Color.blue)
                    
                    VStack(alignment : .leading) {
                        Text(title)
                            
                            .font(.subheadline)
                        Text(desc)
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                            .padding(.top, 3)
                        
                        
                        
                    }
                    
                    Spacer()
                    
                }
                Divider()
        }
    }
}

struct LocationResultModel_Previews: PreviewProvider {
    static var previews: some View {
        LocationResultModel()
    }
}
