//
//  PhotoViewController.m
//  Assignment-4
//
//  Created by Apple on 20/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoCache.h"

#define MINIMUM_SCROLL_SCALE 0.5;
#define MAXIMUM_SCROLL_SCALE 2.0;

@interface PhotoViewController () <UIScrollViewDelegate> //setup zooming
@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.splitViewController.delegate = self;
    
    [self refreshImage];
  
    self.scrollView.minimumZoomScale = MINIMUM_SCROLL_SCALE;
    self.scrollView.maximumZoomScale = MAXIMUM_SCROLL_SCALE;
    self.scrollView.zoomScale = 1.0f; //ipad reset zoomScale because the detailView always on screen so it's not reset as iphone.
    [self updateDisplay];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)refreshImage
{
    //File Manager caching check
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cachePath = [[[manager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject] path];
    NSString *photoPath = [cachePath stringByAppendingPathComponent:[self.photo objectForKey:@"id"]];
    
    if([manager fileExistsAtPath:photoPath])
    {
        NSData *photoData = [manager contentsAtPath:photoPath];
        [self setImageViewPhoto:[UIImage imageWithData:photoData]];
    }
    else
    {
        //make spinner
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        [self viewWillAppear:YES];
        if(self.toolbarSpinner)
        {
            [self.toolbarSpinner startAnimating];
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
                
        //use GCD to load image
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
            NSURL *photoFlickrURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatOriginal];
            NSData *photoData = [NSData dataWithContentsOfURL:photoFlickrURL];
            //cache image:
            [manager createFileAtPath:photoPath contents:photoData attributes:nil];
            //check cache size
            NSNumber *cacheSize = [[manager attributesOfItemAtPath:cachePath error:nil] objectForKey:NSFileSize];
            NSLog(@"%@",[cacheSize stringValue]);
            if([cacheSize intValue] > 1000)
            {
                NSArray *cacheFiles = [manager contentsOfDirectoryAtPath:cachePath error:nil];
                NSString *oldest = [cacheFiles objectAtIndex:0];
                for(NSString *aPath in cacheFiles)
                {
                    NSDate *curOldest = [[manager attributesOfItemAtPath:oldest error:nil] objectForKey:NSFileCreationDate];
                    NSDate *compare = [[manager attributesOfItemAtPath:aPath error:nil] objectForKey:NSFileCreationDate];
                    if([curOldest earlierDate:compare] == compare)
                    {
                        oldest = aPath;
                    }
                }
                [manager removeItemAtPath:oldest error:nil];
            }
            
            UIImage *photoImage = [UIImage imageWithData:photoData];
            
            dispatch_async(dispatch_get_main_queue(),
            ^{
                [self setImageViewPhoto:photoImage];
                [spinner stopAnimating];
                if(self.toolbarSpinner) {
                    [self.toolbarSpinner stopAnimating];
                }
            });
        });
    }    
}

- (void)setImageViewPhoto: (UIImage *)photoImage
{
    self.imageView.image = photoImage;
    if(photoImage)
    {
        self.scrollView.contentSize = self.imageView.bounds.size;
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);        
        self.scrollView.minimumZoomScale = 0.5f;
        self.scrollView.maximumZoomScale = 5.0f;       
    }
}

- (void)setPhoto:(NSDictionary *)photo
{
    if(_photo != photo)
    {
        _photo = photo;
        [self refreshImage];
        if(self.popover != nil)
        {
            [self.popover dismissPopoverAnimated:YES];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark split view controller delegate
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc
{
    barButtonItem.title = @"Photos";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.popover = pc;
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    self.popover = nil;
}

- (void)updateDisplay
{
    //spinner when downloading photo
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        //check cache
        NSURL *url;
        NSString *urlString;
        NSData *imageData;
    
        FlickrPhotoCache *flickrPhotoCache = [[FlickrPhotoCache alloc]init];
        [flickrPhotoCache retrievePhotoCache];
        
        if ([flickrPhotoCache isInCache:self.photo])
        {
            urlString = [flickrPhotoCache readImageFromCache:self.photo];//photo is in cache
            imageData = [NSData dataWithContentsOfFile:urlString];
            NSLog(@"load image from cache: %@",urlString);
        }
        else
        {
            url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge]; //photo is not in cache
            NSLog(@"downloaded from url: %@",url);
            imageData = [NSData dataWithContentsOfURL:url];
        }
        
        //load the image from url
        UIImage *image = [UIImage imageWithData:imageData];
        //NSLog(@"image id to cache is %@",[self.photo objectForKey:FLICKR_PHOTO_ID]);
        [flickrPhotoCache writeImageToCache:image forPhoto:self.photo fromUrl:url]; //update photo cache
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
            self.navigationItem.rightBarButtonItem = nil;
            self.imageView.image = image;
            
            //setup scroll
            self.scrollView.contentSize = self.imageView.bounds.size;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            
            //setup zooming
            self.scrollView.delegate = self;
            
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
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.imageView.image = nil;
}

@end