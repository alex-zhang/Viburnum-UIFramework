package com.viburnum.components
{
	import com.viburnum.components.baseClasses.RealLayoutGroupBase;
	import com.viburnum.layouts.HorizontalLayout;

    public class HGroup extends RealLayoutGroupBase
    {
        public function HGroup()
        {
            super();
			
			layout = new HorizontalLayout();
        }
		
		public function get paddingLeft():Number
		{
			return HorizontalLayout(layout).paddingLeft;
		}
		
		[Inspectable(type="Number")]
		public function set paddingLeft(value:Number):void
		{
			HorizontalLayout(layout).paddingLeft = value;
		}
		
		public function get paddingTop():Number
		{
			return HorizontalLayout(layout).paddingTop;
		}
		
		[Inspectable(type="Number")]
		public function set paddingTop(value:Number):void
		{
			HorizontalLayout(layout).paddingTop = value;
		}
		
		public function get paddingRight():Number
		{
			return HorizontalLayout(layout).paddingRight;
		}
		
		[Inspectable(type="Number")]
		public function set paddingRight(value:Number):void
		{
			HorizontalLayout(layout).paddingRight = value;
		}
		
		public function get paddingBottom():Number
		{
			return HorizontalLayout(layout).paddingBottom;
		}
		
		[Inspectable(type="Number")]
		public function set paddingBottom(value:Number):void
		{
			HorizontalLayout(layout).paddingBottom = value;
		}
		
		public function get gap():Number
		{
			return HorizontalLayout(layout).gap;
		}
		
		[Inspectable(type="Number")]
		public function set gap(value:Number):void
		{
			HorizontalLayout(layout).gap = value;
		}

		public function get horizontalAlign():String
		{
			return HorizontalLayout(layout).horizontalAlign;
		}
		
		[Inspectable(type="String", enumeration="left, center, right", defaultValue="left")]
		public function set horizontalAlign(value:String):void
		{
			HorizontalLayout(layout).horizontalAlign = value;
		}
		
		public function get verticalAlign():String
		{
			return HorizontalLayout(layout).verticalAlign;
		}
		
		[Inspectable(type="String", enumeration="top, middle, bottom", defaultValue="top")]
		public function set verticalAlign(value:String):void
		{
			HorizontalLayout(layout).verticalAlign = value;
		}
		
		public function get variableColumnWidth():Boolean
		{
			return HorizontalLayout(layout).variableColumnWidth;
		}
		
		[Inspectable(type="Number")]
		public function set variableColumnWidth(value:Boolean):void
		{
			HorizontalLayout(layout).variableColumnWidth = value; 
		}
		
		public function get columnWidth():Number
		{
			return HorizontalLayout(layout).columnWidth;
		}
		
		[Inspectable(type="Number")]
		public function set columnWidth(value:Number):void
		{
			HorizontalLayout(layout).columnWidth = value;
		}
    }
}