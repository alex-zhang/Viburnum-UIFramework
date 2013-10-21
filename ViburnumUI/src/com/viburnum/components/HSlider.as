package com.viburnum.components
{
    import com.viburnum.components.baseClasses.SliderBase;
    import com.viburnum.utils.LayoutUtil;
    import com.viburnum.utils.SliderUtil;
    
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class HSlider extends SliderBase
    {
        public function HSlider()
        {
            super();
        }

		override protected function measure():void
		{
			super.measure();

			var trackButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_trackButton);
			var trackButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_trackButton);
			
			var thumbButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_thumbButton);
			
			var measuredW:Number = trackButtonMW;
			var measuredH:Number = Math.max(thumbButtonMH, trackButtonMH);

			setMeasuredSize(measuredW, measuredH);
		}

		override protected function getValueByThumbCenterPosition(thumbCenterX:Number, thumbCenterY:Number):Number
		{
			var thumbBtnSize:Number = _thumbButton.width;
			var trackBtnSize:Number = _trackButton.width;
			
			return SliderUtil.thumbCenterPositionToValue(thumbCenterX, thumbBtnSize, trackBtnSize, minimum, maximum);
		}
		
		override protected function getThumbCenterPositionByValue(value:Number):Number
		{
			var thumbBtnSize:Number = _thumbButton.width;
			var trackBtnSize:Number = _trackButton.width;
			
			return SliderUtil.valueToThumbCenterPosition(value, thumbBtnSize, trackBtnSize, minimum, maximum);
		}

		override protected function layoutDataTipPostion(dataTipTarget:DisplayObject, thumbBtnCenterPostion:Number):void
		{
			if(dataTipTarget == null) return;

			var appThumbCenterP:Point = this.localToGlobal(new Point(thumbBtnCenterPostion, 0));
			appThumbCenterP = application.globalToLocal(appThumbCenterP);

			var appCompoentP:Point = this.localToGlobal(new Point(0, 0));
			appCompoentP = application.globalToLocal(appCompoentP);
			
			var dataTipSideoffset:Number = getStyle("dataTipSideoffset") || 0;
			
			var compontShowY:Number = appCompoentP.y;
			
			var dataTipTargetW:Number = dataTipTarget.width;
			var dataTipTargetH:Number = dataTipTarget.height;
			
			var dataTipTargetX:Number = appThumbCenterP.x - dataTipTargetW / 2;
			var dataTipTargetY:Number = compontShowY;
			
			//< 0 显示在上边,>0显示下边, 0 表示居中显示
			if(dataTipSideoffset < 0)
			{
				dataTipTargetY = compontShowY + dataTipSideoffset - dataTipTargetH;
			}
			else if(dataTipSideoffset > 0)
			{
				dataTipTargetY = compontShowY + this.height + dataTipSideoffset;
			}
			else//0 here
			{
				dataTipTargetY -= (dataTipTargetH - this.height) / 2;
			}
			
			LayoutUtil.ajustChildPostionInLimitShowArea(dataTipTarget, 
				dataTipTargetX, dataTipTargetY, 
				new Rectangle(0, 0, application.width, application.height));
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var trackButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_trackButton);

			LayoutUtil.setDisplayObjectLayout(_trackButton, 
				0, (layoutHeight - trackButtonMH) * 0.5, 
				layoutWidth, trackButtonMH);
			
			var thumbSize:Number = _thumbButton.width;
			var trackSize:Number = this.width;

			var thumbCenterX:Number = SliderUtil.valueToThumbCenterPosition(value, thumbSize, trackSize, minimum, maximum);
			var thumbBtnX:Number = thumbCenterX - thumbSize * 0.5;
			var thumbButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_thumbButton);
			var thumbCenteroffset:Number = getStyle("thumbCenteroffset") || 0;
			var thumbBtnY:Number = (layoutHeight - thumbButtonMH) * 0.5 + thumbCenteroffset;

			_thumbButton.move(thumbBtnX, thumbBtnY);

			var hightlightSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(hightlightSkin);
			var hightlightSkinSize:Number = SliderUtil.valueToThumbCenterPosition(value, 0, trackSize, minimum, maximum);

			LayoutUtil.setDisplayObjectLayout(hightlightSkin, 
				0, (layoutHeight - hightlightSkinMH) * 0.5, 
				hightlightSkinSize, hightlightSkinMH);
		}
    }
}