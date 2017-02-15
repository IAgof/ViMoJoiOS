// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import UIKit;
@import CoreGraphics;
@import Foundation;
@import QuartzCore;
@import CoreMedia;
@import Photos;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

SWIFT_CLASS("_TtC14VideonaProject14AVQualityParse")
@interface AVQualityParse : NSObject
@property (nonatomic, copy) NSString * _Nonnull regularQuality;
@property (nonatomic, copy) NSString * _Nonnull mediumQuality;
@property (nonatomic, copy) NSString * _Nonnull goodQuality;
- (NSArray<NSString *> * _Nonnull)qualityToView;
- (NSString * _Nonnull)parseQualityToViewWithResolution:(NSString * _Nonnull)resolution;
- (NSString * _Nonnull)parseResolutionsToInteractorWithTextResolution:(NSString * _Nonnull)textResolution;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject17AVResolutionParse")
@interface AVResolutionParse : NSObject
- (NSArray<NSString *> * _Nonnull)resolutionsToView;
- (NSString * _Nonnull)parseResolutionToView:(NSString * _Nonnull)resolution;
- (NSString * _Nonnull)parseResolutionsToInteractor:(NSString * _Nonnull)textResolution;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class Project;
@class Video;

SWIFT_CLASS("_TtC14VideonaProject24AddVideoToProjectUseCase")
@interface AddVideoToProjectUseCase : NSObject
- (void)addWithVideoPath:(NSString * _Nonnull)videoPath title:(NSString * _Nonnull)title project:(Project * _Nonnull)project;
- (void)addWithVideo:(Video * _Nonnull)video position:(NSInteger)position project:(Project * _Nonnull)project;
- (void)updateVideoParamsWithProject:(Project * _Nonnull)project;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject5Media")
@interface Media : NSObject
@property (nonatomic) float audioLevel;
@property (nonatomic, copy) NSString * _Nonnull uuid;
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title mediaPath:(NSString * _Nonnull)mediaPath OBJC_DESIGNATED_INITIALIZER;
- (NSString * _Nonnull)getTitle;
- (void)setMediaTitle:(NSString * _Nonnull)title;
- (NSString * _Nonnull)getMediaPath;
- (void)setVideonaMediaPath:(NSString * _Nonnull)path;
- (double)getStartTime;
- (void)setStartTime:(double)time;
- (double)getStopTime;
- (void)setStopTime:(double)time;
- (double)getDuration;
- (double)getFileStopTime;
- (double)getFileStartTime;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC14VideonaProject5Audio")
@interface Audio : Media
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title mediaPath:(NSString * _Nonnull)mediaPath OBJC_DESIGNATED_INITIALIZER;
@end

@class NSCoder;
@class UIColor;

SWIFT_CLASS("_TtC14VideonaProject17AudioLevelBarView")
@interface AudioLevelBarView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)getAudioLevel;
- (void)setBarColor:(UIColor * _Nonnull)color;
@end


SWIFT_CLASS("_TtC14VideonaProject20BatteryRemainingView")
@interface BatteryRemainingView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (UIView * _Nonnull)loadViewFromNib;
- (void)updateValues;
@end


SWIFT_CLASS("_TtC14VideonaProject27CompatibleQualityInteractor")
@interface CompatibleQualityInteractor : NSObject
- (NSArray<NSString *> * _Nonnull)getCompatibleQuality;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject31CompatibleResolutionsInteractor")
@interface CompatibleResolutionsInteractor : NSObject
- (NSArray<NSString *> * _Nonnull)getCompatibleResolutions;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject19DuplicateInteractor")
@interface DuplicateInteractor : NSObject
@property (nonatomic, strong) Project * _Nullable project;
@property (nonatomic) float startTime;
@property (nonatomic) float stopTime;
@property (nonatomic, copy) NSURL * _Nullable mediaURL;
- (nonnull instancetype)initWithProject:(Project * _Nonnull)project OBJC_DESIGNATED_INITIALIZER;
- (void)setVideoPosition:(NSInteger)position;
- (void)setStartAndStopParams;
- (void)setDuplicateVideoToProject:(NSInteger)numberDuplicates;
- (void)add:(Video * _Nonnull)video position:(NSInteger)position;
- (void)getThumbnail:(CGRect)frame;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class UIImage;

