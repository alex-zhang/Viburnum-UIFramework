package com.viburnum.events
{
	import flash.events.Event;
	
	public class CloseEvent extends Event
	{
		public static const CLOSE:String = "close";

		public var detail:int;
		
		public function CloseEvent(type:String, bubbles:Boolean = false,
								   cancelable:Boolean = false, detail:int = -1)
		{
			super(type, bubbles, cancelable);
			
			this.detail = detail;
		}
		
		override public function clone():Event
		{
			return new CloseEvent(type, bubbles, cancelable, detail);
		}
	}
}
