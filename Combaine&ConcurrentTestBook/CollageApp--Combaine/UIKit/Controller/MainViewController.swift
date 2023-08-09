//
//  ViewController.swift
//  Combaine&ConcurrentTestBook
//
//  Created by Rami Alaidy on 06/08/2023.
//

import UIKit
import Combine

class MainViewController: UIViewController {

    @IBOutlet weak var imagePreview:UIImageView!

    @IBOutlet weak var ClearBtn:UIButton!
    @IBOutlet weak var SaveBtn:UIButton!

    private var subscriptions = Set<AnyCancellable>()
    private let images = CurrentValueSubject<[UIImage], Never>([])

    let collageSize = CGSize(width: UIScreen.main.bounds.width, height: 200)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 1
        images
        // 2
            .handleEvents(receiveOutput: { [weak self] photos in
              self?.updateUI(photos: photos)
            })
          .map { photos in
              UIImage.collage(images: photos, size: self.collageSize)
            }
            // 3
            .assign(to: \.image, on: imagePreview)
            // 4
            .store(in: &subscriptions)
    }

   @IBAction func addAction(sender:Any){
//        images.send([])
        let newImages = images.value + [UIImage(named: "IMG_1907.jpg")!]
        images.send(newImages)

       let photos = storyboard!.instantiateViewController(
         withIdentifier: "PhotosViewController") as!
       PhotosViewController
       let newPhotos = photos.selectedPhotos
       newPhotos
         .map { [unowned self] newImage in
         // 1
           return self.images.value + [newImage]
         }
       // 2
         .assign(to: \.value, on: images)
       // 3
         .store(in: &subscriptions)
       navigationController!.pushViewController(photos, animated: true)
    }
    @IBAction func ClearAction(sender:Any){
         images.send([])
     }
    func updateUI(photos:[UIImage]){
        if images.value.isEmpty{
            self.ClearBtn.isEnabled = false
            self.SaveBtn.isEnabled = false
        }else{
            self.ClearBtn.isEnabled = true
            self.SaveBtn.isEnabled = true
        }
    }
}

