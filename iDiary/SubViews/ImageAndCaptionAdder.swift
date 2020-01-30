//
//  ImageAndCaptionAdder.swift
//  iDiary
//
//  Created by Bibin Benny on 30/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

import SwiftUI

struct ImageAndCaptionAdder: View {
    
    @Environment(\.managedObjectContext) var managedObjectcontext
    
    @ObservedObject var diary : Diary
    var pickedTempUiImage : UIImage
    
    @State var testimage : String = "pic1"
    
    @Binding var imagePicked : Bool
    @State var caption : String
    var image : UIImage
    {
        return self.pickedTempUiImage
    }
    
    var size : CGSize
    {
        let ratio = min( UIScreen.main.bounds.width / self.image.size.width, (UIScreen.main.bounds.height / 1.3) / self.image.size.height)
        return CGSize(width: self.image.size.width * ratio, height: self.image.size.height * ratio)
    }
    
    
    var body: some View {
        
        GeometryReader{
            geo in
            VStack {
                
                Spacer()
                Image(uiImage: self.pickedTempUiImage)
                    .resizable()
                    .cornerRadius(5)
                    .clipped()
                    .padding()
                    .frame(width : self.size.width, height : self.size.height)
                    .shadow(radius : 5)
                Spacer()
                VStack(spacing : 1) {
                    TextField("Caption", text: self.$caption)
                        .font(.system(.body, design : .rounded))
                        .padding([.leading,.trailing], 10)
                    
                    Divider()
                        .padding([.leading,.trailing], 10)
                        .padding(.bottom, 10)
                }
                
                
                HStack(spacing : 40)
                {
                    Button(action: {
                       
                        self.imagePicked = false
                        
                        
                    }) {
                        Image(systemName : "x.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.red)
                    }
                    
                    
                    Divider()
                        .frame(height : 20)
                    
                    Button(action: {
                        let photo = Photo(context: self.managedObjectcontext)
                       // photo.caption = self.caption
                        photo.id = UUID()
                        photo.image = self.image.jpeg(.low)!
                        self.diary.images.insert(photo)
                        self.imagePicked = false
                        
                        
                    }) {
                        Image(systemName : "checkmark.circle.fill")
                            .font(.largeTitle)
                    }
                    
                }
                    
                .padding()
                
                
                
                
                
            }
        }
        .background(Color(.systemBackground))
    
        
        
    }
    
    struct ImageAndCaptionAdder_Previews: PreviewProvider {
        static var previews: some View {
            ImageAndCaptionAdder( diary: Diary(), pickedTempUiImage: UIImage(named : "empty")!, imagePicked: .constant(false), caption: "")
            
            
        }
    }
    
}
