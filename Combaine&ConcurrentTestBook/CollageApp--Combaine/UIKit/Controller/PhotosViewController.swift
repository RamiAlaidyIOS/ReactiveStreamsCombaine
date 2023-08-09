//
//  PhotosViewController.swift
//  Combaine&ConcurrentTestBook
//
//  Created by Rami Alaidy on 07/08/2023.
//

import UIKit
import Combine

class PhotosViewController: UIViewController {

    // MARK: - Public properties
    var selectedPhotos: AnyPublisher<UIImage, Never> {
      return selectedPhotosSubject.eraseToAnyPublisher()
    }
    // MARK: - Private properties
    private let selectedPhotosSubject =
      PassthroughSubject<UIImage, Never>()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedPhotosSubject.send(completion: .finished)
    }

}
