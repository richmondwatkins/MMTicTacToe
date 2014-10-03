//
//  ViewController.m
//  TicTacToe
//
//  Created by Richmond on 10/2/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelOne;
@property (strong, nonatomic) IBOutlet UILabel *labelTwo;
@property (strong, nonatomic) IBOutlet UILabel *labelThree;
@property (strong, nonatomic) IBOutlet UILabel *labelFour;
@property (strong, nonatomic) IBOutlet UILabel *labelFive;
@property (strong, nonatomic) IBOutlet UILabel *labelSix;
@property (strong, nonatomic) IBOutlet UILabel *labelSeven;
@property (strong, nonatomic) IBOutlet UILabel *labelEight;
@property (strong, nonatomic) IBOutlet UILabel *labelNine;
@property (strong, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property NSString *lastMove;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];

}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)userTap {

    CGPoint point = [userTap locationInView:self.view];

    UILabel *tapInLabel = [self findLabelUsingPoint:point];

    if (tapInLabel) {
        if([self.whichPlayerLabel.text isEqualToString:@"X"]){
            tapInLabel.text = @"X";
            tapInLabel.textColor = [UIColor blueColor];
            self.lastMove = @"X";
            self.whichPlayerLabel.text = @"O";
            self.whichPlayerLabel.textColor = [UIColor redColor];
        }else{
            tapInLabel.text = @"O";
            tapInLabel.textColor = [UIColor redColor];
            self.lastMove = @"O";
            self.whichPlayerLabel.text = @"X";
            self.whichPlayerLabel.textColor = [UIColor blueColor];
        }
    }

   [self whoWon];

}


-(UILabel *)findLabelUsingPoint: (CGPoint)point{
    NSArray *labelFrames = [NSArray arrayWithObjects: NSStringFromCGRect([self.labelOne frame]), NSStringFromCGRect([self.labelTwo frame]), NSStringFromCGRect([self.labelThree frame]), NSStringFromCGRect([self.labelFour frame]), NSStringFromCGRect([self.labelFive frame]), NSStringFromCGRect([self.labelSix frame]), NSStringFromCGRect([self.labelSeven frame]), NSStringFromCGRect([self.labelEight frame]), NSStringFromCGRect([self.labelNine frame]), nil];

    NSArray *allLabels = [NSArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];

    for (NSString *cgRect in labelFrames){
        if(CGRectContainsPoint(CGRectFromString(cgRect), point)){
            for (UILabel *label in allLabels) {
                if(CGRectEqualToRect([label frame], CGRectFromString(cgRect))){
                    return label;
                }
            }
        }
    }
    return nil;
}

-(NSString *)whoWon{
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.delegate = self;
    alertView.title = [NSString  stringWithFormat:@"%@ is the Winner!", self.lastMove];
    [alertView addButtonWithTitle:@"Play Again!"];

    NSString *lMove = [NSString stringWithFormat:@"%@", self.lastMove];
    if ([self.labelOne.text isEqualToString:lMove] && [self.labelTwo.text isEqualToString:lMove] && [self.labelThree.text isEqualToString:lMove]) {
        [alertView show];
        [self resetBoard];
    }else if([self.labelOne.text isEqualToString:lMove] && [self.labelFour.text isEqualToString:lMove] && [self.labelSeven.text isEqualToString:lMove]){
        [alertView show];
        [self resetBoard];
    }else if([self.labelTwo.text isEqualToString:lMove] && [self.labelFive.text isEqualToString:lMove] && [self.labelEight.text isEqualToString:lMove]){
        [alertView show];
        [self resetBoard];
    }else if([self.labelThree.text isEqualToString:lMove] && [self.labelSix.text isEqualToString:lMove] && [self.labelNine.text isEqualToString:lMove]){
        [alertView show];
        [self resetBoard];
    }else if([self.labelOne.text isEqualToString:lMove] && [self.labelFive.text isEqualToString:lMove] && [self.labelNine.text isEqualToString:lMove]){
        [alertView show];
        [self resetBoard];
    }else if([self.labelThree.text isEqualToString:lMove] && [self.labelFive.text isEqualToString:lMove] && [self.labelSeven.text isEqualToString:lMove]){
        [alertView show];
        [self resetBoard];
    }else if([self.labelFour.text isEqualToString:lMove] && [self.labelFive.text isEqualToString:lMove] && [self.labelSix.text isEqualToString:lMove]){
        [alertView show];
        [self resetBoard];
    }else if([self.labelSeven.text isEqualToString:lMove] && [self.labelEight.text isEqualToString:lMove] && [self.labelNine.text isEqualToString:lMove]){
        [alertView show];
        [self resetBoard];
    }

    return nil;
}

-(void)resetBoard{
    self.labelOne.text = @"";
    self.labelTwo.text = @"";
    self.labelThree.text = @"";
    self.labelFour.text = @"";
    self.labelFive.text = @"";
    self.labelSix.text = @"";
    self.labelSeven.text = @"";
    self.labelEight.text = @"";
    self.labelNine.text = @"";

    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];
}

@end
