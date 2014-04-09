//
//  APViewController.h
//  augmentedPiano
//
//  Created by Jonathan Howard on 4/8/14.
//  Copyright (c) 2014 Jonathan Howard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>


@interface APViewController : UIViewController <CvVideoCameraDelegate> {
    IBOutlet UIImageView *iv;
}

@property (nonatomic, retain) CvVideoCamera *videoCamera;

- (NSUInteger)supportedInterfaceOrientations;

@end
