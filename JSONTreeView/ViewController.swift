//
//  ViewController.swift
//  JSONTreeView
//
//  Created by 成殿 on 2017/2/23.
//  Copyright © 2017年 成殿. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var textView: UITextView?
    var dataSource: AnyHashable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let urlStr = "https://itunes.apple.com/lookup?id=1202672449"
        let urlStr = "http://news-at.zhihu.com/api/4/stories/latest"
//        let urlStr = "http://news-at.zhihu.com/api/4/news/9243949"
        
        let url = URL.init(string: urlStr)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfig)
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json ?? "")
                
                DispatchQueue.main.async {
                    self.dataSource = json as? AnyHashable
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.textView = UITextView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64))
                    self.textView?.isEditable = true
                    self.textView?.text = (json as! Dictionary<String, AnyObject>).description
                    self.view.addSubview(self.textView!)
                }
            }
        }
        dataTask.resume()
        let formatBBI = UIBarButtonItem(title: "格式化", style: .done, target: self, action: #selector(ViewController.format))
        formatBBI.isEnabled = false
        navigationItem.rightBarButtonItem = formatBBI
    }
    
    func format() {
        
         let treeViewC = TreeViewViewController()
         treeViewC.dataSource = dataSource
         treeViewC.title = "DataSource"
         DispatchQueue.main.async {
         self.navigationController?.pushViewController(treeViewC, animated: true)
         }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

