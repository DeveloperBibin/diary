//
//  StreaksData.swift
//  iDiary Watch Extension
//
//  Created by Bibin Benny on 17/02/20.
//  Copyright © 2020 Bibin Benny. All rights reserved.
//

import SwiftUI

class StreaksData : ObservableObject {
    @Published var dailyNumber : Int = 0
    @Published var weeklyNumber : Double = 0
    
}
