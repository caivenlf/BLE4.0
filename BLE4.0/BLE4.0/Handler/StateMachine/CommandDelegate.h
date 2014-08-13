//
//  CommandDelegate.h
//  StateMachine
//
//  Created by Vincent on 14-3-29.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CommandHeader{
    
    H2DR,H2DP,D2HR,D2HP
};
//H2DR Action
enum H2DRCommand{
    
    QueryServerStatus,ScanDV,StopScanDV,AddFriend,ShineDV,UpdateUserInfo,getDVID,UpdateSystem,ResetSetting,UpdateTime,UpdateDVName,UpdateMusic,FindDV,UpdateDialPlate,UpdateData,LimitNotify,GetSportData,ResetWatch,ChangeWatchUI
};
//H2DP Action
enum H2DPCommand{
    
    ServerAvaliable,serverBusy,ServerError,AcceptScanDV,AcceptStopScanDV,AcceptAddFriend,AcceptShineDV,AcceptUpdateUserInfo,AcceptDVID,AcceptUpdateTime,AcceptUpdateSystem,AcceptFindDV,AcceptUpdateDialPlate,AcceptMusicInfo,AcceptUpdateDVName,AcceptResetSetting,AcceptUpdateData,AcceptFilterData,AcceptSportDataBegin,AcceptResetWatch,AcceptChangeUI
};
//D2HR Action
enum D2HRCommand{
    
    ScanDVList,TakePicture,TakeVideo,StopVideo,TakeRecorder,PlayOrStopMusic,PlayNextSong,PlayForwardSong,GetMusicInfo,RefuseInCall,FindPhone,ForgetDevice,SendSportData
};
//D2HP Action
enum D2HPCommand{
    
    ScanDVListResponse,TakePictureResponse,TakeVideoResponse,StopVideoResponse,TakeRecordResponse,PlayMusicResponse,RefuseInCallResponse,FindPhoneResponse,PlayOrStopMusicResponse,PlayNextSongResponse,PlayForwardSongResponse,UpdateMusicResponse,GetSportDataResponse,ReceiveHealthDataResponse
};


//command delegate
@protocol CommandDelegate <NSObject>
@optional

-(void)receiveEventHappend:(enum D2HRCommand)event;

@end

//receive data delegate
@protocol WatchDataDelegate <NSObject>
@optional

- (void)receiveData:(NSData *)data;

@end

//Response delegate.
@protocol WatchResponsDelegate <NSObject>
@optional

- (void)eventHappened:(enum H2DPCommand)event;

@end
