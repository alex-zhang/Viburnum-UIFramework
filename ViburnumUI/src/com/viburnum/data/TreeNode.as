package com.viburnum.data
{
	import com.viburnum.utils.ListUtil;
	import com.viburnum.utils.ObjectUtil;

	public class TreeNode implements IHiberarchyNode
	{
		protected var _source:Object = null;

		private var _parentNode:IHiberarchyNode;
		private var _children:IList = null;
		
		private var _depth:uint = 0;
		private var _isLast:Boolean = false;
		private var _isFirst:Boolean = false;
		
		public function TreeNode(data:Object = null /*null XML Object*/)
		{
			super();
			
			_source = data;
		}
		
		public function get parentNode():IHiberarchyNode
		{
			return _parentNode;
		}
		
		public function set parentNode(value:IHiberarchyNode):void
		{
			_parentNode = value;
			
			_depth = 0;
			
			var node:IHiberarchyNode = _parentNode;
			while(node != null)
			{
				_depth++;
				node = node.parentNode;
			}
		}
		
		public function get depth():uint
		{
			return _depth;
		}
		
		public function get isLast():Boolean
		{
			return _isLast;
		}
		
		public function set isLast(value:Boolean):void
		{
			_isLast = value;
		}
		
		public function get isFirst():Boolean
		{
			return _isFirst;
		}
		
		public function set isFirst(value:Boolean):void
		{
			_isFirst = value;
		}
		
		public function hasChildren():Boolean
		{
			var children:IList = getChildren();
			return children != null && children.length > 0;
		}
		
		public function getChildren():IList//ITreeNode
		{
			if(_children != null) return _children;
			
			if(_source == null) return null;

			var len:uint = 0;
			var i:uint = 0;
			var treeNode:IHiberarchyNode = null;
			var treeNodes:Array = null;
			if(_source is XML)
			{
				var childXMlList:XMLList = XML(_source).elements();
				len = childXMlList.length();
				if(len > 0)
				{
					treeNodes = [];
					
					for(i = 0; i < len; i++)
					{
						treeNode = new TreeNode(childXMlList[i][0]);
						treeNode.parentNode = this;
						treeNodes.push(treeNode);
					}
				
					_children = new ArrayList(treeNodes);
					
					treeNodes[0].isFirst = true;
					treeNodes[treeNodes.length - 1].isLast = true;
				}
			}
			
			return _children;
		}
		
		public function toValueByKeyField(keyField:String):*
		{
			return ListUtil.getItemDataByValueByKeyField(this._source, keyField);
		}
	}
}