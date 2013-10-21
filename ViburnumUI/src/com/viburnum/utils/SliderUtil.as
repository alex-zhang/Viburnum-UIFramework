package com.viburnum.utils
{
	public final class SliderUtil
	{
		public static function thumbCenterPositionToValue(thumbCenterX:Number, thumbSize:Number, trackSize:Number, valueMinimum:Number, valueMaximum:Number):Number
		{
			var valueRange:Number = valueMaximum - valueMinimum;
			var trackRange:Number = trackSize - thumbSize;
			var halfThumbSize:Number = thumbSize / 2;

			var thumbCenterMinX:Number = halfThumbSize;
			var thumbCenterMaxX:Number = trackSize - halfThumbSize;
			
			if(thumbCenterX < thumbCenterMinX) thumbCenterX = thumbCenterMinX;
			if(thumbCenterX > thumbCenterMaxX) thumbCenterX = thumbCenterMaxX;
			
			var value:Number = 0;
			if(trackRange > 0)
			{
				value = (thumbCenterX - thumbCenterMinX) * valueRange / trackRange;
			}
			
			return valueMinimum + value;
		}

		public static function valueToThumbCenterPosition(value:Number, thumbSize:Number, trackSize:Number, valueMinimum:Number, valueMaximum:Number):Number
		{
			var valueRange:Number = valueMaximum - valueMinimum;
			var trackRange:Number = trackSize - thumbSize;
			var halfThumbSize:Number = thumbSize / 2;
			
			if(value < valueMinimum) value = valueMinimum;
			if(value > valueMaximum) value = valueMaximum;
			
			var x:Number = 0;
			if(valueRange > 0)
			{
				x = (value - valueMinimum) * trackRange / valueRange;
			}
			
			return x + halfThumbSize;
		}
		
		public static function pageSizeToThumbSize(pageSize:Number, trackSize:Number, minimum:Number, maximum:Number):Number
		{
			var valueRange:Number = maximum - minimum;
			return Math.min((pageSize / (valueRange + pageSize)) * trackSize, trackSize);
		}
	}
}