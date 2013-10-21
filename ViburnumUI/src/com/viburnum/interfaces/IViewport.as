package com.viburnum.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IViewport extends IEventDispatcher
	{
		function get viewableWidth():Number;
		function get viewableHeight():Number;
		
		function get totalWidth():Number;
		function get totalHeight():Number;

		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		function get horizontalMaxScrollPosition():Number;
		function get verticalMaxScrollPosition():Number;
		
		function get clipAndEnableScrolling():Boolean;
		function set clipAndEnableScrolling(value:Boolean):void;
		
		function getHorizontalScrollPositionDelta(navigationUnit:uint):Number;
		function getVerticalScrollPositionDelta(navigationUnit:uint):Number;
		
		function setViewableSize(newViewableWidth:Number, newViewableHeight:Number):void;
	}
}
