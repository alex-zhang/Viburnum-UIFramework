package com.viburnum.managers
{
	import flash.display.DisplayObject;

	public interface ILayerChildrenManager
	{
		function addChildToLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject;
		function removeChildFromLayerByLayerName(child:DisplayObject, layerName:String):DisplayObject;
		
		function setSize(newWidth:Number, newHeight:Number):void;
	}
}