SWIFT_CLASS("_TtC14VideonaProject18DuplicatePresenter")
@interface DuplicatePresenter : NSObject
@property (nonatomic) NSInteger numberOfDuplicates;
@property (nonatomic) BOOL isGoingToExpandPlayer;
- (void)viewDidLoad;
- (void)viewWillDissappear;
- (void)pushAcceptHandler;
- (void)pushCancelHandler;
- (void)pushBack;
- (void)pushLessClips;
- (void)pushPlusClips;
- (void)expandPlayer;
- (void)setThumbnail:(UIImage * _Nonnull)image;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject19ExpositionModesView")
@interface ExpositionModesView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)setAutoExposure;
- (void)tapViewPointAndViewFrame:(CGPoint)point frame:(CGRect)frame;
- (void)checkIfExposureManualSliderIsEnabled;
@end


@interface ExpositionModesView (SWIFT_EXTENSION(VideonaProject))
@end


SWIFT_CLASS("_TtC14VideonaProject12ExposureView")
@interface ExposureView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)rotateLabelsSlider;
@end


SWIFT_CLASS("_TtC14VideonaProject19FocalLensSliderView")
@interface FocalLensSliderView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)rotateLabelsSlider;
- (void)awakeFromNib;
- (void)rotateImagesSlider;
@end


@interface FocalLensSliderView (SWIFT_EXTENSION(VideonaProject))
@end


SWIFT_CLASS("_TtC14VideonaProject9FocusView")
@interface FocusView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)setAutoFocus;
- (void)tapViewPointAndViewFrame:(CGPoint)point frame:(CGRect)frame;
- (void)checkIfFocalLensIsEnabled;
@end

@class CIFilter;

SWIFT_CLASS("_TtC14VideonaProject36GetActualProjectAVCompositionUseCase")
@interface GetActualProjectAVCompositionUseCase : NSObject
@property (nonatomic) double compositionInSeconds;
- (NSArray<CIFilter *> * _Nonnull)getFiltersFromProject:(Project * _Nonnull)project;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class CALayer;

SWIFT_CLASS("_TtC14VideonaProject43GetActualProjectTextCALayerAnimationUseCase")
@interface GetActualProjectTextCALayerAnimationUseCase : NSObject
- (CALayer * _Nonnull)getCALayerAnimationWithProject:(Project * _Nonnull)project;
- (NSArray<CALayer *> * _Nonnull)getTextLayersAnimatedWithVideoList:(NSArray<Video *> * _Nonnull)videoList;
- (void)addAnimationToLayerWithOverlay:(CALayer * _Nonnull)overlay timeAt:(double)timeAt duration:(double)duration;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject21GetImageByTextUseCase")
@interface GetImageByTextUseCase : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject20ISOConfigurationView")
@interface ISOConfigurationView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)setAutoISO;
@end


SWIFT_CLASS("_TtC14VideonaProject25InputSoundGainControlView")
@interface InputSoundGainControlView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)rotateLabelsSlider;
@end


@interface InputSoundGainControlView (SWIFT_EXTENSION(VideonaProject))
- (void)setInputSoundGainControlValue:(float)value;
@end



SWIFT_CLASS("_TtC14VideonaProject5Music")
@interface Music : Audio
@property (nonatomic, copy) NSString * _Null_unspecified musicSelectedResourceId;
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title author:(NSString * _Nonnull)author iconResourceId:(NSString * _Nonnull)iconResourceId musicResourceId:(NSString * _Nonnull)musicResourceId musicSelectedResourceId:(NSString * _Nonnull)musicSelectedResourceId OBJC_DESIGNATED_INITIALIZER;
- (NSString * _Nonnull)getMusicTitle;
- (void)setMusicTitle:(NSString * _Nonnull)title;
- (NSString * _Nonnull)getAuthor;
- (void)setAuthor:(NSString * _Nonnull)author;
- (NSString * _Nonnull)getIconResourceId;
- (void)setIconResourceId:(NSString * _Nonnull)icon;
- (NSString * _Nonnull)getMusicResourceId;
- (void)setMusicResourceId:(NSString * _Nonnull)musicResource;
- (BOOL)getMusicStateSetOrNot;
- (void)setMusicStateSetOrNot:(BOOL)state;
- (void)setDefaultParameters;
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title mediaPath:(NSString * _Nonnull)mediaPath SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC14VideonaProject16PlayerInteractor")
@interface PlayerInteractor : NSObject
- (NSURL * _Nonnull)findVideosToPlay;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject10PlayerItem")
@interface PlayerItem : NSObject
- (void)setVideoURL:(NSURL * _Nonnull)movieURL;
- (NSURL * _Nonnull)getMovieURL;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class PlayerWireframe;
@class AVAudioMix;

