//
//  PFViewController.m
//  FlickrStream
//
//  Created by Peter Foti on 9/25/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import "PFViewController.h"


@interface PFViewController ()

@end

@implementation PFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 200.0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [self.view addSubview:_tableView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(alertMe)];
    longPress.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPress];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(fetchNewImage:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"Flickr Stream";
    
}

- (void)alertMe
{
    [self.tableView setEditing:YES animated:YES];
}
- (NSArray *)photoIDs
{
    if (!_photoIDs) {
        _photoIDs = [[[self.photoModel.jsonFile objectForKey:@"photos"] objectForKey:@"photo"] valueForKey:@"id"];
    }
    
    return _photoIDs;
}

- (PFFlickrPhotoModel *)photoModel
{
    if (!_photoModel) {
        _photoModel = [[PFFlickrPhotoModel alloc] init];
    }
    
    return _photoModel;
}

- (PFFlickrNetworkCommunicator *)networkCommunicator
{
    if (!_networkCommunicator) {
        _networkCommunicator = [[PFFlickrNetworkCommunicator alloc] init];
    }
    return _networkCommunicator;
}

- (NSMutableArray *)allImages
{
    if (!_allImages) {
        _allImages = [[NSMutableArray alloc] init];
    }
    return _allImages;
}

- (NSArray *)visibleCells
{
    _visibleCells = [self.tableView visibleCells];
    return _visibleCells;
}

- (void)fetchNewImage:(id)sender
{
    [self.indicator startAnimating];
    for (UITableViewCell *cell in self.visibleCells){
        cell.imageView.alpha = 0.5;
    }
    NSString *photoID = [self.photoIDs objectAtIndex:arc4random() % self.photoIDs.count];
    [self.networkCommunicator requestNewImageWithIdentifier:photoID andCompletionBlock:^(PFFlickrPhoto *image) {
        self.singleImage = image.image;
        [self.allImages insertObject:self.singleImage atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationTop];
            [self.indicator stopAnimating];
            for (UITableViewCell *cell in self.visibleCells){
                cell.imageView.alpha = 1.0;
            }
        });

    }];

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.frame = self.view.bounds;
    }
    cell.imageView.image = [self.allImages objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [headerView addSubview:self.indicator];
    return headerView;
    
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped = YES;
        _indicator.center = CGPointMake(self.tableView.center.x, 13);
    }
    return _indicator;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allImages.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 50.0;
}

@end
