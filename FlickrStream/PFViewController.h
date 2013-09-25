//
//  PFViewController.h
//  FlickrStream
//
//  Created by Peter Foti on 9/25/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFFlickrPhotoModel.h"
#import "PFFlickrNetworkCommunicator.h"

@interface PFViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PFFlickrPhotoModel *photoModel;
@property (strong, nonatomic) PFFlickrNetworkCommunicator *networkCommunicator;
@property (strong, nonatomic) NSArray *photoIDs;
@property (strong, nonatomic) UIImage *singleImage;
@property (strong, nonatomic) NSMutableArray *allImages;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSArray *visibleCells;

- (void)fetchNewImage:(id)sender;
@end
