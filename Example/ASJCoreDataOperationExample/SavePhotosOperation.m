//
//  SavePhotosOperation.m
//  ASJCoreDataOperationExample
//
//  Created by sudeep_MAC02 on 12/05/16.
//  Copyright © 2016 sudeep. All rights reserved.
//

#import "SavePhotosOperation.h"
#import "Photo.h"

@implementation SavePhotosOperation

- (void)coreDataOperation
{
  for (NSDictionary *photoInfo in _photos)
  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    fetchRequest.fetchLimit = 1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoId == %@", photoInfo[@"id"]];
    fetchRequest.predicate = predicate;
    
    Photo *photoManagedObject = nil;
    NSError *error = nil;
    NSArray *result = [self.privateMoc executeFetchRequest:fetchRequest error:&error];
    if (error) {
      NSLog(@"error fetching existing photo: %@", error.localizedDescription);
    }
    if (!result.count) {
      photoManagedObject = (Photo *)[NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.privateMoc];
    }
    else {
      photoManagedObject = result.firstObject;
    }
    
    photoManagedObject.albumId = photoInfo[@"albumId"];
    photoManagedObject.photoId = photoInfo[@"id"];
    photoManagedObject.title = photoInfo[@"title"];
    photoManagedObject.url = photoInfo[@"url"];
    photoManagedObject.thumbnailUrl = photoInfo[@"thumbnailUrl"];
  }
  
  NSError *error = nil;
  BOOL success = [self.privateMoc save:&error];
  if (!success || error) {
    NSLog(@"error saving photo: %@", error.localizedDescription);
  }
}

@end
