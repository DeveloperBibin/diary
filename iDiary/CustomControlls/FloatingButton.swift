
//
//  FloatingButton.swift
//  iDiaryPro
//
//  Created by Bibin Benny on 07/11/19.
//  Copyright © 2019 Bibin Benny. All rights reserved.
//

import SwiftUI

struct FloatingButton: View {
    
   @Binding var onLocationButtonClicked : Bool
   @Binding var onPersonButtonClicked : Bool
   @Binding var onPhtotoButtonClicked : Bool
   @Binding var onButtonClicked : Bool
    
    var body: some View {
        
        
        
        ZStack(alignment : .trailing){
            
            HStack
                {
                    
                    Button(action: {
                        self.onLocationButtonClicked.toggle()
                        print("Float - locationClicked")
                    }) {
                        Image(systemName: "location.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.blue)
                    }
                    
                    
            }
            .offset( x: self.onButtonClicked ? -180 : 0)
            .opacity(self.onButtonClicked ? 1 : 0)
            
            
            HStack
                {
                    
                    Button(action: {
                        self.onPersonButtonClicked.toggle()
                    }) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            
                            .foregroundColor(Color.blue)
                        
                    }
                    
                    
                    
                    
            }
            .offset( x: self.onButtonClicked ? -120 : 0)
            .opacity(self.onButtonClicked ? 1 : 0)
            
            
            
            
            HStack
                {
                    
                    Button(action: {
                        
                        self.onPhtotoButtonClicked.toggle()
                        print("Float - PhotoClicked")
                        
                        
                    }) {
                        
                        Image(systemName: "photo.fill")
                            .font(.largeTitle)
                            
                            .foregroundColor(Color.blue)
                            
                            .cornerRadius(15)
                    }
                    
                    
                    
                    
            }
            .offset( x: self.onButtonClicked ? -60 : 0)
            .opacity(self.onButtonClicked ? 1 : 0)
            
            
            
            Button(action: {
                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                
                withAnimation(.spring()){
                    self.onButtonClicked.toggle()}
            }) {
                Image(systemName: "plus.circle.fill")
                    
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                    
                    .scaleEffect(1.4)
                    
                    .rotationEffect(.degrees(self.onButtonClicked ? 225 : 90))
                    .scaleEffect(self.onButtonClicked ? 1.2 : 1)
            }
            
            
        }
        
        
    }
    
    
}


//struct FloatingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatingButton()
//    }
//}
