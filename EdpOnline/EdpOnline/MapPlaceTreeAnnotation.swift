//
//  MapPlaceTreeAnnotation.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 16/11/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import MapKit

class TreeAnnotation : NSObject, MKAnnotation {
    
    private let locationTree:CLLocationCoordinate2D
    let identifier:String = "tree"
    
    init(forLocation location:CLLocationCoordinate2D) {
        locationTree = location
    }
    
    var coordinate: CLLocationCoordinate2D {
        return self.locationTree
    }
    
    var title: String? { return nil }
    var subtitle: String? { return nil }
    
    func viewTreeAnnotation() -> MKAnnotationView {
        let view   = MKAnnotationView(annotation: self, reuseIdentifier: self.identifier)
        view.image = UIImage(named: self.identifier)
        view.canShowCallout = false
        return view
    }
}
