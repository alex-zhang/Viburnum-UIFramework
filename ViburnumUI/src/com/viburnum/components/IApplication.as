package com.viburnum.components
{
	import com.viburnum.managers.ILayerChildrenManager;
	import com.viburnum.interfaces.ILayoutElement;
	import com.viburnum.interfaces.IPluginComponent;
	import com.viburnum.interfaces.IPluginEntity;
	import com.viburnum.interfaces.IVirburnumDisplayObject;
	
	import flash.geom.Rectangle;
	
	public interface IApplication extends IUIComponent, 
		ILayoutElement, 
		IPluginComponent, 
		IPluginEntity, 
		IVirburnumDisplayObject,
		ILayerChildrenManager
	{
		function get screen():Rectangle;
		
		function lockContentInteraction():void;
		function unLockContentInteraction():void;
		
		function regenerateStyleCache(needUpdateSkinImmediately:Boolean):void;
	}
}