package com.viburnum.layouts
{
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	
	//不支持虚拟布局
	public class AbsoluteLayout extends LayoutBase
	{
		public function AbsoluteLayout()
		{
			super();
		}
		
		override protected function realMeasure():void
		{
			super.realMeasure();
			
			var measuredW:Number = 0;
			var measuredH:Number = 0;
			var minW:Number = 0;
			var minH:Number = 0;
			
			var child:DisplayObject = null;
			var n:uint = realLayoutHost.numLayoutElements;
			for(var i:uint = 0; i < n; i++)
			{
				child = realLayoutHost.getLayoutChildAt(i);
				var childIncludeLayout:Boolean = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;
				
				var childMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(child);
				var childMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(child);
				
				measuredW = Math.max(measuredW, childMW + child.x);
				measuredH = Math.max(measuredH, childMH + child.y);

				var childMinMW:Number = LayoutUtil.getDisplayObjectMinWidth(child);
				var childMinMH:Number = LayoutUtil.getDisplayObjectMinHeight(child);
				
				if(childMinMW != 0) childMinMW += child.x;
				if(childMinMH != 0) childMinMH += child.y;
				
				minW = Math.max(minW, childMinMW);
				minH = Math.max(minH, childMinMH);
			}
			
			LayoutUtil.setMeasuredSize(myLayoutHost, measuredW, measuredH);
			LayoutUtil.setMeasuredMinSize(myLayoutHost, minW, minH);
		}
		
		override protected function realUpdateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.realUpdateDisplayList(layoutWidth, layoutHeight);
			
			var child:DisplayObject = null;
			var n:int = realLayoutHost.numLayoutElements;
			for(var i:int = 0; i < n; i++)
			{
				child = realLayoutHost.getLayoutChildAt(i);
				var childIncludeLayout:Boolean = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;
				
				//default
				var childW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(child);
				var childH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(child);

				var percentInW:Number = LayoutUtil.getDisplayObjectPercentInWidth(child);
				if(!isNaN(percentInW))//百分比布局
				{
					var percentLayoutW:Number = layoutWidth - child.x;
					childW = LayoutUtil.calculatePercentSizeInFullSize(percentInW, percentLayoutW);
				}

				var percentInH:Number = LayoutUtil.getDisplayObjectPercentInHeight(child);
				if(!isNaN(percentInH))//百分比布局
				{
					var percentLayoutH:Number = layoutHeight - child.y;
					childH = LayoutUtil.calculatePercentSizeInFullSize(percentInH, percentLayoutH);
				}

				//受大小尺寸限制
				LayoutUtil.setDisplayObjectBoundsSize(child, childW, childH);
			}
		}
	}
}