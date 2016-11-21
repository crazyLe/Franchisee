//
//  KZMaterialsApplyController.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMaterialModel.h"
#import <MWPhotoBrowser.h>
#import "UIViewController+Refresh.h"
#import "KZMaterialListController.h"
#import "KZApplyCommitController.h"
#import "KZMaterialsCollectionFooter.h"
#import "KZMaterialsCollectionHeader.h"
#import "KZMaterialsApplyCell.h"
#import "KZMaterialsApplyController.h"

@interface KZMaterialsApplyController () <UICollectionViewDelegate,UICollectionViewDataSource,KZMaterialsCollectionFooterDelegate,MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic,strong) NSMutableArray *photos;

@end

@implementation KZMaterialsApplyController
{
    
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setUI];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText:@"物料申请" textColor:nil];
    [self setRightText:@"清单" textColor:kBlueThemeColor ImgPath:nil action:@selector(clickRightBtn:)];
}

- (void)setUI
{
    [self setScroll:_collectionView networkAdd:kMaterialApplyInterface paraDic:@{} pageFiledName:@"page" parseDicKeyArr:@[@"data"] parseModelName:@"KZMaterialModel"];
    [self refreshScroll];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"KZMaterialsCollectionHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KZMaterialsCollectionHeader"];
    [_collectionView registerNib:[UINib nibWithNibName:@"KZMaterialsCollectionFooter" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KZMaterialsCollectionFooter"];
    
    _collectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH/2-15, SCREEN_WIDTH/2/0.86);
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    [_collectionView registerNib:[UINib nibWithNibName:@"KZMaterialsApplyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"KZMaterialsApplyCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KZMaterialsApplyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KZMaterialsApplyCell" forIndexPath:indexPath];
    cell.model = self.contentArr[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //区头
        KZMaterialsCollectionHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KZMaterialsCollectionHeader" forIndexPath:indexPath];
        return view;
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        //区尾
        KZMaterialsCollectionFooter *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KZMaterialsCollectionFooter" forIndexPath:indexPath];
        view.delegate = self;
        return view;
    }
    UICollectionReusableView *view = [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    KZMaterialModel *model = self.contentArr[indexPath.item];
//    for (int i = 0; i<arr.count; i++) {
    NSString *str = model.image;
    NSURL *url = [NSURL URLWithString:str];
    MWPhoto *photo = [MWPhoto photoWithURL:url];
    [photos addObject:photo];
//    }
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    
}

- (void)clickRightBtn:(UIButton *)rightBtn
{
    KZMaterialListController *materialListVC = [[KZMaterialListController alloc] init];
    materialListVC.materialModelArr = self.contentArr;
    [self.navigationController pushViewController:materialListVC animated:YES];
}

#pragma mark - KZMaterialsCollectionFooterDelegate

- (void)KZMaterialsCollectionFooter:(KZMaterialsCollectionFooter *)footer clickApplyBtn:(UIButton *)applyBtn;
{
    KZApplyCommitController *commitVC = [[KZApplyCommitController alloc] init];
    commitVC.materialModelArr = self.contentArr;
    [self.navigationController pushViewController:commitVC animated:YES];
}

@end
