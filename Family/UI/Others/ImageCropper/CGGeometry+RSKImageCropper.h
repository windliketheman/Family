//
// CGGeometry+RSKImageCropper.h
//
// Copyright (c) 2015 Ruslan Skorb, http://ruslanskorb.com/
//


#import <CoreGraphics/CoreGraphics.h>
#import <tgmath.h>

// tgmath功能模块启用时不使用iOS。
//打开雷达——http://www.openradar.me/16744288
//解决这个重新定义在这里的东西.

#undef cos
#define cos(__x) __tg_cos(__tg_promote1((__x))(__x))

#undef sin
#define sin(__x) __tg_sin(__tg_promote1((__x))(__x))

#undef atan2
#define atan2(__x, __y) __tg_atan2(__tg_promote2((__x), (__y))(__x), \
__tg_promote2((__x), (__y))(__y))

#undef pow
#define pow(__x, __y) __tg_pow(__tg_promote2((__x), (__y))(__x), \
__tg_promote2((__x), (__y))(__y))

#undef sqrt
#define sqrt(__x) __tg_sqrt(__tg_promote1((__x))(__x))

#undef fabs
#define fabs(__x) __tg_fabs(__tg_promote1((__x))(__x))

#undef ceil
#define ceil(__x) __tg_ceil(__tg_promote1((__x))(__x))

#ifdef CGFLOAT_IS_DOUBLE
    #define RSK_EPSILON DBL_EPSILON
#else
    #define RSK_EPSILON FLT_EPSILON
#endif

// Line segments.
//行段
struct RSKLineSegment {
    CGPoint start;
    CGPoint end;
};
typedef struct RSKLineSegment RSKLineSegment;

// The "empty" point. This is the point returned when, for example, we
// intersect two disjoint line segments. Note that the null point is not the
// same as the zero point.
//“空”的观点。这是返回的点的时候,例如,我们
//两个不相交的线段相交。注意,不是空点
//与零点相同。
CG_EXTERN const CGPoint RSKPointNull;

// Returns the exact center point of the given rectangle.
//返回给定的矩形的中心点。
CGPoint RSKRectCenterPoint(CGRect rect);

// Returns the `rect` scaled around the `point` by `sx` and `sy`.
//返回的矩形的比例在“点”“sx”和“sy”。
CGRect RSKRectScaleAroundPoint(CGRect rect, CGPoint point, CGFloat sx, CGFloat sy);

// Returns true if `point' is the null point, false otherwise.
bool RSKPointIsNull(CGPoint point);

// Returns the `point` rotated around the `pivot` by `angle`.
CGPoint RSKPointRotateAroundPoint(CGPoint point, CGPoint pivot, CGFloat angle);

// Returns the distance between two points.
CGFloat RSKPointDistance(CGPoint p1, CGPoint p2);

// Make a line segment from two points `start` and `end`.
RSKLineSegment RSKLineSegmentMake(CGPoint start, CGPoint end);

// Returns the line segment rotated around the `pivot` by `angle`.
RSKLineSegment RSKLineSegmentRotateAroundPoint(RSKLineSegment lineSegment, CGPoint pivot, CGFloat angle);

// Returns the intersection of `ls1' and `ls2'. This may return a null point.
CGPoint RSKLineSegmentIntersection(RSKLineSegment ls1, RSKLineSegment ls2);
