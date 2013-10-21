package com.viburnum.components
{
	import com.viburnum.events.CollectionEvent;
	
	import flash.display.DisplayObject;

	public interface IItemRenderListViewListener
	{
		function onListDataProviderCollectionChange(event:CollectionEvent):void;
		function onCreatedNewItemRender(renderer:DisplayObject):void;
		function OnUpdateItemRender(render:DisplayObject, itemIndex:int, itemData:Object):void;
	}
}