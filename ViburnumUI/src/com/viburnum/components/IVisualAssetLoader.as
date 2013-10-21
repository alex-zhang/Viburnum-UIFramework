package com.viburnum.components
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.system.LoaderContext;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="init", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="open", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="unload", type="flash.events.Event")]
	[Event(name="uncaughtError", type="flash.events.UncaughtErrorEvent")]
	
	public interface IVisualAssetLoader extends IEventDispatcher
	{
		function get bytesLoaded():Number;
		function get bytesTotal():Number;
		function get percentLoaded():Number;
		
		function get loaderContext():LoaderContext;
		function set loaderContext(value:LoaderContext):void;
		
		function get maintainAspectRatio():Boolean;
		function set maintainAspectRatio(value:Boolean):void;

		function get scaleContent():Boolean;
		function set scaleContent(value:Boolean):void;

		function get smoothBitmapContent():Boolean;
		function set smoothBitmapContent(value:Boolean):void;
		
		function get content():DisplayObject;
		
		function get source():Object;
		function set source(value:Object):void;
		
		function load(url:Object = null):void;
	}
}