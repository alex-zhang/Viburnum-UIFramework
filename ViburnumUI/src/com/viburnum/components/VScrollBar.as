package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ScrollBarBase;
    import com.viburnum.utils.LayoutUtil;
    import com.viburnum.utils.SliderUtil;

    public class VScrollBar extends ScrollBarBase
    {
        public function VScrollBar()
        {
            super();
        }
		
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
		
			if(viewport != null)
			{
				viewport.verticalScrollPosition = value;
			}
		}

		override protected function getValueByThumbCenterPosition(thumbCenterX:Number, thumbCenterY:Number):Number
		{
			var thumbBtnSize:Number = _thumbButton.height;
			
			var decrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_decrementButton);
			var incrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_incrementButton);
			var trackBtnSize:Number = this.height - decrementButtonMH - incrementButtonMH;

			return SliderUtil.thumbCenterPositionToValue(thumbCenterY, thumbBtnSize, 
				trackBtnSize, minimum, maximum);
		}

		override protected function measure():void
		{
			super.measure();

			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_decrementButton);
			var decrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_decrementButton);

			var trackButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_trackButton);
			var trackButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_trackButton);
			
			var thumbButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_thumbButton);
			
			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_incrementButton);
			var incrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_incrementButton);
			
			var measuredW:Number = Math.max(decrementButtonMW, trackButtonMW, thumbButtonMW, incrementButtonMW);
			var measuredH:Number = decrementButtonMH + trackButtonMH + incrementButtonMH;

			setMeasuredSize(measuredW, measuredH);

			var minH:Number = Math.min(decrementButtonMH, incrementButtonMH);
			
			setMeasuredMinSize(0, minH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_decrementButton);
			var decrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_decrementButton);
			
			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_incrementButton);
			var incrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_incrementButton);
			
			var thumbButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_thumbButton);
			
			var trackSize:Number = layoutHeight - decrementButtonMH - incrementButtonMH;
			
			var trackButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_trackButton);
			
			LayoutUtil.setDisplayObjectLayout(_trackButton, 
				(layoutWidth - trackButtonMW) * 0.5, decrementButtonMH, trackButtonMW, trackSize);
			
			LayoutUtil.setDisplayObjectPosition(_decrementButton, 
				(layoutWidth - decrementButtonMW) * 0.5, 0);
			
			LayoutUtil.setDisplayObjectPosition(_incrementButton, 
				(layoutWidth - incrementButtonMW) * 0.5, layoutHeight - incrementButtonMH);
			
			//--
			
			var valueRange:Number = maximum - minimum;
			var thumbCenterX:Number = 0;
			var thumbSize:Number = trackSize;
			var isfixedThumbSize:Boolean = getStyle("fixedThumbSize");
			
			if(valueRange > 0)
			{
				if(isfixedThumbSize)
				{
					thumbSize = _thumbButton.height;
				}
				else
				{
					thumbSize = SliderUtil.pageSizeToThumbSize(pageSize, trackSize, 
						minimum, maximum);
					thumbSize = Math.max(_thumbButton.minHeight, thumbSize);
				}
			}
			
			if(!isfixedThumbSize)
			{
				LayoutUtil.setDisplayObjectSize(_thumbButton, thumbButtonMW, thumbSize);
			}
			
			var autoThumbVisibility:Boolean = getStyle("autoThumbVisibility");
			if (autoThumbVisibility)
			{
				_thumbButton.setVisible(thumbSize < trackSize);
			}
			
			thumbCenterX = SliderUtil.valueToThumbCenterPosition(value, thumbSize, trackSize, minimum, maximum);
			
			var thumbCenteroffset:Number = getStyle("thumbCenteroffset") || 0;
			var thumbBtnY:Number = decrementButtonMH + thumbCenterX - thumbSize * 0.5;
			var thumbBtnX:Number = (layoutWidth - thumbButtonMW) * 0.5 + thumbCenteroffset;
			
			LayoutUtil.setDisplayObjectPosition(_thumbButton, thumbBtnX, thumbBtnY);
		}
		
		override protected function updateMaximumAndPageSize():void
		{
			var vsp:Number = viewport == null ? 0 : viewport.verticalScrollPosition;
			var viewableHeight:Number = viewport == null ? 0 : viewport.viewableHeight;
			var viewportHeight:Number = viewport == null ? 0 : viewport.totalHeight;
			
			maximum = (viewableHeight == 0) ? vsp : viewportHeight - viewableHeight;
			pageSize = viewableHeight;
			
			super.updateMaximumAndPageSize();
		}
    }
}