package com.viburnum.components
{
	import flash.events.IEventDispatcher;

	public interface IToolTipClient extends IEventDispatcher
	{
		function get toolTip():String;
		function set toolTip(value:String):void;
		
		function get toolTipEnable():Boolean;
		function set toolTipEnable(value:Boolean):void;
	}
}