SWIFT_CLASS("_TtC14VideonaProject15PlayerPresenter")
@interface PlayerPresenter : NSObject
@property (nonatomic, strong) PlayerWireframe * _Nullable wireframe;
@property (nonatomic) BOOL isPlaying;
- (void)createVideoPlayer:(NSURL * _Nonnull)videoURL;
- (void)layoutSubViews;
- (void)onVideoStops;
- (void)pauseVideo;
- (void)pushPlayButton;
- (void)videoPlayerViewTapped;
- (void)playPlayer;
- (void)updateSeekBar;
- (void)seekToTime:(float)time;
- (BOOL)isPlayingVideo;
- (void)setPlayerVolume:(float)level;
- (void)setPlayerMuted:(BOOL)state;
- (void)enablePlayerInteraction;
- (void)disablePlayerInteraction;
- (void)setAVSyncLayer:(CALayer * _Nonnull)layer;
- (void)removeFinishObserver;
- (void)setAudioMixWithAudioMix:(AVAudioMix * _Nonnull)value;
- (void)removePlayer;
- (void)timeLabelsWithIsHidden:(BOOL)state;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject14PlayerProvider")
@interface PlayerProvider : NSObject
- (NSArray<NSURL *> * _Nonnull)getMovieList;
- (NSURL * _Nonnull)getTestVideo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class AVPlayer;
@class AVMutableComposition;
@class AVMutableVideoComposition;
@class UIButton;

SWIFT_CLASS("_TtC14VideonaProject10PlayerView")
@interface PlayerView : UIView
@property (nonatomic, strong) AVPlayer * _Nullable player;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified playOrPauseButton;
+ (UIView * _Nonnull)instanceFromNib;
- (void)awakeFromNib;
- (void)setPlayerMovieComposition:(AVMutableComposition * _Nonnull)composition;
- (void)setPlayerAudioMix:(AVAudioMix * _Nonnull)audioMix;
- (void)setPlayerVideoComposition:(AVMutableVideoComposition * _Nonnull)videoComposition;
- (void)layoutSubviews;
- (void)updateLayers;
- (UIView * _Nonnull)getView;
- (void)removeSubviews;
- (void)createVideoPlayer;
- (void)createVideoPlayerByPath:(NSURL * _Nonnull)videoURL;
- (void)updateSeekBarOnUI;
- (void)setViewPlayerTappable;
- (void)initSeekEvents SWIFT_METHOD_FAMILY(none);
- (void)videoPlayerViewTapped;
- (IBAction)pushPlayButton:(id _Nonnull)sender;
- (void)sliderBeganTracking;
- (void)sliderEndedTracking;
- (void)sliderValueChanged;
- (void)setUpVideoFinished;
- (void)onVideoStops;
- (void)pauseVideoPlayer;
- (void)playVideoPlayer;
- (void)seekToTime:(float)time;
- (void)setAVSyncLayer:(CALayer * _Nonnull)layer;
- (void)removeAVSyncLayers;
- (void)setAudioMixWithAudioMix:(AVAudioMix * _Nonnull)value;
- (void)setPlayerVolume:(float)level;
- (void)setPlayerMuted:(BOOL)state;
- (void)disableSliderAndInteractions;
- (void)enableSliderAndInteractions;
- (void)removeAudioMix;
- (void)removeVideoComposition;
- (void)removePlayer;
- (void)removeFinishObserver;
- (void)setTimeLabelsWithIsHidden:(BOOL)state;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIViewController;

SWIFT_CLASS("_TtC14VideonaProject15PlayerWireframe")
@interface PlayerWireframe : NSObject
@property (nonatomic, strong) PlayerPresenter * _Nullable playerPresenter;
@property (nonatomic, strong) PlayerView * _Nullable presentedView;
- (void)presentPlayerInterfaceFromViewController:(UIViewController * _Nonnull)viewController;
- (PlayerPresenter * _Nonnull)getPlayerPresenter;
- (PlayerView * _Nonnull)playerView;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject7Profile")
@interface Profile : NSObject
@property (nonatomic) NSInteger frameRate;
- (nonnull instancetype)initWithResolution:(NSString * _Nonnull)resolution videoQuality:(NSString * _Nonnull)videoQuality frameRate:(NSInteger)frameRate OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (NSString * _Nonnull)getResolution;
- (void)setResolution:(NSString * _Nonnull)resolution;
- (NSString * _Nonnull)getQuality;
- (void)setQuality:(NSString * _Nonnull)quality;
@end

