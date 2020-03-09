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
    @IBOutlet weak var gridCentralView: UIView!
    
    
    let imagePickerController = UIImagePickerController()
    var tag = 0
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var swipeGesture: UISwipeGestureRecognizer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dragGridCentral(swipe:)))
        guard let swipeGesture = swipeGesture else{return}
        gridCentralView.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func dragGridCentral(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridCentralView.transform = CGAffineTransform(translationX: 0, y: -self.screenHeight)
            })
            
            print("je swipe vers le haut")
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridCentralView.transform = CGAffineTransform(translationX: -self.screenWidth, y: 0)
            })
            
            print("je swipe vers la gauche")
        }
        shareSwipeView()
    }
    
    // si le telephone est en portrait on change la direction du swipe pour le mettre en point up haut
    // si non on met le drirection du swipe sur point left
    @objc func handleSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            print("left")
            swipeGesture?.direction = .left
        }else {
            print("up")
            swipeGesture?.direction = .up
           
        }
    }
    
    func shareSwipeView() {
        print(gridCentralView.image)
        let activityVC = UIActivityViewController(activityItems: [gridCentralView.image], applicationActivities: nil)
       // activityVC.popoverPresentationController?.sourceView = gridCentral
        present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 2) {
                self.gridCentralView.transform = .identity
            }
        }
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
            gridButtons[tag].layoutIfNeeded()
            gridButtons[tag].subviews.first?.contentMode = .scaleAspectFill
        }
        dismiss(animated: true)
    }
}










