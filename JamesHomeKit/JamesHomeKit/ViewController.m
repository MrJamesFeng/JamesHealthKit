//
//  ViewController.m
//  JamesHomeKit
//
//  Created by LDY on 17/4/5.
//  Copyright © 2017年 LDY. All rights reserved.
/*
 1、kvo kvc的原理
 2、为什么不能直接对数组的kvo？
 3、数组addobject为什么不走setter？
 
 
 
 */

#import "ViewController.h"
#import<HomeKit/HomeKit.h>
#import "HomesModel.h"
@interface ViewController ()<HMHomeDelegate,HMAccessoryDelegate,HMHomeManagerDelegate,HMAccessoryBrowserDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)HMHomeManager *homeManager;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<HMHome*> *homes;

@property(nonatomic,strong)HomesModel *homesModel;



@end



@implementation ViewController{
    NSMutableArray<HMHome*> *_homes;
}
@synthesize homes = _homes;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.homeManager = [[HMHomeManager alloc]init];
    [self.homeManager setDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(alertviewShow)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(dissmiss)];
    
    
    

   
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
}
-(void)KVO{
    //    [self.homes addObserver:self forKeyPath:nil options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //    [self.homesModel addObserver:self forKeyPath:@"homes" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //    [self addObserver:self forKeyPath:@"homes" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self removeObserver:self.homesModel forKeyPath:@"homes"];
//    [self removeObserver:self forKeyPath:@"homes"];
//    [self removeObserver:self forKeyPath:@"homes"];
}

/**
 添加家庭

 @param homeName 家庭名称（唯一）
 */
-(void)addHome:(NSString *)homeName{
    __weak typeof(self)weakSelf = self;
    [self.homeManager addHomeWithName:homeName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
        if (error) {
            NSLog(@"addHome error=%@",error);
        }else{
            [weakSelf.tableView reloadData];
//            [[weakSelf mutableArrayValueForKey:@"homes"]addObject:home];
        }
    }];
}

-(void)alertviewShow{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"addHome" message:@"home is none need add home" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"homes"]) {
        [self.tableView reloadData];
    }
}
#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            UITextField *textField = [alertView textFieldAtIndex:buttonIndex-1];
            [self addHome:textField.text];
        }
            break;
        default:
            break;
    }
}
#pragma HMHomeManagerDelegate
-(void)homeManagerDidUpdateHomes:(HMHomeManager *)manager{
    
//    [self.homes addObjectsFromArray:manager.homes];
    
//    [self.homesModel.homes addObjectsFromArray:manager.homes];
    
//    [[self.homesModel mutableArrayValueForKey:@"homes"]addObjectsFromArray:manager.homes];
    
//    [[self mutableArrayValueForKey:@"homes"]addObjectsFromArray:manager.homes];
    
    
    if (manager.homes.count==0) {
        [self alertviewShow];
    }else{
        [self.tableView reloadData];
    }
    
}
-(void)home:(HMHome *)home didAddRoom:(HMRoom *)room{
    NSLog(@"%@ AddRoom room=%@",home,room);
}

#pragma HMAccessoryDelegate

#pragma HMAccessoryBrowserDelegate

#pragma UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return self.homes.count;
    //    return self.homesModel.homes.count;
    return self.homeManager.homes.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeManager.homes[section].rooms.count;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return  self.homeManager.homes[section].name;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusableCellWithIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reusableCellWithIdentifier"];
    }
//    HMHome *home = self.homes[indexPath.row];
//    HMHome *home = self.homesModel.homes[indexPath.row];
    HMHome *home = self.homeManager.homes[indexPath.section];
    HMRoom *room = home.rooms[indexPath.row];
    cell.textLabel.text = room.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"primary:%d",home.primary];
    cell.indentationLevel = 1;
    cell.indentationWidth = 20;
   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button setTintColor:[UIColor blueColor]];
    [button setTitle:self.homeManager.homes[section].name forState:UIControlStateNormal ];
    button.tag = section;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [[self mutableArrayValueForKey:@"homes"]removeObjectAtIndex:indexPath.row];
//    }];
//    return @[rowAction];
//}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        HMHome *home = [self.homes objectAtIndex:indexPath.row];
//        [self.homeManager removeHome:home completionHandler:^(NSError * _Nullable error) {
//            if (!error) {
//                [[self mutableArrayValueForKey:@"homes"]removeObjectAtIndex:indexPath.row];
//            }
//        }];
        [self.homeManager removeHome:self.homeManager.homes[indexPath.row] completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"removeHome error = %@",error);
            }else{
                [self.tableView reloadData];
            }
        }];
    }
}

-(NSMutableArray<HMHome *> *)homes{
    if (!_homes) {
        _homes = [NSMutableArray array];
    }
    return _homes;
}
-(void)setHomes:(NSMutableArray<HMHome *> *)homes{
    _homes = homes;
    [self.tableView reloadData];
}

-(void)buttonAction:(UIButton *)button{
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(HomesModel *)homesModel{
    if (!_homesModel) {
        _homesModel = [[HomesModel alloc]init];
    }
    return _homesModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dissmiss{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}


@end
