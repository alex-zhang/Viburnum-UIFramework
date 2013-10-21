package com.viburnum.layouts
{
	import com.viburnum.components.HorizontalAlign;
	import com.viburnum.components.VerticalAlign;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	
	public class HorizontalLayout extends LayoutBase
	{
		private var _paddingLeft:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingBottom:Number = 0;

		private var _gap:Number = 6;
		
		private var _percentChildrenLayoutWSize:Number = 0;
		
		private var _verticalAlign:String = VerticalAlign.TOP;
		private var _horizontalAlign:String = HorizontalAlign.LEFT;
		
		private var _variableColumnWidth:Boolean = true;
		private var _columnWidth:Number = NaN;

		public function HorizontalLayout()
		{
			super();
		}

		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if(_paddingLeft == value) return;
			
			_paddingLeft = value;

			LayoutUtil.invalidateSize(myLayoutHost);
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
		}
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if(_paddingTop == value) return;

			_paddingTop = value;
			
			LayoutUtil.invalidateSize(myLayoutHost);
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
		}
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if(_paddingRight == value) return;
			
			_paddingRight = value;
			
			LayoutUtil.invalidateSize(myLayoutHost);
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
		}
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if(_paddingBottom == value) return;
			
			_paddingBottom = value;
			
			LayoutUtil.invalidateSize(myLayoutHost);
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
		}
		
		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			if(_gap == value) return;

			_gap = value;

			LayoutUtil.invalidateSize(myLayoutHost);
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
		}
		
		public function get horizontalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if(_verticalAlign == value) return;
			
			_verticalAlign = value;
			
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
		}
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(_verticalAlign == value) return;

			_verticalAlign = value;

			LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
		}
		
		public function get variableColumnWidth():Boolean
		{
			return _variableColumnWidth;
		}
		
		public function set variableColumnWidth(value:Boolean):void
		{
			if(_variableColumnWidth != value)
			{
				_variableColumnWidth = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}
		
		public function get columnWidth():Number
		{
			if(!isNaN(_columnWidth))
			{
				return _columnWidth;
			}
			else
			{
				return LayoutUtil.getDisplayObjectMeasuredWidth(typicalLayoutElement);
			}
		}
		
		public function set columnWidth(value:Number):void
		{
			if(_columnWidth != value)
			{
				_columnWidth = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}
		
		//百分比的child最总得到的布局空间大小
		public function get percentChildrenLayoutWSize():Number
		{
			return _percentChildrenLayoutWSize;
		}
		
		override protected function realMeasure():void
		{
			var measuredW:Number = 0;
			var measuredH:Number = 0;
			
			var minW:Number = 0;
			var minH:Number = 0;

			var child:DisplayObject;
			var layoutChildrenN:uint = 0;
			
			var n:int = realLayoutHost.numLayoutElements;
			for(var i:int = 0; i < n; i++)
			{
				child = realLayoutHost.getLayoutChildAt(i);
				
				var childIncludeLayout:Boolean = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;

				layoutChildrenN++;
				
				var childMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(child);
				var childMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(child);
				
				measuredW += childMW;
				measuredH = Math.max(measuredH, childMH);
				
				var childMinW:Number = LayoutUtil.getDisplayObjectMinWidth(child);
				var childMinH:Number = LayoutUtil.getDisplayObjectMinHeight(child);

				minW += childMinW;
				minH = Math.max(minH, childMinH);
			}

			if(!variableColumnWidth)
			{
				measuredW = columnWidth * layoutChildrenN;
			}
			
			var totalGap:Number = (layoutChildrenN == 0) ? 0 : ( layoutChildrenN - 1) * gap;
			
			var hgap:Number = paddingLeft + paddingRight + totalGap;
			var vgap:Number = paddingTop + paddingBottom;
			
			measuredW += hgap;
			measuredH += vgap;

			minW += hgap;
			minH + vgap;

			LayoutUtil.setMeasuredSize(myLayoutHost, measuredW, measuredH);
			LayoutUtil.setMeasuredMinSize(myLayoutHost, minW, minH);
		}

		override protected function realUpdateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			var contentLayoutWidth:Number = layoutWidth - paddingLeft - paddingRight;
			var contentLayoutHeight:Number = layoutHeight - paddingTop - paddingBottom;

			//比如HA percentWidth = 60%, HB percentWidth = 80%
			//则 60% + 80% = 1.4,HA 实际是 60% / 1.4
			_percentChildrenLayoutWSize = 0;

			var layoutChildrenN:uint = 0;
			var percentWChildren:Array = [];
			var childrenOccupancyWSize:Number = 0;//没有百分比布局的child占用的大小
			var childrenTotalPercentInW:Number = 0;
			
			var child:DisplayObject = null;
			var childIncludeLayout:Boolean = true;
			var childW:Number = 0;
			var childH:Number = 0;
			var percentInW:Number = 0;
			var percentInH:Number = 0;
			var n:int = realLayoutHost.numLayoutElements;
			
			//size Child 1
			for(var i:int = 0; i < n; i++)
			{
				child = realLayoutHost.getLayoutChildAt(i);
				
				childIncludeLayout = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;

				layoutChildrenN++;

				percentInW = LayoutUtil.getDisplayObjectPercentInWidth(child);
				percentInH = LayoutUtil.getDisplayObjectPercentInHeight(child);
				
				if(!isNaN(percentInW))//百分比布局
				{
					if(variableColumnWidth)
					{
						childW = 0;
						childrenTotalPercentInW += percentInW;
						percentWChildren.push(child);
					}
					else
					{
						childW = columnWidth;
						childrenOccupancyWSize += childW;
					}
				}
				else
				{
					childW = variableColumnWidth ? LayoutUtil.getDisplayObjectMeasuredWidth(child) : columnWidth;
					childW = LayoutUtil.calculateSizeByMinAndMaxSize(childW, 
						LayoutUtil.getDisplayObjectMinWidth(child), 
						LayoutUtil.getDisplayObjectMaxWidth(child));
					
					childrenOccupancyWSize += childW;
				}
				
				if(!isNaN(percentInH))//百分比布局
				{
					childH = LayoutUtil.calculatePercentSizeInFullSize(percentInH, contentLayoutHeight);
				}
				else
				{
					childH = LayoutUtil.getDisplayObjectMeasuredHeight(child);
				}
				
				childH = LayoutUtil.calculateSizeByMinAndMaxSize(childH, 
					LayoutUtil.getDisplayObjectMinHeight(child), 
					LayoutUtil.getDisplayObjectMaxHeight(child));
				LayoutUtil.setDisplayObjectSize(child, childW, childH);
			}
			
			//size Child 2
			var totalGap:Number = (layoutChildrenN == 0) ? 0 : ( layoutChildrenN - 1) * gap;
			_percentChildrenLayoutWSize = contentLayoutWidth - childrenOccupancyWSize - totalGap;
			var percentWChildrenLength:int = percentWChildren.length;
			
			for(var j:int = 0; j < percentWChildrenLength; j++)
			{
				child = percentWChildren[j];
				
				var childPercentW:Number = LayoutUtil.getDisplayObjectPercentInWidth(child);
				childPercentW = LayoutUtil.calculateChildPercentByTotalPercent(childPercentW, childrenTotalPercentInW);
				
				childW = LayoutUtil.calculatePercentSizeInFullSize(childPercentW, _percentChildrenLayoutWSize);
				childW = LayoutUtil.calculateSizeByMinAndMaxSize(childW, 
					LayoutUtil.getDisplayObjectMinWidth(child), 
					LayoutUtil.getDisplayObjectMaxWidth(child));
				
				LayoutUtil.setDisplayObjectSize(child, childW, child.height);
				
				childrenOccupancyWSize += childW;
			}
			
			//postion
			var contentLayoutWSize:Number = childrenOccupancyWSize + totalGap;
			var lastChildEndX:Number = 0;
			var horizontalAlignOff:Number = LayoutUtil.calculateChildOffxInFreeSpaceAlign(contentLayoutWSize, contentLayoutWidth, horizontalAlign);
			
			for(var k:int = 0; k < n; k++)
			{
				child = realLayoutHost.getLayoutChildAt(k);

				childIncludeLayout = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;

				childW = child.width;
				childH = child.height;
				
				var childX:Number = lastChildEndX + paddingLeft + horizontalAlignOff;
				var childY:Number = paddingTop + LayoutUtil.calculateChildOffxInFreeSpaceAlign(childH, contentLayoutHeight, verticalAlign);
				
				LayoutUtil.setDisplayObjectPosition(child, childX, childY);
				
				lastChildEndX += (gap + childW);
			}
		}
	}
}