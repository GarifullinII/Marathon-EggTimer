//
//  ViewController.swift
//  EggTimer
//
//  Created by Ildar Garifullin on 05/06/2024.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    // MARK: - Property
    let eggTimes = ["SOFT": 300, "MEDIUM": 420, "HARD": 720]
    var totalTime = 0
    var secondsPassed = 0
    var timer = Timer()
    var player: AVAudioPlayer?
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "How do you like your eggs?"
        label.font = .robotoMedium24()
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let softEggButton: UIButton = {
        let button = UIButton()
        button.setTitle("SOFT", for: .normal)
        button.titleLabel?.font = .robotoMedium14()
        button.titleEdgeInsets = UIEdgeInsets(top: 20,
                                              left: -100,
                                              bottom: 0, right: 0
        )
        button.setImage(UIImage(named: "soft_egg"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mediumEggButton: UIButton = {
        let button = UIButton()
        button.setTitle("MEDIUM", for: .normal)
        button.titleLabel?.font = .robotoMedium14()
        button.titleEdgeInsets = UIEdgeInsets(top: 20,
                                              left: -100,
                                              bottom: 0, right: 0
        )
        button.setImage(UIImage(named: "medium_egg"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let hardEggButton: UIButton = {
        let button = UIButton()
        button.setTitle("HARD", for: .normal)
        button.titleLabel?.font = .robotoMedium14()
        button.titleEdgeInsets = UIEdgeInsets(top: 20,
                                              left: -100,
                                              bottom: 0, right: 0
        )
        button.setImage(UIImage(named: "hard_egg"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var buttonsStackView = UIStackView()
    
    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.progressTintColor = .white
        progress.trackTintColor = .black
        progress.progress = 0.0
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    // MARK: - Life cycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .cyan
        
        view.addSubview(mainLabel)
        
        buttonsStackView = UIStackView(
            arrangedSubviews: [
                softEggButton,
                mediumEggButton,
                hardEggButton,
            ],
            axis: .horizontal,
            spacing: 20)
        view.addSubview(buttonsStackView)
        
        view.addSubview(progressBar)
    }
    
    @objc private func  buttonTapped(_ sender: UIButton) {
        timer.invalidate()
        progressBar.progress = 0
        let hardness = sender.currentTitle!
        mainLabel.text = hardness
        secondsPassed = 0
        totalTime = eggTimes[hardness]!
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if (secondsPassed < totalTime) {
            secondsPassed += 1
            let percentageProgress = Float(secondsPassed) / Float(totalTime)
            progressBar.progress = percentageProgress
        } else {
            timer.invalidate()
            
            mainLabel.text = "DONE!!!"
            playSound(soundName: "alarm_sound")
        }
    }
    
    private func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - SetConstraints
extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            softEggButton.heightAnchor.constraint(equalToConstant: 130),
            softEggButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            mediumEggButton.heightAnchor.constraint(equalToConstant: 130),
            mediumEggButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            hardEggButton.heightAnchor.constraint(equalToConstant: 130),
            hardEggButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 40),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 6),
        ])
    }
}

