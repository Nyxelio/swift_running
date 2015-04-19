//
//  ViewEnregistrement.swift
//  running
//
//  Created by Developer on 17/04/2015.
//  Copyright (c) 2015 Developer. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData


class ViewEnregistrement: UIViewController, MKMapViewDelegate {
    
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
        theMap.mapType = MKMapType.Satellite
        theMap.showsUserLocation = true
        
        //Centre mapView faire notre itinéraire
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
        
      //REvoir
      /*  for i in 1 ... tabCoordonnées.count
        {
            itineraire(tabCoordonnées[i - 2], coordonnee2: tabCoordonnées[i - 1])
        }*/
        
        
        
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
        
        /*if let err = error {
            status.text = err.localizedFailureReason
        } else {
            
            status.text = "Enregistrement effectué"
            
        }*/
    }
    
    func itineraire (coordonnee1: CLLocationManager, coordonnee2: CLLocationManager)
    {
        
        let c1 = coordonnee1.location.coordinate
        let c2 = coordonnee2.location.coordinate
        var a = [c1, c2]
        var polyline = MKPolyline(coordinates: &a, count: a.count)
        theMap.addOverlay(polyline)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }
  }
