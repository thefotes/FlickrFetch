//
//  PFFlickrNetworkCommunicator.m
//  FlickrStream
//
//  Created by Peter Foti on 9/25/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import "PFFlickrNetworkCommunicator.h"
#import "PFFlickrPhoto.h"

@interface PFFlickrNetworkCommunicator()

@property (strong, nonatomic) NSMutableArray *allImages;

@end
@implementation PFFlickrNetworkCommunicator

- (void)requestNewImageWithIdentifier:(NSString *)identifier
                   andCompletionBlock:(CompletionBlock)completionBlock
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=df5449ba04d3e634e6f817e068f8258d&photo_id=%@&format=json&nojsoncallback=1", identifier];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:0
                                                               error:nil];
        
        NSString *imageUrlString = [[[[JSON objectForKey:@"sizes"] objectForKey:@"size"] lastObject] objectForKey:@"source"];
        NSLog(@"Fetching Image at URL: %@", imageUrlString);
        
        PFFlickrPhoto *newPhoto = [[PFFlickrPhoto alloc] init];
        newPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlString]]];
        
        // Send newPhoto back to the main queue (main thread)
        if (completionBlock) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock(newPhoto);
            }];
        }
    }];
    
    [self.operationQueue addOperation:operation];
}

- (NSMutableArray *)allImages
{
    if (!_allImages) {
        _allImages = [NSMutableArray array];
}
        return _allImages;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue= [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return _operationQueue;
}

@end
