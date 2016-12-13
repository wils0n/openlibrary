//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Wilson Mejía on 9/12/16.
//  Copyright © 2016 NinjaLABS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mySearchBar: UISearchBar!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.resultTextView.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        NSLog("Search button tapped")
        consultaAsincronica(isbn:mySearchBar.text!)
    }

    
    
    func consultaAsincronica(isbn:String){
        //let config = URLSessionConfiguration.default // Session Configuration
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let url = URL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"+isbn)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "problemas de conexion", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            } else {
                
                do {
                    
                    DispatchQueue.main.async {
                        let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        self.resultTextView.text = datastring as String!
                    }
                    
                } catch {
                    print("error in JSONSerialization")
                }
                
            }
            
        })
        task.resume()
    }

    @IBAction func limpiarSearch(_ sender: Any) {
        self.mySearchBar.text = ""
    }
    
    
}

