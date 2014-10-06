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
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@property NSArray *rowOne;
@property NSArray *rowTwo;
@property NSArray *rowThree;
@property NSArray *columnOne;
@property NSArray *columnTwo;
@property NSArray *columnThree;
@property NSArray *diagonalLeft;
@property NSArray *diagonalRight;
@property NSString *lastMove;
@property NSArray *labelFrames;
@property NSArray *allLabels;
@property int timeAmount;
@property NSTimer *gameTimer;
@property CGPoint gamePieceOriginalCenter;
@property NSArray *columnsAndRows;
@property UILabel *humanMove;
@property UILabel *twoHumanMovesAgo;
@property int moveNumber;
@property CGRect originalPosition;
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

    self.rowOne = [NSArray arrayWithObjects:self.labelOne, self.labelTwo, self.labelThree, nil];
    self.rowTwo = [NSArray arrayWithObjects:self.labelFour, self.labelFive, self.labelSix, nil];
    self.rowThree = [NSArray arrayWithObjects:self.labelSeven, self.labelEight, self.labelNine, nil];
    self.columnOne = [NSArray arrayWithObjects:self.labelOne, self.labelFour, self.labelSeven, nil];
    self.columnTwo = [NSArray arrayWithObjects:self.labelTwo, self.labelFive, self.labelEight, nil];
    self.columnThree = [NSArray arrayWithObjects:self.labelThree, self.labelSix, self.labelNine, nil];
    self.diagonalLeft = [NSArray arrayWithObjects:self.labelOne, self.labelFive, self.labelNine, nil];
    self.diagonalRight = [NSArray arrayWithObjects:self.labelThree, self.labelFive, self.labelSeven, nil];

    self.originalPosition = CGRectMake(self.whichPlayerLabel.frame.origin.x, self.whichPlayerLabel.frame.origin.y, self.whichPlayerLabel.frame.size.width, self.whichPlayerLabel.frame.size.height);                                                

    self.columnsAndRows = [NSArray arrayWithObjects:self.rowOne, self.rowTwo, self.rowThree, self.columnOne, self.columnTwo, self.columnThree, self.diagonalLeft, self.diagonalRight,  nil];

    self.gamePieceOriginalCenter = self.whichPlayerLabel.center;

    self.whichPlayerLabel.backgroundColor = [UIColor clearColor];
    [self setTimer];


}
- (void)updateLabelPreferredMaxLayoutWidthToCurrentWidth:(UILabel *)label
{
    label.preferredMaxLayoutWidth =
    [label alignmentRectForFrame:label.frame].size.width;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelOne];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelTwo];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelThree];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelFour];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelFive];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelSix];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelSeven];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelEight];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.labelNine];

    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.whichPlayerLabel];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.timerLabel];


    [self.view layoutSubviews];
}

-(void)setTimer
{
    self.timeAmount = 10;
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
}

-(void)runTimer:(NSTimer *)timer
{
    if (self.timeAmount == -1){
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
        self.twoHumanMovesAgo = self.humanMove;
        self.humanMove = tapInLabel;
        [self animateMove:tapInLabel];
    }
}

- (IBAction)dragGamePiece:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture translationInView:self.view];

    self.whichPlayerLabel.transform =CGAffineTransformMakeTranslation(point.x, point.y);

    if (panGesture.state == UIGestureRecognizerStateEnded) {
       UILabel *validMove =  [self findLabelUsingPoint:[panGesture locationInView:self.view] ];
        if (validMove) {
            validMove.text = @"X";
            validMove.textColor = [UIColor blueColor];
            [UIView animateWithDuration:0.5
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.whichPlayerLabel.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){
                                 if (finished) {
                                     self.twoHumanMovesAgo = self.humanMove;
                                     self.humanMove = validMove;
                                     [self nextMove:validMove];
                                 }
                             }];


        }
    }
}

-(void)resetGamePiece
{
    [UIView animateWithDuration:0.5 animations:^{
        self.whichPlayerLabel.transform = CGAffineTransformIdentity;
    }];
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
            self.lastMove = @"X";
            self.whichPlayerLabel.text = @"O";
            self.whichPlayerLabel.textColor = [UIColor redColor];
        }else{
            self.lastMove = @"O";
            self.whichPlayerLabel.text = @"X";
            self.whichPlayerLabel.textColor = [UIColor blueColor];
        }

        self.moveNumber += 1;
        [self whoWon:movedToLabel];
        [self.gameTimer invalidate];
        [self setTimer];

}

