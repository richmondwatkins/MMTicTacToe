//
//  ViewController.m
//  TicTacToe
//
//  Created by Richmond on 10/2/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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

    NSLog(@"================");
    NSLog(@"%@", tapInLabel);
    NSLog(@"================");

    if([self.whichPlayerLabel.text isEqualToString:@"X"]){
        tapInLabel.text = @"X";
        self.whichPlayerLabel.text = @"Y";
    }else{
        tapInLabel.text = @"Y";
        self.whichPlayerLabel.text = @"X";
    }



//    NSLog(@"%@", NSStringFromCGPoint(point));
//    NSLog(@"THE FRAME");
//    NSLog(@"%@", NSStringFromCGRect([self.labelOne frame]));
//    NSLog(@"ARRAY");
//    NSLog(@"%@", labelFrames);

}


-(UILabel *)findLabelUsingPoint: (CGPoint)point{
    NSArray *labelFrames = [NSArray arrayWithObjects: NSStringFromCGRect([self.labelOne frame]), NSStringFromCGRect([self.labelTwo frame]), NSStringFromCGRect([self.labelThree frame]), NSStringFromCGRect([self.labelFour frame]), NSStringFromCGRect([self.labelFive frame]), NSStringFromCGRect([self.labelSix frame]), NSStringFromCGRect([self.labelSeven frame]), NSStringFromCGRect([self.labelEight frame]), NSStringFromCGRect([self.labelNine frame]), nil];

    NSArray *allLabels = [NSArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];

//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    [dictionary setObject:@"String value" forKey:@"stringKey"];
//    [dictionary setObject:[NSNumber numberWithInt:25] forKey:@"numberKey"];
//    [dictionary setObject:array forKey:@"arrayKey"];


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


@end
