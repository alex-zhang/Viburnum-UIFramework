package com.viburnum.components
{

	public interface IMenuItemRenderer extends IItemRender
	{
		function get type():String;
		function set type(value:String):void;
		
		function get disabled():Boolean;
		function set disabled(value:Boolean):void;
		
		function get toggled():Boolean;
		function set toggled(value:Boolean):void;
		
		function get groupName():String;
		function set groupName(value:String):void;
		
		function get hasBranch():Boolean;
		function set hasBranch(value:Boolean):void;
	}
}