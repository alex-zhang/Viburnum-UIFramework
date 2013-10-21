package com.viburnum.components
{
	import com.viburnum.components.baseClasses.GroupBase;
	import com.viburnum.data.IDataProvider;
	import com.viburnum.data.IList;
	import com.viburnum.events.CollectionEvent;
	import com.viburnum.events.CollectionEventKind;
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.alex.utils.IFactory;
	import com.viburnum.interfaces.ILayoutElement;
	import com.viburnum.layouts.IVirtualLayoutHost;
	import com.viburnum.layouts.VerticalLayout;
	import com.viburnum.utils.ListUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class DataGroup extends GroupBase implements IVirtualLayoutHost, IItemRenderListView
	{
		private var _typicalLayoutElement:ILayoutElement = null;
		
		private var _dataProvider:IList = null;
		private var _dataProviderChangedFlag:Boolean = false;

		private var _itemRenderer:IFactory = null;
		private var _itemRendererChangedFlag:Boolean = false;

		private var _virtualLayoutUnderwayFlag:Boolean = false;
		
		private var _lastItemIndicesInViewCache:Vector.<int> = new Vector.<int>();
		private var _itemIndicesInView:Vector.<int> = new Vector.<int>();
		//index 和 _itemIndicesInView 中始终保持一致
		private var _indexToRendererMap:Array = [];
		
		//回收的都是在显示列表里面的
		private var _recycleRenderersCache:Vector.<DisplayObject> = new Vector.<DisplayObject>();

		//--
		private var _itemRenderListViewListener:IItemRenderListViewListener = null;
		
		private var _itemToValueByKeyFieldFuction:Function = null;
		private var _labelFiled:String = "label";//default
		
		public function DataGroup()
		{
			super();
			
			var vlayout:VerticalLayout = new VerticalLayout();
			vlayout.gap = 0;
			layout = vlayout;
		}
		
		public function get itemRenderListViewListener():IItemRenderListViewListener
		{
			return _itemRenderListViewListener;
		}
		
		public function set itemRenderListViewListener(value:IItemRenderListViewListener):void
		{
			_itemRenderListViewListener = value;
		}
		
		//IItemRenderListView Interface
		public function get labelFiled():String
		{
			return _labelFiled;
		}
		
		[Inspectable(type="String")]
		public function set labelFiled(value:String):void
		{
			_labelFiled = value;
		}
		
		public function get itemToValueByKeyFieldFuction():Function
		{
			return _itemToValueByKeyFieldFuction;
		}
		
		public function set itemToValueByKeyFieldFuction(f:Function):void
		{
			_itemToValueByKeyFieldFuction = f;
		}
		
		public function itemToValueByKeyField(itemData:Object, keyField:String):*
		{
			return ListUtil.getItemDataByValueByKeyField(itemData, keyField, _itemToValueByKeyFieldFuction);
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		[Inspectable(type="List")]
		public function set dataProvider(value:IList):void
		{
			if(_dataProvider != value)
			{
				removeDataProviderListener();
				removeAllItemRenderers();
				
				_dataProvider = value;
				_dataProviderChangedFlag = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		
		[Inspectable(type="Object")]
		public function set itemRenderer(value:IFactory):void
		{
			if(_itemRenderer != value)
			{
				_itemRenderer = value;
				
				removeDataProviderListener();
				removeAllItemRenderers();
				
				_itemRendererChangedFlag = true;
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//IVirtualLayoutHost
		override public function get numLayoutElements():uint
		{
			return _dataProvider == null ? 0 : _dataProvider.length;
		}
		
		public function getItemIndicesInView():Vector.<int>
		{
			return _itemIndicesInView.concat();
		}
		
		//在调用getLayoutChildAt之前已经由layout确定了可视范围的index
		override public function getLayoutChildAt(index:int):DisplayObject
		{
			if(index < 0 || index >= numLayoutElements) return null;
			
			var renderer:DisplayObject = getChildAtInView(index);
			
			//virtualLayoutUnderwayFlag 保证这里的index是在可视范围内的, _itemIndicesInView已经在布局前清空
			if(_virtualLayoutUnderwayFlag)
			{
				_itemIndicesInView.push(index);
				
				if(renderer == null)
				{
					renderer = createItemRendererByIndexFromItemRenderFactory(index);
					
					_indexToRendererMap[index] = renderer;//更新缓存
				}
			}
			
			return renderer;
		}
		
		public function getChildAtInView(index:int):DisplayObject
		{
			if(index < 0 || index >= numLayoutElements) return null;
			
			return _indexToRendererMap[index] as DisplayObject;
		}
		
		//--
		
		protected function onCreatedNewItemRender(renderer:DisplayObject):void
		{
			if(_itemRenderListViewListener != null)
			{
				_itemRenderListViewListener.onCreatedNewItemRender(renderer);
			}
		}
		
		protected function updateRenderer(renderer:DisplayObject, itemIndex:int, itmeData:Object):void
		{
			if(_itemRenderListViewListener != null)
			{
				_itemRenderListViewListener.OnUpdateItemRender(renderer, itemIndex, itmeData);
			}
			
			if(renderer is IItemRender)
			{
				IItemRender(renderer).label = itemToValueByKeyField(itmeData, labelFiled);
				IItemRender(renderer).data = itmeData;
			}
		}
		
		protected function onListDataProviderCollectionChange(event:CollectionEvent):void
		{
			//这里Listener会先被处理，可能设置event的cancelable，导致该对象的onListDataProviderCollectionChange不能执行
			if(_itemRenderListViewListener != null)
			{
				_itemRenderListViewListener.onListDataProviderCollectionChange(event);
			}

			if(event.isDefaultPrevented()) return;
			
			var kind:String = event.kind;
			switch(kind)
			{
				case CollectionEventKind.ADD:
					onDataProviderAddItem(event.item, event.location);
					break;
				
//				case CollectionEventKind.MOVE:
//					break;
				
				case CollectionEventKind.REFRESH:
					onDataProviderRefresh();
					break;
				
				case CollectionEventKind.REMOVE:
					onDataProviderRemoveItem(event.oldItem, event.location);
					break;
				
				case CollectionEventKind.REPLACE:
					onDataProviderReplaceItem(event.item, event.location);
					break;
				
				case CollectionEventKind.RESET:
					onDataProviderReset();
					break;
				
				case CollectionEventKind.UPDATE:
					onDataProviderUpdateItem(event.item, event.location, event.property, event.propertyValue);
					break;

				default:
					break;
			}
		}

		private function onDataProviderAddItem(newItem:Object, index:int):void
		{
			itemAdded(newItem, index);
		}
		
		private function itemAdded(item:Object, index:int):void
		{
			// Increment all of the indices in virtualRendererIndices that are >= index.
			const n:int = _itemIndicesInView.length;
			for (var i:int = 0; i < n; i++)
			{
				const vrIndex:int = _itemIndicesInView[i];
				if(vrIndex >= index)
				{
					_itemIndicesInView[i] = vrIndex + 1;
					resetRendererItemIndex(i);
				}
			}
			
			_indexToRendererMap.splice(index, 0, null); // shift items >= index to the right
			// virtual ItemRenderer itself will be added lazily, by updateDisplayList()
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function itemRemoved(item:Object, index:int):void
		{
			// Decrement all of the indices in virtualRendererIndices that are > index
			// Remove the one (at vrItemIndex) that equals index.
			
			var vrItemIndex:int = -1;  // location of index in virtualRendererIndices 
			const n:int = _itemIndicesInView.length;
			for (var i:int = 0; i < n; i++)
			{
				const vrIndex:int = _itemIndicesInView[i];
				if(vrIndex == index)
				{
					vrItemIndex = i;
				}
				else if(vrIndex > index)
				{
					_itemIndicesInView[i] = vrIndex - 1;
					resetRendererItemIndex(i);
				}
			}
			
			if(vrItemIndex != -1)
			{
				_itemIndicesInView.splice(vrItemIndex, 1);
				
				// Remove the old renderer at index from indexToRenderer[], from the 
				// DataGroup, and clear its data property (if any).
				
				const oldRenderer:DisplayObject = _indexToRendererMap.splice(index, 1)[0];
				recycleItemRenderToCache(oldRenderer);
				
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private function itemUpdated(item:Object, index:int, property:Object, propertyValue:Object):void
		{
			var render:DisplayObject = _indexToRendererMap[index];
			if(render != null && render is IItemRender)
			{
				if(property.toString() == _labelFiled)
				{
					IItemRender(render).label = propertyValue.toString();
				}
			}
		}
		
		private function itemReplaced(item:Object, index:int):void
		{
			var render:DisplayObject = _indexToRendererMap[index];
			updateRenderer(render, index, item);
		}
		
//		protected function onDataProviderMoveItem():void
//		{
//		}
		
		private function onDataProviderRefresh():void
		{
		}
		
		private function onDataProviderRemoveItem(oldItem:Object, index:int):void
		{
			itemRemoved(oldItem, index);
		}
		
		private function onDataProviderReplaceItem(item:Object, index:int):void
		{
			itemReplaced(item, index);
		}
		
		private function onDataProviderReset():void
		{
			removeAllItemRenderers();
		}
		
		private function onDataProviderUpdateItem(item:Object, index:int, property:Object, propertyValue:Object):void
		{
			itemUpdated(item, index, property, propertyValue);
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if (_dataProviderChangedFlag || _itemRendererChangedFlag)
			{
				initializeTypicalLayoutElement();

				addDataProviderListener();

				if(_itemRendererChangedFlag)
				{
					_itemRendererChangedFlag = false;
				}
				
				if(_dataProviderChangedFlag)
				{
					_dataProviderChangedFlag = false;
					
					horizontalScrollPosition = 0;
					verticalScrollPosition = 0;
				}
			}
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			if(layout)
			{
				_virtualLayoutUnderwayFlag = true;
				startVirtualLayout();
			}
			
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			if(_virtualLayoutUnderwayFlag)
			{
				finishVirtualLayout();
				_virtualLayoutUnderwayFlag = false;
			}
		}
		
		override protected function clipAndScrollViewableArea():void
		{
			this.scrollRect = new Rectangle(horizontalScrollPosition, verticalScrollPosition, viewableWidth, viewableHeight);
		}
		
		//保留上次的可视区域的索引
		private function startVirtualLayout():void
		{
			_lastItemIndicesInViewCache = _itemIndicesInView.concat();
			_itemIndicesInView.splice(0, -1);
//			trace("startVirtualLayout ", _itemIndicesInView);
		}
		
		//比较上次的索引,进行回收、缓存操作
		private function finishVirtualLayout():void
		{
//			trace("finishVirtualLayout ", _itemIndicesInView);

			var n:uint = _lastItemIndicesInViewCache.length;
			
			var hasItemIndicesInViewChanegd:Boolean = n != _itemIndicesInView.length;
			
			for(var i:uint = 0; i < n; i++)
			{
				var index:uint = _lastItemIndicesInViewCache[i];

				if(_itemIndicesInView.indexOf(index) == -1)
				{
					var render:DisplayObject = _indexToRendererMap[index];
					_indexToRendererMap[index] = null;
					recycleItemRenderToCache(render);
					
					hasItemIndicesInViewChanegd = true;
				}
			}
			
			//内容改变了需要重新度量
			if(hasItemIndicesInViewChanegd)
			{
				invalidateSize();
			}
		}

		private function initializeTypicalLayoutElement():void
		{
			if(_dataProvider == null || _dataProvider.length == 0) return;
			
			var typicalItemRender:DisplayObject = createItemRendererByIndexFromItemRenderFactory(0); 
			
			setTypicalLayoutElement(ILayoutElement(typicalItemRender));

			super.removeChild(typicalItemRender);
		}

		private function setTypicalLayoutElement(element:ILayoutElement):void
		{
			_typicalLayoutElement = element;

			if(layout)
			{
				layout.typicalLayoutElement = element;
			}
		}
		
		private function createItemRendererByIndexFromItemRenderFactory(index:int):DisplayObject
		{
			if(index < 0 || index >= numLayoutElements) return null;
			
			var item:Object = dataProvider.getItemAt(index);
			
			var renderer:DisplayObject = null;
			
			//缓存取
			if(_recycleRenderersCache.length > 0)
			{
				renderer = _recycleRenderersCache.pop();
				renderer.visible = true;
			}
			else//新建
			{
				renderer = _itemRenderer.newInstance();

				if(renderer is IUIComponent)
				{
					IUIComponent(renderer).owner = this;
				}

				onCreatedNewItemRender(renderer);

				super.addChild(renderer);
			}

			updateRenderer(renderer, index, item);
			
			if(renderer is IItemRender)
			{
				IItemRender(renderer).itemIndex = index;
				IItemRender(renderer).data = item;
			}

			if(renderer is IAsyValidatingClient)
			{
				IAsyValidatingClient(renderer).validateNow();
			}

			return renderer;
		}
		
		private function recycleItemRenderToCache(render:DisplayObject):void
		{
			if(render == null) return;
			
			render.visible = false;
			
			_recycleRenderersCache.push(render);
		}
		
		private function addDataProviderListener():void
		{
			if(_dataProvider && _dataProvider is IDataProvider)
			{
				IDataProvider(_dataProvider).addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProviderCollectionChangeHandler, false, 0, true);
			}
		}
		
		private function removeDataProviderListener():void
		{
			if(_dataProvider && _dataProvider is IDataProvider)
			{
				IDataProvider(_dataProvider).removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProviderCollectionChangeHandler);
			}
		}
		
		private function removeAllItemRenderers():void
		{
			_lastItemIndicesInViewCache.splice(0, -1);
			_itemIndicesInView.splice(0, -1);
			_recycleRenderersCache.splice(0, -1);
			_indexToRendererMap = [];

			while(numChildren > 0)
			{
				super.removeChildAt(0);
			}
		}
		
		private function resetRendererItemIndex(index:int):void
		{
			var render:IItemRender = _indexToRendererMap[index] as IItemRender;
			if(render != null)
			{
				render.itemIndex = index;
			}
		}
		
		//event handler
		private function dataProviderCollectionChangeHandler(event:CollectionEvent):void
		{
			this.onListDataProviderCollectionChange(event);
		}
		
//		override protected function measure():void
//		{
//			super.measure();
			
//			trace(this.measuredWidth, this.measuredHeight);
//		}
	}
}
