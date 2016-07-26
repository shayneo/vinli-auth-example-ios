//
//  AppDelegate.h
//  Vinli-Auth-Example
//
//  Created by Shayne O'Sullivan on 7/26/16.
//  Copyright © 2016 Shayne O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

