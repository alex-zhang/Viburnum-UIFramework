package com.viburnum.events
{
	import flash.events.Event;

	public class MenuEvent extends ListEvent
	{
		public function MenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}