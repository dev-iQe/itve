import UIKit
import AVKit

final class PlayerViewController: AVPlayerViewController {
    private let url: URL?

    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        if let url = url {
            let player = AVPlayer(url: url)
            self.player = player
            player.play()
        }
    }
}
