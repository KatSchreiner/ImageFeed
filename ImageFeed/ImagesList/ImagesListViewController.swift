//
//  ViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.02.2024.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
    // создаем массив чисел и возвращаем массив строк
    private let photosName: [String] = Array(0..<20).map{ "\($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ImagesListViewController {
    // конфигурация ячейки
        func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
            // получаем название картинки по индексу
            let imageName = photosName[indexPath.row]
            
            // проверяем есть UIImage с таким название
            if let image = UIImage(named: imageName) {
                cell.cellImage.image = image
            } else { return }
            
            // добавляем текущую дату
            let currentDate = Date()
            let dateString = dateFormatter.string(from: currentDate)
            cell.dateLabel.text = dateString
            
            if indexPath.row % 2 == 0 {
                cell.likeButton.setImage(UIImage(named: "Active"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "No Active"), for: .normal)
            }
            
            cell.linearGradientView.linearGradient()
        }
}

extension UIView {
    func linearGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.00).cgColor, UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.20).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    // определяем количество ячеек в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // возвращаем ячейку по идентификатору
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath) //
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    // действия при нажатии на ячейку таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    // динамическая высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageWidth = tableView.bounds.width - tableView.contentInset.left - tableView.contentInset.right
        let imageHeight = imageWidth * (image.size.height / image.size.width)
        let padding = tableView.contentInset.top + tableView.contentInset.bottom

        return imageHeight + padding
    
    }
}
