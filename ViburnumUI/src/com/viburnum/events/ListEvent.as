package com.viburnum.events
{
	
	import com.viburnum.components.IItemRender;
	
	import flash.events.Event;

	public class ListEvent extends Event
	{
		public static const ITEM_RENDER_ROLL_OVER:String = "itemRenderRollOver";
		public static const ITEM_RENDER_ROLL_OUT:String = "itemRenderRollOut";
		public static const ITEM_RENDER_MOUSE_DOWN:String = "itemRenderMouseDown";
		public static const ITEM_RENDER_CLICK:String = "itemRenderClick";
		public static const ITEM_RENDER_DOUBLE_CLICK:String = "itemRenderDoubleClick";
		
		public var rowIndex:int = -1;
		public var columnIndex:int = -1;
		public var itemRender:IItemRender;

		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var event:ListEvent = new ListEvent(type, bubbles, cancelable);
			event.itemRender = itemRender;
			event.rowIndex = rowIndex;
			event.columnIndex = columnIndex;
			return event;
		}
	}
}