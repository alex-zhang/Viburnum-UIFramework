package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ScrollBarBase;
    import com.viburnum.utils.LayoutUtil;
    import com.viburnum.utils.SliderUtil;

    public class HScrollBar extends ScrollBarBase
    {
        public function HScrollBar()
        {
            super();
        }

		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			
			if(viewport != null) viewport.horizontalScrollPosition = value;
		}
		
		override protected function getValueByThumbCenterPosition(thumbCenterX:Number, thumbCenterY:Number):Number
		{
			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_decrementButton);
			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_incrementButton);

			var thumbBtnSize:Number = _thumbButton.width;
			var trackBtnSize:Number = this.width - decrementButtonMW - incrementButtonMW;
			
			return SliderUtil.thumbCenterPositionToValue(thumbCenterX, thumbBtnSize, trackBtnSize, minimum, maximum);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_decrementButton);
			var decrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_decrementButton);
			
			var trackButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_trackButton);
			var trackButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_trackButton);
			
			var thumbButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_thumbButton);
			
			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_incrementButton);
			var incrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_incrementButton);
			
			var measuredW:Number = decrementButtonMW + trackButtonMW + incrementButtonMW;
			var measuredH:Number = Math.max(decrementButtonMH, trackButtonMH, thumbButtonMH, incrementButtonMH);
			
			setMeasuredSize(measuredW, measuredH);

			var minW:Number = Math.max(decrementButtonMW, incrementButtonMW);
			setMeasuredMinSize(minW, 0);
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_decrementButton);
			var decrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_decrementButton);
			
			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_incrementButton);
			var incrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_incrementButton);

			var thumbButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_thumbButton);
			
			var trackSize:Number = layoutWidth - decrementButtonMW - incrementButtonMW;
			
			var trackButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_trackButton);
			
			LayoutUtil.setDisplayObjectLayout(_trackButton, 
				decrementButtonMW, (layoutHeight - trackButtonMH) * 0.5, 
				trackSize, trackButtonMH);
			
			LayoutUtil.setDisplayObjectPosition(_decrementButton, 
				0, (layoutHeight - decrementButtonMH) * 0.5);
			
			LayoutUtil.setDisplayObjectPosition(_incrementButton, 
				layoutWidth - incrementButtonMW, (layoutHeight - incrementButtonMH) * 0.5);

			//--
			
			var valueRange:Number = maximum - minimum;
			var thumbCenterX:Number = 0;
			var thumbSize:Number = trackSize;
			var isfixedThumbSize:Boolean = getStyle("fixedThumbSize");

			if(valueRange > 0)
			{
				if(isfixedThumbSize)
				{
					thumbSize = _thumbButton.width;
				}
				else
				{
					thumbSize = SliderUtil.pageSizeToThumbSize(pageSize, trackSize, minimum, maximum);
					thumbSize = Math.max(_thumbButton.minWidth, thumbSize);
				}
			}
			
			if(!isfixedThumbSize)
			{
				LayoutUtil.setDisplayObjectSize(_thumbButton, thumbSize, thumbButtonMH);
			}
			
			var autoThumbVisibility:Boolean = getStyle("autoThumbVisibility");
			if (autoThumbVisibility)
			{
				_thumbButton.setVisible(thumbSize < trackSize);
			}

			thumbCenterX = SliderUtil.valueToThumbCenterPosition(value, thumbSize, trackSize, minimum, maximum);
			
			var thumbCenteroffset:Number = getStyle("thumbCenteroffset") || 0;
			var thumbBtnY:Number = (layoutHeight - thumbButtonMH) * 0.5 + thumbCenteroffset;
			var thumbBtnX:Number = decrementButtonMW + thumbCenterX - thumbSize * 0.5;
			
			LayoutUtil.setDisplayObjectPosition(_thumbButton, thumbBtnX, thumbBtnY);
		}

		override protected function updateMaximumAndPageSize():void
		{
			var hsp:Number = viewport == null ? 0 : viewport.horizontalScrollPosition;
			var viewableWidth:Number = viewport == null ? 0 : viewport.viewableWidth;
			var viewportWidth:Number = viewport == null ? 0 : viewport.totalWidth;

			maximum = (viewableWidth == 0) ? hsp : viewportWidth - viewableWidth;
			pageSize = viewableWidth;
			
			super.updateMaximumAndPageSize();
		}
    }
}