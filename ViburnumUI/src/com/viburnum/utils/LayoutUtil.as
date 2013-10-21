package com.viburnum.utils
{
	import com.viburnum.components.HorizontalAlign;
	import com.viburnum.components.IUIComponent;
	import com.viburnum.components.VerticalAlign;
	import com.viburnum.interfaces.IAsyValidatingClient;
	import com.viburnum.interfaces.IBorder;
	import com.viburnum.interfaces.ILayoutElement;
	import com.viburnum.interfaces.IVirburnumDisplayObject;
	import com.viburnum.layouts.ILayoutHost;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public final class LayoutUtil
	{
		//measure 度量一个显示对象的尺寸，有时对象可能是非显示对象，所以这里用Object引用
		//======================================================================
		
		public static function getDisplayObjectWidth(child:Object):Number
		{
			if(child is DisplayObject)
			{
				return DisplayObject(child).width;
			}
			else
			{
				return 0;
			}
		}
		
		public static function getDisplayObjectHeight(child:Object):Number
		{
			if(child is DisplayObject)
			{
				return DisplayObject(child).height;
			}
			else
			{
				return 0;
			}
		}
		
		//默认是可布局
		public static function getDisplayObjectIncludeLayout(child:Object):Boolean
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).includeInLayout;	
			}
			
			return true;
		}
		
		public static function getDisplayObjectMeasuredWidth(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).measuredWidth;
			}
			else if(child is DisplayObject)//DisplayObject Here
			{
				if(child.scaleX == 0) return 0;
				return child.width / child.scaleX;
			}
			
			return 0;
		}
		
		public static function getDisplayObjectMeasuredHeight(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).measuredHeight;
			}
			else if(child is DisplayObject)//DisplayObject Here
			{
				if(child.scaleY == 0) return 0;
				return child.height / child.scaleY;
			}
			
			return 0;
		}
		
		public static function getDisplayObjectExplicitWidth(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).explicitWidth;
			}
			
			return NaN;
		}
		
		public static function getDisplayObjectExplicitHeight(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).explicitHeight;
			}
			
			return NaN;
		}
		
		public static function getDisplayObjectMinWidth(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).minWidth;
			}
			
			return 0;
		}
		
		public static function getDisplayObjectMinHeight(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).minHeight;
			}
			else
			{
				return 0;
			}
		}
		
		public static function getDisplayObjectMaxWidth(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).maxWidth
			}
			else
			{
				return Number.MAX_VALUE;
			}
		}
		
		public static function getDisplayObjectMaxHeight(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).maxHeight;
			}
			else
			{
				return Number.MAX_VALUE;
			}
		}
		
		public static function getDisplayObjectPercentInWidth(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).percentWidth;
			}
			else//else
			{
				return NaN;
			}
		}
		
		public static function getDisplayObjectPercentInHeight(child:Object):Number
		{
			if(child is ILayoutElement)
			{
				return ILayoutElement(child).percentHeight;
			}
			else//else
			{
				return NaN;
			}
		}
		
		//layout 设置对象的实际显示尺寸
		//======================================================================
		public static function setDisplayObjectPosition(target:Object, x:Number, y:Number):void
		{
			if(target == null) return;
			
			x = Math.round(x);
			y = Math.round(y);
			
			if(target is IVirburnumDisplayObject)
			{
				IVirburnumDisplayObject(target).move(x, y);
			}
			else if(target is DisplayObject)
			{
				DisplayObject(target).x = x;
				DisplayObject(target).y = y;
			}
		}
		
		public static function setDisplayObjectSize(target:Object, width:Number, height:Number):void
		{
			width = Math.round(width);
			height = Math.round(height);
			
			if(target is IVirburnumDisplayObject)
			{
				IVirburnumDisplayObject(target).setSize(width, height);
			}
			else if(target is DisplayObject)
			{
				DisplayObject(target).width = width;
				DisplayObject(target).height = height;
			}
		}
		
		//这里是对对象的显示尺寸做最大和最小限制的设置对象的实际显示尺寸
		public static function setDisplayObjectBoundsSize(target:Object, width:Number, height:Number):void
		{
			if(target == null) return;
			
			var minWidth:Number = getDisplayObjectMinWidth(target);
			var maxWidth:Number = getDisplayObjectMaxWidth(target);
			var minHeight:Number = getDisplayObjectMinHeight(target);
			var maxHeight:Number = getDisplayObjectMaxHeight(target);
			
			setDisplayObjectSize(target, calculateSizeByMinAndMaxSize(width, minWidth, maxWidth), 
				calculateSizeByMinAndMaxSize(height, minHeight, maxHeight));
		}
		
		//这里的布局不约束尺寸
		public static function setDisplayObjectLayout(target:Object, 
													  x:Number, y:Number, width:Number, height:Number):void
		{
			if(target == null) return;
			
			setDisplayObjectPosition(target, x, y);
			setDisplayObjectSize(target, width, height);
		}
		
		public static function setDisplayObjectLayout2(target:Object, 
													   left:Number, top:Number, right:Number, bottom:Number, 
													   layoutWidth:Number, layoutHeight:Number):void
		{
			if(target == null) return;
			
			var width:Number = layoutWidth - left - right;
			var height:Number = layoutHeight - top - bottom;
			
			setDisplayObjectLayout(target, left, top, width, height);
		}
		
		//layer
		//======================================================================
		
		public static function sortDisplayObjectChildren(parent:DisplayObjectContainer, ...children):void
		{
			if(parent == null || children.length == 0) return;
			
			var child:DisplayObject = null;
			for(var i:int = 0, n:int = children.length; i < n; i++)
			{
				child = children[i];
				
				if(child is DisplayObject)
				{
					parent.setChildIndex(child, 0);
				}
			}
		}
		
		public static function setDisplayObjectChildIndex(parent:DisplayObjectContainer, target:Object, childIndex:int):void
		{
			if(parent == null) return;
			
			if(target is DisplayObject)
			{
				if(childIndex == -1)
				{
					if(parent.numChildren > 0)
					{
						childIndex = parent.numChildren - 1;
					}
					else
					{
						childIndex = 0;
					}
				}
				
				parent.setChildIndex(DisplayObject(target), childIndex);	
			}
		}
		
		//calculate 布局方面的计算
		//======================================================================
		
		public static function calculatePercentSizeInFullSize(percentSize:Number, fullSize:Number):Number
		{
			if(isNaN(percentSize)) return 0;
			
			if(percentSize < 0)
			{
				percentSize = 0;
			}
			else if(percentSize > 1)
			{
				percentSize = 1;
			}
			
			return percentSize * fullSize;
		}
		
		public static function calculateSizeByMinAndMaxSize(value:Number, minSize:Number, maxSize:Number):Number
		{
			if(value < minSize) value = minSize;
			else if(value > maxSize) value = maxSize;
			
			if(isNaN(value) || value < 0) value = 0;
			
			return value;
		}
		
		//在百分比布局中当一个对象的宽（高）度变化时，对应的百分比的变化
		public static function calculateValueBySize(totalSize:Number, 
													childSize:Number, percentTotal:Number):Number
		{
			return childSize * percentTotal / totalSize;
		}
		
		public static function calculateChildPercentByTotalPercent(childpercent:Number, percentTotalW:Number):Number
		{
			if(percentTotalW > 1) childpercent /= percentTotalW;
			
			return childpercent;
		}
		
		//计算child的位置通过index， 水平布局和垂直布局使用
		public static function calculatetypeElementPostionByIndex(index:int, 
																  typeElementSize:Number, 
																  gap:Number = 0, padding:Number = 0):Number
		{
			return padding + (typeElementSize + gap) * index;
		}
		
		//在某个大小空间里面的对其方式，child的偏移量
		public static function calculateChildOffxInFreeSpaceAlign(childSize:Number, 
																  boundarySize:Number, align:String):Number
		{
			if(align == HorizontalAlign.CENTER || align == VerticalAlign.MIDDLE)
			{
				return (boundarySize - childSize) / 2;
			}
			else if(align == HorizontalAlign.RIGHT || align == VerticalAlign.BOTTOM)
			{
				return boundarySize - childSize;
			}
			else//lef or top
			{
				return 0;
			}
		}
		
		public static function layoutTargetAroundByScale9Grid2BorderMetrics(target:DisplayObject, 
																			layoutWidth:Number, layoutHeight:Number):void
		{
			if(target == null) return;
			
			var targetBorderLeft:Number = 0;
			var targetBorderTop:Number = 0;
			var targetBorderRight:Number = 0;
			var targetBorderBottom:Number = 0;
			
			var targetMW:Number = getDisplayObjectMeasuredWidth(target);
			var targetMH:Number = getDisplayObjectMeasuredHeight(target);
			
			if(target is IBorder)
			{
				var bm:EdgeMetrics = IBorder(target).borderMetrics;
				if(bm == null) bm = EdgeMetrics.EMPTY;
				
				targetBorderLeft = bm.left;
				targetBorderTop = bm.top;
				targetBorderRight = bm.right;
				targetBorderBottom = bm.bottom;
			}
			else if(target.scale9Grid != null)
			{
				targetBorderLeft = target.scale9Grid.left;
				targetBorderTop = target.scale9Grid.top;
				targetBorderRight = targetMW - target.scale9Grid.right;
				targetBorderBottom = targetMH - target.scale9Grid.bottom;
			}
			
			setDisplayObjectLayout2(target, -targetBorderLeft, -targetBorderTop, -targetBorderRight, -targetBorderBottom, 
				layoutWidth, layoutHeight);
		}
		
		public static function ajustChildPostionInLimitShowArea(child:Object, showX:Number, showY:Number, showBounds:Rectangle):void
		{
			if(child == null) return;
			
			if(showBounds != null)
			{
				var childW:Number = getDisplayObjectWidth(child);
				var childH:Number = getDisplayObjectHeight(child);
				
				if(showX < showBounds.left) showX = showBounds.left;
				else if(showX + childW > showBounds.right) showX = showBounds.right - childW;
				
				if(showY < showBounds.top) showY = showBounds.top;
				else if(showY + childH > showBounds.bottom) showY = showBounds.bottom - childH;
			}
			
			setDisplayObjectPosition(child, showX, showY);
		}
		
		//一般用作全尺寸的约束
		public static function ajustChildPostionInLimitShowArea2(child:Object, showX:Number, showY:Number, showBoundsWidth:Number, showBoundsHeight:Number):void
		{
			if(child == null) return;
			
			var childW:Number = getDisplayObjectWidth(child);
			var childH:Number = getDisplayObjectHeight(child);
			
			if(showX < 0) showX = 0;
			else if(showX + childW > showBoundsWidth) showX = showBoundsWidth - childW;
			
			if(showY < 0) showY = 0;
			else if(showY + childH > showBoundsHeight) showY = showBoundsHeight - childH;
			
			setDisplayObjectPosition(child, showX, showY);
		}
		
		//显示
		public static function setDisplayObjectVisiable(target:Object, visible:Boolean):void
		{
			if(target == null) return;
			
			if(target is IUIComponent)
			{
				IUIComponent(target).setVisible(visible);
			}
			else if(target is DisplayObject)
			{
				DisplayObject(target).visible = visible;
			}
		}
		
		//提交
		public static function invalidateDisplayObjectList(target:Object):void
		{
			if(target is IAsyValidatingClient)
			{
				IAsyValidatingClient(target).invalidateDisplayList();
			}
		}
		
		public static function invalidateSize(target:Object):void
		{
			if(target is IAsyValidatingClient)
			{
				IAsyValidatingClient(target).invalidateSize();	
			}
		}
		
		//--
		
		public static function setMeasuredSize(target:Object, newMeasuredWidth:Number, newMeasuredHeight:Number):void
		{
			if(target is ILayoutHost)
			{
				ILayoutHost(target).setMeasuredSize(newMeasuredWidth, newMeasuredHeight);
			}
		}
		
		public static function setMeasuredMaxSize(target:Object, newMeasuredMaxWidth:Number, newMeasuredMaxHeight:Number):void
		{
			if(target is ILayoutHost)
			{
				ILayoutHost(target).setMeasuredMaxSize(newMeasuredMaxWidth, newMeasuredMaxHeight);
			}
		}
		
		public static function setMeasuredMinSize(target:Object, newMeasuredMinWidth:Number, newMeasuredMinHeight:Number):void
		{
			if(target is ILayoutHost)
			{
				ILayoutHost(target).setMeasuredMinSize(newMeasuredMinWidth, newMeasuredMinHeight);
			}
		}
	}
}