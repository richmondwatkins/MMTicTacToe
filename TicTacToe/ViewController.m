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
@property int moveNumber;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moveNumber = 1;

    self.lastMove = @"X";
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
    
//    [self setTimer];
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
            self.lastMove = @"X";
            self.whichPlayerLabel.text = @"O";
            self.whichPlayerLabel.textColor = [UIColor redColor];
            [self computerMove];
        }else{
            self.whichPlayerLabel.text = @"X";
            self.whichPlayerLabel.textColor = [UIColor blueColor];
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
        self.humanMove = tapInLabel;
        [self nextMove:tapInLabel];
    }
}

- (IBAction)dragGamePiece:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture translationInView:self.view];

    self.whichPlayerLabel.transform =CGAffineTransformMakeTranslation(point.x, point.y);

    if (panGesture.state == UIGestureRecognizerStateEnded) {
       UILabel *validMove =  [self checkForValidMove:[panGesture locationInView:self.view] ];
        if (validMove) {
            self.humanMove = validMove;
            [self nextMove:validMove];
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
    alertView.title = [NSString  stringWithFormat:@"%@ is the Winner!", self.lastMove];
    [alertView addButtonWithTitle:@"Play Again!"];

    BOOL foundWinner = false;
    NSString *lMove = [NSString stringWithFormat:@"%@", self.lastMove];
    for (NSArray *colOrRow in self.columnsAndRows) {
            UILabel *temp1 = colOrRow[0];
            UILabel *temp2 = colOrRow[1];
            UILabel *temp3 = colOrRow[2];
        if([temp1.text isEqualToString:lMove] && [temp2.text isEqualToString:lMove] && [temp3.text isEqualToString:lMove]){
            [self.gameTimer invalidate];
            foundWinner = true;
            [alertView show];
        }
    }

    if(!foundWinner && [self.lastMove isEqualToString:@"X"]){
            [self computerMove];
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
        }else{
            movedToLabel.text = @"O";
            movedToLabel.textColor = [UIColor redColor];
            self.lastMove = @"O";
            self.whichPlayerLabel.text = @"X";
            self.whichPlayerLabel.textColor = [UIColor blueColor];
        }

        self.moveNumber += 1;
        [self whoWon:movedToLabel];
        [self.gameTimer invalidate];
        [self setTimer];

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
    if (![self isBoardFull]) {
        NSArray *columnOrRowOfLastMove = [self findColumnOrRowOfLastMove];
        NSArray *allEmptyPossMoves;
        NSMutableArray *computerWinningMove = [self checkForWinningMove:@"O"];
        NSMutableArray *humanWinningMove = [self checkForWinningMove:@"X"];

        UILabel *middle = [self isMiddleOpen];

        NSArray *checkForTrap = [self checkForHumanCornerTrap];

        if (checkForTrap) {
            uint32_t rnd = arc4random_uniform([checkForTrap count]);
            UILabel *randomLabel = [checkForTrap objectAtIndex:rnd];
            [self nextMove:randomLabel];
        }else{
            if (computerWinningMove) {
                [self nextMove:computerWinningMove[0]];
            }else{
                if (humanWinningMove) {
                    [self nextMove:humanWinningMove[0]];
                }else{
                    if(middle){
                        [self nextMove:middle];
                    }else{
                        if (!columnOrRowOfLastMove) {
                            allEmptyPossMoves = [self findAllEmptyLabels];
                            if (!allEmptyPossMoves) {
                                [self alertFullBoard];
                            }
                        }else{
                            allEmptyPossMoves = [self returnAllEmptyPossibleComputerMoves:columnOrRowOfLastMove];
                        }
                        uint32_t rnd = arc4random_uniform([allEmptyPossMoves count]);
                        UILabel *randomLabel = [allEmptyPossMoves objectAtIndex:rnd];
                        [self nextMove:randomLabel];
                        
                    }
                    
                }
                
            }
        }
    }else{
        [self alertFullBoard];
    }

}

-(UILabel *)isMiddleOpen{
    if ([self.labelFive.text isEqualToString:@" "]) {
        return self.labelFive;
    }else{
        return nil;
    }
}

-(NSArray *)checkForHumanCornerTrap{
    NSArray *correctMoves;
    if (self.moveNumber == 4 && [self.labelFive.text isEqualToString:@"O"]) {
        if ([self.labelOne.text isEqualToString:@"X"] && [self.labelNine.text isEqualToString:@"X"]) {
            correctMoves = [[NSArray alloc]  initWithObjects:self.labelTwo,self.labelFour, self.labelSix, self.labelEight, nil];
        }
        if ([self.labelThree.text isEqualToString:@"X"] && [self.labelSeven.text isEqualToString:@"X"]) {
            correctMoves = [[NSArray alloc]  initWithObjects:self.labelTwo,self.labelFour, self.labelSix, self.labelEight, nil];
        }
        return correctMoves;
    }
    return nil;
}

-(NSMutableArray *)checkForWinningMove:(NSString *)playerToCheck{
    NSMutableArray *winningMovesRowsOrCols = [[NSMutableArray alloc] init];
    for (NSArray *rowOrCol in self.columnsAndRows) {
        NSMutableArray *tempRowOrCol = [[NSMutableArray alloc] init];
        for (UILabel *label in rowOrCol) {
            if ([label.text isEqualToString:playerToCheck]) {

                [tempRowOrCol addObject:label];
            }
        }
        if (tempRowOrCol.count == 2) {

            [winningMovesRowsOrCols addObject:rowOrCol];
        }
    }

    NSMutableArray *winningMoves = [[NSMutableArray alloc] init];
    if (winningMovesRowsOrCols) {
        for (NSArray *moveArray in winningMovesRowsOrCols) {
            for (UILabel *move in moveArray) {
                if ([move.text isEqualToString:@" "]) {
                    [winningMoves addObject:move];
                }
            }
        }
    }

    if (winningMoves.count) {
        return winningMoves;
    }else{
        return nil;
    }
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

-(NSMutableArray *)findAllEmptyLabels
{
    NSMutableArray *emptyLabels = [[NSMutableArray alloc]init];

    for (UILabel *label in self.allLabels) {
        if ([label.text isEqualToString:@" "]) {
            [emptyLabels addObject:label];
        }
    }

    if (emptyLabels.count) {
        return emptyLabels;
    }

    return nil;
}

-(BOOL)isBoardFull{
    NSMutableArray *fullLabels = [[NSMutableArray alloc]init];

    for (UILabel *label in self.allLabels) {
        if ([label.text isEqualToString:@"X"] || [label.text isEqualToString:@"O"]) {
            [fullLabels addObject:label];
        }
    }

    if (fullLabels.count == 9) {
        return YES;
    } else{
        return NO;
    }
}

-(void)alertFullBoard{
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.delegate = self;
    alertView.title = @"It is a tie!";
    [alertView addButtonWithTitle:@"Play Again!"];
    [alertView show];
}

-(void)resetBoard
{
    self.moveNumber = 1;
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
    [self resetBoard];
    [self.gameTimer invalidate];
    [self setTimer];

}


-(IBAction) unwindFromSegue:(UIStoryboardSegue *)segue{

}

@end
