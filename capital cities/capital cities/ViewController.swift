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
        mapView.mapType = .satellite
        mapView.addGestureRecognizer(recognizer)
        startNewGame()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addPin(at coordinate: CLLocationCoordinate2D) {
        // check if city exists
        guard let actual = currenCity else { return }
        
        let guess = Pin(title: "Your Guess", coordinate: coordinate, color: .red)
        //Add the guess pin on the map
        mapView.addAnnotation(guess)
        //add the actual pin on the map
        mapView.addAnnotation(actual)
        
        //convert pins location to map points for calculation
        let point1 = MKMapPoint(guess.coordinate)
        let point2 = MKMapPoint(actual.coordinate)
        
        //Calculate how far the distance of points were means 10km diff
        let distance = Int(max(0, 500 - point1.distance(to: point2) / 1000))
        
        //Add the score that will trigger the property observer
        score += distance
        
        actual.subtitle = "You scored: \(distance)"
        mapView.selectAnnotation(actual, animated: true)
    }
    
    @objc func mapClicked(_ recognizer: NSClickGestureRecognizer) {
        if mapView.annotations.count == 0 {
            addPin(at: mapView.convert(recognizer.location(in: mapView), toCoordinateFrom: mapView))
        }else {
            nextCity()
        }
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
        cities.append(Pin(title: "Istanbul", coordinate: CLLocationCoordinate2D(latitude:  41.015137, longitude: 28.979530)))
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


// add string functionality to convert numbers to string represrntation
extension String.StringInterpolation {
    mutating func appendInterpolation(format  value: Int){
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        if let result = formatter.string(from: value as NSNumber){
            appendLiteral(result)
        }
    }
}
