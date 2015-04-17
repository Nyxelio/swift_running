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

class ViewEnregistrement: UIViewController {
    
    @IBOutlet weak var lbl_Temps: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_vitesse: UILabel!
    
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
}