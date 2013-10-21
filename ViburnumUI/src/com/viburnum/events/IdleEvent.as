package com.viburnum.events
{
	import flash.events.Event;

	public class IdleEvent extends Event
	{
		public static const IDLE:String = "idle";
		public static const ACTIVED:String = "actived";
		public static const DEACTIVED:String = "deactived";
		
		public function IdleEvent(type:String)
		{
			super(type);
		}
	}
}