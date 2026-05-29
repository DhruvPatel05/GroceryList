//
//  Tip.swift
//  GroceryListApp
//
//  Created by Dhruv Patel on 28/05/26.
//

import Foundation
import TipKit


struct ButtonTip : Tip {
    var title: Text = Text("Essential Foods")
    var message: Text? = Text("Add some everyday item to the shopping list.")
    var image: Image? = Image(systemName: "info.circle")
    
}
