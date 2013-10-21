package com.viburnum.utils
{
	public final class UpdateAfterEventGloabalControlUtil
	{
		public static var allowUpdateAfterEvent:Boolean = false;
		
		public static var cutomControlFunction:Function = null;
		
		//here event must be MouseEvent or TimeEvent
		public static function requetsUpdateAfterEvent(event:*):void
		{
			if(!allowUpdateAfterEvent) return;
			
			if(cutomControlFunction == null || cutomControlFunction.call(null, event))
			{
				event.updateAfterEvent();
			}
		}
	}
}