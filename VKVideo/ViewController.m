//
//  ViewController.m
//  VKVideo
//
//  Created by Максим Стегниенко on 17.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import "ViewController.h"
#import "MSLoginViewController.h"
#import "MSServerManager.h"
#import "MSVideo.h"
#import "MSVideoPlayerVC.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (assign , nonatomic) BOOL firstAppear;
@property (strong , nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *videosArray;



@property (strong,nonatomic) UIImage *imgPhoto;


@end

float heightOfCell = 100.f;


@implementation ViewController

- (void) loadView {
    [super loadView];
    
    
    self.videosArray = [NSMutableArray array];
    self.firstAppear = YES;
    self.imgPhoto = [ UIImage imageNamed:@"Placeholder_4-3.svg.png"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame ;
    
    frame.size.height= 44 ;
    frame.size.width = self.view.bounds.size.width;
    
    frame.origin.x = 0;
    frame.origin.y = 20;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    
    searchBar.autoresizingMask  =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:searchBar];
    

    
    searchBar.delegate = self;
    
    self.searchBar = searchBar;
    
    CGRect frameOfTableView = self.view.bounds;
    
    frameOfTableView.size.height = self.view.bounds.size.height - frame.size.height;
    frameOfTableView.size.width = self.view.bounds.size.width;
    
    frameOfTableView.origin.x = 0;
    frameOfTableView.origin.y = frame.origin.y + frame.size.height;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frameOfTableView style:UITableViewStyleGrouped];
    tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    
  
    self.tableView = tableView;
    
   
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.firstAppear) {
        
        self.firstAppear = NO;
        
        [[MSServerManager sharedManager] authorizeUser:^(MSUser* user) {

    }];
    
    }
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return heightOfCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSVideoPlayerVC *vc = [[MSVideoPlayerVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    MSVideo *video = [self.videosArray objectAtIndex:indexPath.row];
    
    vc.playerURL = video.playerURL;
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if(indexPath.row + 1 == self.videosArray.count) {
        

        
        [[MSServerManager sharedManager] getVideosWithSearch:self.searchBar.text withOffset:[self.videosArray count] onSuccess:^(NSArray *videosArray) {
            
            [self.videosArray addObjectsFromArray:videosArray];
            
            NSMutableArray* newPaths = [NSMutableArray array];
            for (int i = (int)[self.videosArray count] - (int)[videosArray count]; i < [self.videosArray count]; i++) {
                [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
         
            [self.tableView reloadData];
           
            
        } onFailture:^(NSError *error) {
            NSLog(@"error %@", error.localizedDescription);
        }];
        
        
    }
}



#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videosArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    
    MSVideo *video = [self.videosArray objectAtIndex:indexPath.row];
  
    
    
    
    cell.imageView.image = self.imgPhoto;
  
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:video.photoOfVideo completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [UIImage imageWithData:data];
                 
                });
            
        }
    }];
    [task resume];
    
    
    NSString *labelOfVideo = [NSString stringWithString:video.labelOfVideo];
    
    
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:labelOfVideo
                                                                               attributes:@{
                                                                                            NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                            NSFontAttributeName : [UIFont fontWithName:@"PingFang-TC-Light" size:15.0]
                                                                                            } ];
                                             
    
    
            cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:video.duration
                                                                    attributes:@{
                                                                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                                                                 NSFontAttributeName : [UIFont fontWithName:@"PingFang-TC-Light" size:12.0]
                                                                                 }   ];
    
    
    return cell;
    
}



#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    
   [ searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [ searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    
    [[MSServerManager sharedManager] getVideosWithSearch:searchBar.text withOffset:[self.videosArray count] onSuccess:^(NSArray *videosArray) {
        
        NSMutableArray* arr = [NSMutableArray arrayWithArray:videosArray];
        
        self.videosArray = arr;
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
        });
      
        
    } onFailture:^(NSError *error) {
        NSLog(@"error %@", error.localizedDescription);
    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [ searchBar setShowsCancelButton:NO animated:YES];
    
    
}




@end
