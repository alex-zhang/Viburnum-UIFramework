package com.viburnum.events
{
	import flash.events.Event;

	public dynamic class DynamicEvent extends Event
	{
		public function DynamicEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}