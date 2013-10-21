package com.viburnum.rsls
{
	import flash.events.IEventDispatcher;

	[event(name="rslComplete", type="com.viburnum.rsls.RSLEvent")]
	[event(name="rslProgress", type="com.viburnum.rsls.RSLEvent")]
	[event(name="rslError", type="com.viburnum.rsls.RSLEvent")]
	
	public interface IRSLsLoader extends IEventDispatcher
	{
		function load():void;
	}
}