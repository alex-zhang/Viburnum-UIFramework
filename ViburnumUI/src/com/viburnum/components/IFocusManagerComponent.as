package com.viburnum.components
{
	public interface IFocusManagerComponent
	{
		function get focusEnabled():Boolean;
//		function set focusEnabled(value:Boolean):void;

		function get hasFocusableChildren():Boolean;
//		function set hasFocusableChildren(value:Boolean):void;

		function get mouseFocusEnabled():Boolean;
//
		function get tabFocusEnabled():Boolean;

		function get tabIndex():int;
		function set tabIndex(value:int):void;

		function drawFocus(isFocused:Boolean):void;
	}
}
