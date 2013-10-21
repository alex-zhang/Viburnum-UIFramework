package com.viburnum.components
{
	import com.viburnum.components.baseClasses.RealLayoutGroupBase;
	import com.viburnum.layouts.TileLayout;

    public class TileGroup extends RealLayoutGroupBase
    {
        public function TileGroup()
        {
            super();

			layout = new TileLayout()
        }
		
		public function get columnCount():int
		{
			return TileLayout(layout).columnCount;
		}
		
		[Inspectable(type="Number")]
		public function set columnCount(value:int):void
		{
			TileLayout(layout).columnCount = value;
		}
		
		public function get rowCount():int
		{
			return TileLayout(layout).rowCount;
		}
		
		[Inspectable(type="Number")]
		public function set rowCount(value:int):void
		{
			TileLayout(layout).rowCount = value;
		}
		
		public function get rowAlign():String
		{
			return TileLayout(layout).rowAlign;
		}
		
		[Inspectable(type="String", enumeration="left, center, right", defaultValue="left")]
		public function set rowAlign(value:String):void
		{
			TileLayout(layout).rowAlign = value;
		}
		
		public function get columnAlign():String
		{
			return TileLayout(layout).columnAlign;
		}
		
		[Inspectable(type="String", enumeration="top, middle, bottom", defaultValue="top")]
		public function set columnAlign(value:String):void
		{
			TileLayout(layout).columnAlign = value;
		}
    }
}