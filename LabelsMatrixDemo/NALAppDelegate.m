//
//  NALAppDelegate.m
//  LabelsMatrixDemo
//
//  Created by neeks on 12/02/14.
//  Copyright (c) 2014 neeks. All rights reserved.
//

#import "NALAppDelegate.h"
#import "NALLabelsMatrix.h"

@interface NALAppDelegate ()
@property (strong, nonatomic) NALLabelsMatrix *m_matrix;
@end

@implementation NALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self addMatrix];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)addMatrix {
    // ACTION BUTTONS
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = (CGRect){
        .origin.x = 160,
        .origin.y = 20,
        .size.width = 100,
        .size.height = 44
    };
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"Remove" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onRemove:)
  forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = (CGRect){
        .origin.x = 60,
        .origin.y = 20,
        .size.width = 100,
        .size.height = 44
    };
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"Add" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onAdd:)
  forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:btn];
    
    // DISPLAY
    NALLabelsMatrix* matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(5, 70, 310, 100) andColumnsWidths:@[ @60, @125, @125 ]];
    
    matrix.m_bIsEditable = YES;
    
    [matrix addRecord:@[ @" ", @"Old Value", @"New value ", ]];
    [matrix addRecord:@[ @"Field1", @"hello", @"This is a really really long string and should wrap to multiple lines.", ]];
    [matrix addRecord:@[ @"Some Date", @"06/24/2013", @"06/30/2013", ]];
    [matrix addRecord:@[ @"Field2", @"some value", @"some new value", ]];
    [matrix addRecord:@[ @"Long Fields", @"The quick brown fox jumps over the little lazy dog.", @"some new value", ]];
    
    self.m_matrix = matrix;
    
    [self.window addSubview:matrix];
}

#pragma mark - Actions
- (void)onRemove:(id)sender {
    [_m_matrix removeRecordAtRow:[_m_matrix rowsCount] - 2];
}

- (void)onAdd:(id)sender {
    [_m_matrix addRecord:@[ [NSString stringWithFormat:@"Field%@", @( [_m_matrix rowsCount] )], @"Value233333", @"BlaBlaBla", ]];
}

@end
