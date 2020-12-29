//
//  FindLocationController.swift
//  On the Map
//
//  Created by John Fowler on 12/18/20.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class FindLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var findLocationTextField: UITextField!
    @IBOutlet weak var addLinkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var placeMark = [CLPlacemark?]()
    var newCoordinates: MKPointAnnotation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.findLocationTextField.delegate = self
        self.addLinkTextField.delegate = self
        activityIndicator.isHidden = true
    }
    
  
    @IBAction func findLocationButtonTapped(_ sender: UIButton) {
        let location = findLocationTextField.text ?? ""
        setLcoationSearch(true)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [self] (data: [CLPlacemark]?, error: Error?) in
            if let data = data { //addLinkTextField.text != "" {
                //CLPlacemark array is successfully downloaded
                self.placeMark = data
                //                print("***CLPLACEMARK Data from GeoCoder****")
                //                print(self.placeMark)
                //Need to convert CLPlacemark to MKAnnotation
                if let newPlacemark = self.placeMark[0] {
                    setLcoationSearch(false)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newPlacemark.location!.coordinate
//                    annotation.title = "Your New Location"
//                    annotation.subtitle = addLinkTextField.text ?? ""
                    self.newCoordinates = annotation
//                    print("***MKANNotation from CLPlacemark****")
//                    print(self.newCoordinates!.coordinate)
                    userInfo.latitude = Float(self.newCoordinates!.coordinate.latitude)
                    userInfo.longitude = Float(self.newCoordinates!.coordinate.longitude)
                    userInfo.mediaURL = addLinkTextField.text ?? ""
                    self.performSegue(withIdentifier: "showDetail", sender: nil)
                    
                } else {
                    setLcoationSearch(false)
                    return
                }
                
            } else {
                if data == nil {
                    print("****LOCATION NOT FOUND***")
                    setLcoationSearch(false)
                    showDataFailure(message: "That Location Was Not Found, Please Try Again")
                } else if addLinkTextField.text == ""{
                    showDataFailure(message: "Please Enter Your URL")
                }
                
            }
            
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! ConfirmLocationViewController
            detailVC.newLocation = self.newCoordinates
            //            print("PREPARE FOR SEGUE NEW COORDINATES")
            //            print(self.newCoordinates)
        }
    }
    
    func geocodeAddressString(_ addressString: String,
                              completionHandler: @escaping ([CLPlacemark]?, Error?) -> Void) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == findLocationTextField) {
            textField.text = ""
        }
        else if (textField == addLinkTextField) {
            textField.text = ""
        }
    }
    
    func showDataFailure(message: String) {
        
        let alertVC = UIAlertController(title: "GeoCoding Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //show(alertVC, sender: nil)
        
        UIApplication.topMostViewController?.present(alertVC, animated: true, completion: nil)
        
    }
    
    // MARK: Activity Indicator
    
    func setLcoationSearch(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        findLocationTextField.isEnabled = !loggingIn
        addLinkTextField.isEnabled = !loggingIn
        findLocationButton.isEnabled = !loggingIn
        
    }
    
    
}


// MARK: UIApplication & UIViewController extensions

extension UIApplication {
    /// The top most view controller
    static var topMostViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.visibleViewController
    }
}

extension UIViewController {
    /// The visible view controller from a given view controller
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
}


