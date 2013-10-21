package com.viburnum.layouts
{
	import com.viburnum.components.HorizontalAlign;
	import com.viburnum.components.VerticalAlign;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	
	public class TileLayout extends LayoutBase
	{
		private var _columnCount:int = -1;
		private var _rowCount:int = -1;
		private var _rowHeight:Number = NaN;
		private var _columnWidth:Number = NaN;

		private var _rowAlign:String = HorizontalAlign.LEFT;
		private var _columnAlign:String = VerticalAlign.TOP;
		
		public function TileLayout()
		{
			super();
		}
		
		public function get columnCount():int
		{
			return _columnCount;    
		}
		
		public function set columnCount(value:int):void
		{
			if(_columnCount != value)
			{
				_columnCount = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}
		
		public function get rowCount():int
		{
			return _rowCount;    
		}

		public function set rowCount(value:int):void
		{
			if(_rowCount != value)
			{
				_rowCount = value;

				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}

		public function get rowAlign():String
		{
			return _rowAlign;    
		}

		public function set rowAlign(value:String):void
		{
			if(_rowAlign != value)
			{
				_rowAlign = value;

				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}

		public function get columnAlign():String
		{
			return _columnAlign;    
		}

		public function set columnAlign(value:String):void
		{
			if(_columnAlign != value)
			{
				_columnAlign = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}

		override protected function realMeasure():void
		{
			super.realMeasure();
			
			var measuredW:Number = 0;
			var measuredH:Number = 0;

			var minW:Number = 0;
			var minH:Number = 0;
			
			ajustRealLayoutColumnAndRowCount();
			
			var child:DisplayObject;
			//i->columnIndex, j->rowIndex
			for(var i:int = 0; i < _columnCount; i++)
			{
				//该栏所有行宽度最大
				var maxColumnMeasureWidth:Number = 0;
				var maxColumnMeaureMinWidth:Number = 0;
				
				var rowMeasureHeight:Number = 0;
				var rowMeaureMinHeight:Number = 0;

				for(var j:int = 0; j < _rowCount; j++)
				{
					child = realLayoutHost.getLayoutChildAt(getLayoutIndexByColumnAndRowIndex(i, j));
					
					var childIncludeLayout:Boolean = LayoutUtil.getDisplayObjectIncludeLayout(child);
					if(!childIncludeLayout) continue;

					var childMeasuredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(child);
					var childMeasuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(child);
					
					var childMeasuredMinW:Number = LayoutUtil.getDisplayObjectMinWidth(child);
					var childMeasuredMinH:Number = LayoutUtil.getDisplayObjectMinHeight(child);

					maxColumnMeasureWidth = Math.max(childMeasuredW, maxColumnMeasureWidth);
					maxColumnMeaureMinWidth = Math.max(childMeasuredMinW, maxColumnMeaureMinWidth);
					
					rowMeasureHeight += childMeasuredH;
					rowMeaureMinHeight += childMeasuredMinH;
				}
				
				measuredW += maxColumnMeasureWidth;
				minW += maxColumnMeaureMinWidth;
				
				measuredH = Math.max(rowMeasureHeight, measuredH);
				minH = Math.max(rowMeaureMinHeight, minH);
			}
			
			LayoutUtil.setMeasuredSize(myLayoutHost, measuredW, measuredH);
			LayoutUtil.setMeasuredMinSize(myLayoutHost, minW, minH);
		}

		private function getLayoutIndexByColumnAndRowIndex(columnIndex:int, rowIndex:int):int
		{
			//1.水平从左向右排列
			return rowIndex * columnCount + columnIndex;
		}

		override protected function realUpdateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.realUpdateDisplayList(layoutWidth, layoutHeight);
			
			ajustRealLayoutColumnAndRowCount();
			
			var childLayoutWidth:Number = layoutWidth / _columnCount;
			var childLayoutHeight:Number = layoutHeight / _rowCount;

			var child:DisplayObject;
			var childPercentW:Number;
			var childPercentH:Number;
			//i->columnIndex, j->rowIndex
			for(var i:int = 0; i < _columnCount; i++)
			{
				for(var j:int = 0; j < _rowCount; j++)
				{
					child = realLayoutHost.getLayoutChildAt(getLayoutIndexByColumnAndRowIndex(i, j));
					
					var childIncludeLayout:Boolean = LayoutUtil.getDisplayObjectIncludeLayout(child);
					if(!childIncludeLayout) continue;
					
					var childW:Number = 0;
					var childH:Number = 0;

					childPercentW = LayoutUtil.getDisplayObjectPercentInWidth(child);
					if(isNaN(childPercentW))
					{
						childW = LayoutUtil.getDisplayObjectMeasuredWidth(child);
					}
					else
					{
						childW = LayoutUtil.calculatePercentSizeInFullSize(childPercentW, childLayoutWidth);
					}
					
					childPercentH = LayoutUtil.getDisplayObjectPercentInHeight(child);
					if(isNaN(childPercentH))
					{
						childH = LayoutUtil.getDisplayObjectMeasuredHeight(child);
					}
					else
					{
						childH = LayoutUtil.calculatePercentSizeInFullSize(childPercentH, childLayoutHeight);
					}
					
					LayoutUtil.setDisplayObjectBoundsSize(child, childW, childH);

					childW = LayoutUtil.getDisplayObjectWidth(child);
					childH = LayoutUtil.getDisplayObjectHeight(child);
					
					var childX:Number = i * childLayoutWidth + LayoutUtil.calculateChildOffxInFreeSpaceAlign(childW, childLayoutWidth, _columnAlign);;
					var childY:Number = j * childLayoutHeight + LayoutUtil.calculateChildOffxInFreeSpaceAlign(childH, childLayoutHeight, _rowAlign);

					LayoutUtil.setDisplayObjectPosition(child, childX, childY);
				}
			}
		}

		private function ajustRealLayoutColumnAndRowCount():void
		{
			var layoutChildrenN:uint = realLayoutHost.numLayoutElements
			if(_columnCount > 0 && _rowCount <= 0)
			{
				_columnCount = layoutChildrenN;
				_rowCount = 1;
			}
			else if(_columnCount <= 0 && _rowCount > 0)
			{
				_columnCount = 1;
				_rowCount = layoutChildrenN;
			}
			else if(_columnCount > 0 && _rowCount > 0)
			{
				_rowCount = Math.ceil(layoutChildrenN / _columnCount);
			}
			else if(_columnCount <=0 && _rowCount <= 0)
			{
				_columnCount = layoutChildrenN;
				_rowCount = 1;
			}
		}
	}
}