//
//  ViewEnregistrement.swift
//  running
//
//  Created by Developer on 17/04/2015.
//  Copyright (c) 2015 Developer. All rights reserved.
//

import Foundation
import UIKit

import CoreLocation
import CoreData
import MapKit

class ViewEnregistrement: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext
    
    
    @IBOutlet weak var lbl_Temps: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_vitesse: UILabel!
    @IBOutlet weak var lbl_vitesseMax: UILabel!
    @IBOutlet weak var theMap: MKMapView!
    
    //Variables qui vont recevoir les données de la fenetre précedante
    var tempsText = String()
    var distanceText = String()
    var vitesseText = String()
    var tabCoordonnées :[CLLocationCoordinate2D] = []
    var vitesseMaxText = String()
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var i :Int
        // Do any additional setup after loading the view, typically from a nib.
        lbl_Temps.text = tempsText
        lbl_distance.text = distanceText
        lbl_vitesse.text = vitesseText
        lbl_vitesseMax.text = vitesseMaxText
        
        //Setup our Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.Standard
        theMap.showsUserLocation = true
        
        
        // For use in foreground
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            
        }
        
        //Centre mapView faire notre itinéraire
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
        
        
        var polyline = MKPolyline(coordinates: &tabCoordonnées, count: tabCoordonnées.count)
        theMap.addOverlay(polyline)
        
    }
    @IBAction func Enregistrer(sender: UIButton) {

        let entityTraining =
        NSEntityDescription.entityForName("Training",
            inManagedObjectContext: managedObjectContext!)
        
        let training = Training(entity: entityTraining!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        training.date = NSDate()
        training.duration = tempsText
        training.distance = distanceText
        training.speed = vitesseText
        training.maxspeed = vitesseMaxText

       
        var locationSet = NSMutableOrderedSet()
        
        let entityLocations =
        NSEntityDescription.entityForName("Location",
            inManagedObjectContext: managedObjectContext!)
        
        for location in tabCoordonnées {
            let currentLocation = Location(entity: entityLocations!,
                insertIntoManagedObjectContext:managedObjectContext)
            
            currentLocation.latitude = location.latitude
            currentLocation.longitude = location.longitude
            
            locationSet.addObject(currentLocation)

        }
        
        training.locations = locationSet
        
        
        var error: NSError?
        
        managedObjectContext?.save(&error)
        
       
    }
    
   
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation
        userLocation: MKUserLocation!) {
            mapView.centerCoordinate = userLocation.location.coordinate
    }
    
   
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay is MKPolyline) {
            var pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            pr.lineWidth = 5;
            return pr;
        }
        
        return nil
    }
  }
