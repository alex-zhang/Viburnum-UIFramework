package com.viburnum.interfaces
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 当用户没有任何操作的时间超过idleThreshold时间后便会以idleInterval间隔触发该事件.
	 */	
	[Event(name="idle", type="com.viburnum.events.IdleEvent")]
	
	/**
	 *  IInteractionMonitor是基于ISystemStage的鼠标和键盘输入并在捕获阶段进行的检测.
	 * 
	 * @author winnie
	 * 
	 */	
	public interface IInteractionMonitor extends IEventDispatcher, IPluginComponent
	{
		function get idleThreshold():uint;
		function set idleThreshold(value:uint):void;
		
		function get idleInterval():uint;
		function set idleInterval(value:uint):void;
		
		function get passedIdleTime():uint;
		function get stageIsActive():Boolean;
		
		/**
		 * 当前是否处于侦听开启状态.
		 * 
		 * @return 
		 * 
		 */		
		function get isListening():Boolean;
		
		/**
		 * 打开侦听.
		 * 
		 */		
		function open():void;
		
		/**
		 * 关闭侦听. 
		 * 
		 */		
		function close():void;
		
		/**
		 * 重置侦听. 
		 * 
		 */		
		function restart():void;
	}
}