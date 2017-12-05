//
//  RegisterViewController.swift
//  NOTES-EcommerceApp
//
//  Created by Shane Bersiek on 11/9/17.
//  Copyright © 2017 saif. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    //MARK: -properties
    
    var phoneNumber: String?
    
    //MARK: -outlets
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var codeTxtField: UITextField!
    @IBOutlet weak var requestButtonOutlet: UIButton!
    
    //email registration
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    //Dismiss key board
    //Calls this function when the tap is recognized.
  @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: IBAction
    @IBAction func requestButtonPressed(_ sender: Any) {
        
        if phoneNumberTxtField.text != "" {
            
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTxtField.text!, uiDelegate: nil, completion: { (verificationID, error) in
               
                if error != nil {
                    print("error phone number \(String(describing: error?.localizedDescription))")
                    return
                }
                
                self.phoneNumber = self.phoneNumberTxtField.text!
                self.phoneNumberTxtField.text = ""
                self.phoneNumberTxtField.placeholder = self.phoneNumber!
                self.phoneNumberTxtField.isEnabled = false
                
                //reveals the code txtfield and changes the title txt
                self.codeTxtField.isHidden = false
                self.requestButtonOutlet.setTitle("register", for: .normal)
                
                
                UserDefaults.standard.set(verificationID, forKey: kVERIFICATIONCODE)
            })
            
            //checks the codetxt field to se if it has text
            if codeTxtField.text != "" {
                
                FUser.registerUserWith(phoneNumber: phoneNumber!, verificationCode: codeTxtField.text!, completion: { (error, shouldLogIn) in
                    
                    if error != nil {
                        print("error: \(String(describing: error?.localizedDescription))")
                    }
                    
                    if shouldLogIn {
                        
                        //go to main view
                        print("go to main view")
                        
                    } else {
                        
                        //go to finish register
                        print("go to finish register")
                        
                    }
                    
                    
                    
                })
            }
        }
        
    }
    
    @IBAction func emailRegisterButtonPressed(_ sender: Any) {
        
        if emailTxtField.text != String() && nameTxtField.text != String(), lastNameTxtField.text != String(), passwordTxtField.text != String() {
            
            FUser.registerUserWith(email: emailTxtField.text!, password: passwordTxtField.text!, firstName: nameTxtField.text!, lastName: lastNameTxtField.text!, completion: { (error) in
                
                if error != nil {
                    print("Error registering user with email: \(String(describing: error?.localizedDescription))")
                }
                
                self.gotToAppMainVC()
                
            })
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        gotToAppMainVC()
    }
    
    //MARK: -helper functions
    
    ///goes to my tab-bar-controler
    func gotToAppMainVC(){
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
