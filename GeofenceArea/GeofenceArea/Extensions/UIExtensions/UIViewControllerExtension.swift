//
//  UIViewControllerExtension.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String,
                   message: String,
                   possitiveTitle: String,
                   possitiveAction: ((UIAlertAction) -> Void)?,
                   negativeTitle: String? = nil,
                   negativeAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: possitiveTitle, style: .default, handler: possitiveAction)
        if negativeTitle != nil {
            let cancelAction = UIAlertAction(title: negativeTitle, style: UIAlertAction.Style.cancel, handler: negativeAction)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func presentAlert(title: String = "", message: String, actionTitle: String = "OK", actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel, handler: actionHandler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
