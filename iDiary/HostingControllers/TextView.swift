//
//  TextView.swift
//  iDiary
//
//  Created by Bibin Benny on 01/09/19.
//  Copyright © 2019 Bibin Benny. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation
import NaturalLanguage



struct TextView : UIViewRepresentable {
    typealias UIViewType = UITextView
  
    @Binding var text: String
   
 

    func makeCoordinator() -> Coordinator {
        
        
        return Coordinator(self)
        
    }

    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        
        
        
        
        let textView = UITextView()

        
        
        textView.usesStandardTextScaling = true
        textView.isScrollEnabled = true
        
        textView.backgroundColor = UIColor.quaternarySystemFill
        textView.layer.cornerRadius = 20
    
        textView.alwaysBounceVertical = true
        
        textView.contentInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)

        textView.isUserInteractionEnabled = true
        textView.showsVerticalScrollIndicator = false
   
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        textView.textColor   = UIColor.label.withAlphaComponent(0.6)
        
        
        let selectionInteraction = UITextInteraction(for : .editable)

        selectionInteraction.textInput = textView

        textView.addInteraction(selectionInteraction)
        textView.delegate = context.coordinator
        
        

        return textView
    }
    
    
    

    func updateUIView(_ uiView: UITextView, context:
        UIViewRepresentableContext<TextView>) {

        uiView.text = self.text
        uiView.isEditable = true
      
        let selectionInteraction = UITextInteraction(for : .editable)
            selectionInteraction.textInput = uiView
            uiView.addInteraction(selectionInteraction) }
    
   


    class Coordinator : NSObject, UITextViewDelegate{

        var parent: TextView
        
      

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
           
            
        }
        
    
        
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           
            return true
        }
        
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
           
        }

        func textViewDidChange(_ textView: UITextView) {
    
            
            parent.text = textView.text

            
            
        }
        
      
        
        

        
        
        func validate(textView: UITextView) -> Bool {
            guard let text = textView.text,
                !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
            }

            return true
        }
        


    }

}



struct TextView_Previews: PreviewProvider {

    static var previews: some View {



        TextView(text: .constant("Text"))
    }
}