@class NSDate;
@class CIColor;

SWIFT_CLASS("_TtC14VideonaProject7Project")
@interface Project : NSObject
@property (nonatomic) BOOL isMusicSet;
@property (nonatomic, copy) NSArray<Audio *> * _Nonnull voiceOver;
@property (nonatomic, readonly) BOOL isVoiceOverSet;
@property (nonatomic) float projectOutputAudioLevel;
@property (nonatomic) double transitionTime;
@property (nonatomic, copy) NSString * _Nonnull uuid;
@property (nonatomic, strong) NSDate * _Nullable modificationDate;
@property (nonatomic, strong) NSDate * _Nullable exportDate;
@property (nonatomic, strong) CIFilter * _Nullable videoFilter;
@property (nonatomic, strong) CIColor * _Nonnull transitionColor;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title rootPath:(NSString * _Nonnull)rootPath profile:(Profile * _Nonnull)profile OBJC_DESIGNATED_INITIALIZER;
- (id _Nonnull)copyWithZone:(struct _NSZone * _Nullable)zone;
- (void)reloadProjectWithProject:(Project * _Nonnull)project;
- (NSString * _Nonnull)getTitle;
- (void)setTitle:(NSString * _Nonnull)title;
- (NSString * _Nonnull)getProjectPath;
- (void)setProjectPath:(NSString * _Nonnull)projectPath;
- (Profile * _Nonnull)getProfile;
- (void)setProfile:(Profile * _Nonnull)profile;
- (double)getDuration;
- (void)setDuration:(double)duration;
- (void)clear;
- (NSInteger)numberOfClips;
- (void)setVideoList:(NSArray<Video *> * _Nonnull)list;
- (NSArray<Video *> * _Nonnull)getVideoList;
- (void)setExportedPathWithPath:(NSString * _Nullable)path;
- (NSString * _Nullable)getExportedPath;
- (void)setMusic:(Music * _Nonnull)music;
- (Music * _Nonnull)getMusic;
- (void)updateModificationDate;
- (void)reorderVideoList;
@end


SWIFT_CLASS("_TtC14VideonaProject23ResolutionsSelectorView")
@interface ResolutionsSelectorView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)awakeFromNib;
- (void)setResolutionAtInit:(NSString * _Nonnull)resolution;
@end

@class UITableView;
@class UITableViewCell;

@interface ResolutionsSelectorView (SWIFT_EXTENSION(VideonaProject)) <UITableViewDelegate, UIScrollViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end


SWIFT_CLASS("_TtC14VideonaProject15SpaceOnDiskView")
@interface SpaceOnDiskView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)updateValues;
@end


SWIFT_CLASS("_TtC14VideonaProject15SplitInteractor")
@interface SplitInteractor : NSObject
@property (nonatomic, strong) Project * _Nullable project;
- (nonnull instancetype)initWithProject:(Project * _Nonnull)project OBJC_DESIGNATED_INITIALIZER;
- (void)setVideoPosition:(NSInteger)position;
- (void)getVideoParams;
- (void)setSplitVideosToProject:(double)splitTime;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC14VideonaProject14SplitPresenter")
@interface SplitPresenter : NSObject
@property (nonatomic) BOOL isMovingByPlayer;
@property (nonatomic) BOOL isGoingToExpandPlayer;
- (void)viewDidLoad;
- (void)viewWillDissappear;
- (void)pushAcceptHandler;
- (void)pushCancelHandler;
- (void)pushBack;
- (void)setSplitValue:(float)value;
- (void)updateSplitValueByPlayer:(float)value;
- (void)expandPlayer;
- (void)settSplitValue:(float)value;
- (void)setMaximumValue:(float)value;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;

