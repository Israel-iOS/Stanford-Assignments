//
//  PhotoScrollViewController.m
//  Assignment6
//
//  Created by Apple on 06/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PhotoScrollViewController.h"
#import "FlickrHelper.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoCache.h"
#import "VacationHelper.h"
#import "Photo+Flickr.h"

@interface PhotoScrollViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIManagedDocument *vacation;
@property (nonatomic, strong) Photo *photoInDB;

@end

@implementation PhotoScrollViewController

- (UIActivityIndicatorView *)spinner
{
    if(!_spinner)
    {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _spinner;
}

- (void)storePhotoToRecent:(NSDictionary *)photo
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *discardedItems = [NSMutableArray array];
    NSMutableArray *photoArray = [[prefs objectForKey:@"photos"] mutableCopy];
    
    if (photoArray == nil)
    {
        photoArray = [[NSMutableArray alloc]  init];
    }
    
    for (NSDictionary *oldPhoto in photoArray)
    {
        if ([[photo valueForKey:FLICKR_PHOTO_ID] isEqual:[oldPhoto valueForKey:FLICKR_PHOTO_ID]])
        {
            [discardedItems addObject:oldPhoto];
            break;
        }
    }
    [photoArray removeObjectsInArray:discardedItems];
    [photoArray insertObject:photo atIndex:0];
    
    [prefs setObject:photoArray forKey:@"photos"];
}

- (void)loadView
{
    [super loadView];
    
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.spinner];
}

- (void)setPhoto:(NSDictionary *)photo
{
    [self.view addSubview:_spinner];
    [self.spinner startAnimating];
    if(_photo != photo)
    {
        NSLog(@"%@", photo);
        _photo = photo;
        [self showSpinner:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            FlickrPhotoCache *imageCache= [[FlickrPhotoCache alloc] init];
            UIImage *image = [imageCache getImageFromCacheWithIdentifier:[[photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:@".large"]];
            if (!image)
            {
                NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                [imageCache addImageToCache:image withIdentifier:[[photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:@".large"]];
                [self frameToCenter];
            }
            
            if (self.photo == photo)
            {
                [self storePhotoToRecent:photo];
                
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    self.title = [[FlickrHelper getInfoForPhoto:photo] objectForKey:@"title"];
                    [self showSpinner:NO];
                    
                    self.imageView = [[UIImageView alloc] initWithImage:image];
                    [self.scrollView addSubview:_imageView];
                    
                    //setup scroll
                    
                    self.scrollView.backgroundColor = [UIColor blackColor];
                    self.scrollView.contentSize = self.imageView.bounds.size;
                    self.scrollView.delegate = self;
                    
                    //setup zooming.
                    self.scrollView.minimumZoomScale=MIN(self.scrollView.bounds.size.width/self.imageView.image.size.width, self.scrollView.bounds.size.height/self.imageView.image.size.height);
                    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
                    
                    [self frameToCenter];
                });
            }
        });
    }
}

- (void)showSpinner:(BOOL) isShow
{
    if (isShow)
    {
        [self.spinner startAnimating];
    }
    else
    {
        [self.spinner stopAnimating];
    }
}

- (void)setPhotoInDB:(Photo *)photoInDB
{
    if (photoInDB != _photoInDB)
    {
        _photoInDB = photoInDB;
        if (photoInDB)
        {
            self.navigationItem.rightBarButtonItem.title = @"Unvisit";
            [self frameToCenter];
        }
        else
        {
            self.navigationItem.rightBarButtonItem.title = @"Visit";
            [self frameToCenter];
        }
    }
}

- (IBAction)visit:(id)sender
{
    NSString *buttonTitle;
    
    if([sender isKindOfClass:[UIBarButtonItem class]])
    {
        buttonTitle = [sender title];
    }
    
    if(self.photoInDB)
    {
        //[Photo deletePhoto:self.photoInDB inManagedObjectContext:self.vacation.managedObjectContext];
        [self.vacation.managedObjectContext deleteObject:self.photoInDB];
        self.photoInDB = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.photoInDB = [Photo photoWithFlickrInfo:self.photo inManagedObjectContext:self.vacation.managedObjectContext];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    [super viewWillAppear:animated];
    self.imageView.image = nil;
    
    [VacationHelper openVacation:self.vacationName usingBlock:^(UIManagedDocument *vacation){
        self.vacation = vacation;
        self.photoInDB = [Photo getPhotoWithFlickrInfo:self.photo inManagedObjectContext:self.vacation.managedObjectContext];
    }];
    
    self.spinner.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    [self frameToCenter];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.scrollView addGestureRecognizer:doubleTap];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    [self frameToCenter];
    return self.imageView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollView = nil;
    self.imageView = nil;
    self.spinner = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewWillLayoutSubviews
{
    if (self.imageView.image)
    {
        float zoomScaleAfterOrientationChange = self.view.bounds.size.width / self.imageView.image.size.width;
        [self.scrollView setZoomScale:zoomScaleAfterOrientationChange];
        
    }
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
}

- (void)frameToCenter
{
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = _scrollView.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
    {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    
    else
    {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
    {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else
    {
        frameToCenter.origin.y = 0;
    }
    
    self.imageView.frame = frameToCenter;
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self frameToCenter];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.scrollView.zoomScale > _scrollView.minimumZoomScale)
        [self.scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    
    else
        [self.scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
}

@end
