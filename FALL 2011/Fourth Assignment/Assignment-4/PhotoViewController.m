//
//  PhotoViewController.m
//  Assignment-4
//
//  Created by Apple on 20/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

#define MINIMUM_SCROLL_SCALE 0.5;
#define MAXIMUM_SCROLL_SCALE 2.0;

@interface PhotoViewController () <UIScrollViewDelegate> //setup zooming

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = MINIMUM_SCROLL_SCALE;
    self.scrollView.maximumZoomScale = MAXIMUM_SCROLL_SCALE;
}

- (void) viewWillAppear:(BOOL)animated
{    
    //spinner when downloading photo
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
   
    dispatch_async(downloadQueue,
    ^{
        //load the image from url
        NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
       
        dispatch_async(dispatch_get_main_queue(),
        ^{
            self.navigationItem.rightBarButtonItem = nil;
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView = [[UIImageView alloc] initWithImage:image];
            [self.scrollView addSubview:self.imageView];
            self.scrollView.zoomScale = 1;
            //setup scroll
             self.scrollView.contentSize = self.imageView.bounds.size;
            
            //setup zooming
            CGFloat widthZoom = self.scrollView.bounds.size.width / self.imageView.image.size.width;
            CGFloat heightZoom = self.scrollView.bounds.size.height / self.imageView.image.size.height;
            if (widthZoom > heightZoom)
            {
                self.scrollView.zoomScale = widthZoom;
            }
            else
            {
                self.scrollView.zoomScale = heightZoom;
            }

            //set the photo title on navigation bar
            NSString *title = [self.photo objectForKey:FLICKR_PHOTO_TITLE];
            self.navigationItem.title = title;
        });
    });
    dispatch_release(downloadQueue);
}
 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    // Width ratio compares the width of the viewing area with the width of the image
    float widthRatio = self.view.bounds.size.width / self.imageView.image.size.width;
    
    // Height ratio compares the height of the viewing area with the height of the image
    float heightRatio = self.view.bounds.size.height / self.imageView.image.size.height;
    
    // Update the zoom scale
    self.scrollView.zoomScale = MAX(widthRatio, heightRatio);    
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
