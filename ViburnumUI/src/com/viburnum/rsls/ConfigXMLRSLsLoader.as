package com.viburnum.rsls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;

	//queue表示RSl加载的先后顺序,也表示RSL之间的先后依赖关系
	//parallel 表示该层级之间的RSL是无依赖关系的
	
	public class ConfigXMLRSLsLoader extends EventDispatcher implements IRSLsLoader
	{
		private var _rslsConfigXMLUrl:String = null;
		private var _rslsConfigXMLLoaded:Boolean = false;
		
		private var _loadingRSLList:Array = null;//[RSLItem, [RSLItem .... ], ....]
		
		private var _currentLoadIndex:int = -1;
		private var _totalLoadCount:int = -1;

		public function ConfigXMLRSLsLoader(rslsConfigXMLUrl:String)
		{
			super();

			_rslsConfigXMLUrl = rslsConfigXMLUrl;
		}

		public function load():void
		{
			if(_rslsConfigXMLUrl == null || _rslsConfigXMLLoaded) return;

			var rslsConfigXMLLoader:URLLoader = new URLLoader();
			rslsConfigXMLLoader.addEventListener(Event.COMPLETE, rslsConfigXMLLoaderCompleteHandler);
			rslsConfigXMLLoader.load(new URLRequest(_rslsConfigXMLUrl));
		}
		
		private function createRSLItemLoaderByItemXML(itemXML:XML):IRSListItem
		{
			var rlsItemLoaderCls:Class = XMLRSLItem;
			if(itemXML.hasOwnProperty("@implCls"))
			{
				rlsItemLoaderCls = Class(getDefinitionByName(itemXML.@implCls));
			}
			
			return new rlsItemLoaderCls(itemXML);
		}
		
		private function rslsConfigXMLLoaderCompleteHandler(event:Event):void
		{
			var rslsConfigXMLLoader:URLLoader = URLLoader(event.target);
			rslsConfigXMLLoader.removeEventListener(Event.COMPLETE, rslsConfigXMLLoaderCompleteHandler);
			
			var rslsConfigXML:XML = new XML(rslsConfigXMLLoader.data);
			//format
			/*
			<rsls_queue>
				<rsls_parallel>
					<rsl title="" description="" url="" implCls="XXX.XXX.XXX" isCache="false"/>
				</rsls_parallel>
				<rsls_parallel>
					<rsl title="" description="" url="" implCls="XXX.XXX.XXX" isCache="false"/>
				</rsls_parallel>
				...
			</rsls_queue>
			*/

			var loaderList:XMLList = rslsConfigXML.elements();
			_loadingRSLList = [];
			
			var rslItem:IRSListItem = null;
			for each(var rsl:XML in loaderList)
			{
				var rslName:String = rsl.name().toString();
				if(rslName == "rsl")
				{
					rslItem = createRSLItemLoaderByItemXML(rsl);
					_loadingRSLList.push(rslItem);
				}
				else if(rslName == "rsls_parallel")
				{
					var parallels:XMLList = rsl.elements("rsl");
					if(parallels.length() > 0)
					{
						var parallelArr:Array = [];
						for each(var rsl2:XML in parallels)
						{
							rslItem = createRSLItemLoaderByItemXML(rsl2);
							parallelArr.push(rslItem);
						}
						_loadingRSLList.push(parallelArr);
					}
				}
			}
			
			_totalLoadCount = _loadingRSLList.length;
			if(_totalLoadCount > 0)
			{
				loadNextRSLs();
			}
		}
		
		private function loadNextRSLs():void
		{
			_currentLoadIndex++;
			
			if(_currentLoadIndex >= _totalLoadCount)
			{
				var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_COMPLETE);
				dispatchEvent(rslEvent);
				return;
			}
			
			var currentRSLItems:Array = [];
			var subTotalItemsCount:int = -1;
			
			var rslItem:IRSListItem = null;
			var loadItem:* = _loadingRSLList[_currentLoadIndex];
			if(loadItem is IRSListItem)
			{
				rslItem = IRSListItem(loadItem);
				addRSLItemListener(rslItem);
				rslItem.load();
				
				currentRSLItems[rslItem];
				subTotalItemsCount = 1;
			}
			else if(loadItem is Array)
			{
				var items:Array = loadItem as Array;
				var n:uint = items.length;
				for(var i:uint = 0; i < n; i++)
				{
					rslItem = IRSListItem(items[i]);
					addRSLItemListener(rslItem);
					rslItem.load();
				}
			}
			
			var nextRslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_NEXT);
			nextRslEvent.currentItemIndex = _currentLoadIndex;
			nextRslEvent.totalItemsCount = _totalLoadCount;
			nextRslEvent.currentRSLItems = currentRSLItems;
			nextRslEvent.subTotalItemsCount = subTotalItemsCount;
			dispatchEvent(nextRslEvent);
		}

		private function addRSLItemListener(rslItem:IRSListItem):void
		{
			rslItem.addEventListener(RSLEvent.RSL_ITEM_PROGRESS, rslItemProgressHandler);
			rslItem.addEventListener(RSLEvent.RSL_ITEM_COMPLETE, rslItemCompleteHandler);
			rslItem.addEventListener(RSLEvent.RSL_ERROR, rslItemErrorHandler);
		}

		private function removeRSLItemListener(rslItem:IRSListItem):void
		{
			rslItem.removeEventListener(RSLEvent.RSL_ITEM_PROGRESS, rslItemProgressHandler);
			rslItem.removeEventListener(RSLEvent.RSL_ITEM_COMPLETE, rslItemCompleteHandler);
			rslItem.removeEventListener(RSLEvent.RSL_ERROR, rslItemErrorHandler);
		}
		
		private function rslItemProgressHandler(event:RSLEvent):void
		{
			var allbytesLoaded:uint = 0;
			var allbytesTotal:uint = 0;
			var rslItem:IRSListItem = null;
			var currentRSLItem:IRSListItem = IRSListItem(event.target);
			
			var currentRSLItems:Array = [currentRSLItem];
			var subCurrentItemIndex:int = -1;
			var subTotalItemsCount:int = -1;
			
			var loadItem:* = _loadingRSLList[_currentLoadIndex];
			if(loadItem is IRSListItem)
			{
				rslItem = IRSListItem(loadItem);
				allbytesLoaded = rslItem.bytesLoaded;
				allbytesTotal = rslItem.bytesTotal;
				
				subCurrentItemIndex = 0;
				subTotalItemsCount = 1;
			}
			else if(loadItem is Array)
			{
				var items:Array = loadItem as Array;
				var n:uint = items.length;
				for(var i:uint = 0; i < n; i++)
				{
					rslItem = items[i];
					allbytesLoaded += rslItem.bytesLoaded;
					allbytesTotal += rslItem.bytesTotal;
				}
				
				subCurrentItemIndex = items.indexOf(currentRSLItem);
				subTotalItemsCount = items.length;
			}

			var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_PROGRESS);
			rslEvent.currentItemIndex = _currentLoadIndex;
			rslEvent.totalItemsCount = _totalLoadCount;
			rslEvent.subCurrentItemIndex = subCurrentItemIndex;
			rslEvent.subTotalItemsCount = subTotalItemsCount;
			rslEvent.currentRSLItems = currentRSLItems;
			rslEvent.bytesLoaded = allbytesLoaded;
			rslEvent.bytesTotal = allbytesTotal;
			
			dispatchEvent(rslEvent);
		}
		
		private function rslItemCompleteHandler(event:RSLEvent):void
		{
			var currentRSlItem:IRSListItem = IRSListItem(event.target);
			removeRSLItemListener(currentRSlItem);

			var loadItem:* = _loadingRSLList[_currentLoadIndex];
			if(loadItem is IRSListItem)
			{
				loadNextRSLs();
			}
			else if(loadItem is Array)
			{
				var loaded:Boolean = true;
				var rslItem:IRSListItem = null;
				
				var items:Array = loadItem as Array;
				var n:uint = items.length;
				for(var i:uint = 0; i < n; i++)
				{
					rslItem = items[i];
					if(!rslItem.loaded)
					{
						loaded = false;
						break;
					}
				}
				
				if(loaded)
				{
					loadNextRSLs();
				}
			}
		}

		//rls加载 不允许出现错误
		private function rslItemErrorHandler(event:RSLEvent):void
		{
			dispatchEvent(event);
		}
	}
}