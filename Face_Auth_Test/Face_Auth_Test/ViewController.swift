//
//  ViewController.swift
//  Face_Auth_Test
//
//  Created by 임재현 on 2023/06/25.
//

import UIKit
import LocalAuthentication

final class BioAuthViewController: UIViewController {
    private lazy var authButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "Auth"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemGreen
        button.configuration = config
        button.addTarget(self, action: #selector(didTapAuth), for: .touchUpInside)
        return button
    }()
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Not Authenticated yet"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        authButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        authButton.center = view.center
        resultLabel.frame = CGRect(x: 0, y: authButton.frame.origin.y - 100, width: view.frame.size.width, height: 100)
    }

    private func setUI() {
        title = "Bio Auth"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(authButton)
        view.addSubview(resultLabel)
        view.backgroundColor = .systemBackground
    }

    @objc private func didTapAuth() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize with your Bio-ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                guard
                    success,
                    error == nil else {
                    self?.showAlert(title: "Failed to Authenticate", message: "Please try again")
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.resultLabel.text = "Authentication Passed"
                }
            }
        } else {
            showAlert(title: "Unavaiable", message: "You cannot use this service")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }

}


//class BioAuthViewController:UIViewController {
//   
//    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.alignment = .center  // This will apply to the second line only
//
//    let attributedText = NSMutableAttributedString(string: "First line of text\n", attributes: [.paragraphStyle: paragraphStyle])
//    attributedText.append(NSAttributedString(string: "Second line of text", attributes: [.paragraphStyle: paragraphStyle]))
//
//    let label = UILabel()
//    label.numberOfLines = 0
//    label.attributedText = attributedText
//   
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        
//    }
//    
//    
//    
//}
