//
//  RateViewController.m
//  Jidelnicek
//
//  Created by mik on 13.04.13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "RateViewController.h"

@interface RateViewController ()
{
    Reachability *internetReachableFoo;

}
@end

@implementation RateViewController

-(void) viewDidDisappear:(BOOL)animated{
    
     if (_rate.rating != _ratingData) {
         NSLog(@"Rating: %f %f", _rate.rating, _ratingData);
         NSString *url = @"http://akela.mendelu.cz/~xmuron1/jidelnicek/send_score.php";
         url = [NSString stringWithFormat:@"%@?id_food=%i&score=%f",url,[self.foodId integerValue],self.rate.rating];
         NSLog(@"%@",url);
         _receivedData = [[NSMutableData alloc] init];
         NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
         NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Internet is reachable
        internetReachableFoo.reachableBlock = ^(Reachability*reach)
        {
            // Update the UI on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                    [connection start];
            });
        };
        internetReachableFoo.unreachableBlock = ^(Reachability *reach)
             {
                 // Update the UI on the main thread
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"Internet neni dostupny");
                     
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No internet" message:@"Pro odeslani vaseho hodnoceni je potreba byt pripojen k internetu." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil, nil];
                     [alert show];
                     
                 });
             };
             
        [internetReachableFoo startNotifier];    
    
     }
    
    
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
    NSLog(@"%@",[[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding]);

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
    {
        [super viewDidLoad];

        self.rate.notSelectedImage = [UIImage imageNamed:@"hvezdy_empty.png"];
        self.rate.halfSelectedImage = [UIImage imageNamed:@"hvezdy_half.png"];
        self.rate.fullSelectedImage = [UIImage imageNamed:@"hvezdy_full.png"];
    
  //      self.rate.rating = 3;
        self.rate.rating = self.ratingData;
        #if DEBUG
            NSLog(@"Rating je %f a RatingDate je %f",self.rate.rating,self.ratingData);
        #endif
        self.rate.editable = YES;
        
        self.rate.maxRating = 5;
        self.rate.delegate = (id) self;
        [self rateView:_rate ratingDidChange:self.ratingData];
        
        self.foodLabel.text = self.foodLabelData;
        
        
        
    }
    
-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
        self.label.text = [NSString stringWithFormat:@"Hodnocení: %@", [NSString stringWithFormat:@"%0.0f",rating]];
}

-(void)didReceiveMemoryWarning
                                                                                                                                                                           
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
