//
//  ViewController.swift
//  On the Map
//
//  Created by John Fowler on 12/15/20.
//

import UIKit

//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator:
        UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observe access token changes
        // This will trigger after successful login / logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Print out access token
            //print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
            if AccessToken.current?.tokenString != nil {
                self.setLoggingIn(false)
                //self.performSegue(withIdentifier: "completeLogin", sender: nil)
            } else {
                self.setLoggingIn(false)
                self.showLoginFailure(message: "Try Another Login Method")
            }
        }
    }
    
    

    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (success, error) in
            if success?.account.key != nil {
                self.setLoggingIn(false)
                UdacityClient.getUserData { (success, error) in
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                } } else if AccessToken.current?.tokenString != nil {
                        self.performSegue(withIdentifier: "completeLogin", sender: nil)
                    self.setLoggingIn(false)
                        return
                    }
                    else {
                self.setLoggingIn(false)
                let errorResponse = error!.error
                self.showLoginFailure(message: errorResponse)
            }
        }
    }

    
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let url = URL(string: "https://auth.udacity.com/sign-up")
        UIApplication.shared.open(url!)
    }
    
    func showLoginFailure(message: String) {
        setLoggingIn(false)
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    
}

