//
//  VideoPlayerViewController.swift
//  MtsHackNew-tvOS
//
//  Created by  Даниил on 29.03.2023.
//

import UIKit
import AVFoundation
import SnapKit
import AVKit

class VideoPlayerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserverToken: Any?
    private var commentIndex = 0
    private var comments: [Comment] = []
    private var lastComment: Comment?
    private var synthesizer: AVSpeechSynthesizer?
    private var isSpeaking = false
    
    private let videoFileName = "ВоВсеЖвачные"
    private let videoExtension = "mp4"
    
    private let commentsString =
    """
    4 - 6 Мальчик в рубашке идет по полю и достает розовый пистолет
    7 - 9 Мальчик в рубашке и желтых шортах смотрит на поле
    9 - 10 Мальчик целится из пистолета
    14 - 16 Мальчик держит рекламную табличку автомойки
    25 - 26 Взрослый мужчина врач показан крупным планом
    33 - 39 Грустный мальчик заходит в класс и видит девочку блондинку
    52 - 54 Скайлер сидит возле своего дома
    57 - 59 Хэнк  открывает школьный шкафчик и сыпятся конфеты
    68 - 69 Мальчик в красной кофте оглядывается
    71 - 73 Уолтер замечает второго
    100 - 102 Черная машина в поле
    103 - 124 Мальчики смешивают разные виды сахара и конфет в стаканах, заливают смесь газировкой , а после этого начинают варить смесь, а после мальчик в красной кофте перебирает готовый продукт синего цвета
    137 - 139 Уолтер выглядит уставшим
    140 - 159 Серия кадров где мальчик в красной кофте передает жвачку синего цвета и конфеты ученикам, в стенах школы, а после следует разговор в поле
    171 - 188 Уолтер бреет свою голову, берет клей и клочок волос
    191 - 199 Мальчик в шапке кидает синий пакетик мальчику в гавайской рубашке, он пробует конфеты с ножа
    205 - 207 Мальчик втыкает нож в стол
    210 - 212 Уолтер появляется с усами и бородой
    213 - 214 диалог Уолта и Хэнка
    254 - 256 Уолтер встречается с темнокожим мальчиком
    259 - 266 Уолтер и Второй мальчик в желтых костюмах идут к спрятанной лаборатории
    272 - 274 Уолтер в красной футболке оборачивается на Скайлер
    308 - 309 Гас ест шоколадный пистолет
    316 - 318 Уолтер показывает синие жвачки
    320 - 328 Хэнк везет на велосипеде мальчика инвалида в шляпе, который общается звонками
    333 - 340 Мальчик надувает жвачку, Гас вскакивает и начинает кричать, звук хлопка
    342 - 358 Камера мерцает, гас выходит из комнаты, половина его лица и туловища в жвачке, он поправляет галстук и падает
    360 - 361  Шестеро человек в поле
    376 - 386 Неловкое молчание, Все ждут от мальчика в красной кофте чего то
    """
    
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load video player
        var videoURL = Bundle.main.url(forResource: videoFileName, withExtension: videoExtension) ?? URL(string: "http://91.185.84.113/breaking_gum.mp4")
        
        
        
        let playerItem = AVPlayerItem(url: videoURL!)
        playerItem.preferredForwardBufferDuration = 5
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer!)
        playerLayer?.frame = view.bounds
        
        // Load comments
        comments = parseComments(commentsString)
        
        // Add time observer
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] time in
            self?.checkComment(time)
        })
        
        // Initialize speech synthesizer
        synthesizer = AVSpeechSynthesizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
    
    
    // MARK: - Helper Methods
    private func parseComments(_ commentsString: String) -> [Comment] {
        var comments: [Comment] = []
        
        let commentComponents = commentsString.components(separatedBy: .newlines)
        for commentComponent in commentComponents {
            let components = commentComponent.components(separatedBy: .whitespaces)
            guard components.count >= 4,
                  let startTimeString = Optional(components[0]),
                  let endTimeString = Optional(components[2]),
                  let startTime = TimeInterval(startTimeString),
                  let endTime = TimeInterval(endTimeString) else {
                continue
            }
            
            let text = components.dropFirst(3).joined(separator: " ")
            let comment = Comment(startTime: startTime, endTime: endTime, text: text)
            comments.append(comment)
        }
        comments.forEach({print("#ENDTIME", $0.endTime)})
        return comments
    }
    var maxSpeechRate: Float = 0.55
    
    private func checkComment(_ time: CMTime) {
        let currentSecond = time.seconds
        if let currentComment = comments.first(where: { $0.startTime <= currentSecond && $0.endTime > currentSecond && !$0.isPlayed }),
           currentComment != lastComment, !currentComment.isPlayed {
            print("#SECOND", currentSecond)
            
            // Mark current comment as played
            currentComment.isPlayed = true
            
            // Calculate the delay time based on comment start and end time
            let delay = currentComment.endTime - currentSecond
            
            // Calculate speech rate based on comment length and duration
            let textLength = Float(currentComment.text.count)
            let speechDuration = Float(currentComment.endTime - currentComment.startTime)
            let speechRate = maxSpeechRate * min(textLength / speechDuration, 1)
            
            // Play the comment using the robot voice after the delay time
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let utterance = AVSpeechUtterance(string: currentComment.text)
                utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
                utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
                utterance.rate = speechRate
                utterance.volume = currentComment.volume
                print("Volume", currentComment.volume)
                self.synthesizer?.speak(utterance)
            }
            
            lastComment = currentComment
        }
    }
    
    private var playedComments = [Comment]()
    
    // MARK: - Deinitialization
    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
        }
    }
}


