package com.viburnum.components
{
	import com.viburnum.components.baseClasses.SkinnableContainerBase;
	import com.viburnum.data.IList;
	import com.viburnum.events.CollectionEvent;
	import com.alex.utils.IFactory;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	public class SkinableDataContainer extends SkinnableContainerBase implements IFocusManagerContainer, 
		IItemRenderListView, IItemRenderListViewListener
	{
		public function SkinableDataContainer()
		{
			super();

			//default
			myContentGroup = new DataGroup();
			DataGroup(myContentGroup).itemRenderListViewListener = this;
		}
		
		public function getContentChildAtInView(index:int):DisplayObject
		{
			return DataGroup(myContentGroup).getChildAtInView(index);
		}

		//IItemRenderListView Interfacre
		public function get dataProvider():IList
		{
			return DataGroup(myContentGroup).dataProvider;
		}

		[Inspectable(type="List")]
		public function set dataProvider(value:IList):void
		{
			DataGroup(myContentGroup).dataProvider = value;
		}
		
		public function get itemRenderer():IFactory
		{
			return DataGroup(myContentGroup).itemRenderer;
		}

		[Inspectable(type="Object")]
		public function set itemRenderer(value:IFactory):void
		{
			DataGroup(myContentGroup).itemRenderer = value;
		}
		
		public function get labelFiled():String
		{
			return DataGroup(myContentGroup).labelFiled;
		}
		
		[Inspectable(type="String")]
		public function set labelFiled(value:String):void
		{
			DataGroup(myContentGroup).labelFiled = value;
		}

		public function get itemToValueByKeyFieldFuction():Function
		{
			return DataGroup(myContentGroup).itemToValueByKeyFieldFuction;
		}
		
		public function set itemToValueByKeyFieldFuction(f:Function):void
		{
			DataGroup(myContentGroup).itemToValueByKeyFieldFuction = f;
		}
		
		public function itemToValueByKeyField(itemData:Object, keyField:String):*
		{
			return DataGroup(myContentGroup).itemToValueByKeyField(itemData, keyField);
		}
		
		//IItemRenderListViewListener Interface
		public function onListDataProviderCollectionChange(event:CollectionEvent):void
		{
		}
		
		public function onCreatedNewItemRender(renderer:DisplayObject):void
		{
		}
		
		public function OnUpdateItemRender(render:DisplayObject, itemIndex:int, itemData:Object):void
		{
		}
	}
}