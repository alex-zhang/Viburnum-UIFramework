package com.viburnum.components
{
	import com.viburnum.components.baseClasses.RealLayoutGroupBase;
	import com.viburnum.layouts.FlowLayout;

	public class FlowGroup extends RealLayoutGroupBase
	{
		public function FlowGroup()
		{
			layout = new FlowLayout();
		}
		
		public function get paddingLeft():Number
		{
			return FlowLayout(layout).paddingLeft;
		}
		
		[Inspectable(type="Number")]
		public function set paddingLeft(value:Number):void
		{
			FlowLayout(layout).paddingLeft = paddingLeft;
		}
		
		public function get paddingTop():Number
		{
			return FlowLayout(layout).paddingTop;
		}
		
		[Inspectable(type="Number")]
		public function set paddingTop(value:Number):void
		{
			FlowLayout(layout).paddingTop = paddingTop;
		}
		
		public function get paddingRight():Number
		{
			return FlowLayout(layout).paddingRight;
		}
		
		[Inspectable(type="Number")]
		public function set paddingRight(value:Number):void
		{
			FlowLayout(layout).paddingRight = paddingRight;
		}
		
		public function get paddingBottom():Number
		{
			return FlowLayout(layout).paddingBottom;
		}
		
		[Inspectable(type="Number")]
		public function set paddingBottom(value:Number):void
		{
			FlowLayout(layout).paddingBottom = value;
		}
		
		public function get horizontalGap():Number
		{
			return FlowLayout(layout).horizontalGap;
		}
		
		[Inspectable(type="Number")]
		public function set horizontalGap(value:Number):void
		{
			FlowLayout(layout).horizontalGap = value;
		}
		
		public function get verticalGap():Number
		{
			return FlowLayout(layout).verticalGap;
		}
		
		[Inspectable(type="Number")]
		public function set verticalGap(value:Number):void
		{
			FlowLayout(layout).verticalGap = value;
		}
	}
}