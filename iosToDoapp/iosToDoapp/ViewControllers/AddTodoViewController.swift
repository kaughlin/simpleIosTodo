//
//  AddTodoViewController.swift
//  iosToDoapp
//
//  Created by Kaughlin Caver on 12/14/18.
//  Copyright © 2018 Kaughlin Caver. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    //MARK: - Properties

    var managedContext: NSManagedObjectContext!
    
    //MARK: -Outlets

    @IBOutlet weak var inputTextview: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        inputTextview.becomeFirstResponder()
    }
    
    //MARK: Actions
    
    @objc func keyboardWillShow(with notification: Notification){
        
        let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight
        
        //animate it
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        //dismmiss view
        dismiss(animated: true)
        inputTextview.resignFirstResponder()
    }
    @IBAction func done(_ sender: UIButton) {
        guard let title = inputTextview.text, !title.isEmpty else {
            //Todo add alert to let user know can not save empty todos
            return
        }
        let todo = Todo(context: managedContext)
        todo.title = title
        todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        todo.date = Date()
        
        //now save todo
        do {
            try managedContext.save()
            dismiss(animated: true)
            inputTextview.resignFirstResponder()
        } catch {
            print("Error saving todo: \(error)")
        }
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
extension AddTodoViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden{
            textView.text.removeAll()
            textView.textColor = .white
            
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
           
        }
    }
}
