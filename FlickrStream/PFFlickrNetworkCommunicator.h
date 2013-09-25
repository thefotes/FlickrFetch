//
//  PFFlickrNetworkCommunicator.h
//  FlickrStream
//
//  Created by Peter Foti on 9/25/13.
//  Copyright (c) 2013 Peter Foti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFFlickrPhoto.h"

typedef void (^CompletionBlock) (PFFlickrPhoto *image);

@interface PFFlickrNetworkCommunicator : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (void)requestNewImageWithIdentifier:(NSString *)identifier
                   andCompletionBlock:(CompletionBlock)completionBlock;

@end
