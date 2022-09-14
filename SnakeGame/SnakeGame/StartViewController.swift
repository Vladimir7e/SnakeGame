//
//  StartViewController.swift
//  SnakeGame
//
//  Created by Developer on 31.08.2022.
//

import UIKit

class StartViewController: UIViewController {
    
    private var playButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        
    }
    
    private func setupUIElements() {
        view.backgroundColor = .systemGray
        view.addSubview(playButton)
        
        playButton.setTitle("PLAY", for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        playButton.setTitleColor(.black, for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func didTapPlayButton() {
        let playVC: UIViewController = PlayViewController()
        playVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(playVC, animated: false, completion: nil)
    }
    
}
