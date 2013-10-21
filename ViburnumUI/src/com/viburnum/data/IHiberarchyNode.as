package com.viburnum.data
{
	public interface IHiberarchyNode
	{
		function get parentNode():IHiberarchyNode
		function set parentNode(value:IHiberarchyNode):void;
		
		function get depth():uint;
		
		function get isFirst():Boolean;
		function set isFirst(value:Boolean):void;
		
		function get isLast():Boolean;
		function set isLast(value:Boolean):void;
		
		function hasChildren():Boolean;
		function getChildren():IList;
		
		function toValueByKeyField(keyField:String):*;
	}
}