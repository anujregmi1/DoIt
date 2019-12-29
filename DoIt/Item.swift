//
//  Item.swift
//  DoIt
//
//  Created by Anuj Regmi on 12/25/19.
//  Copyright © 2019 Anuj Regmi. All rights reserved.
//

import Foundation

//conform to the protocol Codeable to encode and decode the data and for that all the properties in the class have to be a standard datatype.
class Item: Codable {
    
    var title : String?
    var done = false;
}
