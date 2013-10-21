package com.viburnum.data
{
	import flash.events.EventDispatcher;

	public class TreeList extends ArrayList implements IList
	{
		public function TreeList(data:Object = null)
		{
			super(data);
		}

		override public function set source(data:Object/*IList Array Object Vector XML XMLList*/):void
		{
			super.source = changeDataToTreeNodes(data);
		}
		
		protected function changeDataToTreeNodes(data:Object):Array
		{
			var treeNodes:Array = null;
			var treeNode:IHiberarchyNode = null;

			if(data is XML)
			{
				treeNode = new TreeNode(data);
				treeNode.isFirst = true;
				treeNode.isLast = true;
				treeNodes = [treeNode];
			}
			else if(data is XMLList)
			{
				var len:uint = 0;
				var i:uint = 0;

				var xmlList:XMLList = XMLList(data)
				len = xmlList.length();
				if(len > 0)
				{
					treeNodes = [];
					for(i = 0; i < len; i++)
					{
						treeNode = new TreeNode(xmlList[i][0]);
						treeNodes.push(treeNode);
					}
				}
			}
			
			treeNodes[0].isFirst = true;
			treeNodes[treeNodes.length - 1].isLast = true;

			return treeNodes;
		}
		
		override public function getItemAt(index:int):Object
		{
			return IHiberarchyNode(super.getItemAt(index));
		}
		
		override public function getItemIndex(item:Object):int
		{
			return super.getItemIndex(IHiberarchyNode(item));
		}
		
		override public function addItem(item:Object):void
		{
			super.addItem(IHiberarchyNode(item));
		}
		
		override public function addItemAt(item:Object, index:int):void
		{
			super.addItemAt(IHiberarchyNode(item), index);
		}
		
		override public function removeItem(item:Object):void
		{
			super.removeItem(IHiberarchyNode(item));
		}
		
		override public function replaceItem(newItem:Object, oldItem:Object):void
		{
			super.replaceItem(IHiberarchyNode(newItem), IHiberarchyNode(oldItem));
		}
		
		override public function replaceItemAt(newItem:Object, index:uint):void
		{
			super.replaceItem(IHiberarchyNode(newItem), index);
		}
		
		override public function updateListItem(item:Object, property:Object = null, newValue:Object = null):void
		{
			super.updateListItem(IHiberarchyNode(item), property, newValue);
		}
	}
}