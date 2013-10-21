package com.viburnum.layouts
{
	import com.viburnum.components.HorizontalAlign;
	import com.viburnum.components.VerticalAlign;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	
	public class VerticalLayout extends LayoutBase
	{
		//计算可视范围内的childIndex的range, 水平布局和垂直布局使用
		public static function calculateVisualIndexRangeByTypeElementSizeAndViewableRang(typeElementSize:Number,
																						 viewablePostion:Number, viewableSize:Number,
																						 gap:Number = 0,
																						 padding:Number = 0):Array
		{
			var minIndex:uint = 0;
			var maxIndex:uint = 0;
			
			var itemSize:Number = typeElementSize + gap;
			var startPostion:Number = viewablePostion - padding;
			var endPostion:Number = startPostion + viewableSize;
			
			minIndex = int(startPostion / itemSize);
			maxIndex = int(endPostion / itemSize);
			
			return [minIndex, maxIndex];
		}
		
		private var _paddingLeft:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingBottom:Number = 0;

		private var _gap:Number = 6;
		
		private var _percentChildrenLayoutHSize:Number = 0;
		
		private var _verticalAlign:String = VerticalAlign.TOP;
		private var _horizontalAlign:String = HorizontalAlign.LEFT;
		
		private var _variableRowHeight:Boolean = true;
		private var _rowHeight:Number = NaN;

		public function VerticalLayout()
		{
			super();
		}
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if(_paddingLeft != value)
			{
				_paddingLeft = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if(_paddingTop != value)
			{
				_paddingTop = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}

		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if(_paddingRight != value)
			{
				_paddingRight = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if(_paddingBottom != value)
			{
				_paddingBottom = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}
		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			if(_gap != value)
			{
				_gap = value;

				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}
		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if(_horizontalAlign != value)
			{
				_horizontalAlign = value;
				
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(_verticalAlign != value)
			{
				_verticalAlign = value;
				
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}

		public function get variableRowHeight():Boolean
		{
			return _variableRowHeight;
		}
		
		public function set variableRowHeight(value:Boolean):void
		{
			if(_variableRowHeight != value)
			{
				_variableRowHeight = value;

				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
			}
		}
		
		public function get rowHeight():Number
		{
			if(!isNaN(_rowHeight))
			{
				return _rowHeight;
			}
			else
			{
				return LayoutUtil.getDisplayObjectMeasuredHeight(typicalLayoutElement);
			}
		}
		
		public function set rowHeight(value:Number):void
		{
			if(_rowHeight != value)
			{
				_rowHeight = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}
		
		//百分比的child最总得到的布局空间大小
		public function get percentChildrenLayoutHSize():Number
		{
			return _percentChildrenLayoutHSize;
		}
		
		//step 1: virtualMeasure:           根据typicalLayoutElement的高度 和 numLayoutElements 度量默认size
		//step 2: virtualUpdateDisplayList: 根据typicalLayoutElement的高度 和可视区域确定可见的childIndex Range, 
		//		  							由typicalLayoutElement的高度和childIndex Range 完成一次预布局
		//step 3: requestMeasureAndLayout:  step2中Cild的Size和Postion是不准确的需要重新完成一次度量和布局 invalidateSize invalidateDisplayObject
		//step 4: virtualMeasure:           virtualMeasure 根据typicalLayoutElement的高度 和 numLayoutElements 以及 childIndex Range 中的size 度量默认size
		//step 5: virtualUpdateDisplayList: 
		override protected function virtualMeasure():void
		{
			var measuredW:Number = 0;
			var measuredH:Number = 0;

			var n:uint = virtualLayoutHost.numLayoutElements;

			measuredW = LayoutUtil.getDisplayObjectMeasuredWidth(typicalLayoutElement);

			var itemsInView:Vector.<int>= virtualLayoutHost.getItemIndicesInView();
			var itemsInViewCount:uint = itemsInView.length;

			var typicalLayoutElementMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(typicalLayoutElement);
			measuredH = typicalLayoutElementMH * (n - itemsInViewCount);

			for(var i:uint = 0; i < itemsInViewCount; i++)
			{
				var index:uint = itemsInView[i];
				var child:DisplayObject = virtualLayoutHost.getLayoutChildAt(index);
				
				var childMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(child);
				var childMH:Number = variableRowHeight ? LayoutUtil.getDisplayObjectMeasuredHeight(child) : typicalLayoutElementMH;
				
				measuredW = Math.max(measuredW, childMW);
				measuredH += childMH;
			}

			var totalGap:Number = (n == 0) ? 0 : (n - 1) * gap;
			
			var hgap:Number = paddingLeft + paddingRight;
			var vgap:Number = paddingTop + paddingBottom + totalGap;
			
			measuredW += hgap;
			measuredH += vgap;
			
			LayoutUtil.setMeasuredSize(myLayoutHost, measuredW, measuredH);
		}

		override protected function virtualUpdateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.virtualUpdateDisplayList(layoutWidth, layoutHeight);

			var contentLayoutWidth:Number = layoutWidth - paddingLeft - paddingRight;
			var contentLayoutHeight:Number = layoutHeight - paddingTop - paddingBottom;
			
			var n:uint = virtualLayoutHost.numLayoutElements;
			
			//这里需要根据typicalLayoutElement 和 IViewport 重新计算可视区域的对象getItemIndicesInView
			var verticalScrollPosition:Number = virtualLayoutHost.verticalScrollPosition;
			var viewableHeight:Number = virtualLayoutHost.viewableHeight;
//			trace("verticalScrollPosition", verticalScrollPosition);
			var visualIndexRange:Array = calculateVisualIndexRangeByTypeElementSizeAndViewableRang(rowHeight, verticalScrollPosition, viewableHeight, gap, paddingTop);
			var startIndex:uint = visualIndexRange[0];
//			trace("layout", startIndex, rowHeight, verticalScrollPosition, viewableHeight, gap, paddingTop);
			var viewableChildrenHeight:Number = 0;
			
			var currentIndex:uint = startIndex;
			var childY:Number = LayoutUtil.calculatetypeElementPostionByIndex(startIndex, rowHeight, gap, paddingTop);
			
			while(viewableHeight + rowHeight > viewableChildrenHeight && currentIndex < n)
			{
				var childW:Number = 0;
				var childH:Number = 0;

				var child:DisplayObject = virtualLayoutHost.getLayoutChildAt(currentIndex);
//				var childPercentW:Number = getDisplayObjectPercentInWidth(child);
//				if(!isNaN(childPercentW))//百分比布局
//				{
//					childW = LayoutUtil.calculatePercentSizeInFullSize(childPercentW, contentLayoutWidth);
//				}
//				else
//				{
//					childW = getDisplayObjectMeasuredWidth(child);
//				}

				//默认填满
				childW = layoutWidth;
				childH = variableRowHeight ? LayoutUtil.getDisplayObjectMeasuredHeight(child) : rowHeight;
				
				LayoutUtil.setDisplayObjectSize(child, childW, childH);//no limited w h
				
				var childX:Number = paddingLeft + LayoutUtil.calculateChildOffxInFreeSpaceAlign(childW, contentLayoutWidth, horizontalAlign);
				LayoutUtil.setDisplayObjectPosition(child, childX, childY);
				
				viewableChildrenHeight += childH;

				childY += childH + gap;
				viewableChildrenHeight += gap;

				currentIndex++;
			}
		}
		
		override protected  function realMeasure():void
		{
			super.realMeasure();

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

				var typicalLayoutElementMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(typicalLayoutElement);
				var childMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(child);
				var childMH:Number = variableRowHeight ? LayoutUtil.getDisplayObjectMeasuredHeight(child) : typicalLayoutElementMH;
				
				measuredW = Math.max(measuredW, childMW);
				measuredH += childMH;
				
				var childMinW:Number = LayoutUtil.getDisplayObjectMinWidth(child);
				var childMinH:Number = LayoutUtil.getDisplayObjectMinHeight(child);
				
				minW = Math.max(minW, childMinW);
				minH += childMinH;
			}
			
			var totalGap:Number = (layoutChildrenN == 0) ? 0 : (layoutChildrenN - 1) * gap;
			
			var hgap:Number = paddingLeft + paddingRight;
			var vgap:Number = paddingTop + paddingBottom + totalGap;
			
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
			
			//比如HA percentHeight = 60%, HB percentHeight = 80%
			//则 60% + 80% = 1.4,HA 实际是 60% / 1.4
			_percentChildrenLayoutHSize = 0;
			
			var layoutChildrenN:uint = 0;
			var percentHChildren:Array = [];
			var childrenOccupancyHSize:Number = 0;
			var childrenTotalPercentInH:Number = 0;
			
			var child:DisplayObject;
			var childIncludeLayout:Boolean = true;
			var childW:Number = 0;
			var childH:Number = 0;
			var childPercentW:Number = 0;
			var childPercentH:Number = 0;
			var n:uint = realLayoutHost.numLayoutElements;

			for(var i:uint = 0; i < n; i++)
			{
				child = realLayoutHost.getLayoutChildAt(i);
				
				childIncludeLayout = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;
				
				layoutChildrenN++;
				
				childPercentW = LayoutUtil.getDisplayObjectPercentInWidth(child);
				childPercentH = LayoutUtil.getDisplayObjectPercentInHeight(child);
				
				if(!isNaN(childPercentH))//百分比布局
				{
					if(variableRowHeight)
					{
						childH = 0;
						childrenTotalPercentInH += childPercentH;
						percentHChildren.push(child);
					}
					else
					{
						childH = rowHeight;
						childrenOccupancyHSize += childH;
					}
				}
				else
				{
					childH = variableRowHeight ? LayoutUtil.getDisplayObjectMeasuredHeight(child) : rowHeight;
					childH = LayoutUtil.calculateSizeByMinAndMaxSize(childH, 
						LayoutUtil.getDisplayObjectMinHeight(child), 
						LayoutUtil.getDisplayObjectMaxHeight(child));
					
					childrenOccupancyHSize += childH;
				}
				
				if(!isNaN(childPercentW))//百分比布局
				{
					childW = LayoutUtil.calculatePercentSizeInFullSize(childPercentW, contentLayoutWidth);
				}
				else
				{
					childW = LayoutUtil.getDisplayObjectMeasuredWidth(child);
				}
				
				childW = LayoutUtil.calculateSizeByMinAndMaxSize(childW, 
					LayoutUtil.getDisplayObjectMinWidth(child), 
					LayoutUtil.getDisplayObjectMaxWidth(child));
				LayoutUtil.setDisplayObjectSize(child, childW, childH);
			}
			
			var totalGap:Number = (layoutChildrenN == 0) ? 0 : (layoutChildrenN - 1) * gap;
			_percentChildrenLayoutHSize = contentLayoutHeight - childrenOccupancyHSize - totalGap;
			
			var percentHChildrenLength:int = percentHChildren.length;
			for(var j:int = 0; j < percentHChildrenLength; j++)
			{
				child = percentHChildren[j];
				
				childPercentH = LayoutUtil.getDisplayObjectPercentInHeight(child);
				childPercentH = LayoutUtil.calculateChildPercentByTotalPercent(childPercentH, childrenTotalPercentInH);
				
				childH = LayoutUtil.calculatePercentSizeInFullSize(childPercentH, _percentChildrenLayoutHSize);
				childH = LayoutUtil.calculateSizeByMinAndMaxSize(childH, 
					LayoutUtil.getDisplayObjectMinHeight(child), 
					LayoutUtil.getDisplayObjectMaxHeight(child));
				
				LayoutUtil.setDisplayObjectSize(child, child.width, childH);
				
				childrenOccupancyHSize += childH;
			}

			//postion
			var contentLayoutHSize:Number = childrenOccupancyHSize + totalGap;
			var lastChildEndY:Number = 0;
			var verticalAlignOff:Number = paddingTop + LayoutUtil.calculateChildOffxInFreeSpaceAlign(contentLayoutHSize, contentLayoutHeight, verticalAlign);
			
			for(var k:uint = 0; k < n; k++)
			{
				child = realLayoutHost.getLayoutChildAt(k);
				
				childIncludeLayout = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;
				
				childW = child.width;
				childH = child.height;
				
				var childX:Number = paddingLeft + LayoutUtil.calculateChildOffxInFreeSpaceAlign(childW, contentLayoutWidth, horizontalAlign);
				var childY:Number = lastChildEndY + verticalAlignOff;
				
				LayoutUtil.setDisplayObjectPosition(child, childX, childY);
				
				lastChildEndY += (gap + childH);
			}
		}
	}
}