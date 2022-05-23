//
//  SpinnerView.swift
//  ZemogaMobile
//
//  Created by Luci on 19/5/22.
//

import UIKit
public class Spinner {
    internal static var spinner: UIActivityIndicatorView?
   
    public static var style: UIActivityIndicatorView.Style = .large
    public static var baseBackColor = UIColor(white: 0, alpha: 0.6)
    public static var baseColor = UIColor.white
    
    public static func start(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        if spinner == nil, let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = baseBackColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }

}
