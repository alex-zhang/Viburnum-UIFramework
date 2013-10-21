package com.viburnum.components
{
	import flash.events.IEventDispatcher;

	public interface IButton extends IEventDispatcher
	{
		function get emphasized():Boolean;
		function set emphasized(value:Boolean):void;
	}
}