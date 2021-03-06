//
//  LabelDetailViewController.swift
//  IssueTracker
//
//  Created by 양어진 on 2020/11/02.
//  Copyright © 2020 양어진. All rights reserved.
//

import UIKit

final class LabelDetailViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var colorTextField: UITextField!
    @IBOutlet private weak var colorSampleView: UIView!
    
    // MARK: - Properties
    
    var label: Label?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEditMode()
        configureTextField()
        configureGestureRecognizer()
    }
    
    // MARK: - IBAction
    
    @IBAction private func colorRandomButtonDidTap(_ sender: UIButton) {
        let color = UIColor().random
        colorSampleView.backgroundColor = color
        colorTextField.text = color.toHexString()
    }
    
    @IBAction private func saveButtonDidTap(_ sender: UIButton) {
        let name = titleTextField.text
        let description = descriptionTextField.text
        let color = colorTextField.text
        guard let labelID = label?.id else { return }
        
        let label = Label(id: labelID, name: name, description: description, color: color)
        LabelService.shared.updateLabel(label: label) { [weak self] in
            NotificationCenter.default.post(Notification(name: .labelDidUpdate,
                                                         object: label,
                                                         userInfo: nil))
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction private func deleteButtonDidTap(_ sender: UIButton) {
        guard let labelID = label?.id else { return }
        LabelService.shared.deleteLabel(id: labelID) { [weak self] in
            NotificationCenter.default.post(Notification(name: .labelDidDelete,
                                                         object: nil,
                                                         userInfo: ["id": labelID]))
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Methods
    
    private func configureEditMode() {
        self.navigationItem.title = "레이블 편집"
        guard let label = label, let color = label.color else { return }
        titleTextField.text = label.name
        descriptionTextField.text = label.description
        colorTextField.text = label.color
        colorSampleView.backgroundColor = UIColor(hex: color)
    }
    
    private func configureTextField() {
        colorTextField.addTarget(self,
                                 action: #selector(textFieldDidChange(_:)),
                                 for: .editingChanged)
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Objc
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let color = colorTextField.text else { return }
        colorSampleView.backgroundColor = UIColor(hex: color)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
