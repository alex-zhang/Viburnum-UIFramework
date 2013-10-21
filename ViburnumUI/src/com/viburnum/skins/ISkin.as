package com.viburnum.skins
{
    import flash.display.DisplayObjectContainer;

    public interface ISkin
    {
		function get owner():DisplayObjectContainer;
		function set owner(value:DisplayObjectContainer):void;
			
        function getStyle(styleProp:String):*;
		function getHostStyle(styleProp:String):*;
		
		function set skinPartName(value:String):void;
		function get skinPartName():String;
		
		function getSkinPartStyleProp(styleProp:String):String;
    }
}