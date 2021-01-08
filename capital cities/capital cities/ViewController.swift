//
//  ViewController.swift
//  capital cities
//
//  Created by Arsalan Wahid Asghar on 09/01/2021.
//

import Cocoa
import MapKit

class ViewController: NSViewController {
    
    
    @IBOutlet var questionLabel: NSTextField!
    @IBOutlet var scoreLabel: NSTextField!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

