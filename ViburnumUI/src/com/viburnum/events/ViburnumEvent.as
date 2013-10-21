package com.viburnum.events
{
    import flash.events.Event;

    public class ViburnumEvent extends Event
    {
		public static const SHOW:String = "show";
		public static const HIDE:String = "hide";
		
		public static const PRE_INITIALIZE:String = "preInitialize";
		public static const INITIALIZE:String = "initialize";
		public static const INITIALIZE_COMPLETE:String = "initializeComplete";
		public static const CREATION_COMPLETE:String = "creationComplete";

		public static const VALUE_CHANGED:String = "valueChanged";
		public static const CURSOR_UPDATE:String = "cursorUpdate";
		
		public static const VIEWABLE_SIZE_CHANGED:String = "viewableSizeChanged";
		
		public var data:Object;
		
        public function ViburnumEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
		
		override public function clone():Event
		{
			var event:ViburnumEvent = new ViburnumEvent(type, bubbles, cancelable);
			event.data = data;
			return event;
		}
    }
}