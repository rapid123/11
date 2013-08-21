//
//  MMDefaultsWrapper.h

//
//	Do not give this class a dependency to any controller or working classes.
//	It may have a dependency on model objects, if you can't figure out a better way.

#import <Foundation/Foundation.h>


@interface RBDefaultsWrapper : NSObject 
{

}

@property (nonatomic, readonly) NSString * currentUserName;
//@property (nonatomic, readonly) NSString * currentPassword;


+ (RBDefaultsWrapper *)standardWrapper;

- (void)updateUserName:(NSString *)newUserName;
-(void)updateFullName:(NSString *)newFullName;
//- (void)updatePassword:(NSString *)newPassword;
- (void)clearUserInformation;
-(NSString *)currentUserName;
-(NSString *)FBUserName;
//- (BOOL) isAnonymous;
-(void)lastuserLoggedIn:(NSString *)userName;
-(NSString *)lastuser ;

@end
