//
//  ViewController.swift
//  Instagrid
//
//  Created by Sergio Canto  on 28/01/2020.
//  Copyright © 2020 Sergio Canto . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var topRightGridButton: UIButton!
    @IBOutlet weak var bottomRightGridButton: UIButton!
    @IBOutlet var gridButtons: [UIButton]!
    @IBOutlet weak var gridCentral: UIView!
    
    
    let imagePickerController = UIImagePickerController()
    var tag = 0
    var screenWidth = UIScreen.main.bounds.height
    let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(dragGridCentral(swipe:)))
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(dragGridCentral(swipe:)))
        swipeUpGesture.direction = .up
        view.addGestureRecognizer(swipeUpGesture)
        

    }
    
    
    @objc private func dragGridCentral(swipe: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridCentral.transform = CGAffineTransform(translationX: 0, y: -self.screenWidth)
        }) { _ in
            print("l'animation est términée")
            UIView.animate(withDuration: 2) {
               self.gridCentral.transform = .identity
            }
        }
       
    }
    
    func handleSwipeDirection() {
        let myDevice = UIDevice.current.orientation
        if myDevice.isPortrait {
            swipeUpGesture.direction = .up
            print("Portrait")
        } else if myDevice.isLandscape{
            swipeUpGesture.direction = .left
            print("LandScape")
        }
        // si le telephone est en portrait on change la direction du swipe pour le mettre en point up haut
        // si non on met le drirection du swipe sur point left
    }
    
    
    
    @IBAction func addPhoto(_ sender: UIButton) {
        tag = sender.tag
                    imagePickerController.sourceType = .photoLibrary
                    present(imagePickerController, animated: true)
    }
    
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        layoutButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        switch sender.tag {
        case 0:
            topRightGridButton.isHidden = true
            bottomRightGridButton.isHidden = false
        case 1:
            topRightGridButton.isHidden = false
            bottomRightGridButton.isHidden = true
        case 2:
            topRightGridButton.isHidden = false
            bottomRightGridButton.isHidden = false
        default:
            break
        }
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            gridButtons[tag].setImage(image, for: .normal)
        }
        dismiss(animated: true)
    }
}
