package com.viburnum.components
{
	import com.viburnum.data.IList;
	import com.alex.utils.IFactory;

	public interface IItemRenderListView
	{
		function set labelFiled(value:String):void;
		function get labelFiled():String;
		
		//itemToLabel,itemToIcon,ect...
		function get itemToValueByKeyFieldFuction():Function;
		function set itemToValueByKeyFieldFuction(f:Function):void;
		
		function itemToValueByKeyField(itemData:Object, keyField:String):*;
		
		function get dataProvider():IList;
		function set dataProvider(value:IList):void;
		
		function get itemRenderer():IFactory;
		function set itemRenderer(value:IFactory):void;
	}
}