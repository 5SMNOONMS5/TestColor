//
//  ViewController.swift
//  test
//
//  Created by Stephen Chen on 25/3/2017.
//  Copyright © 2017 fcloud. All rights reserved.
//

import UIKit

class Color: UIColor {

    convenience init(value: CGFloat) {
        self.init(red: value/255,
                  green: value/255,
                  blue: value/255,
                  alpha: 1)
    }
}

class MainTableViewController: UITableViewController {

    fileprivate var colorArray = [UIColor.red,
                                  UIColor.blue,
                                  UIColor.yellow,
                                  UIColor.brown,
                                  UIColor.black,
                                  UIColor.cyan,
                                  UIColor.gray,
                                  UIColor.green,
                                  UIColor.purple,
                                  UIColor.magenta,
                                  UIColor.darkGray,
                                  UIColor.lightGray,
                                  UIColor.orange,
                                  #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
                                  Color(value: 100),
                                  Color(value: 120),
                                  Color(value: 140),
                                  Color(value: 160),
                                  Color(value: 180),
                                  Color(value: 200),
                                  Color(value: 220)]
    
    fileprivate let reuseId = "id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainTableViewController.tapGesture))
        self.tableView.addGestureRecognizer(tap)
    }
    
    /// <#Description#>
    ///
    /// - Parameter sender: <#sender description#>
    func tapGesture(sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: sender.view)
        let color  = self.getPixelColorAtPoint(point: point, sourceView: self.tableView)
        print(" color = \(color)")
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - point: <#point description#>
    ///   - sourceView: <#sourceView description#>
    /// - Returns: <#return value description#>
    fileprivate func getPixelColorAtPoint(point: CGPoint, sourceView: UIView) -> UIColor? {
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        if let context = context
        {
            context.translateBy(x: -point.x, y: -point.y)
            sourceView.layer.render(in: context)
            
            let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
            
            pixel.deallocate(capacity: 4)
            return color
        }
        else
        {
            return nil
        }
    }
}


// MARK: - UITableViewDelegate
extension MainTableViewController {

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// for people like me has fat finger easy to tap
        return 88.0
    }
}

// MARK: - UITableViewDataSource
extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        
        cell.backgroundColor = self.colorArray[indexPath.row]
        return cell
    }
}

