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


class ViewEnregistrement: UIViewController {
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext
    
    
    @IBOutlet weak var lbl_Temps: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_vitesse: UILabel!
    @IBOutlet weak var status: UILabel!
    
    //Variables qui vont recevoir les données de la fenetre précedante
    var tempsText = String()
    var distanceText = String()
    var vitesseText = String()
    var tabCoordonnées :[CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lbl_Temps.text = tempsText
        lbl_distance.text = distanceText
        lbl_vitesse.text = vitesseText
    }
    @IBAction func Enregistrer(sender: UIButton) {
        
        let entity =
        NSEntityDescription.entityForName("Training",
            inManagedObjectContext: managedObjectContext!)
        
        /*let training = Training(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        training.duration = tempsText
        training.distance = distanceText
        training.speed = vitesseText
        */
        
        let options = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedObjectContext)
        
        options.setValue(tempsText, forKey: "duration")
        options.setValue(distanceText, forKey: "distance")
        options.setValue(vitesseText, forKey: "speed")
        //options.setValue(tabCoordonnées, forKey: "locations")

        var error: NSError?
        
        managedObjectContext?.save(&error)
        
        if let err = error {
            status.text = err.localizedFailureReason
        } else {
            
            status.text = "Enregistrement effectué"
            
        }
    }
  }