//
//  ViewController.swift
//  Pixel City
//
//  Created by praveen thati on 6/28/18.
//  Copyright © 2018 state of delaware. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapVC: UIViewController, UIGestureRecognizerDelegate {
   // Outlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
    }
    
    func animateViewUp () {
        pullUpViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func locationBtnPressed(_ sender: Any) {
        
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMaponUserLocation()
        }
    }
    
    func addDoubleTap () {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
    }
    
}

extension MapVC: MKMapViewDelegate {
    func centerMaponUserLocation () {
        guard let coordinate = locationManager.location?.coordinate else {return}
        
        let cordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius, regionRadius)
        mapView.setRegion(cordinateRegion, animated: true)
    }
    
    @objc func dropPin (sender: UITapGestureRecognizer) {
        removePin()
        animateViewUp()
        let touchPoint = sender.location(in: mapView)
        let touchCordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotaion = DroppablePin(coordinate: touchCordinate, identifier: "droppablePin")
        
        mapView.addAnnotation(annotaion)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCordinate, regionRadius*2.0, regionRadius*2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func removePin () {
        for annotaion in mapView.annotations {
            mapView.removeAnnotation(annotaion)
        }
    }

    
}
extension MapVC: CLLocationManagerDelegate {
    
    func configureLocationServices() {
        
        if authorizationStatus == .notDetermined {
             locationManager.requestAlwaysAuthorization()
        }
        else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMaponUserLocation()
    }
    
}

