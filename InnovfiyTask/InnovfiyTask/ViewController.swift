//
//  ViewController.swift
//  Innovfiy Task
//
//  Created by Henit Nathwani on 24/03/18.
//  Copyright © 2018 Henit Nathwani. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    //MARK: VARIABLES
    var locationManager:CLLocationManager = CLLocationManager()
    var lastLocation:CLLocation?
    var lastSpeedInKm:CLLocationSpeed = -1
    var lastSpeedType:Speed = .none

    //MARK: OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // CONFIGURE LOCATION MANAGER
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: SWITCH EVENT
    @IBAction func locationSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.locationManager.requestLocation()
        }else{
            NSObject.cancelPreviousPerformRequests(withTarget: self.locationManager)
        }
    }
    
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> Void{
        if let lastLocation = locations.last{
            
            
            // GET CURRENT SPEED AT TIME OF LAST LOCATION
            let currentSpeedInKm = lastLocation.speed * 3.6
            let currentSpeedType:Speed = Speed.getSpeedType(ForSpeed: currentSpeedInKm)
            var calculatedSpeedType:Speed = currentSpeedType
            
            // CHANGE IN TIME INTERVAL
            if self.lastSpeedType != .none && self.lastSpeedType != currentSpeedType{
                if self.lastSpeedType.rawValue < currentSpeedType.rawValue{
                    if let newSpeedType = Speed(rawValue: lastSpeedType.rawValue + 1){
                        calculatedSpeedType = newSpeedType
                    }
                }else{
                    if let newSpeedType = Speed(rawValue: lastSpeedType.rawValue - 1){
                        calculatedSpeedType = newSpeedType
                    }
                }
            }
            
            // STORE IN LOCAL DB
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                appDelegate.addNewTrackInfo(WithLocation: lastLocation.coordinate, currentTimeInterval: self.lastSpeedType.getIntervalInSeconds(), nextTimeInterval: calculatedSpeedType.getIntervalInSeconds())
            }
            
            // UPDATE LAST SPPED
            self.lastSpeedType = calculatedSpeedType
            self.lastSpeedInKm = currentSpeedInKm
            
            // SCHEDULE NEXT CALL
            self.locationManager.perform(#selector(CLLocationManager.requestLocation), with: nil, afterDelay: calculatedSpeedType.getIntervalInSeconds())
            
            print("\n-----Current Speed : \(lastLocation.speed * 3.6) KM/H")
            print("Current Time : \(Date())")
            print("Next location scheduled after \(calculatedSpeedType.getIntervalInSeconds()) seconds at \(Date().addingTimeInterval(calculatedSpeedType.getIntervalInSeconds()))-----\n")
            
            self.mapView.setRegion(MKCoordinateRegion.init(center: lastLocation.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        }else{
            // RETRY AFTER 30 SEC IF LOCATION IS NOT AVAILABLE
            self.locationManager.perform(#selector(CLLocationManager.requestLocation), with: nil, afterDelay: 30)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        
    }

}

