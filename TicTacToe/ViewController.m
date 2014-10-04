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
@property NSArray *labelFrames;
@property NSArray *allLabels;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property int timeAmount;
@property NSTimer *gameTimer;
@property CGPoint gamePieceOriginalCenter;
@property NSArray *columnsAndRows;
@property UILabel *humanMove;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.textColor = [UIColor blueColor];

    self.labelFrames =  [NSArray arrayWithObjects: NSStringFromCGRect(self.labelOne.frame), NSStringFromCGRect(self.labelTwo.frame), NSStringFromCGRect([self.labelThree frame]), NSStringFromCGRect(self.labelFour.frame), NSStringFromCGRect(self.labelFive.frame), NSStringFromCGRect(self.labelSix.frame), NSStringFromCGRect(self.labelSeven.frame), NSStringFromCGRect(self.labelEight.frame), NSStringFromCGRect(self.labelNine.frame), nil];

    self.allLabels = [NSArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil];

    NSArray *rowOne = [NSArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, nil];
    NSArray *rowTwo = [NSArray arrayWithObjects:self.labelFour, self.labelFive, self.labelSix, nil];
    NSArray *rowThree = [NSArray arrayWithObjects:self.labelSeven, self.labelEight, self.labelNine, nil];
    NSArray *columnOne = [NSArray arrayWithObjects:self.labelOne, self.labelFour, self.labelSeven, nil];
    NSArray *columnTwo = [NSArray arrayWithObjects:self.labelTwo, self.labelFive, self.labelEight, nil];
    NSArray *columnThree = [NSArray arrayWithObjects:self.labelThree, self.labelSix, self.labelNine, nil];
    NSArray *diagonalLeft = [NSArray arrayWithObjects:self.labelOne, self.labelFive, self.labelNine, nil];
    NSArray *diagonalRight = [NSArray arrayWithObjects:self.labelThree, self.labelFive, self.labelSeven, nil];

    self.columnsAndRows = [NSArray arrayWithObjects:rowOne, rowTwo, rowThree, columnOne, columnTwo, columnThree, diagonalLeft, diagonalRight,  nil];

    self.gamePieceOriginalCenter = self.whichPlayerLabel.center;
    
        [self setTimer];
}


-(void)setTimer
{
    self.timeAmount = 10;
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
}

-(void)runTimer:(NSTimer *)timer
{
    if (self.timeAmount == 0){
        if ([self.whichPlayerLabel.text isEqualToString:@"X"]) {
            self.whichPlayerLabel.text = @"O";
        }else{
            self.whichPlayerLabel.text = @"X";
        }
        [self.gameTimer invalidate];
        [self resetGamePiece];
        [self setTimer];
    }

    self.timerLabel.text = [NSString stringWithFormat:@"%i", self.timeAmount];
    self.timeAmount -= 1;
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)userTap
{

    CGPoint point = [userTap locationInView:self.view];

    UILabel *tapInLabel = [self findLabelUsingPoint:point];

    if (tapInLabel) {
        [self nextMove:tapInLabel];
    }

    [self whoWon:tapInLabel];

}

- (IBAction)dragGamePiece:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture translationInView:self.view];

    self.whichPlayerLabel.transform =CGAffineTransformMakeTranslation(point.x, point.y);

    if (panGesture.state == UIGestureRecognizerStateEnded) {
       UILabel *validMove =  [self checkForValidMove:[panGesture locationInView:self.view] ];
        if (validMove) {
            validMove.text = self.whichPlayerLabel.text;
            self.humanMove = validMove;
            [self whoWon:validMove];
            [self.gameTimer invalidate];
            [self setTimer];
        }
        [self resetGamePiece];
    }
}

-(void)resetGamePiece
{
    [UIView animateWithDuration:1.0 animations:^{
        self.whichPlayerLabel.transform = CGAffineTransformIdentity;
    }];
}

-(UILabel *)findLabelUsingPoint: (CGPoint)point
{
    for (NSString *cgRect in self.labelFrames){
        if(CGRectContainsPoint(CGRectFromString(cgRect), point)){
            for (UILabel *label in self.allLabels) {
                if(CGRectEqualToRect([label frame], CGRectFromString(cgRect))){
                    return label;
                }
            }
        }
    }
    return nil;
}

