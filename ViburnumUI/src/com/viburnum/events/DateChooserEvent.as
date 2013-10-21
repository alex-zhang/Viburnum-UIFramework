package com.viburnum.events
{
	import flash.events.Event;

	public class DateChooserEvent extends Event
	{
		public static const NEXT_MONTH_BUTTON_CLICK:String = "nextMonthButtonClick";
		public static const PREV_MONTH_BUTTON_CLICK:String = "prevMonthButtonClick";

		public static const NEXT_YEAR_BUTTON_CLICK:String = "nextYearButtonClick";
		public static const PREV_YEAR_BUTTON_CLICK:String = "prevYearButtonClick";

		public static const DATE_SELECTED:String = "dateSelected";
		public static const DATE_ROLL_OVER:String = "dateRollOver";
		
		public var date:uint = 0;
		public var year:uint = 0;
		public var month:uint = 0;
		
		public function DateChooserEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var event:DateChooserEvent = new DateChooserEvent(type, bubbles, cancelable);
			event.date = date;
			event.year = year;
			event.month = month;
			
			return event;
		}
	}
}