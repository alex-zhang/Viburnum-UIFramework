package com.viburnum.data
{
	public interface IList
	{
		function get length():uint;
		
		function getItemAt(index:int):Object;
		function getItemIndex(item:Object):int;
		
		function addItem(item:Object):void;
		function addItemAt(item:Object, index:int):void;
		
		function addItems(items:Object):void;
		function addItemsAt(items:Object, index:int):void;

		function removeItem(item:Object):void;
		function removeItemAt(index:int):void;
		
		function removeItemsByRangeLength(startIndex:int, length:uint):void;
		function removeItemsByRangeIndex(startIndex:int, endIndex:int):void;

		function removeAll():void;
		
		function replaceItem(newItem:Object, oldItem:Object):void;
		function replaceItemAt(newItem:Object, index:uint):void;
		
		function updateListItem(item:Object, property:Object = null, newValue:Object = null):void;
		function updateListItemByIndex(index:int, property:Object = null, newValue:Object = null):void;
		
		function toArray():Array;
	}
}