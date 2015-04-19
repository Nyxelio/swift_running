//
//  NewTrainingController.swift
//  running
//
//  Created by Developer on 13/04/2015.
//  Copyright (c) 2015 Developer. All rights reserved.
//

import UIKit
import CoreLocation

class NewTrainingController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var btn_Start: UIButton!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_Vitesse: UILabel!
    @IBOutlet weak var btn_démarrer: UIButton!
    @IBOutlet weak var btn_terminer: UIButton!
    
    //Constante: temps initial
    let initSec = 60
    
    //Variable qui va servir à afficher la valeur du timer
    var sec:Int = 00
    var min:Int = 00
    var heure:Int = 00
   
    //initialisation du timer
    var timer:NSTimer = NSTimer()
    
    //Deux variable qui vont nous servir 
    var exist:Bool = false
    var work:Bool = false
    
    //Manager de la géolocalisation
    let locationManager = CLLocationManager()
    
    //Tableau qui enregistre les position
    var locationsList :[CLLocationCoordinate2D] = []
    
    //Variable qui recupere la distance
    var distance:Float = 0
    
    //Variable qui récupere la vitesse
    var vitesse:Float=0
    var vitesseList:[Float] = []
    var vitesseMax:Float = 0
    var vitesseMoy:Float = 0
    
    //Si le bouton démarrer est actionné
    @IBAction func GoTimer(sender: UIButton)
    {
        
        if(!exist) //Si il existe pas
        {
            
            //On lance le timer
            TimerStart()
            
            //Il existe donc et fonctionne
            exist = true
            work = true
            
            //Changer le texte du UIBouton
            btn_Start.setTitle("Pause", forState: .Normal)
            //On lance l'actulisation des données
            locationManager.startUpdatingLocation()
            btn_terminer.hidden = false
            btn_démarrer.hidden = true
        }
        else
        {
            if(work) //Le timer fonctionne
            {
                //On l'arrete et on change le texte du bouton
                timer.invalidate()
                work = false
                btn_Start.setTitle("Continuer", forState: .Normal)
            }
            /*else
            { //Si le timer ne fonctionne pas
                //On le relance et on change le txt du bouton
                TimerStart()
                work = true
                btn_Start.setTitle("Terminer", forState: .Normal)
            }*/
        }
    }
    
    
    //Si on action le bouton terminer
    @IBAction func terminer(sender: AnyObject)
    {

        //On stop l'actualisation des données de géolocalisées
        locationManager.stopUpdatingLocation()
        timer.invalidate()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TIMER
    func TimerStart()
    {
            //Timer qui appelle toutes les secondes, la fonction update
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("Update"), userInfo: nil, repeats: true)
        
    }
    
    func Update()
    {
        if(sec < 59)
        {
            sec++
            
             lbl_Timer.text = AffichageChrono(heure, minIn: min, secIn: sec)
            
        }
        else
        {
            if (sec == 59 && min < 59)
            {
                sec = 0
                min++
                lbl_Timer.text = AffichageChrono(heure, minIn: min, secIn: sec)
            }
            else
            {
                if (min == 59 && sec == 59)
                {
                    sec = 0
                    min = 0
                    heure++
                    
                    lbl_Timer.text = AffichageChrono(heure, minIn: min, secIn: sec)
                }
            }
        }
    }
    
    //Fonction permettant d'afficher le timer
    func AffichageChrono(heureIn:Int, minIn:Int, secIn:Int) -> String
    {
        var stringSec:String = ""
        var stringMin:String = ""
        var stringHeure:String = ""
        
        if(sec < 10)
        {
            stringSec = "0"+String(secIn)
        }
        else
        {
            stringSec = String(secIn)
        }
        
        if(min < 10)
        {
            stringMin = "0"+String(minIn)
        }
        else
        {
            stringMin = String(minIn)
        }
        
        if(heure < 10)
        {
            stringHeure = "0"+String(heureIn)
        }
        else
        {
            stringHeure = String(heureIn)
        }
        
        return ("\(stringHeure):\(stringMin):\(stringSec)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        
        //Stockage des données
        locationsList.append(locValue)
        
        //Affichage position de départ
        var locDepart:CLLocationCoordinate2D = locationsList[0]
        

        
        //Affichage de la distance
        if(locationsList.count > 2)
        {
            
            distance += CalculDistance(locationsList[locationsList.count - 2], to: locValue)
            lbl_Distance.text  = "\((round(1000 * distance) / 1000)) Km"

        }
        else
        {
            if(locationsList.count == 2)
            {
                distance += CalculDistance(locDepart, to: locValue)
                lbl_Distance.text = "\((round(1000 * distance) / 1000)) Km"
            }
        }
        
        
        //Calcule de vitesse
        vitesse = (manager.location.speed.description as NSString).floatValue * 1.6093
        lbl_Vitesse.text = "\(vitesse) Km/h"
        vitesseList.append(vitesse)
        
        
        
    }
    
    func CalculDistance(from:CLLocationCoordinate2D,to:CLLocationCoordinate2D) -> Float
    {
        let from2 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return (from2.distanceFromLocation(to2).description as NSString).floatValue / 1000
    }
    
    func CalculVitesse()
    {
        var i: Int = 0
        var vitesseAdditionner : Float = 0
        
        for i in 0 ... (vitesseList.count - 1)
        {
            vitesseAdditionner += vitesseList[i]
            
            if (vitesseMax < vitesseList[i])
            {
                vitesseMax = vitesseList[i]
            }
        }
        
        //Calcule de la moyenne
        vitesseMoy = (vitesseAdditionner / Float(vitesseList.count))
        
        //Arrondie les deux variables de vitesse
        vitesseMoy = (round(1000 * vitesseMoy) / 1000)
        vitesseMax = (round(1000 * vitesseMax) / 1000)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "Enregistrement")
        {
            CalculVitesse()
            distance = (round(1000 * distance) / 1000)
            
            var destViewController : ViewEnregistrement = segue.destinationViewController as ViewEnregistrement
            destViewController.tempsText = AffichageChrono(heure, minIn: min, secIn: sec)
            destViewController.distanceText = "\(distance) Km"
            destViewController.vitesseText = "\(vitesseMoy) Km/h"
            destViewController.vitesseMaxText = "\(vitesseMax) Km/h"
            destViewController.tabCoordonnées = locationsList
            
            
        }
    }
    
}