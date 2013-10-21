package com.viburnum.managers
{
    import com.viburnum.interfaces.IPluginComponent;
    import com.viburnum.layouts.PositionConstrainType;
    
    import flash.display.DisplayObject;

    public interface IPopupManager extends IPluginComponent
    {
		function getModalWindowCount():int;
		
		function addPopUp(window:DisplayObject, modal:Boolean = false, modalAlpha:Number = NaN):void;
		function bringToFront(window:DisplayObject):void;
		function bringToBack(window:DisplayObject):void;
		
		function constrainPostion(window:DisplayObject, constrainType:String = "custom", isAlwaysConstrain:Boolean = false):void;
		function centerPopUp(window:DisplayObject, isAlwaysPopupCenter:Boolean = false):void;
		
		function removePopUp(window:DisplayObject):void;

		function hasWindow(window:DisplayObject):Boolean;
    }
}