SWIFT_CLASS("_TtC14VideonaProject19TimeNumberFormatter")
@interface TimeNumberFormatter : NSNumberFormatter
- (NSString * _Nullable)stringFromNumber:(NSNumber * _Nonnull)number;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject10TrackLayer")
@interface TrackLayer : CALayer
- (void)layoutSublayers;
- (void)drawInContext:(CGContextRef _Nonnull)ctx;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithLayer:(id _Nonnull)layer OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14VideonaProject14TrimInteractor")
@interface TrimInteractor : NSObject
@property (nonatomic, strong) Project * _Nullable project;
- (nonnull instancetype)initWithProject:(Project * _Nonnull)project OBJC_DESIGNATED_INITIALIZER;
- (void)setVideoPosition:(NSInteger)position;
- (void)getVideoParams;
- (void)setParametersOnVideoSelectedOnProjectList:(float)startTime stopTime:(float)stopTime;
- (void)setParametersOnVideoSelected:(float)startTime stopTime:(float)stopTime;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC14VideonaProject13TrimPresenter")
@interface TrimPresenter : NSObject
- (void)updateRangeVal;
- (void)seekToTimeInPlayer:(float)time;
- (void)updateVideoParams;
- (void)viewDidLoad;
- (void)viewWillDissappear;
- (void)pushAcceptHandler;
- (void)pushCancelHandler;
- (void)pushBack;
- (void)expandPlayer;
- (void)trimSliderEnded;
- (void)trimSliderBegan;
- (NSInteger)getVideoSelectedIndex;
- (void)setVideoSelectedIndex:(NSInteger)index;
- (void)setLowerValue:(float)value;
- (void)setUpperValue:(float)value;
- (void)setMaximumValue:(float)value;
- (void)updateParamsFinished;
- (void)updatePlayer;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIApplication (SWIFT_EXTENSION(VideonaProject))
@end


@interface UIDevice (SWIFT_EXTENSION(VideonaProject))
@property (nonatomic, readonly, copy) NSString * _Nonnull modelName;
@end


@interface UIImage (SWIFT_EXTENSION(VideonaProject))
@end


SWIFT_CLASS("_TtC14VideonaProject5Utils")
@interface Utils : NSObject
@property (nonatomic, readonly) NSInteger thumbnailEditorListDiameter;
@property (nonatomic, readonly, copy) NSString * _Nonnull udid;
- (double)getDoubleHourAndMinutes;
- (NSString * _Nonnull)giveMeTimeNow;
- (void)debugLog:(NSString * _Nonnull)logMessage;
- (NSString * _Nonnull)getUDID;
- (NSString * _Nonnull)getStringByKeyFromSettings:(NSString * _Nonnull)key;
- (NSString * _Nonnull)getStringByKeyFromShare:(NSString * _Nonnull)key;
- (NSString * _Nonnull)getStringByKeyFromIntro:(NSString * _Nonnull)key;
- (NSString * _Nonnull)getStringByKeyFromEditor:(NSString * _Nonnull)key;
- (NSString * _Nonnull)getStringByKeyFromProjectList:(NSString * _Nonnull)key;
- (NSString * _Nonnull)hourToString:(double)time;
- (NSString * _Nonnull)formatTimeToMinutesAndSeconds:(double)time;
- (void)delay:(double)delay closure:(void (^ _Nonnull)(void))closure;
- (void)removeFileFromURL:(NSURL * _Nonnull)URL;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class PHAsset;

SWIFT_CLASS("_TtC14VideonaProject5Video")
@interface Video : Media
@property (nonatomic, copy) NSURL * _Nonnull videoURL;
@property (nonatomic, strong) PHAsset * _Nonnull videoPHAsset;
@property (nonatomic, copy) NSString * _Nonnull textToVideo;
@property (nonatomic) NSInteger textPositionToVideo;
@property (nonatomic) float originAudioLevel;
@property (nonatomic) float secondAudioLevel;
- (nonnull instancetype)initWithTitle:(NSString * _Nonnull)title mediaPath:(NSString * _Nonnull)mediaPath OBJC_DESIGNATED_INITIALIZER;
- (id _Nonnull)copyWithZone:(struct _NSZone * _Nullable)zone;
- (void)mediaRecordedFinished;
- (void)setDefaultVideoParameters;
- (BOOL)getIsSplit;
- (void)setIsSplit:(BOOL)state;
- (NSInteger)getPosition;
- (void)setPosition:(NSInteger)position;
@end


SWIFT_CLASS("_TtC14VideonaProject14VideoThumbnail")
@interface VideoThumbnail : UICollectionViewCell
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class AVAsset;
@class UITouch;
@class UIEvent;

