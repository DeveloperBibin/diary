
//
//  FloatingButton.swift
//  iDiaryPro
//
//  Created by Bibin Benny on 07/11/19.
//  Copyright © 2019 Bibin Benny. All rights reserved.
//

import SwiftUI

struct FloatingButton: View {
    
    @ObservedObject var data : FloatButtonData
    
    var body: some View {
        
        
        
        ZStack(alignment : .trailing){
            
            HStack
                {
                    
                    Button(action: {
                        self.data.onLocationButtonClicked.toggle()
                        print("Float - locationClicked")
                    }) {
                        Image(systemName: "location.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.blue)
                    }
                    
                    
            }
            .offset( x: self.data.onButtonClicked ? -180 : 0)
            .opacity(self.data.onButtonClicked ? 1 : 0)
            
            
            HStack
                {
                    
                    Button(action: {
                        self.data.onPersonButtonClicked.toggle()
                    }) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            
                            .foregroundColor(Color.blue)
                        
                    }
                    
                    
                    
                    
            }
            .offset( x: self.data.onButtonClicked ? -120 : 0)
            .opacity(self.data.onButtonClicked ? 1 : 0)
            
            
            
            
            HStack
                {
                    
                    Button(action: {
                        
                        self.data.onPhtotoButtonClicked.toggle()
                        print("Float - PhotoClicked")
                        
                        
                    }) {
                        
                        Image(systemName: "photo.fill")
                            .font(.largeTitle)
                            
                            .foregroundColor(Color.blue)
                            
                            .cornerRadius(15)
                    }
                    
                    
                    
                    
            }
            .offset( x: self.data.onButtonClicked ? -60 : 0)
            .opacity(self.data.onButtonClicked ? 1 : 0)
            
            
            
            Button(action: {
                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                
                withAnimation(.spring()){
                    self.data.onButtonClicked.toggle()}
            }) {
                Image(systemName: "plus.circle.fill")
                    
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                    
                    .scaleEffect(1.4)
                    
                    .rotationEffect(.degrees(self.data.onButtonClicked ? 225 : 90))
                    .scaleEffect(self.data.onButtonClicked ? 1.2 : 1)
            }
            
            
        }
        
        
    }
    
    
}


struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(data : FloatButtonData())
    }
}
