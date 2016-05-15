//
//  ViewController.swift
//  MapsRuta
//
//  Created by Alejandro Veiga López on 15/5/16.
//  Copyright © 2016 Alejandro Veiga López. All rights reserved.
//

import UIKit

import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var TipoMapaSegmentControl: UISegmentedControl!
    @IBOutlet weak var MapaMapView: MKMapView!
    
    @IBOutlet weak var TrackingSwitch: UISwitch!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 500
    var dist : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Localizacion
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        
        // Empezar Updates
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        // Maps
        MapaMapView.delegate = self
        MapaMapView.mapType = MKMapType.Standard
        MapaMapView.setUserTrackingMode(.FollowWithHeading, animated: true)
        MapaMapView.centerCoordinate = MapaMapView.userLocation.coordinate
        MapaMapView.showsUserLocation = true
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, regionRadius, regionRadius)
        MapaMapView.setRegion(coordinateRegion, animated: true)
        
        // Otros
        TipoMapaSegmentControl.selectedSegmentIndex = 0
        //TrackingSwitch.on = false
        
        // Para Updates
        //locationManager.stopUpdatingLocation()
        //locationManager.stopUpdatingHeading()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func TipoSatAcction(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            MapaMapView.mapType = MKMapType.Standard
            
        }
        else if sender.selectedSegmentIndex == 1 {
            
            MapaMapView.mapType = MKMapType.Satellite
            
        }
        else if sender.selectedSegmentIndex == 2 {
            
            MapaMapView.mapType = MKMapType.Hybrid
            
        }
        
        
    }
    
    @IBAction func TrackingAction(sender: UISwitch) {
    
        if sender.on {
            
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            dist = 0
            
        }
        else {
            
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
            MapaMapView.removeAnnotations(MapaMapView.annotations)
            dist = 0
            
        }
        
    }
    
// MARK: - Location
    
    // Cuando se cambia la autorizacion
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        MapaMapView.showsUserLocation = (status == .AuthorizedAlways)
        
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        
        }
        else {
            
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
            
        }
        
    }
    
    // Cada vez que hay datos nuevos de coordenadas
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Actualizado")
        
        MapaMapView.setCenterCoordinate((manager.location?.coordinate)!, animated: true)

        if TrackingSwitch.on {
            
            let punto : CLLocationCoordinate2D = (manager.location?.coordinate)!
            let anotacion : MKPointAnnotation = MKPointAnnotation()
            anotacion.coordinate = punto
            anotacion.title = "Lat: \(punto.latitude), Log: \(punto.longitude)"
            anotacion.subtitle = "\(dist)m"
            MapaMapView.addAnnotation(anotacion)
            dist += 50
            
        }
        else {
            
            MapaMapView.removeAnnotations(MapaMapView.annotations)
            
        }
        
    }
    
    // Error en la localizacion
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alerta = UIAlertController(title: "Error", message: "error: \(error.code)", preferredStyle: .Alert)
        let accionOk = UIAlertAction(title: "Ok", style: .Default, handler: { accion in
            // ... Tratar error
        
        })
        
        alerta.addAction(accionOk)
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }

// MARK: - Maps
    
    func mapView(mapView: MKMapView!, didUpdateUserLocationuserLocation: MKUserLocation!) {
        
        MapaMapView.centerCoordinate = MapaMapView.userLocation.location!.coordinate
        
    }
    
// MARK: - Brujula
    
    // Cada vez que hay datos nuevos de brujula
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
}

