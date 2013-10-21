package com.viburnum.interfaces
{
    public interface IStyleClient
    {
        function get styleName():Object;
        function set styleName(value:Object/*String CSSStyleDeclaration*/):void;
        
        function getStyle(styleProp:String):*;
        function setStyle(styleProp:String, newValue:*):void;
        function clearStyle(styleProp:String):void;
    }
}