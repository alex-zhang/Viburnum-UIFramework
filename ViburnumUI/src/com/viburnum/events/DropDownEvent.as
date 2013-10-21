package com.viburnum.events
{
	import flash.events.Event
		
	public class DropDownEvent extends Event
	{
		public static const CLOSE:String = "close";
		public static const OPEN:String = "open";
		
		public function DropDownEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
