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

        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(mapClicked))
        mapView.addGestureRecognizer(recognizer)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let guess = Pin(title: "Your Guess", coordinate: coordinate, color: .red)
        mapView.addAnnotation(guess)
    }
    
    @objc func mapClicked(_ sender: NSClickGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        addPin(at: coordinates)
    }
}

