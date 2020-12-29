//
//  MapViewController.swift
//  On the Map
//
//  Created by John Fowler on 12/16/20.
//


import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reloadData: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    //var locations: StudentData
    var annotations = [MKPointAnnotation]()
    
    @IBAction func reloadData(_ sender: Any) {
        handleStudentData()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UdacityClient.deleteSession { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleStudentData()
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation , reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .yellow
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
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
                if canOpenURL(toOpen) {
                    print("valid url.")
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                } else {
                    print("invalid url.")
                    print(view.annotation?.subtitle! ?? "The URL is nil")
                    return
                }
            }
        }
    }
    
    
    
    // MARK: - Handle Student Data
    
    // This helper function handles the downloaded Student Data and assigns it to point annotations on the map
    
    
    func handleStudentData() {
        self.annotations = []
        mapView.removeAnnotations(mapView.annotations)
        UdacityClient.getStudentData() { (data: StudentData?, error: Error?) in
            if let error = error {
                let networkError = LoginErrorResponse (status: 99, error: "The Network Is Down")
                DispatchQueue.main.async {
                    self.showFailure(message: "The Network is Down")
                }
                return
            } else if data != nil {
                for student in data!.results {
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(student.latitude), CLLocationDegrees(student.longitude))
                    pointAnnotation.title = "\(student.firstName) \(student.lastName)"
                    pointAnnotation.subtitle = "\(student.mediaURL)"
                    self.annotations.append(pointAnnotation)
                }
                self.mapView.addAnnotations(self.annotations)
            } else {
                self.showFailure(message: "The Data Isn't Loading, Please Try Again Later")
            }
        }
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Refresh Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    //Check if Student has listed a valid URL
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
              let url = URL(string: urlString)
        else { return false }
        
        if !UIApplication.shared.canOpenURL(url) { return false }
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    
    
}
