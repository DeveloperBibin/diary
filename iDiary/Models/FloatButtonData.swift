//
//  FloatButtonData.swift
//  iDiary
//
//  Created by Bibin Benny on 29/01/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI
import Combine

class FloatButtonData : ObservableObject {
    
    @Published var onLocationButtonClicked : Bool = false
    @Published var onPersonButtonClicked : Bool = false
    @Published var onPhtotoButtonClicked : Bool = false
    @Published var onButtonClicked : Bool = true
    
}
