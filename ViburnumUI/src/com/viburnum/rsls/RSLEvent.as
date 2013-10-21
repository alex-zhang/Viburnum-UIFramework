package com.viburnum.rsls
{
    import flash.events.Event;
    import flash.events.ProgressEvent;

    public class RSLEvent extends ProgressEvent
    {
        //item
		public static const RSL_ITEM_COMPLETE:String = "rslItemComplete";
        public static const RSL_ITEM_PROGRESS:String = "rslItemProgress";

        //total
        public static const RSL_COMPLETE:String = "rslComplete";
        public static const RSL_PROGRESS:String = "rslProgress";
		public static const RSL_NEXT:String = "rslNext";
		
		public static const RSL_ERROR:String = "rslError";
		
		public var currentItemIndex:int = -1;
		public var totalItemsCount:int = -1;
		
		public var currentRSLItems:Array = null;
		
		public var subCurrentItemIndex:int = -1;
		public var subTotalItemsCount:int = -1;
        
        public function RSLEvent(type:String)
        {
            super(type);
        }
        
        override public function clone():Event
        {
            var event:RSLEvent = new RSLEvent(type);
			event.currentItemIndex = currentItemIndex;
			event.totalItemsCount = totalItemsCount;
			event.currentRSLItems = currentRSLItems;
			event.subCurrentItemIndex = subCurrentItemIndex;
			event.subTotalItemsCount = subTotalItemsCount;
			
            return event;
        }
    }
}