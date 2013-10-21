package com.viburnum.data
{
	import flash.events.IEventDispatcher;

	//该类会监测数据的变化并以事件的形式广播
	public interface IDataProvider extends IEventDispatcher
	{
		function get source():Object;
		function set source(data:Object):void;
	}
}