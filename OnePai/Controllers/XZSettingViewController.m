//
//  XZSettingViewController.m
//  OnePai
//
//  Created by zhouzhou on 2019/7/27.
//  Copyright © 2019年 zhouzhou. All rights reserved.
//

#import "XZAppSetting.h"
#import "XZSettingCell.h"
#import "XZSettingSectionModel.h"
#import "XZFaceDetectorManager.h"

#import "XZSettingViewController.h"

static NSString * const kReuseIdentifier = @"XZSettingCell";

// section ID
static NSString * const kSectionIDFace = @"SectionIDFace";

// model ID
static NSString * const kModelIDFacepp = @"ModelIDFacepp";

@interface XZSettingViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
XZSettingCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <XZSettingSectionModel *>*sections;

@end

@implementation XZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    [self commonInit];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Private

- (void)commonInit {
    [self setupData];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.translucent = NO;
    [self setupCloseButton];
    [self setupTableView];
}

- (void)setupData {
    /// 人脸识别引擎
    XZSettingSectionModel *faceSection = [[XZSettingSectionModel alloc] init];
    faceSection.sectionID = kSectionIDFace;
    faceSection.sectionTitle = @"人脸识别引擎";
    // Face++
    XZSettingModel *faceppModel = [[XZSettingModel alloc] init];
    faceppModel.modelID = kModelIDFacepp;
    faceppModel.modelTitle = @"Face++";
    faceppModel.isSwitchOn = [XZAppSetting isUsingFaceppEngine];
    faceppModel.switchChangedAction = ^(BOOL isOn) {
        XZFaceDetectorManager *manager = [XZFaceDetectorManager shareManager];
        if (isOn) {
            manager.faceDetectMode = XZFaceDetectModeFacepp;
        } else if (manager.faceDetectMode == XZFaceDetectModeFacepp) {
            manager.faceDetectMode = XZFaceDetectModeNone;
        }
    };
    
    faceSection.models = @[faceppModel];
    self.sections = @[faceSection];
}

- (void)setupCloseButton {
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [closeButton setImage:[UIImage imageNamed:@"btn_navigation_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self
                    action:@selector(closeAction:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[XZSettingCell class] forCellReuseIdentifier:kReuseIdentifier];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIView *)headViewWithSectionModel:(XZSettingSectionModel *)sectionModel {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = RGBA(155, 155, 155, 1);
    label.text = sectionModel.sectionTitle;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(10);
        make.left.equalTo(view).offset(20);
    }];
    
    return view;
}

// 通过 ID 来更改 cell 和 model 的状态
- (void)changeModelStatusWithModelID:(NSString *)modelID status:(BOOL)status {
    XZSettingModel *targetModel = nil;
    XZSettingSectionModel *targetSection = nil;
    for (XZSettingSectionModel *section in self.sections) {
        for (XZSettingModel *model in section.models) {
            if ([model.modelID isEqualToString:modelID]) {
                targetSection = section;
                targetModel = model;
                break;
            }
        }
    }
    if (targetModel) {
        targetModel.isSwitchOn = status;
        
        // 查找cell，如果展示中，则修改UI
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[targetSection.models indexOfObject:targetModel] inSection:[self.sections indexOfObject:targetSection]];
        XZSettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setOn:status];
    }
}

#pragma mark - Action

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section].models count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    cell.model = self.sections[indexPath.section].models[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headViewWithSectionModel:self.sections[section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

#pragma mark - XZSettingCellDelegate

- (void)settingCell:(XZSettingCell *)settingCell didChangedWithModel:(XZSettingModel *)model {
    model.isSwitchOn = [settingCell isOn];
}

@end