-(void)animateMove:(UILabel *)compMove{

    [UIView animateWithDuration:0.5 animations:^{
        self.whichPlayerLabel.frame = CGRectMake(self.whichPlayerLabel.frame.origin.x, self.whichPlayerLabel.frame.origin.y, self.whichPlayerLabel.frame.size.width, self.whichPlayerLabel.frame.size.height); // 200 is considered to be center
        self.whichPlayerLabel.alpha = 1;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{
            self.whichPlayerLabel.frame = CGRectMake(compMove.frame.origin.x, compMove.frame.origin.y, compMove.frame.size.width, compMove.frame.size.height); // 400 is considered to be bottom somewhere
        }completion:^(BOOL finished){
            if ([self.whichPlayerLabel.text isEqualToString:@"X"]) {
                compMove.text = @"X";
                compMove.textColor = [UIColor blueColor];
            }else{
                compMove.text = @"O";
                compMove.textColor = [UIColor redColor];
            }

            [UIView animateWithDuration:0.5 animations:^{
                self.whichPlayerLabel.frame = self.originalPosition;
            }completion:^(BOOL finished){
                [self nextMove:compMove];
             }];
        }];
    }];

}

-(UILabel *)findLabelUsingPoint:(CGPoint)labelPosition
{
    for (NSString *cgRect in self.labelFrames){
        if(CGRectContainsPoint(CGRectFromString(cgRect), labelPosition)){
            for (UILabel *label in self.allLabels) {
                if(CGRectEqualToRect([label frame], CGRectFromString(cgRect)) && [label.text isEqualToString:@""]){
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
        NSArray *columnOrRowOfLastMove = [self findColumnOrRowOfMove:self.humanMove.frame];
        NSArray *allEmptyPossMoves;
        NSMutableArray *computerWinningMove = [self checkForWinningMove:@"O"];
        NSMutableArray *humanWinningMove = [self checkForWinningMove:@"X"];

        UILabel *middle = [self isMiddleOpen];

        NSArray *checkForTrap = [self checkForHumanCornerTrap];

        if (self.moveNumber == 4 && [self.labelFive.text isEqualToString:@"X"] && [self.labelThree.text isEqualToString:@"X"]) {
            [self animateMove:self.labelOne];

        }else if([self.labelFive.text isEqualToString:@"O"] && [self.labelSeven.text isEqualToString:@"X"] && [self.labelThree.text isEqualToString:@"X"] && self.moveNumber == 4){
            [self animateMove:self.labelEight];
        }else if(self.moveNumber == 2 && [self.labelFive.text isEqualToString:@"X"]){
            [self animateMove:self.labelSeven];
        }else if(checkForTrap){
            uint32_t rnd = arc4random_uniform([checkForTrap count]);
            UILabel *randomLabel = [checkForTrap objectAtIndex:rnd];
            [self animateMove:randomLabel];
        }else if(computerWinningMove.count){
            [self animateMove:computerWinningMove[0]];
        }else if(humanWinningMove){
            [self animateMove:humanWinningMove[0]];
        }else if(middle){
            [self animateMove:middle];
        }else{
            if(!columnOrRowOfLastMove){
            allEmptyPossMoves = [self findAllEmptyLabels];
                if (!allEmptyPossMoves) {
                    [self alertFullBoard];
                }
            }else{
                allEmptyPossMoves = [self returnAllEmptyPossibleComputerMoves:columnOrRowOfLastMove];
            }
            uint32_t rnd = arc4random_uniform([allEmptyPossMoves count]);
            UILabel *randomLabel = [allEmptyPossMoves objectAtIndex:rnd];
            [self animateMove:randomLabel];
        }

    }else{
        [self alertFullBoard];
    }

}

-(UILabel *)isMiddleOpen{
    if ([self.labelFive.text isEqualToString:@""]) {
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
                if ([move.text isEqualToString:@""]) {
                    [winningMoves addObject:move];
                }
            }
        }
    }

    if (winningMoves.count == 1) {
        return winningMoves;
    }else{
        return nil;
    }
}


-(NSMutableArray *)returnAllEmptyPossibleComputerMoves:(NSArray *)rowOrColOfHumanMove{
    BOOL needBlockingMove = NO;
    NSMutableArray *emptyLabels = [[NSMutableArray alloc] init];
    if (self.moveNumber == 4) {
        NSArray *firstRowOrCol = [self findColumnOrRowOfMove:self.twoHumanMovesAgo.frame];
        NSArray *secondRowOrCol = [self findColumnOrRowOfMove:self.humanMove.frame];
        NSArray *intersectionArrays = [NSArray arrayWithObjects:firstRowOrCol, secondRowOrCol, nil];
        for (NSArray *rowOrColArray in intersectionArrays) {
            for (NSArray *rowOrCol in rowOrColArray) {
                if ([rowOrCol isEqualToArray:self.rowOne] || [rowOrCol isEqualToArray:self.rowThree] || [rowOrCol isEqualToArray:self.columnOne] || [rowOrCol isEqualToArray:self.columnThree] ) {
                    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                    for (UILabel *tempLabel in rowOrCol) {
                        if ([tempLabel.text isEqualToString:@"X"]) {
                            [tempArray addObject:tempLabel];
                        }
                    }
                    if (tempArray.count == 1) {
                        needBlockingMove = YES;
                    }else{
                        needBlockingMove = NO;
                    }
                }
            }
        }
        BOOL columnRowIntersect = NO;
        if (needBlockingMove) {
            for (NSArray *rowOrCol in secondRowOrCol) {
                if (([rowOrCol isEqualToArray:self.rowOne] ||  [rowOrCol isEqualToArray:self.columnOne]) && [self.labelOne.text isEqualToString:@""]) {
                    for (NSArray *rowOrCol in firstRowOrCol) {
                        if (([rowOrCol isEqualToArray:self.rowOne] ||  [rowOrCol isEqualToArray:self.columnOne]) && [self.labelOne.text isEqualToString:@""]) {
                            columnRowIntersect = YES;
                            [emptyLabels addObject:self.labelOne];
                        }
                    }
                }
            }
            for (NSArray *rowOrCol in secondRowOrCol) {
                if (([rowOrCol isEqualToArray:self.rowOne] ||  [rowOrCol isEqualToArray:self.columnThree]) && [self.labelThree.text isEqualToString:@""]) {
                    for (NSArray *rowOrCol in firstRowOrCol) {
                        if (([rowOrCol isEqualToArray:self.rowOne] ||  [rowOrCol isEqualToArray:self.columnThree]) && [self.labelThree.text isEqualToString:@""]) {
                            columnRowIntersect = YES;
                            [emptyLabels addObject:self.labelThree];
                        }
                    }
                }
            }
            for (NSArray *rowOrCol in secondRowOrCol) {
                if (([rowOrCol isEqualToArray:self.rowThree] ||  [rowOrCol isEqualToArray:self.columnOne]) && [self.labelSeven.text isEqualToString:@""]) {
                    for (NSArray *rowOrCol in firstRowOrCol) {
                        if (([rowOrCol isEqualToArray:self.rowThree] ||  [rowOrCol isEqualToArray:self.columnOne]) && [self.labelSeven.text isEqualToString:@""]) {
                            columnRowIntersect = YES;
                            [emptyLabels addObject:self.labelSeven];
                        }
                    }
                }
            }
            for (NSArray *rowOrCol in secondRowOrCol) {
                if (([rowOrCol isEqualToArray:self.rowThree] ||  [rowOrCol isEqualToArray:self.columnThree]) && [self.labelNine.text isEqualToString:@""]) {
                    for (NSArray *rowOrCol in firstRowOrCol) {
                        if (([rowOrCol isEqualToArray:self.rowThree] ||  [rowOrCol isEqualToArray:self.columnThree]) && [self.labelNine.text isEqualToString:@""]) {
                            columnRowIntersect = YES;
                            [emptyLabels addObject:self.labelNine];
                        }
                    }
                }
            }
        }
        if(!columnRowIntersect){
            for (NSArray *rowOrCol in rowOrColOfHumanMove) {
                for (UILabel *emptyLabel in rowOrCol) {
                    if ([emptyLabel.text isEqualToString:@""]) {
                        [emptyLabels addObject:emptyLabel];
                    }
                }
            }
            
        }

    }else{
        for (NSArray *rowOrCol in rowOrColOfHumanMove) {
            for (UILabel *emptyLabel in rowOrCol) {
                if ([emptyLabel.text isEqualToString:@""]) {
                    [emptyLabels addObject:emptyLabel];
                }
            }
        }

    }

    return emptyLabels;
}

-(NSMutableArray *)findColumnOrRowOfMove:(CGRect) moveFrame{
    NSMutableArray *arrayOfColsAndRows = [[NSMutableArray alloc]init];

    for (NSArray *colOrRow in self.columnsAndRows) {
        for (UILabel *label in colOrRow) {
            if(CGRectEqualToRect(label.frame, moveFrame)){
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
        if ([label.text isEqualToString:@""]) {
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
    self.timerLabel.text = @"";
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
