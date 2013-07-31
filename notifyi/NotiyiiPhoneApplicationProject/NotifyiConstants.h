//
//  NotifyiConstants.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//static int replayID = 1,replayAllID = 2, forwordID = 3;
//static int sentMsgID = 2,draftMsgId = 3, trashMsgID=4;

static NSString *regularFont = @"Eurostile";
static NSString *boldFont = @"Eurostile LT";



//Alert View Tags
#define noTag 0
#define reachabilityTag 1
#define invalidUsernameOrPasswordTag 2
#define parseErrorTag 3
#define deleteMessageTag 4
#define sentSuccessfullTag 5
#define deleteForeverTag 6
#define noSubjectTag 7
#define removeParticipentTag 8
#define sessionExpiryTag 9
#define deleteForeverSuccessAPITag 10
#define parseSuccessfullAPITag 11
#define noCommentTag 12
#define noDetailsTag 13
#define jsonErrorMsgTag 14

#define replayID 1
#define replayAllID 2
#define forwordID 3
#define sentMsgID 0
#define draftMsgId 2
#define trashMsgID 3
#define draftPassID 4
#define inboxMesgID 1

#define customNormal  12.0
#define nameFont  18.0
#define buttonFont 13.0
#define titleFont  15.0
#define customSmall  8.0
#define customMedium  10.0
#define customRegular  14.0

#define GreenBackGround_RedColor 0.0078431372f
#define GreenBackGround_GreenColor 0.48627450980392f
#define GreenBackGround_BlueColor 0.68627450980392f

#define GreyBackGround_RedColor 0.4f
#define GreyBackGround_GreenColor 0.4f
#define GreyBackGround_BlueColor 0.4f



#define LOGIN_FETCH_URL @"https://www.notifyistaging.com/ws/Login"
#define INBOX_FETCH_URL @"https://www.notifyistaging.com/WS/GetInbox"
#define TOUCHBASE_FETCH_URL @"https://www.notifyistaging.com/WS/touchBase"
#define DIRECTORY_FETCH_URL @"https://www.notifyistaging.com/WS/Directory"
#define MYPROFILE_FETCH_URL @"https://www.notifyistaging.com/WS/Myprofile"
#define COVERAGECALENDER_FETCH_URL @"https://www.notifyistaging.com/WS/CoverageCalendar"
#define READ_MESSAGE_URL @"https://www.notifyistaging.com/WS/ReadMessage"
#define READ_COMMENT_URL @"https://www.notifyistaging.com/WS/ReadComment"
#define READ_DISCUSSION_URL @"https://www.notifyistaging.com/WS/ReadDiscussion"
#define DELETE_MESSAGE_URL @"https://www.notifyistaging.com/WS/DeleteMessage"
#define COMPOSE_MESSAGE_URL @"https://www.notifyistaging.com/WS/ComposeMsg"
#define START_DISCUSSION_URL @"https://www.notifyistaging.com/WS/startDiscussion"
#define NEW_COMMENTS_URL @"https://www.notifyistaging.com/WS/NewComments"
#define ADD_PARTICIPANT_URL @"https://www.notifyistaging.com/WS/addPart"
#define REMOVE_PARTICIPANT_URL @"https://www.notifyistaging.com/WS/RemoveMe"
#define PUSHNOTIFICATION_URL @"https://www.notifyistaging.com/WS/PushNotification"
#define SINGLE_DIRECTORYDETAIL_URL  @"https://www.notifyistaging.com/WS/SingleDirectoryDetail"
//TouchBase Parsing Response Attribute strings
#define SERVICE_RESPONSE @"serviceResponse"
#define RESPONSE_CODE @"responseCode"
#define DETAILS @"details"
#define INBOX @"Inbox"
#define TOUCHBASE @"TouchBase"
#define MYPROFILE @"MyProfile"
#define DISCUSSIONID @"discussionId"
#define SUBJECT @"subject" 
#define COMMENTS @"Comments"
#define COMMENTID @"CommentId"
#define COMMENTDESCRIPTION @"CommentDescription"
#define COMMENTSTATUS @"CommentStatus"
#define COMMENTDATE @"CommentDate"
#define COMMENTPERSONNAME @"CommentPersonName"
#define COMMENTPERSONID @"commentPersonId"
#define PARTICIPANTS @"Participants"
#define COVERAGECALENDER @"CoverageCalendar"

#define PARTICIPANTID @"ParticipantId"
#define DISCUSSIONPARTICIPANTS @"DiscussionParticipants"
#define PARTICIPANTNAME @"ParticipantName"
#define DISCUSSIONDATE @"discussionDate"
#define TEXTDISCUSSION @"TextDiscussion"

#define PHYSICIANID @"physicianId"
#define PHYSICIANNAME @"physicianName"
#define PHYSICIANTHUMBNAIL @"physicianThumbnail"
#define PRACTICE @"practice"
#define SPECIALITY @"speciality"
#define PHONE @"phone"
#define CITY @"city"
#define STATE @"state"
#define STATUS @"status"

@interface NotifyiConstants : NSObject
{
   
    
}



@end
