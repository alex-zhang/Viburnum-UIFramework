package com.viburnum.lang
{
	import com.viburnum.interfaces.IPluginComponent;
	
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	public interface ILangManager extends IEventDispatcher, IPluginComponent
	{
		function get locale():String;
		function set locale(value:String):void;
		
		function loadResourceModule(url:String, update:Boolean = true, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):IEventDispatcher;
		
		function addResourceBundle(resourceBundle:LangBundle):void;
		function removeResourceBundle(locale:String, bundleName:String):void;
		function removeResourceBundlesForLocale(locale:String):void;
		
		function update():void;
		
		function getLocales():Array; /* of String */
		
		function getBundleNamesForLocale(locale:String):Array /* of String */
		
		function initializeLocaleChain(locale:String, bundlesResourceChain:Object):void;
		
		function getObject(bundleName:String, resourceName:String, locale:String = null):*;
		function getString(bundleName:String, resourceName:String, parameters:Array = null, locale:String = null):String;
		function getStringArray(bundleName:String, resourceName:String, locale:String = null):Array; /* of String */
		function getNumber(bundleName:String, resourceName:String, locale:String = null):Number;
		function getInt(bundleName:String, resourceName:String, locale:String = null):int;
		function getUint(bundleName:String, resourceName:String, locale:String = null):uint;
		function getBoolean(bundleName:String, resourceName:String, locale:String = null):Boolean;
		function getClass(bundleName:String, resourceName:String, locale:String = null):Class;
	}
}
