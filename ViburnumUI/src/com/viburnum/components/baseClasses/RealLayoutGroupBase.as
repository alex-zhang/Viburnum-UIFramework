package com.viburnum.components.baseClasses
{
	import com.viburnum.layouts.IRealLayoutHost;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	//是内部布局没有外部装饰 的类
	public class RealLayoutGroupBase extends GroupBase implements IRealLayoutHost
	{
		public function RealLayoutGroupBase()
		{
			super();
		}
		
		override protected function delwithChildrenInConstractor():void
		{
		}
		
		public function getAllChildren():Array
		{
			var results:Array = [];
			for(var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				results.push(getChildAt(i));
			}
			
			return results;
		}
		
		override public function get numLayoutElements():uint
		{
			return numChildren;	
		}
		
		//need to measure and layout
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			
			invalidateSize();
			invalidateDisplayList();
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			
			invalidateSize();
			invalidateDisplayList();
			
			return child;
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			super.setChildIndex(child, index);
			
			invalidateDisplayList();
		}
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			super.swapChildren(child1, child2);
			
			invalidateDisplayList();
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			super.swapChildrenAt(index1, index2);
			
			invalidateDisplayList();
		}
		
		override public function getLayoutChildAt(index:int):DisplayObject
		{
			return getChildAt(index);
		}
		
		override protected function clipAndScrollViewableArea():void
		{
			if(clipAndEnableScrolling)
			{
				this.scrollRect = new Rectangle(horizontalScrollPosition, verticalScrollPosition, viewableWidth, viewableHeight);
			}
			else
			{
				this.scrollRect = null;	
			}
		}
	}
}