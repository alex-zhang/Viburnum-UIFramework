package com.viburnum.skins
{
	import com.viburnum.data.IHiberarchyNode;

	public class TreeRelationWireSkin extends ProgrammaticSkin implements IHiberarchyRelationWireSkin
	{
		private var _depth:uint = 0;
		private var _branchWidth:Number = 0;
		private var _branchHeight:Number = 0;
		private var _folderWidth:Number = 0;
		private var _folderHeight:Number = 0;
		private var _leafWidth:Number = 0;
		private var _leafHeight:Number = 0;
		private var _itemGap:Number = 0;
		private var _hasBranch:Boolean = false;
		private var _isOpen:Boolean = false;
		private var _node:IHiberarchyNode;
		
		private var _drawContentChanegdFlag:Boolean = false;
		
		public function TreeRelationWireSkin()
		{
			super();
		}
		
		public function setDepth(value:Number):void
		{
			if(_depth != value)
			{
				_depth = value;
				
				_drawContentChanegdFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function setBranchSize(width:Number, height:Number):void
		{
			if(_branchWidth != width || _branchHeight != height)
			{
				_branchWidth = width;
				_branchHeight = height;
				
				_drawContentChanegdFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function setFolderSize(width:Number, height:Number):void
		{
			if(_folderWidth != width || _folderHeight != height)
			{
				_folderWidth = width;
				_folderHeight = height;
				
				_drawContentChanegdFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function setLeafSize(width:Number, height:Number):void
		{
			if(_leafWidth != width || _leafHeight != height)
			{
				_leafWidth = width;
				_leafHeight = height;
				
				_drawContentChanegdFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function setItemGap(value:Number):void
		{
			if(_itemGap != value)
			{
				_itemGap = value;
				
				_drawContentChanegdFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function hasBranch(value:Boolean):void
		{
			if(_hasBranch != value)
			{
				_hasBranch = value;
				
				_drawContentChanegdFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function setIsOpen(value:Boolean):void
		{
			if(_isOpen != value)
			{
				_isOpen = value;
				
				_drawContentChanegdFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function setNode(value:IHiberarchyNode):void
		{
			_node = value;
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			graphics.clear();
			
			if(true)
			{
				_drawContentChanegdFlag = false;
				
				if(_node != null)
				{
					graphics.lineStyle(1);
					
					//从右边向左画
					//这个两个branch的距离
					var branchDistance:Number = (_branchWidth + _itemGap + (_folderWidth - _branchWidth) / 2);
					//当前branch的起始位置
					var depthPadding:Number = branchDistance * _depth;
					
					var halfBranchWidth:Number = _branchWidth / 2;
					
					var centerY:Number = layoutHeight / 2;
					var branchCenterX:Number = depthPadding + halfBranchWidth;
					
					if(_hasBranch)
					{
						var halfFolderWidth:Number = _folderWidth / 2;
						var folderCenterX:Number = branchCenterX + halfBranchWidth + _itemGap + halfFolderWidth;

						graphics.moveTo(branchCenterX, centerY);
						graphics.lineTo(folderCenterX, centerY);
						
						if(_isOpen)
						{
							graphics.moveTo(folderCenterX, centerY);
							graphics.lineTo(folderCenterX, layoutHeight);
						}
					}
					else
					{
						var halfLeafWidth:Number = _leafWidth / 2;
						var leafCenterX:Number = branchCenterX + halfBranchWidth + _itemGap + halfLeafWidth;
						
						graphics.moveTo(branchCenterX, centerY);
						graphics.lineTo(leafCenterX, centerY);
					}
					
					var parentNode:IHiberarchyNode = _node.parentNode;
					
					//当前Brance垂直
					var hasCurrentBranceTopLine:Boolean = !_node.isFirst || parentNode != null;
					var hasCurrentBranceBottomLine:Boolean = !_node.isLast;
					
					if(hasCurrentBranceTopLine)
					{
						graphics.moveTo(branchCenterX, 0);
						graphics.lineTo(branchCenterX, centerY);
					}
					
					if(hasCurrentBranceBottomLine)
					{
						graphics.moveTo(branchCenterX, centerY);
						graphics.lineTo(branchCenterX, layoutHeight);
					}
					
					//父节点
					var p:IHiberarchyNode = parentNode;
					var pi:uint = 0;
					var pBranceCenterX:Number = branchCenterX;
					while(p != null && pi < _depth)
					{
						pBranceCenterX -= branchDistance;
						
						if(!p.isLast)
						{
							//画条整线
							graphics.moveTo(pBranceCenterX, 0);
							graphics.lineTo(pBranceCenterX, layoutHeight);
						}
						
						p = p.parentNode;
						pi++;
					}
				}
			}
			graphics.endFill();
		}
	}
}