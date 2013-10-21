package com.viburnum.managers
{
	import com.viburnum.components.IButton;
	import com.viburnum.components.IFocusManagerComponent;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;

	public interface IFocusManager
	{
		function get defaultButton():IButton;
		
		function get defaultButtonEnabled():Boolean;
		function set defaultButtonEnabled(value:Boolean):void;
		
		function get focusPane():Sprite;
		function set focusPane(value:Sprite):void;
		
		function get showFocusIndicator():Boolean;
		function set showFocusIndicator(value:Boolean):void;
		
		function getFocus():IFocusManagerComponent;
		function setFocus(o:IFocusManagerComponent):void;
		
		function showFocus():void;
		function hideFocus():void;
		
		function activate():void;
		function deactivate():void;

		function findFocusManagerComponent(o:InteractiveObject):IFocusManagerComponent;

		function registFocusManagerComponent(target:IFocusManagerComponent):void;
		function unRegistFocusManagerComponent(target:IFocusManagerComponent):void;
	}
}