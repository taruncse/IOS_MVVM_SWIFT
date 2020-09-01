//
//  Order.swift
//  IOS_MVVM_SWIFT
//
//  Created by DreamOnline on 30/8/20.
//  Copyright © 2020 Tarun. All rights reserved.
//

import Foundation
import CodableFirebase

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espressino
    case cortado
}



struct Order: Codable {
    let name : String
    let email : String
    let type: CoffeeType
    let size : CoffeeSize
    
    init?(_ vm : NewOrderViewModel) {
        guard let name = vm.name,
            let email = vm.email,
            let selectedType = CoffeeType.init(rawValue: vm.selectedType!.lowercased()),
            let selectedSize = CoffeeSize.init(rawValue: vm.selectedSize!.lowercased()) else {
                return nil
        }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
    
    static func create (vm : NewOrderViewModel) -> FirebaseResource<Order?> {
        let order = Order(vm)
        guard let data = try? FirebaseEncoder().encode(order) else {
            fatalError("Error encoding with Firebase Encoder library")
        }
        // Using JSON encoder
        /*guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order!")
        }*/
        
        let resource = FirebaseResource<Order?>(data: data)
        return resource
    }
}
