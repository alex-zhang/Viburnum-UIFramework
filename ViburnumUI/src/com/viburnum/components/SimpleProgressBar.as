package com.viburnum.components
{
	import com.viburnum.components.baseClasses.RangeBase;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	[Style(name="trackSkin", type="Class", skinClass="true")]
	[Style(name="barSkin", type="Class", skinClass="true")]

	[Style(name="paddingLeft", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="paddingTop", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="paddingRight", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="paddingBottom", type="Number", invalidateSize="true", invalidateDisplayList="true")]

    public class SimpleProgressBar extends RangeBase
    {
		public var trackSkin:DisplayObject;
		public var barSkin:DisplayObject;

        public function SimpleProgressBar()
        {
            super();

			maximum = 100;
        }
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.sortDisplayObjectChildren(this, barSkin, trackSkin);
		}
		
		override protected function measure():void
		{
			super.measure();

			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var measuredW:Number = 0;
			var measuredH:Number = 0;
			
			var trackSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(trackSkin);
			var trackSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(trackSkin);
			
			var paddingW:Number = pl + pr;
			var paddingH:Number = pt + pb;
			
			measuredW += trackSkinMW + paddingW;
			measuredH += trackSkinMH + paddingH;
			
			setMeasuredSize(measuredW, measuredH);
			setMeasuredMinSize(trackSkinMW, paddingH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;

			var paddingw:Number = pl + pr;
			var paddingh:Number = pt + pb;
			
			LayoutUtil.setDisplayObjectSize(trackSkin, layoutWidth, layoutHeight);
			
			var barSkinLayoutW:Number = layoutWidth - paddingw;
			var barSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(barSkin);

			var barSkinW:Number = (value / maximum) * barSkinLayoutW;

			LayoutUtil.setDisplayObjectLayout(barSkin, pl, pt, barSkinW, barSkinMH);
		}
    }
}