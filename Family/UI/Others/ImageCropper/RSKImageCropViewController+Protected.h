//
// RSKImageCropViewController+Protected.h
//
// Copyright (c) 2014-present Ruslan Skorb, http://ruslanskorb.com/
//

/**
 The methods in the RSKImageCropViewControllerProtectedMethods category
 typically should only be called by subclasses which are implementing new
 image crop view controllers. They may be overridden but must call super.
 
 RSKImageCropViewControllerProtectedMethods类别的方法
 通常只能被实施新的子类
 图像作物视图控制器。他们可能被覆盖,但必须调用super。
 */
@interface RSKImageCropViewController (RSKImageCropViewControllerProtectedMethods)

/**
 Asynchronously crops the original image in accordance with the current settings and tells the delegate that the original image will be / has been cropped.
 
 异步作物原始图像按照当前的设置和告诉委托,将原始图像/已经被裁剪。
 */
- (void)cropImage;

/**
 Tells the delegate that the crop has been canceled.
 
 告诉代理取消对原始图像的裁剪
 */
- (void)cancelCrop;

/**
 Resets the rotation angle, the position and the zoom scale of the original image to the default values.
 
 @param animated Set this value to YES to animate the reset.
 @参数设置这个值为YES以动画动画重置。
 */
- (void)reset:(BOOL)animated;

@end
