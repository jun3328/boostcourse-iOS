//
//  ViewController.swift
//  SectionTableView
//
//  Created by lee on 2021/01/30.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView = { () -> UITableView in
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return view
    }()

    let alphabet = ["a","b","c","d","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    let hangle = ["ㄱ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "섹션 테이블뷰"
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return alphabet.count
        case 1:
            return hangle.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "알파벳 \(self.alphabet[indexPath.row])"
        case 1:
            cell.textLabel?.text = "한글 \(self.hangle[indexPath.row])"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "영어"
        case 1:
            return "한글"
        default:
            return nil
        }
    }
}


#if DEBUG
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // no-op
    }

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
