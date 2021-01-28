//
//  ViewController.swift
//  MusicPlayer
//
//  Created by lee on 2021/01/29.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    
    var timer: Timer!
    
    lazy var playPauseButton = { () -> UIButton in
        let view = UIButton()
        view.setImage(UIImage(named: "button_play")!, for: .normal)
        view.setImage(UIImage(named: "button_pause")!, for: .selected)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var timeLabel = { () -> UILabel in
        let view = UILabel()
        view.text = "00:00:00"
        view.textColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var progressSlider = { () -> UISlider in
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "MusicPlayer"
        self.view.backgroundColor = .white
        
        setupView()
        setConstraint()
    
        self.initializePlayer()
    }
    
    func initializePlayer() {
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 파일 에셋을 가져올 수 없습니다")
            return
        }

        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }

        self.progressSlider.minimumValue = 0
        self.progressSlider.maximumValue = Float(self.player.duration)
        self.progressSlider.value = Float(self.player.currentTime)
    }

    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)

        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)

        self.timeLabel.text = timeText
    }

    func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in

            if self.progressSlider.isTracking { return }

            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }

    func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    private func setupView() {
        self.view.addSubview(playPauseButton)
        self.view.addSubview(timeLabel)
        self.view.addSubview(progressSlider)
        
        playPauseButton.addTarget(self, action: #selector(tocuhPlayPause), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(slideValueChanged), for: .valueChanged)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            playPauseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 100),
            playPauseButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.playPauseButton.bottomAnchor, constant: 50),
            timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressSlider.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 50),
            progressSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressSlider.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            progressSlider.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func slideValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        
        guard sender.isTracking == false else { return }
        
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    @objc func tocuhPlayPause(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
            self.makeAndFireTimer()
        } else {
            self.player?.pause()
            self.invalidateTimer()
        }
    }
}

extension ViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error = error else {
            print("오디오 플레이어 디코드 오류 발생")
            return
        }
        
        let message = "오디오 플레이어 디코드 오류 발생 \(error.localizedDescription)"
        
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
}


#if DEBUG
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {/* no-op */}
    
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        ViewControllerRepresentable()
            .previewDisplayName("아이폰 12")
    }
}
#endif
