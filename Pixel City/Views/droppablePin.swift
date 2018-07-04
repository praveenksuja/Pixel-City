//
//  droppablePin.swift
//  Pixel City
//
//  Created by praveen thati on 6/30/18.
//  Copyright © 2018 state of delaware. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate:CLLocationCoordinate2D, identifier: String){
        self.coordinate = coordinate
        self.identifier = identifier
    }
    
}
