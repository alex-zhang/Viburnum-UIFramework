package com.viburnum.managers
{
    import com.viburnum.components.IToolTip;
    import com.viburnum.interfaces.IPluginComponent;
    
    import flash.display.InteractiveObject;

    public interface IToolTipManager extends IPluginComponent
    {
        function get currentToolTip():IToolTip;
		function get currentToolTipClient():InteractiveObject

        function get enabled():Boolean;
        function set enabled(value:Boolean):void;

		function get showDelay():uint;
		function set showDelay(value:uint):void;
		
        function get hideDelay():uint;
        function set hideDelay(value:uint):void;
        
        function get scrubDelay():uint;
        function set scrubDelay(value:uint):void;

        function get toolTipClass():Class;
        function set toolTipClass(value:Class):void;
        
        function registToolTipClient(target:InteractiveObject):void;
		function unRegistToolTipClient(target:InteractiveObject):void;
		
		function showTargetToolTip(target:InteractiveObject, immediately:Boolean = false):void;
		
		function destroyCurrentToolTip():void;
		
		function showCustomToolTip(toolTip:IToolTip, postionX:Number, postionY:Number):void;
		function removeCustomToolTip(toolTip:IToolTip):void;
		function removeAllCustomToolTip():void;
    }
}