//
//  AddOrderViewModel.swift
//  IOS_MVVM_SWIFT
//
//  Created by DreamOnline on 30/8/20.
//  Copyright © 2020 Tarun. All rights reserved.
//

import Foundation

struct NewOrderViewModel {
    var name : String?
    var email : String?
    var selectedSize : String?
    var selectedType : String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes : [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized}
    }
}
