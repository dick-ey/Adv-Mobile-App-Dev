//
//  SpiceDetails_ViewController.swift
//  Spice Rack
//
//  Created by Matt Dickey on 3/1/16.
//  Copyright © 2016 Matt Dickey. All rights reserved.
//

import UIKit
import RealmSwift

//http://stackoverflow.com/questions/29569314/passing-value-to-another-viewcontroller-upon-selecting-cell-in-uicollectionview


class SpiceDetails_ViewController: UIViewController {
    
    // MARK: - Global Variables
    let database = try! Realm()
    var receivedObject : Spice?
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    // MARK: - IBActions
    @IBAction func showDetailSegue(segue: UIStoryboardSegue) { }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        let currentSliderValue = Int(sender.value)
        percentageLabel.text = String(currentSliderValue) + "%"
        
        let volumeRemaining = receivedObject!.netWt * Double(sender.value/100).roundToPlaces(1)
        label2.text = String(volumeRemaining)
        
    }
    
    @IBAction func saveChanges(sender: AnyObject) {
        try! database.write{
            receivedObject!.volumeRemaining = Double(label2.text!)!
        }
        performSegueWithIdentifier("unwindSegue", sender: nil)
        
    }
    
    @IBAction func trashIconTapped(sender: AnyObject) {
        let options = UIAlertController(title: nil, message: "Remove \(receivedObject!.name) from your rack?", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in self.trashAndUnwind()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in print("should Cancel")
        })
        
        options.addAction(deleteAction)
        options.addAction(cancelAction)
        
        self.presentViewController(options, animated: true, completion: nil)
    }
    
    
    // MARK: - My Functions
    
    func trashAndUnwind(){
        try! database.write({
            database.delete(receivedObject!)
        })
        performSegueWithIdentifier("unwindSegue", sender: nil)
    }
    
    
    
    // MARK: - Included
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = receivedObject!.name.capitalizedString
        label2.text = String(receivedObject!.volumeRemaining)
        
        //Update slider to reflect the volume left in the Spice.
        let percentageLeft = Float(receivedObject!.volumeRemaining / receivedObject!.netWt * 100)
        volumeSlider.value = percentageLeft
        percentageLabel.text = String(Int(percentageLeft)) + "%"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    
} // End of Class

