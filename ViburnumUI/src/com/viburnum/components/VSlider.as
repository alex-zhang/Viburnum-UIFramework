package com.viburnum.components
{
	import com.viburnum.components.baseClasses.SliderBase;
	import com.viburnum.utils.LayoutUtil;
	import com.viburnum.utils.SliderUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

    public class VSlider extends SliderBase
    {
        public function VSlider()
        {
			super();
        }
		
		override protected function getValueByThumbCenterPosition(thumbCenterX:Number, thumbCenterY:Number):Number
		{
			var thumbBtnSize:Number = _thumbButton.height;
			var trackBtnSize:Number = _trackButton.height;

			return SliderUtil.thumbCenterPositionToValue(thumbCenterY, thumbBtnSize, trackBtnSize, minimum, maximum);
		}
		
		override protected function getThumbCenterPositionByValue(value:Number):Number
		{
			var thumbBtnSize:Number = _thumbButton.height;
			var trackBtnSize:Number = _trackButton.height;
			
			return SliderUtil.valueToThumbCenterPosition(value, thumbBtnSize, trackBtnSize, minimum, maximum);
		}
		
		override protected function layoutDataTipPostion(dataTipTarget:DisplayObject, thumbBtnCenterPostion:Number):void
		{
			if(dataTipTarget == null) return;
			
			var appThumbCenterP:Point = this.localToGlobal(new Point(0, thumbBtnCenterPostion));
			appThumbCenterP = application.globalToLocal(appThumbCenterP);
			
			var appCompoentP:Point = this.localToGlobal(new Point(0, 0));
			appCompoentP = application.globalToLocal(appCompoentP);
			
			var dataTipSideoffset:Number = getStyle("dataTipSideoffset") || 0;
			
			var compontShowX:Number = appCompoentP.x;
			
			var dataTipTargetW:Number = dataTipTarget.width;
			var dataTipTargetH:Number = dataTipTarget.height;
			
			var dataTipTargetY:Number = appThumbCenterP.y - dataTipTargetH / 2;
			var dataTipTargetX:Number = compontShowX;
			//< 0 显示在左边,>0显示右边, 0 表示居中显示
			if(dataTipSideoffset < 0)
			{
				dataTipTargetX = compontShowX + dataTipSideoffset - dataTipTargetH;
			}
			else if(dataTipSideoffset > 0)
			{
				dataTipTargetX = compontShowX + this.width + dataTipSideoffset;
			}
			else//0 here
			{
				dataTipTargetX -= (dataTipTargetW - this.width) / 2;
			}
			
			LayoutUtil.ajustChildPostionInLimitShowArea(dataTipTarget, 
				dataTipTargetX, dataTipTargetY, 
				new Rectangle(0, 0, application.width, application.height));
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var trackButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_trackButton);
			var trackButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_trackButton);
			
			var thumbButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_thumbButton);
			
			var measuredW:Number = Math.max(trackButtonMW, thumbButtonMW);
			var measuredH:Number = trackButtonMH;
			
			setMeasuredSize(measuredW, measuredH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
		
			var trackButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_trackButton);
			
			LayoutUtil.setDisplayObjectLayout(_trackButton, 
				(layoutWidth - trackButtonMW) * 0.5, 0, trackButtonMW, layoutHeight);
			
			var thumbSize:Number = _thumbButton.height;
			var trackSize:Number = this.height;
			
			var thumbCenterX:Number = SliderUtil.valueToThumbCenterPosition(value, thumbSize, trackSize, minimum, maximum);
			var thumbBtnY:Number = thumbCenterX - thumbSize * 0.5;
			var thumbButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_thumbButton);
			var thumbCenteroffset:Number = getStyle("thumbCenteroffset") || 0;
			var thumbBtnX:Number = (layoutWidth - thumbButtonMW) * 0.5 + thumbCenteroffset;
			
			_thumbButton.move(thumbBtnX, thumbBtnY);
			
			var hightlightSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(hightlightSkin);
			var hightlightSkinSize:Number = SliderUtil.valueToThumbCenterPosition(value, 0, trackSize, minimum, maximum);
			
			LayoutUtil.setDisplayObjectLayout(hightlightSkin, 
				(layoutWidth - hightlightSkinMW) * 0.5, 0, hightlightSkinMW, hightlightSkinSize);
		}
    }
}