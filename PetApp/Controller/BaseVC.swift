//
//  BaseVC.swift
//  PetApp
//
//  Created by Umang Sahu on 22/06/24.
//

import UIKit

var imageChache = NSCache<AnyObject, UIImage>()

class BaseVC: UIViewController {

    var httpUtils: HttpUtils = HttpUtils()
    let userDefaults = UserDefaults.standard
    var likedPetList: LikedModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension UIImageView {
    func load(url: URL) {
        image = nil
        if let imgChashed = imageChache.object(forKey: url.absoluteString as AnyObject) {
            self.image = imgChashed
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageChache.setObject(image, forKey: url.absoluteString as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}

