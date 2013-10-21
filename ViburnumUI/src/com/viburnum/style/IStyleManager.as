package com.viburnum.style
{
    import com.viburnum.components.SkinableComponent;
    import com.viburnum.interfaces.IPluginComponent;
    
    import flash.events.IEventDispatcher;

    public interface IStyleManager extends IPluginComponent
    {
		function registComponent(component:SkinableComponent):void;

        function getGlobalStyleDeclaration():CSSStyleDeclaration;
		function getHeritingClassTypeListStyleDeclaration(component:SkinableComponent):CSSStyleDeclaration;
		function getHeritingClassStyleMetadataInfos(component:SkinableComponent):Object;
		
		function getFilteredStyleDeclaration(c:CSSStyleDeclaration, isGetInheritingStyleProp:Boolean):CSSStyleDeclaration;
		
        function registerInheritingStyleProp(styleProp:String):void;
        function isInheritingStyleProp(styleProp:String):Boolean;

        function getStyleDeclaration(selector:String):CSSStyleDeclaration;
        function setStyleDeclaration(selector:String, styleDeclaration:CSSStyleDeclaration, update:Boolean):void;
        function clearStyleDeclaration(selector:String, update:Boolean):void;

		function initStyleByPropChian(stylePropChainMap:Object):void;
        function regenerateStylePropChian(stylePropChain:Object):void;

        function loadStyleDeclarations(url:String, update:Boolean = true):IEventDispatcher;
        function unloadStyleDeclarations(url:String, update:Boolean = true):void;
    }
}