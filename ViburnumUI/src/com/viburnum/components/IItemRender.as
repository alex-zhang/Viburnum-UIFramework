package com.viburnum.components
{
	import com.viburnum.interfaces.ILayoutElement;
	import com.viburnum.interfaces.IVirburnumDisplayObject;

	//IItemRenderer 必须是由显示对象实现
	public interface IItemRender extends ILayoutElement, IVirburnumDisplayObject
	{
		function get label():String;
		function set label(value:String):void;
		
		//--
		
		function get itemIndex():int;
		function set itemIndex(value:int):void;

		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		function get data():Object;
		function set data(value:Object):void;
	}
}
