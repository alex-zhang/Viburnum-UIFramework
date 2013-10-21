package com.viburnum.components
{
	import com.viburnum.components.baseClasses.RealLayoutGroupBase;
	import com.viburnum.layouts.VerticalLayout;

    public class VGroup extends RealLayoutGroupBase
    {
        public function VGroup()
        {
            super();
			
			layout = new VerticalLayout();
        }
		
		public function get paddingLeft():Number
		{
			return VerticalLayout(layout).paddingLeft;
		}
		
		[Inspectable(type="Number")]
		public function set paddingLeft(value:Number):void
		{
			VerticalLayout(layout).paddingLeft = value;
		}
		
		public function get paddingTop():Number
		{
			return VerticalLayout(layout).paddingTop;
		}
		
		[Inspectable(type="Number")]
		public function set paddingTop(value:Number):void
		{
			VerticalLayout(layout).paddingTop = value;
		}
		
		public function get paddingRight():Number
		{
			return VerticalLayout(layout).paddingRight;
		}
		
		[Inspectable(type="Number")]
		public function set paddingRight(value:Number):void
		{
			VerticalLayout(layout).paddingRight = value;
		}
		
		public function get paddingBottom():Number
		{
			return VerticalLayout(layout).paddingBottom;
		}
		
		[Inspectable(type="Number")]
		public function set paddingBottom(value:Number):void
		{
			VerticalLayout(layout).paddingBottom = value;
		}
		
		public function get gap():Number
		{
			return VerticalLayout(layout).gap;
		}
		
		[Inspectable(type="Number")]
		public function set gap(value:Number):void
		{
			VerticalLayout(layout).gap = value;
		}
		
		public function get horizontalAlign():String
		{
			return VerticalLayout(layout).horizontalAlign;
		}
		
		[Inspectable(type="String", enumeration="left, center, right", defaultValue="left")]
		public function set horizontalAlign(value:String):void
		{
			VerticalLayout(layout).horizontalAlign = value;
		}
		
		public function get verticalAlign():String
		{
			return VerticalLayout(layout).verticalAlign;
		}
		
		[Inspectable(type="String", enumeration="top, middle, bottom", defaultValue="top")]
		public function set verticalAlign(value:String):void
		{
			VerticalLayout(layout).verticalAlign = value;
		}
		
		public function get variableRowHeight():Boolean
		{
			return VerticalLayout(layout).variableRowHeight;
		}
		
		[Inspectable(type="Boolean")]
		public function set variableRowHeight(value:Boolean):void
		{
			VerticalLayout(layout).variableRowHeight = value; 
		}
		
		public function get rowHeight():Number
		{
			return VerticalLayout(layout).rowHeight;
		}
		
		[Inspectable(type="Number")]
		public function set rowHeight(value:Number):void
		{
			VerticalLayout(layout).rowHeight = value;
		}
    }
}