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
    Mat grey_copy;
    cvtColor(image, image_copy, CV_BGR2BGRA);
    
    /// Reduce noise with a kernel 3x3
    GaussianBlur(image_copy, detected_edges, cv::Size(3,3), 2, 2);
    
    /// Canny detector
    Canny( detected_edges, detected_edges, 25, 50, 3);
    
    /// Using Canny's output as a mask, we display our result
    dst = Scalar::all(0);
    
    image.copyTo( dst, detected_edges);
    
    //Contours
    cv::cvtColor(image, grey_copy, CV_BGR2GRAY);
//    threshold(grey_copy, grey_copy, 80, 255, CV_THRESH_BINARY);
    threshold(grey_copy, grey_copy, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
    
    //morphological close to remove lines between keys (we want entire keyboard)
    morphologyEx(grey_copy, grey_copy,
                 MORPH_CLOSE,
                 getStructuringElement(MORPH_RECT, cv::Size(8,5)));
//    image = grey_copy.clone();

    
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    int keyboardIdx = 0;
    double prevArea = 0.0;
    
    cv::findContours( grey_copy, contours, hierarchy, cv::RETR_CCOMP, cv::CHAIN_APPROX_SIMPLE);
    for ( size_t i=0; i<contours.size(); ++i )
    {
        cv::Rect brect = cv::boundingRect(contours[i]);
        if(brect.area() > prevArea) {
            keyboardIdx = (int)i;
            prevArea = brect.area();
        }
    }
    
    cv::drawContours( image, contours, keyboardIdx, Scalar(200,0,0), 1, 8, hierarchy, 0, cv::Point() );
//    cv::rectangle(image, brect, Scalar(255,0,0));

//    cv::cvtColor(image, image, CV_BGR2GRAY);
//    cvtColor(dst, image, CV_BGR2BGRA);
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
