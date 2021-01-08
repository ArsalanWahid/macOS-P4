//
//  ViewController.swift
//  capital cities
//
//  Created by Arsalan Wahid Asghar on 09/01/2021.
//

import Cocoa
import MapKit

class ViewController: NSViewController, MKMapViewDelegate {
    
    
    @IBOutlet var questionLabel: NSTextField!
    @IBOutlet var scoreLabel: NSTextField!
    @IBOutlet var mapView: MKMapView!
    
    var cities = [Pin]()
    var currenCity: Pin?
    
    var score = 0 {
        didSet {
            scoreLabel.stringValue = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(mapClicked))
        mapView.addGestureRecognizer(recognizer)
        startNewGame()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Convert the annotaion as pin so we can change the color
        guard let pin = annotation as? Pin else { return nil}
        
        //Create a string identifier that will be used to share map pins
        let identifier = "Guess"
        
        // Attempt to dequeue a pin from the re-use queue
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            // There as no pin to re-use so make a new one
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }else {
            //Use got a pin back to re-use to update its annotation to new annotation
            annotationView?.annotation = annotation
        }
        
        //Customize pin so it has a call out and color
        annotationView?.canShowCallout = true
        annotationView?.pinTintColor = pin.color
        return annotationView
    }
    
    
    func startNewGame() {
        score = 0
        cities.append(Pin(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)))
        cities.append(Pin(title: "Karachi", coordinate: CLLocationCoordinate2D(latitude: 24.860966, longitude: 66.990501)))
        cities.append(Pin(title: "Lahore", coordinate: CLLocationCoordinate2D(latitude: 31.582045, longitude: 74.329376)))
        cities.append(Pin(title: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.652832, longitude: 139.839478)))
        cities.append(Pin(title: "Beijing", coordinate: CLLocationCoordinate2D(latitude: 39.916668, longitude: 116.383331)))
        cities.append(Pin(title: "Bangkok", coordinate: CLLocationCoordinate2D(latitude: 13.736717, longitude: 100.523186)))
        cities.append(Pin(title: "London", coordinate: CLLocationCoordinate2D(latitude:  41.015137, longitude: 28.979530)))
        nextCity()
    }
    
    func nextCity() {
        if let city = cities.popLast() {
            currenCity = city
            questionLabel.stringValue = "Where is \(city.title!)"
        }else {
            currenCity = nil
            let alert = NSAlert()
            alert.messageText = "Final score: \(score)"
            alert.runModal()
            startNewGame()
        }
    }
}

