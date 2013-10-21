package com.viburnum.rsls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	internal class BasicRSLItemLoader extends EventDispatcher implements IRSListItem
	{
		protected var _title:String = "";
		protected var _description:String = "";
		protected var _url:String = "";
		protected var _bytesLoaded:uint = 0;
		protected var _bytesTotal:uint = 1;
		
		protected var _loaded:Boolean = false;
		
		public function BasicRSLItemLoader()
		{
			super();
		}
		
		//IRSListItem Interface
		public function get title():String
		{
			return _title;
		}
		
		public function get description():String
		{
			return _description;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		public function load():void
		{
		}
		
		//event handler
		protected function loadIOErrorHandler(event:IOErrorEvent):void
		{
		}
		
		protected function loadProgressHandler(event:ProgressEvent):void
		{
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
		}
	}
}