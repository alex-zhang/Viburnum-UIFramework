package com.viburnum.data
{
	import com.viburnum.events.CollectionEvent;
	import com.viburnum.events.CollectionEventKind;
	import com.alex.utils.ArrayUtil;
	import com.alex.utils.NameUtil;
	
	import flash.events.EventDispatcher;

	public class ArrayList extends EventDispatcher implements IList, IDataProvider
	{
		private var _source:Array = null;
		
		public function ArrayList(data:Object = null)
		{
			super();
			
			if(data)
			{
				this.source = data;
			}
		}

		public function set source(data:Object):void
		{
			if(_source != data)
			{
				var array:Array = changedSouceDataToArray(data);

				_source = array;
				
				if(_source == null) _source = [];
				
				internalDispatchCollectionChangeEvent(CollectionEventKind.RESET);
			}
		}
		
		protected function changedSouceDataToArray(data:Object /*XMLList*/):Array
		{
			if(data is Array)
			{
				return data as Array;
			}
			else if(data is IList)
			{
				return IList(data).toArray();
			}
			else if(data is XML || data is XMLList)
			{
				var xmllist:XMLList = data is XML ? XML(data).elements() : XMLList(data);
				var len:uint = xmllist.length();
				if(len > 0)
				{
					var xmlArray:Array = [];
					for each(var xmlitem:XML in xmllist)
					{
						xmlArray.push(xmlitem);
					}
					return xmlArray;
				}
			}
			return null;
		}
		
		public function get source():Object
		{
			return _source;
		}
		
		//IList Interface
		public function get length():uint
		{
			return _source == null ? 0 : _source.length;
		}
		
		public function getItemAt(index:int):Object
		{
			return _source[index];
		}
		
		public function getItemIndex(item:Object):int
		{
			return _source.indexOf(item);
		}

		public function addItem(item:Object):void
		{
			addItemAt(item, length);
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			if(index >= 0 && index <= length)
			{
				_source.splice(index, 0, item);
				
				internalDispatchCollectionChangeEvent(CollectionEventKind.ADD, item, null, index);
			}
		}
		
		public function addItems(items:Object):void
		{
			addItemsAt(items, length);
		}
		
		public function addItemsAt(items:Object, index:int):void
		{
			if(items == null) return;

			if(items is Array || items is Vector || items is IList)
			{
				var isList:Boolean = items is IList;
				
				var n:uint = items.length;
				var item:Object = null;
				for(var i:int = 0; i < n; i++)
				{
					item = isList ? IList(items).getItemAt(i) : items[i];
					this.addItemAt(item, i + index);
				}
			}
		}
		
		public function removeItem(item:Object):void
		{
			if(length > 0)
			{
				var index:int = getItemIndex(item);
				if(index >= 0)
				{
					removeItemAt(index);
				}	
			}
		}
		
		public function removeItemAt(index:int):void
		{
			if(length > 0 && index >= 0 && index < length)
			{
				var removedObject:Object = _source.splice(index, 1)[0];
				
				internalDispatchCollectionChangeEvent(CollectionEventKind.REMOVE, null, removedObject, index);
			}
		}
		
		public function removeItemsByRangeLength(startIndex:int, length:uint):void
		{
			if(this.length == 0) return;
			
			if(length > 0 && startIndex < this.length)
			{
				if(startIndex < 0) startIndex = this.length + startIndex;
				if(startIndex < 0) return;//startIndex 负值范围在this.length内
				
				var endIndex:int = startIndex + length;
				if(endIndex > this.length) endIndex = this.length;
				
				removeItemsByRangeIndex(startIndex, endIndex);
			}
		}
		
		public function removeItemsByRangeIndex(startIndex:int, endIndex:int):void
		{
			if(this.length == 0) return;
			
			if(startIndex < 0) startIndex = this.length + startIndex;
			if(startIndex < 0) return;//startIndex 负值范围在this.length内
			
			if(endIndex < 0) endIndex = this.length + endIndex;
			if(endIndex < 0) return;//endIndex 负值范围在this.length内
			
			//这里index肯定都是>=0的值且在this.length范围内
			while(startIndex < endIndex)
			{
				removeItemAt(startIndex);
				
				endIndex--;
			}
		}

		public function removeAll():void
		{
			if(length > 0)
			{
				_source.splice(0, -1);
				
				internalDispatchCollectionChangeEvent(CollectionEventKind.RESET);
			}    
		}

		public function replaceItem(newItem:Object, oldItem:Object):void
		{
			if(length > 0)
			{
				var index:int = getItemIndex(oldItem);
				if(index >= 0)
				{
					replaceItemAt(newItem, index);
				}
			}
		}
		
		public function replaceItemAt(newItem:Object, index:uint):void
		{
			if(length > 0 && index >= 0 && index < length)
			{
				var oldItem:Object = _source[index];
				_source[index] = newItem;
				
				internalDispatchCollectionChangeEvent(CollectionEventKind.REPLACE, newItem, oldItem, index);
			}
		}
		
		public function updateListItem(item:Object, property:Object = null, newValue:Object = null):void
		{
			if(length > 0 && item != null)
			{
				var index:int = getItemIndex(item);
				if(index >= 0)
				{
					updateListItemByIndex(index, property, newValue);
				}
			}
		}
		
		public function updateListItemByIndex(index:int, property:Object = null, newValue:Object = null):void
		{
			if(length > 0 && index >= 0 && index < length)
			{
				var item:Object = getItemAt(index);
				if(item != null && property != null && 
					property is String && 
					item.hasOwnProperty(property))
				{
					var oldValue:Object = item[property];
					if(oldValue != newValue)
					{
						item[property] = newValue;
						
						internalDispatchCollectionChangeEvent(CollectionEventKind.UPDATE, item, null, index, -1, property, newValue, oldValue);
					}
				}
			}
		}
		
		public function toArray():Array
		{
			return _source.concat();
		}
		
		override public function toString():String
		{
			if(_source != null)
			{
				return this.toString();
			}
			else
			{
				return NameUtil.getUnqualifiedClassName(this);
			}
		}
		
		protected function internalDispatchCollectionChangeEvent(kind:String = null, 
															   item:Object = null,
															   oldItem:Object = null,
															   location:int = -1,
															   oldLocation:int = -1, 
															   property:Object = null,
															   propertyValue:Object = null,
															   propertyOldValue:Object = null):void
		{
			if(hasEventListener(CollectionEvent.COLLECTION_CHANGE))
			{
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, kind, 
					item, oldItem, 
					location, oldLocation, 
					property, 
					propertyValue, propertyOldValue);
				
				dispatchEvent(event);
			}
		}
	}
}