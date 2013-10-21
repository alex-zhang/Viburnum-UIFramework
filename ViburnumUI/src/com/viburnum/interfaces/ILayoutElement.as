package com.viburnum.interfaces
{

	public interface ILayoutElement extends IVirburnumDisplayObject
	{
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		
		function get maxWidth():Number;
		function set maxWidth(value:Number):void;
		
		function get maxHeight():Number;
		function set maxHeight(value:Number):void;

		function get explicitWidth():Number;
		function get explicitHeight():Number;

		function get percentWidth():Number;
		function set percentWidth(value:Number):void;
		
		function get percentHeight():Number;
		function set percentHeight(value:Number):void;
		
		function get measuredWidth():Number;
		function get measuredHeight():Number;

		function get includeInLayout():Boolean;
		function set includeInLayout(value:Boolean):void;
	}
}