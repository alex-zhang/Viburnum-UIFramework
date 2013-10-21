package com.viburnum.layouts
{
	import com.viburnum.interfaces.IViewport;
	
	import flash.display.DisplayObject;
	import com.viburnum.interfaces.ILayoutElement;

	public interface ILayoutHost extends IViewport, ILayoutElement
	{
		function get numLayoutElements():uint;
		
		function getLayoutChildAt(index:int):DisplayObject;

		function setMeasuredMinSize(newMeasuredMinWidth:Number, newMeasuredMinHeight:Number):void;
		function setMeasuredMaxSize(newMeasuredMaxWidth:Number, newMeasuredMaxHeight:Number):void;
		function setMeasuredSize(newMeasuredWidth:Number, newMeasuredHeight:Number):void;
	}
}