SWIFT_CLASS("_TtC14VideonaProject18VideonaRangeSlider")
@interface VideonaRangeSlider : UIControl
@property (nonatomic, strong) UIImage * _Nullable lowerSliderImage;
@property (nonatomic, strong) UIImage * _Nullable middleSliderImage;
@property (nonatomic, strong) UIImage * _Nullable upperSliderImage;
@property (nonatomic, strong) UIColor * _Nullable backgroundSliderColor;
@property (nonatomic, strong) UIColor * _Nullable middleSliderColor;
@property (nonatomic, strong) UIColor * _Nullable untrackedAreaColor;
@property (nonatomic) CGFloat untrackedAreaHeight;
@property (nonatomic) CGFloat trackedAreaHeight;
@property (nonatomic) CGFloat thumbLayerHeight;
@property (nonatomic) CGFloat thumbLayerWidth;
@property (nonatomic) CGFloat middleThumbLayerHeight;
@property (nonatomic) CGFloat middleThumbLayerWidth;
@property (nonatomic) double middleValue;
@property (nonatomic, readonly) double actualValue;
@property (nonatomic) double minimumValue;
@property (nonatomic) double maximumValue;
@property (nonatomic) double lowerValue;
@property (nonatomic) double upperValue;
@property (nonatomic, strong) AVAsset * _Nullable videoAsset;
@property (nonatomic, readonly) double currentTime;
@property (nonatomic) CMTime rangeTime;
@property (nonatomic, strong) UIColor * _Nonnull sliderTintColor;
@property (nonatomic, strong) UIColor * _Nonnull untrackedAreaTintColor;
@property (nonatomic, strong) UIColor * _Null_unspecified middleThumbTintColor;
@property (nonatomic) CGRect frame;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)layoutSubviews;
- (BOOL)beginTrackingWithTouch:(UITouch * _Nonnull)touch withEvent:(UIEvent * _Nullable)event;
- (BOOL)continueTrackingWithTouch:(UITouch * _Nonnull)touch withEvent:(UIEvent * _Nullable)event;
- (void)endTrackingWithTouch:(UITouch * _Nullable)touch withEvent:(UIEvent * _Nullable)event;
@end


SWIFT_CLASS("_TtC14VideonaProject20VideonaTrackOverView")
@interface VideonaTrackOverView : UIView
@property (nonatomic, copy) NSArray<TrackLayer *> * _Nonnull trackLayers;
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent * _Nullable)event;
- (void)updateLayerFrames;
- (void)setTrackLayers;
- (void)setTrackedAreaViewWithLayer:(TrackLayer * _Nonnull)layer;
- (void)removeLayerFromPositionWithPosition:(NSInteger)position;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;
@class UICollectionViewLayout;
@class NSBundle;

SWIFT_CLASS("_TtC14VideonaProject27VideosGalleryViewController")
@interface VideosGalleryViewController : UICollectionViewController
@property (nonatomic, strong) PHFetchResult<PHAsset *> * _Null_unspecified videosAsset;
@property (nonatomic, copy) NSString * _Nonnull albumName;
@property (nonatomic, strong) UIColor * _Nullable cellColor;
@property (nonatomic) CGFloat cellSpacing;
@property (nonatomic, strong) IBOutlet UILabel * _Null_unspecified noPhotosLabel;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithCollectionViewLayout:(UICollectionViewLayout * _Nonnull)layout OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UICollectionView;

@interface VideosGalleryViewController (SWIFT_EXTENSION(VideonaProject))
- (void)collectionView:(UICollectionView * _Nonnull)collectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end


@interface VideosGalleryViewController (SWIFT_EXTENSION(VideonaProject))
- (void)fetchVideos;
@end


@interface VideosGalleryViewController (SWIFT_EXTENSION(VideonaProject))
- (void)getVideosSelectedURL:(void (^ _Nonnull)(NSArray<NSURL *> * _Nonnull))completion;
@end


@interface VideosGalleryViewController (SWIFT_EXTENSION(VideonaProject))
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
@end


@interface VideosGalleryViewController (SWIFT_EXTENSION(VideonaProject)) <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGFloat)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
@end


SWIFT_CLASS("_TtC14VideonaProject16WhiteBalanceView")
@interface WhiteBalanceView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)setAutoWB;
@end


SWIFT_CLASS("_TtC14VideonaProject14ZoomSliderView")
@interface ZoomSliderView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)rotateLabelsSlider;
@end


@interface ZoomSliderView (SWIFT_EXTENSION(VideonaProject))
@end


@interface ZoomSliderView (SWIFT_EXTENSION(VideonaProject))
- (void)setZoomSliderValue:(float)value;
- (void)setZoomWithPinchValues:(CGFloat)scale velocity:(CGFloat)velocity;
@end

#pragma clang diagnostic pop
