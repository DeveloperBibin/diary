//
//  TodayCard.swift
//  iDiary
//
//  Created by Bibin Benny on 28/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

struct TodayCard: View {
    
    @ObservedObject var diary : Diary
    
    var body: some View {
        VStack
            {
                 VStack(spacing : 3) {
                    TextField("Dear diary,", text: self.$diary.title)
                        .font(.system(.headline, design : .rounded))
                        .padding([.leading, .trailing])
                        .transition(.scale)
                        .opacity(0.7)
                 }
                 .padding([.top, .bottom], 10)
                    
                 .background(Color(.quaternarySystemFill))
                 .cornerRadius(10)
                 .padding([.leading,.trailing])
                 .padding([.top, .bottom], 10)
                
                ZStack {
                    TextView(text: self.$diary.entry)
                        .padding([.leading, .trailing])
                        .transition(.scale)
                    if (self.diary.entry.isBlank)
                    {
                        Image(systemName : "pencil")
                            .font(.system(.largeTitle, design : .rounded))
                            .foregroundColor(Color(.systemGray))
                            .transition(.scale)
                    }
                }
                .padding(.bottom)
        }
    }
}

struct TodayCard_Previews: PreviewProvider {
    static var previews: some View {
        TodayCard(diary: Diary())
    }
}
