//
//  NewTrainingController.swift
//  running
//
//  Created by Developer on 13/04/2015.
//  Copyright (c) 2015 Developer. All rights reserved.
//

import UIKit

class NewTrainingController: UIViewController {
    
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var btn_Start: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            
            AffichageChrono(heure, minIn: min, secIn: sec)
            
        }
        else
        {
            if (sec == 59 && min < 59)
            {
                sec = 0
                min++
                AffichageChrono(heure, minIn: min, secIn: sec)
            }
            else
            {
                if (min == 59 && sec == 59)
                {
                    sec = 0
                    min = 0
                    heure++
                    AffichageChrono(heure, minIn: min, secIn: sec)
                }
            }
        }
    }
    
    func AffichageChrono(heureIn:Int, minIn:Int, secIn:Int)
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
        
        lbl_Timer.text = stringHeure+":"+stringMin+":"+stringSec
    }
}