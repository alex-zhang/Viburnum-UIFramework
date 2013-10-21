package com.viburnum.components
{
    import com.viburnum.components.supportClasses.TreeItemRenderer;
    import com.alex.utils.ClassFactory;
    import com.viburnum.data.ArrayList;
    import com.viburnum.data.IDataProvider;
    import com.viburnum.data.IHiberarchyNode;
    import com.viburnum.data.IList;
    import com.viburnum.events.CollectionEvent;
    import com.viburnum.events.ListEvent;
    
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;

    public class Tree extends List
    {
		private var _dataProvider:IList = null;
		private var _dataProviderChangedFlag:Boolean = false;
		
		private var _openedItems:Dictionary = new Dictionary(true);
		
		private var _useRelationWire:Boolean = false;
		
        public function Tree()
        {
            super();
			
			itemRenderer = new ClassFactory(TreeItemRenderer);
        }
		
		public function get useRelationWire():Boolean
		{
			return _useRelationWire;
		}
		
		[Inspectable(type="Boolean")]
		public function set useRelationWire(value:Boolean):void
		{
			if(_useRelationWire != value)
			{
				_useRelationWire = value;
			}
		}

		public function expandItem(itemData:Object, 
								   opened:Boolean, 
								   animate:Boolean = false, 
								   dispatchEvent:Boolean = false):void
		{
			if(checkItemDataHasBranch(itemData))
			{
				var isItemDataOpened:Boolean = getItemDataIsOpended(itemData);
				if(isItemDataOpened != opened)
				{
					var itemDataInListIndex:int = super.dataProvider.getItemIndex(itemData);
					var render:DisplayObject = getContentChildAtInView(itemDataInListIndex);
					
					if(render is ITreeItemRenderer)
					{
						ITreeItemRenderer(render).isOpen = opened;
					}
					
					if(opened)
					{
						addItemDataToOpendItems(itemData);
						expandOpenedItemChildrenItemsToList(itemData, itemDataInListIndex + 1);
					}
					else
					{
						removeItemDataFromOpenedItems(itemData);
						expandClosedItemChildrenItemsFromList(itemData, itemDataInListIndex + 1);
					}
				}
			}
		}
		
		//返回最后可插入的在list中index
		private function expandOpenedItemChildrenItemsToList(branchItemData:Object, insertInListIndex:int):int
		{
			var itemDataBranchList:IList = getItemDataBranchList(branchItemData);

			var n:uint = itemDataBranchList.length;
			for(var i:uint = 0; i < n; i++)
			{
				var childItemData:Object = itemDataBranchList.getItemAt(i);
				
				super.dataProvider.addItemAt(childItemData, insertInListIndex);
				
				insertInListIndex++;

				if(checkItemDataHasBranch(childItemData))
				{
					var isItemDataOpened:Boolean = getItemDataIsOpended(childItemData);
					if(isItemDataOpened)
					{
						insertInListIndex = expandOpenedItemChildrenItemsToList(childItemData, insertInListIndex);
					}
				}
			}
			
			return insertInListIndex;
		}
		
		//这里是实际就是一直删除最初branchItemData下一个index的item直到全部删完
		private function expandClosedItemChildrenItemsFromList(branchItemData:Object, deleteInListIndex:int):void
		{
			var itemDataBranchList:IList = getItemDataBranchList(branchItemData);
			
			var n:uint = itemDataBranchList.length;
			for(var i:uint = 0; i < n; i++)
			{
				var childItemData:Object = itemDataBranchList.getItemAt(i);
				
				//一直在删除startIndex这里的item
				super.dataProvider.removeItemAt(deleteInListIndex);
				
				if(checkItemDataHasBranch(childItemData))
				{
					var isItemDataOpened:Boolean = getItemDataIsOpended(childItemData);
					if(isItemDataOpened)
					{
						expandClosedItemChildrenItemsFromList(childItemData, deleteInListIndex);
					}
				}
			}
		}
		
		private function getItemDataIsOpended(itemData:Object):Boolean
		{
			return _openedItems[itemData] != undefined;
		}
		
		private function addItemDataToOpendItems(itemData:Object):void
		{
			if(_openedItems[itemData] == undefined)
			{
				_openedItems[itemData] = true;
			}
		}
		
		private function removeItemDataFromOpenedItems(itemData:Object):void
		{
			if(_openedItems[itemData] != undefined)
			{
				delete _openedItems[itemData];
			}
		}
		
		private function clearAllOpenedItems():void
		{
			_openedItems = new Dictionary(true);
		}
		
		override public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		/**
		 * tree和父类的dataProvider并不是一个dataProvider，tree中的dataProvider需要转化为
		 * 父类中的dataProvider.
		 * 
		 * 具体的转化逻辑由Tree完成。
		 * 
		 * @param value
		 * 
		 */
		[Inspectable(type="List")]
		override public function set dataProvider(value:IList):void
		{
			if(_dataProvider != value)
			{
				removeDataProviderListener();
				
				_dataProvider = value;

				_dataProviderChangedFlag = true;
				invalidateProperties();
			}
		}
		
		private function removeDataProviderListener():void
		{
			if(_dataProvider && _dataProvider is IDataProvider)
			{
				IDataProvider(_dataProvider).removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProviderCollectionChangeHandler);
			}
		}
		
		private function addDataProviderListener():void
		{
			if(_dataProvider && _dataProvider is IDataProvider)
			{
				IDataProvider(_dataProvider).addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProviderCollectionChangeHandler, false, 0, true);
			}
		}
		
		private function dataProviderCollectionChangeHandler(event:CollectionEvent):void
		{
			this.onTreeListDataProviderCollectionChange(event);
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_dataProviderChangedFlag)
			{
				_dataProviderChangedFlag = false;
				
				super.dataProvider = _dataProvider == null ? null : new ArrayList(_dataProvider.toArray()); 
			}
		}
		
		public function requestOpen2CloseTreeItem(isOpen:Boolean):void
		{
		}
		
		override public function onCreatedNewItemRender(renderer:DisplayObject):void
		{
			super.onCreatedNewItemRender(renderer);
			
			if(renderer is ITreeItemRenderer)
			{
				ITreeItemRenderer(renderer).treeOwner = this;
			}
		}
		
		override public function OnUpdateItemRender(render:DisplayObject, itemIndex:int, itemData:Object):void
		{
			super.OnUpdateItemRender(render, itemIndex, itemData);
			
			if(render is ITreeItemRenderer)
			{
				var hasBranch:Boolean = checkItemDataHasBranch(itemData);
				ITreeItemRenderer(render).hasBranch = hasBranch;
				ITreeItemRenderer(render).isOpen = hasBranch ? getItemDataIsOpended(itemData) : false;
				ITreeItemRenderer(render).depth = getItemDataDepth(itemData);
			}
		}
		
		protected function onTreeListDataProviderCollectionChange(event:CollectionEvent):void
		{
		}
		
		override public function onListDataProviderCollectionChange(event:CollectionEvent):void
		{
			//暂时取消一切数据变化的处理
			event.preventDefault();
		}
		
		protected function checkItemDataHasBranch(itemData:Object):Boolean
		{
			if(itemData is IHiberarchyNode)
			{
				return IHiberarchyNode(itemData).hasChildren();
			}
			
			return false;
		}
		
		protected function getItemDataDepth(itemData:Object):uint
		{
			if(itemData is IHiberarchyNode)
			{
				return IHiberarchyNode(itemData).depth;
			}
			
			return 0;
		}
		
		protected function getItemDataBranchList(itemData:Object):IList
		{
			if(itemData is IHiberarchyNode)
			{
				return IHiberarchyNode(itemData).getChildren();
			}
			
			return null;
		}
		
		override protected function itemRenderClickHandler(event:ListEvent):void
		{
		}
    }
}