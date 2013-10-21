package com.viburnum.components
{
	import com.viburnum.managers.IFocusManager;
	
	import flash.events.IEventDispatcher;
	
	public interface IFocusManagerContainer extends IEventDispatcher
	{
		function get focusManager():IFocusManager;
		function set focusManager(value:IFocusManager):void;
		
		function get defaultButton():IButton;
		function set defaultButton(value:IButton):void;
	}
}