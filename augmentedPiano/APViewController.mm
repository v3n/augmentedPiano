//
//  APViewController.m
//  augmentedPiano
//
//  Created by Jonathan Howard on 4/8/14.
//  Copyright (c) 2014 Jonathan Howard. All rights reserved.
//

#import "APViewController.h"

using namespace cv;

Mat src, src_gray;
Mat dst, detected_edges;

@interface APViewController () {
}

@end

@implementation APViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [self.videoCamera adjustLayoutToInterfaceOrientation:toInterfaceOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:iv];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetiFrame960x540;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    [self.videoCamera start];
    
    [self.videoCamera adjustLayoutToInterfaceOrientation:self.interfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#ifdef __cplusplus

- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGR2GRAY);
    
    /// Reduce noise with a kernel 3x3
    GaussianBlur(image_copy, detected_edges, cv::Size(3,3), 2, 2);
    
    /// Canny detector
    Canny( detected_edges, detected_edges, 25, 50, 3);
    
    /// Using Canny's output as a mask, we display our result
    dst = Scalar::all(0);
    
    image.copyTo( dst, detected_edges);
    
    cvtColor(dst, image, CV_BGR2BGRA);
}
#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
