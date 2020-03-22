//
//  ViewController.swift
//  Instagrid
//
//  Created by Sergio Canto  on 28/01/2020.
//  Copyright © 2020 Sergio Canto . All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - OUTLETS

    @IBOutlet private var layoutButtons: [UIButton]!
    @IBOutlet private weak var topRightGridButton: UIButton!
    @IBOutlet private weak var bottomRightGridButton: UIButton!
    @IBOutlet private var gridButtons: [UIButton]!
    @IBOutlet private weak var gridCentralView: UIView!

    // MARK: - PROPERTIES

    private let imagePickerController = UIImagePickerController()
    private var tag = 0
    private var swipeGesture: UISwipeGestureRecognizer?

    // MARK: - VIEW LIFE CYCLE

    //This method give the first action view when the app is run
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dragGridCentral(swipe:)))
        guard let swipeGesture = swipeGesture else {return}
        gridCentralView.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwipeDirection),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - ACTIONS

    // This method add photo from the Photo Library
    @IBAction private func addPhoto(_ sender: UIButton) {
        tag = sender.tag
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }

    // This method chose layout grid with the button tapped
    @IBAction private func layoutButtonTapped(_ sender: UIButton) {
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

    // MARK: - METHODS

    // this methods animate the swipe to Up or to Left
    @objc
    private func dragGridCentral(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridCentralView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.gridCentralView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            })
        }
        shareSwipeView()
    }

    // if the phone is in portrait we change the direction of the swipe to point it up
    // if not we put the direction of the swipe on point left
    @objc
    private func handleSwipeDirection() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGesture?.direction = .left
        } else {
            swipeGesture?.direction = .up
        }
    }

    // This method Swipe View to Share
    private func shareSwipeView() {
        let activityVC = UIActivityViewController(activityItems: [gridCentralView.image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 2) {
                self.gridCentralView.transform = .identity
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

// This extension call the controllers Navigation and Picker Delegate
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            gridButtons[tag].setImage(image, for: .normal)
            gridButtons[tag].layoutIfNeeded()
            gridButtons[tag].subviews.first?.contentMode = .scaleAspectFill
        }
        dismiss(animated: true)
    }
}
