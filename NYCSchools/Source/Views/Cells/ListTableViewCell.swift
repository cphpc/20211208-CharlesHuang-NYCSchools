//
//  ListTableViewCell.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/5/21.
//

import Foundation
import UIKit

final class ListTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var gradeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)

        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .left
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        gradeLabel.numberOfLines = 0
        gradeLabel.textAlignment = .left
        gradeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        gradeLabel.textColor = .lightGray
    }

    /// Basic cell setup with School for basic information
    func setup(school: School) {
        nameLabel.text = school.schoolName
        locationLabel.text = school.generalLocation
        gradeLabel.text = school.grades
    }
}
