package com.viburnum.events
{
	import com.viburnum.components.IToolTip;
	
	import flash.events.Event;

	public class ToolTipEvent extends Event
	{
		public static const TOOL_TIP_CREATE:String = "toolTipCreate";
		public static const TOOL_TIP_DESTORY:String = "toolTipDestory";

		public var toolTip:IToolTip;
		public var tips:String;
		
		public function ToolTipEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
									 toolTip:IToolTip = null)
		{
			super(type, bubbles, cancelable);
			
			this.toolTip = toolTip;
		}
		
		override public function clone():Event
		{
			var event:ToolTipEvent = new ToolTipEvent(type, bubbles, cancelable, toolTip);
			event.tips = tips;
			return event;
		}
	}
	
}
