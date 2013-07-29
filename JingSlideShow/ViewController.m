//
//  ViewController.m
//  JingSlideShow
//
//  Created by justin jing on 13-7-29.
//  Copyright (c) 2013年 justin jing. All rights reserved.
//

#import "ViewController.h"
#import "SLGSlideshowView.h"
 

@interface ViewController () <SLGSlideshowViewDatasource,SLGSlideshowViewDelegate,UIGestureRecognizerDelegate>
{
    SLGSlideshowView *slideShowView;
    UIImageView *_topBar;
    BOOL isPlayed;
    UIImageView* playIcon;
}

@end

@implementation ViewController{
    
    NSArray *_slideshowData;
    NSArray *_transitionOptions;
}

-(void)TopView
{
    _topBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [_topBar setImage:[UIImage imageNamed:@"topBack.png"]];
    [self.view addSubview:_topBar];
    
    isPlayed=YES;
    
    
    UIButton* backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonSt.png"] forState:UIControlStateHighlighted];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(8, 7, 8, 5)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton addTarget:self action:@selector(previousButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* backIcon=[[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 21, 15)];
    [backIcon setImage:[UIImage imageNamed:@"backImage.png"]];
    
    UIButton* playButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"topDone.png"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"topDoneSelected.png"] forState:UIControlStateHighlighted];
    [playButton setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 7, 0)];
    [playButton setFrame:CGRectMake(140, 0, 45, 44)];
    [playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    playIcon=[[UIImageView alloc]initWithFrame:CGRectMake(156,12,16, 20)];
    [playIcon setImage:[UIImage imageNamed:@"mvplay.png"]];
    
    
    UIButton* nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"nextButton.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"nextButtonSt.png"] forState:UIControlStateHighlighted];
    [nextButton setImageEdgeInsets:UIEdgeInsetsMake(8, 7, 8, 5)];
    [nextButton setFrame:CGRectMake(257, 0, 60, 44)];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     
    UIImageView* nextIcon=[[UIImageView alloc]initWithFrame:CGRectMake(276, 15, 21,15)];
    [nextIcon setImage:[UIImage imageNamed:@"nextImage.png"]];
    
    
    [_topBar addSubview:backButton];
    [_topBar addSubview:backIcon];
    [_topBar addSubview:playButton];
    [_topBar addSubview:playIcon];
    [_topBar addSubview:nextButton];
    [_topBar addSubview:nextIcon];
    [_topBar setUserInteractionEnabled:YES];
 
    _topBar.alpha=0.0;
    
}
#pragma mark View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // setup some slideshow data
    _transitionOptions= @[[NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromLeft],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromRight],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlUp],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlDown],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCrossDissolve],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromTop],
                          [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromBottom]];
    
    NSArray* section1 = @[@"flower1.jpg",@"flower2.jpg",@"flower3.jpg"];
    NSArray* section2 = @[@"flower4.jpg",@"flower5.jpg",@"flower6.jpg",@"flower7.jpg"];
    _slideshowData =[NSArray arrayWithObjects:section1,section2,nil];
    
    slideShowView=[[SLGSlideshowView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20)];
    slideShowView.delegate=self;
    slideShowView.datasource=self;
    [self.view addSubview:slideShowView];
    
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [singleFingerOne setDelegate:self];
    [slideShowView addGestureRecognizer:singleFingerOne];
    
    [self TopView];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [slideShowView beginSlideShow];
}


#pragma mark - Actions
-(void)previousButtonAction:(id)sender{
    
    [slideShowView previousImage];
}
-(void)playButtonAction:(id)sender{
    
    if (isPlayed) {
        isPlayed=NO;
        
         [playIcon setImage:[UIImage imageNamed:@"mvpause.png"]];
    }
    else
    {
       isPlayed=YES;
         [playIcon setImage:[UIImage imageNamed:@"mvplay.png"]];
    }
    [slideShowView pauseResumeSlideShow];
}
-(void)nextButtonAction:(id)sender{
    
    [slideShowView nextImage];
}


#pragma mark - Datasource
-(NSUInteger)numberOfSectionsInSlideshow:(SLGSlideshowView*)slideShowView{
    
    return [_slideshowData count];
    
}
-(NSInteger)numberOfItems:(SLGSlideshowView*)slideShowView inSection:(NSUInteger)section{
    
    return [[_slideshowData objectAtIndex:section]count];
}
-(UIView*)viewForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    
    NSString* imageName = [[_slideshowData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    UIImage* img  = [UIImage imageNamed:imageName];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

-(NSTimeInterval)slideDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    
    // random time
    return arc4random()%4;
    
}
-(NSTimeInterval)transitionDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    // random time
    return (arc4random()%(4-1))+1;
    
}
-(NSUInteger)transitionStyleForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    
    
    //random style
    NSUInteger rIndex = arc4random()%[_transitionOptions count];
    return [[_transitionOptions objectAtIndex:rIndex]integerValue];
    
}

#pragma mark - SlideShowDelegate
-(void)slideShowViewDidEnd:(SLGSlideshowView*)slideShowView willRepeat:(BOOL)willRepeat{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
-(void)slideShowView:(SLGSlideshowView*)slideShowView willDisplaySlideAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"%s: %i : %i",__PRETTY_FUNCTION__,indexPath.section,indexPath.row);
}
-(void)slideShowView:(SLGSlideshowView*)slideShowView didDisplaySlideAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"%s: %i : %i",__PRETTY_FUNCTION__,indexPath.section,indexPath.row);
}
-(void)slideShowView:(SLGSlideshowView*)slideShowView willBeginSection:(NSUInteger)section{
    NSLog(@"%s:%i",__PRETTY_FUNCTION__,section);
}
-(void)slideShowView:(SLGSlideshowView*)slideShowView didBeginSection:(NSUInteger)section{
    NSLog(@"%s:%i",__PRETTY_FUNCTION__,section);
    
}
-(void)slideShowViewDidPause:(SLGSlideshowView*)slideShowView{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
-(void)slideShowViewDidResume:(SLGSlideshowView*)slideShowView{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
#pragma mark
#pragma mark - SEL Method
-(void)handleSingleFingerEvent:(UIGestureRecognizer *)gesture{
 
    
    if (_topBar.alpha == 0.0) {
        // fade in navigation
        
        [UIView animateWithDuration:0.4 animations:^{
            _topBar.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        
        [UIView animateWithDuration:0.4 animations:^{
            _topBar.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
