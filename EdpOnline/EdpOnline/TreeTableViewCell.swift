//
//  TreeTableViewCell.swift
//  EdpOnline
//
//  Created by MACBOOK AIR on 20/11/17.
//  Copyright © 2017 MACBOOK AIR. All rights reserved.
//

import UIKit
import Alamofire

class TreeTableViewCell : UITableViewCell {
    
    @IBOutlet weak var treeTitle:UILabel?
    @IBOutlet weak var treeLocation:UILabel?
    @IBOutlet weak var treePoints:UILabel?
    @IBOutlet weak var treeImage:WebImageView?
    @IBOutlet weak var treeSpinnerLoad: UIActivityIndicatorView?
    
    static private var cacheRam:[URL:[String:Any]] = [:]
    
    func treeCellCache() -> [String:Any]? {
        guard let url = self.url,
              let cached = TreeTableViewCell.cacheRam[url] else {
            return nil
        }
        return cached
    }
    
    var useCell:Bool = false {
        didSet{
            self.treeTitle?.text = ""
            self.treePoints?.text = ""
            self.treeLocation?.text = ""
            self.treeImage?.image = nil
            self.treeSpinnerLoad?.startAnimating()
        }
    }
    
    var url:URL? {
        didSet{
          guard let remoteURL = url else{
                return
          }
          
          if let treeInfoCached = TreeTableViewCell.cacheRam[remoteURL] {
             guard let title  = treeInfoCached["titulo"] as? String,
                   let points = treeInfoCached["pontos"] as? Int,
                   let locality = treeInfoCached["country"] as? String
                 else {
                 return
             }
            
             self.treeTitle?.text  = title
             self.treePoints?.text = "\(points) Pontos"
             self.treeLocation?.text = locality
             self.treeSpinnerLoad?.stopAnimating()
          }else{
             Alamofire.request(remoteURL).responseData(completionHandler: {
             (response) in
               if response.error == nil,
                  let data = response.data {
                  do{
                    let json = try JSONSerialization.jsonObject(
                        with: data, options: JSONSerialization.ReadingOptions())
                    
                    guard let info   = json as? [String:Any],
                          let treeInfo = info["arvore"] as? [String:Any],
                          let title    = treeInfo["titulo"] as? String,
                          let points   = treeInfo["pontos"] as? Int,
                          let locality = treeInfo["country"] as? String
                        else {
                        return
                    }
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.treeSpinnerLoad?.stopAnimating()
                    }){_ in
                        self.treeTitle?.text  = title
                        self.treePoints?.text = "\(points) Pontos"
                        self.treeLocation?.text = locality
                        TreeTableViewCell.cacheRam[remoteURL] = treeInfo
                    }
                  }catch{
                    print("ERROR",error.localizedDescription)
                  }
                
               }
             })
          }
       }
    }
}
