//
//  MapViewController.swift
//  AllTrails
//
//  Created by Jose Alvarez on 11/15/21.
//

import UIKit

final class MapViewComposer {
    private init() {}
    
    static func compose() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        return storyboard.instantiateViewController(identifier: "MapViewController") as MapViewController
    }
}

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
