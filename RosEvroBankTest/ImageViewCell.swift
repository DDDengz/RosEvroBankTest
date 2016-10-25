//
//  ImageViewCell.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {
    
    // MARK: Model
    
    var imageT: Image? {
        didSet {
            updateUI()
        }
    }
    var cache: NSCache<AnyObject, AnyObject>?
    private var lastUrl: URL?
    
    // MARK: Outlets

    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    
    func updateUI() {
        // переустанавливаем информацию существующей строки
        imageImageView.image = nil
        imageTitle.text = nil
        
        // Загружаем новую информацию, если она определена
        if let imageT = self.imageT {
            imageTitle.text = imageT.title
            setImageViewCell(imageT)
        }
    }
    
    private func setImageViewCell(_ imageR: Image) {
        lastUrl = URL(string: imageR.thumbnaiUrl!)
        if let thumbImageURL = URL(string: imageR.thumbnaiUrl!) {
            let imageData = cache?.object(forKey: URL(string: imageR.thumbnaiUrl!) as AnyObject) as? Data
            guard imageData == nil else { imageImageView.image = UIImage(data: imageData!); return }
            DispatchQueue.global(qos: .userInitiated).async { [weak weakSelf = self] in
                let contentsOfURL = try? Data(contentsOf: thumbImageURL)
                DispatchQueue.main.async {
                    if thumbImageURL == weakSelf?.lastUrl {
                        if let imageData = contentsOfURL  {
                            self.imageImageView?.image = UIImage(data: imageData)
                            self.cache?.setObject(imageData as AnyObject, forKey: thumbImageURL as AnyObject,
                                                  cost: imageData.count )
                        }
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
