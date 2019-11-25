//
//  OnboardingViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 25/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class OnboardingViewController: UIViewController {

    // MARK: - Variable.
    
    /// Database
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var people: [People] = []
    
    // MARK: - IBOutlet list
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginBtn(_ sender: UIButton) {
        checkForm()
        //let vc: UIViewController = UIStoryboard(name: "Report", bundle: nil).instantiateViewController(withIdentifier: "reportViewController") as! reportViewController
        
        /*let vc: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard")
        
        let appDelegate = UIApplication.shared.windows
        appDelegate.first?.rootViewController = vc
        self.present(vc, animated: true, completion: nil)*/
        
        
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        //performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    // MARK: - obj function untuk nampilin data Query Database
    @objc func QueryDatabase(){
        let query = CKQuery(recordType: "Profile", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else { return }
            //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
            self.data = record
            self.initDataModel()
            for i in self.people{
                print(i.username)
                print(i.password)
           }
            print("Total Employee dalam database : \(self.data.count)")
        }
        
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
       
        errorLbl.isHidden = true
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.QueryDatabase()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Init data model
    func initDataModel() {
        people.removeAll()
        for countData in data {
            let username = countData.value(forKey: "UserName") as! String
            let password = countData.value(forKey: "Password") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let lastName = countData.value(forKey: "lastName") as! String
            let phone = countData.value(forKey: "phoneNumber") as! String
            
            people.append(People(username: username, password: password, firstName: firstName, lastName: lastName, phone: phone))
        }
    }
    
    // MARK: - Function
    func checkForm() {
        if usernameTextField.text == "" && passwordTextField.text == "" {
            print("KOSONG ANJENG")
            errorLbl.text = "Username dan password harus diisi"
            errorLbl.isHidden = false
        } else if usernameTextField.text == "" {
            print("KOSONG ANJENG")
            errorLbl.text = "Username harus diisi"
            errorLbl.isHidden = false
        } else if passwordTextField.text == "" {
            print("KOSONG ANJENG")
            errorLbl.text = "Password harus diisi"
            errorLbl.isHidden = false
        } else {
            var cek = false
            for i in people{
                if i.username == usernameTextField.text, i.password == passwordTextField.text{
                    cek = true
                    break
                }
            }
            
            if cek == true{
                performSegue(withIdentifier: "toChooseRole", sender: nil)
            }else{
                 presentAlert(withTitle: "Login Gagal", message: "UserName atau Password salahb")
            }
            print(String(usernameTextField.text!))
            print(String(passwordTextField.text!))
            errorLbl.isHidden = true
            
        }
    }

}
