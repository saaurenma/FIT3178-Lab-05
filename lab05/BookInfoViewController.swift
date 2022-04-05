//
//  BookInfoViewController.swift
//  lab05
//
//  Created by Saauren Mankad on 5/4/2022.
//

import UIKit

class BookInfoViewController: UIViewController {
    
    var currentBook: Book?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ISBNLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var publisherLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = currentBook?.title
        authorLabel.text = currentBook?.authors
        dateLabel.text = currentBook?.publicationDate
        ISBNLabel.text = currentBook?.isbn13
        publisherLabel.text = currentBook?.publisher
        descriptionLabel.text = currentBook?.bookDescription
        
        // set image for imageview
        if let cover = currentBook?.imageURL{
            let url = URL(string: (cover))
            var comps = URLComponents(url: url!, resolvingAgainstBaseURL: false)
            comps?.scheme = "https"
            let data = try? Data(contentsOf: (comps?.url!)!)
            bookImageView.image = UIImage(data: data!)
        }


        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
