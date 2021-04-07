//
//  ReusableEggColorView.swift
//  Chicken Saver Plus
//
//  Created by Caroline Gilleeny on 4/27/17.
//  Copyright © 2017 Caroline Gilleeny. All rights reserved.
//

import UIKit

class ReusableEggColorView: UIView {

    @IBOutlet var view: ReusableEggColorView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadeView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "ReusableEggColorView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        UINib(nibName: "ReusableEggColorView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
    
    /*
    - (id)initWithFrame:(CGRect)frame
    {
    self = [super initWithFrame:frame];
    if(!self){
    return nil;
    }
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *views = [mainBundle loadNibNamed:NSStringFromClass([self class])
    owner:nil
    options:nil];
    [self addSubview:views[0]];
    
    return self;
    }
    */
}
