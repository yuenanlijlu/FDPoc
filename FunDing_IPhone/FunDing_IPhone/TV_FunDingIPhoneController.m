//
//  TV_FunDingIPhoneController.m
//  FunDing_IPhone
//
//  Created by apple on 12-11-9.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "TV_FunDingIPhoneController.h"

@interface TV_FunDingIPhoneController ()

@end

@implementation TV_FunDingIPhoneController

@synthesize listData;
@synthesize dataList;
@synthesize imageList;

@synthesize uv_maps;

@synthesize imageView;
@synthesize lblTitle;
@synthesize lblAddr;
@synthesize imageHot;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Restraurant";
    
    
    //加载plist文件的数据和图片
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"Restraurant" withExtension:@"plist"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
    //NSMutableArray *tmpImageArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[dictionary count]; i++) {
        NSString *key = [[NSString alloc] initWithFormat:@"%i", i+1];
        NSDictionary *tmpDic = [dictionary objectForKey:key];
        [tmpDataArray addObject:tmpDic];
        
        /*NSString *imageUrl = [[NSString alloc] initWithFormat:@"%i.png", i+1];
         UIImage *image = [UIImage imageNamed:imageUrl];
         [tmpImageArray addObject:image];*/
    }
    self.dataList = [tmpDataArray copy];
    //self.imageList = [tmpImageArray copy];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                    target:self
                                    action:@selector(onMapClicked)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)onMapClicked {
    /*
    uv_maps = [[UIViewController alloc] init];
    uv_maps.view = [uv_maps.view init];
    [self.view addSubview: uv_maps.view];
     */
    
    /* 
    *uv_maps = [[UIViewController alloc] initWithNibName:@"UIViewController" bundle:nil];
    [self.navigationController pushViewController:tmpViewController animated:YES];*/

    /*
    uv_maps = [[UIViewController alloc] init];
    uv_maps.view = [uv_maps.view init];

    [self presentModalViewController:uv_maps animated:YES];
    
    //返回
    //[self dismissModalViewControllerAnimated:YES];
     */
    
    //uv_maps = [[UIViewController alloc] init];
    //[uv_maps viewDidLoad];
    //uv_maps.view = [uv_maps.view init];
    //_nibName	__NSCFString *	"\xffffff80\x03\x05\b"
    uv_maps = [[UIViewController alloc] initWithNibName:@"UV_Maps" bundle:nil];
    [self.navigationController pushViewController: uv_maps animated:true];
    //跳转：[self.navigationController pushViewController:subTableViewController  animated:YES];
    
    //返回：[self.navigationController popViewControllerAnimated:YES];
    //[uv_maps release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // return 0;
    return [self.dataList count];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell; */
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        // TODO:
        
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.dataList objectAtIndex:row];
    
    
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:3];
    lblName.text  = [rowData objectForKey:@"name"];
    
    UILabel *lblAddress = (UILabel *)[cell viewWithTag:4];
    lblAddress.text  = [rowData objectForKey:@"addr"];
    
    UILabel *lblPrice = (UILabel *)[cell viewWithTag:5];
    lblPrice.text  = [rowData objectForKey:@"price"];
    
    //self.lblTitle.text = [rowData objectForKey:@"name"];
    //self.lblAddr.text = [rowData objectForKey:@"addr"];
    
    /*SearchList *cell = [tableView dequeueReusableCellWithIdentifier:SearchListIdentifier];
    if (cell == nil) {
        cell = [[SearchList alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SearchListIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.dataList objectAtIndex:row];
    
    cell.name = [rowData objectForKey:@"name"];
    cell.addr = [rowData objectForKey:@"addr"];
    cell.hot = [rowData objectForKey:@"hot"];
    cell.image = [imageList objectAtIndex:row];
     
     */
    
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