-(void)whoWon:(UILabel *)lastMovelabel
{
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.delegate = self;
    alertView.title = [NSString  stringWithFormat:@"%@ is the Winner!", lastMovelabel.text];
    [alertView addButtonWithTitle:@"Play Again!"];

    BOOL isWinner = NO;
    NSString *lMove = [NSString stringWithFormat:@"%@", lastMovelabel.text];
    for (NSArray *colOrRow in self.columnsAndRows) {
            UILabel *temp1 = colOrRow[0];
            UILabel *temp2 = colOrRow[1];
            UILabel *temp3 = colOrRow[2];
        if([temp1.text isEqualToString:lMove] && [temp2.text isEqualToString:lMove] && [temp3.text isEqualToString:lMove]){
            isWinner = YES;
            [alertView show];
            [self.gameTimer invalidate];
            [self resetBoard];
        }
    }

    if (!isWinner) {
        [self nextMove:lastMovelabel];
    }
}

-(void)nextMove:(UILabel *)movedToLabel
{
    if([self.whichPlayerLabel.text isEqualToString:@"X"]){
        movedToLabel.text = @"X";
        movedToLabel.textColor = [UIColor blueColor];
        self.lastMove = @"X";
        self.whichPlayerLabel.text = @"O";
        self.whichPlayerLabel.textColor = [UIColor redColor];
        [self computerMove];
    }else{
        movedToLabel.text = @"O";
        movedToLabel.textColor = [UIColor redColor];
        self.lastMove = @"O";
        self.whichPlayerLabel.text = @"X";
        self.whichPlayerLabel.textColor = [UIColor blueColor];
    }

}

-(UILabel *)checkForValidMove:(CGPoint)labelPosition
{
    for (NSString *cgRect in self.labelFrames){
        if(CGRectContainsPoint(CGRectFromString(cgRect), labelPosition)){
            for (UILabel *label in self.allLabels) {
                if(CGRectEqualToRect([label frame], CGRectFromString(cgRect))){
                    return label;
                }
            }
        }
    }

    return nil;
}

-(void)computerMove
{
    NSArray *columnOrRowOfLastMove = [self findColumnOrRowOfLastMove];

    NSArray *allEmptyPossMoves = [self returnAllEmptyPossibleComputerMoves:columnOrRowOfLastMove];

    uint32_t rnd = arc4random_uniform([allEmptyPossMoves count]);

    UILabel *randomLabel = [allEmptyPossMoves objectAtIndex:rnd];
    randomLabel.text = @"O";
    [self whoWon:randomLabel];
    [self.gameTimer invalidate];
    [self setTimer];

}

-(NSMutableArray *)returnAllEmptyPossibleComputerMoves:(NSArray *)rowOrColOfHumanMove{
    NSMutableArray *emptyLabels = [[NSMutableArray alloc] init];
    for (NSArray *rowOrCol in rowOrColOfHumanMove) {
        for (UILabel *emptyLabel in rowOrCol) {
            if ([emptyLabel.text isEqualToString:@" "]) {
                [emptyLabels addObject:emptyLabel];
            }
        }
    }
    return emptyLabels;
}

-(NSMutableArray *)findColumnOrRowOfLastMove{
    NSMutableArray *arrayOfColsAndRows = [[NSMutableArray alloc]init];

    for (NSArray *colOrRow in self.columnsAndRows) {
        for (UILabel *label in colOrRow) {
            if(CGRectEqualToRect(label.frame, self.humanMove.frame)){
                [arrayOfColsAndRows addObject:colOrRow];
            }
        }
    }

    if (arrayOfColsAndRows.count ) {
        return arrayOfColsAndRows;
    }
    return nil;
}

-(void)resetBoard
{
    self.timerLabel.text = @" ";
    self.labelOne.text = @" ";
    self.labelTwo.text = @" ";
    self.labelThree.text = @" ";
    self.labelFour.text = @" ";
    self.labelFive.text = @" ";
    self.labelSix.text = @" ";
    self.labelSeven.text = @" ";
    self.labelEight.text = @" ";
    self.labelNine.text = @" ";

    self.whichPlayerLabel.text = @"X";
    self.timerLabel.text = [NSString stringWithFormat:@"%i", 10];
    self.whichPlayerLabel.textColor = [UIColor blueColor];

}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setTimer];

}


-(IBAction) unwindFromSegue:(UIStoryboardSegue *)segue{

}

@end
