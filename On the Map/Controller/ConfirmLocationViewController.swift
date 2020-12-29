//
//  ConfirmLocationViewController.swift
//  On the Map
//
//  Created by John Fowler on 12/18/20.
//

//
//  MapViewController.swift
//  On the Map
//
//  Created by John Fowler on 12/16/20.
//


import UIKit
import MapKit
import CoreLocation

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmLocationButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    var currentUser: UserInfo? = nil

    var newLocation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
//        print("***ConfirmLocationViewController Coodinates****")
//        print(newLocation)
        handleUserLocation(newCoordinates: newLocation)
    }
    
    @IBAction func confirmLocationAction(_ sender: Any) {
        UdacityClient.postUserData(uniqueKey: userInfo.userID, firstName: userInfo.firstName, lastName: userInfo.lastName, mapString: userInfo.mapString, mediaURL: userInfo.mediaURL, latitude: userInfo.latitude, longitude: userInfo.longitude) { (success, error) in
            if success {
                print(userInfo.userID)
                print(success)
                self.navigationController?.dismiss(animated: true, completion: {
                    
                    return
                })
            } else {
                
                self.showPostFailure(message: "Please Try Again Later")
            }
        }
    }
    
    func showPostFailure(message: String) {
        
        let alertVC = UIAlertController(title: "Confirm Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //show(alertVC, sender: nil)
        
        UIApplication.topMostViewController?.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
        //self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation , reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .yellow
            //pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let toOpenURL = URL(string: toOpen)
                app.open(toOpenURL!, options: [:]) { (sucesss) in
                    return
                }  
            }
        }
    }
    
    func handleUserLocation(newCoordinates: MKAnnotation? ) {
        var pinLocation = [MKPointAnnotation]()
        //var pointAnnotation = MKPointAnnotation()
        if let newCoordinates = newCoordinates {
            let pointAnnotation = newCoordinates
            let coordinateRegion = MKCoordinateRegion(center: pointAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(coordinateRegion, animated: true)
            pinLocation.append(pointAnnotation as! MKPointAnnotation)
            self.mapView.addAnnotations(pinLocation)
        } else {
            print("***NO DATA FOR PINLOCATION")
            
        }
    }
}



