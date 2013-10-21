package com.viburnum.rsls
{
    import flash.events.IEventDispatcher;

	[event(name="rslItemComplete", type="com.viburnum.rsls.RSLEvent")]
	[event(name="rslItemProgress", type="com.viburnum.rsls.RSLEvent")]
	[event(name="rslError", type="com.viburnum.rsls.RSLEvent")]
	
    public interface IRSListItem extends IEventDispatcher
    {
        function get title():String;
        function get description():String;
        function get url():String;
		function get bytesLoaded():uint;
		function get bytesTotal():uint;
		function get loaded():Boolean;
		
        function load():void;
    }
}