package com.viburnum.components.baseClasses
{
	import com.viburnum.components.UIComponent;
	import com.viburnum.events.ViburnumEvent;
	import com.viburnum.interfaces.IViewport;
	import com.viburnum.layouts.ILayoutHost;
	import com.viburnum.layouts.LayoutBase;
	
	import flash.display.DisplayObject;
	
	public class GroupBase extends UIComponent implements IViewport, ILayoutHost
	{
		private var _layout:LayoutBase;

		private var _viewableWidth:Number = 0;
		private var _viewableHeight:Number = 0;

		private var _horizontalScrollPosition:Number = 0;
		private var _verticalScrollPosition:Number = 0;
		
		private var _clipAndEnableScrolling:Boolean = false;

		public function GroupBase()
		{
			super();
			
			tabChildren = true;
		}
		
		public function get layout():LayoutBase
		{
			return _layout;
		}

		public function set layout(value:LayoutBase):void
		{
			if(_layout == value) return;
			
			if(_layout != null)
			{
				_layout.layoutHost = null;
			}

			_layout = value; 

			if(_layout != null)
			{
				_layout.layoutHost = this;
			}

			invalidateSize();
			invalidateDisplayList();
		}
		
		//ILayoutHost Interface=============
		public function get numLayoutElements():uint
		{
			return 0;
		}

		public function getLayoutChildAt(index:int):DisplayObject
		{
			return null;
		}
		
		//IViewport Interface==============
		public function get viewableWidth():Number 
		{
			if(!isNaN(explicitWidth)) return explicitWidth;
			return _clipAndEnableScrolling ? _viewableWidth : width;
		}
		
		public function get viewableHeight():Number 
		{
			if(!isNaN(explicitHeight)) return explicitHeight;
			return _clipAndEnableScrolling ? _viewableHeight : height;
		}
		
		public function get totalWidth():Number
		{
			return width;
		}
		
		public function get totalHeight():Number
		{
			return height;
		}

		public function get horizontalScrollPosition():Number 
		{
			return _horizontalScrollPosition;
		}
		
		public function set horizontalScrollPosition(value:Number):void 
		{
			if(_horizontalScrollPosition != value)
			{
				_horizontalScrollPosition = value;
				
				if(_clipAndEnableScrolling)
				{
					invalidateDisplayList();
				}
			}
		}
		
		public function get verticalScrollPosition():Number 
		{
			return _verticalScrollPosition;
		}
		
		public function set verticalScrollPosition(value:Number):void 
		{
			if(_verticalScrollPosition != value)
			{
				_verticalScrollPosition = value;

				if(_clipAndEnableScrolling)
				{
					invalidateDisplayList();
				}
			}
		}
		
		public function get horizontalMaxScrollPosition():Number
		{
			if(_clipAndEnableScrolling)
			{
				return this.width - this.viewableWidth;
			}
			else
			{
				return 0;
			}
		}
		
		public function get verticalMaxScrollPosition():Number
		{
			if(_clipAndEnableScrolling)
			{
				return this.height - this.viewableHeight;
			}
			else
			{
				return 0;
			}
		}
		
		public function get clipAndEnableScrolling():Boolean 
		{
			return _clipAndEnableScrolling;
		}

		public function set clipAndEnableScrolling(value:Boolean):void 
		{
			if(_clipAndEnableScrolling != value)
			{
				_clipAndEnableScrolling = value;
				
				invalidateDisplayList();
			}
		}
		
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			return 0;     
		}
		
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			return 0;     
		}

		//一般是在对象布局之后调用，所以这里的width 和 height 都对象当前最新的尺寸
		public function setViewableSize(newViewableWidth:Number, newViewableHeight:Number):void
		{
			var changed:Boolean = false;

			if(_viewableWidth != newViewableWidth)
			{
				_viewableWidth = newViewableWidth;
				changed = true;
			}

			if(_viewableHeight != newViewableHeight)
			{
				_viewableHeight = newViewableHeight;
				changed = true;
			}
			
			if(changed)
			{
				if(_clipAndEnableScrolling)
				{
					invalidateDisplayList();
				}
				
				if(hasEventListener(ViburnumEvent.VIEWABLE_SIZE_CHANGED))
				{
					dispatchEvent(new ViburnumEvent(ViburnumEvent.VIEWABLE_SIZE_CHANGED));
				}
			}
		}

		override protected function measure():void
		{
			super.measure();
			
			if(layout != null) layout.measure();
		}
		
		//虚拟布局这里的layoutWidth layoutHeight可能是个很大的数
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			if(_clipAndEnableScrolling)
			{
				adjustViewportValues();
			}
			
			clipAndScrollViewableArea();
			
			if(_layout != null) _layout.updateDisplayList(layoutWidth, layoutHeight);
		}

		private function adjustViewportValues():void
		{
			if(_viewableWidth < 0) _viewableWidth = 0;
			else if(_viewableWidth > width) _viewableWidth = width;
			
			if(_horizontalScrollPosition < 0) _horizontalScrollPosition = 0;
			else if(_horizontalScrollPosition > width - _viewableWidth) _horizontalScrollPosition = width - _viewableWidth;
			
			if(_viewableHeight < 0) _viewableHeight = 0;
			else if(_viewableHeight > height) _viewableHeight = height;
			
			if(_verticalScrollPosition < 0) _verticalScrollPosition = 0;
			else if(_verticalScrollPosition > height - _viewableHeight) _verticalScrollPosition = height - _viewableHeight;
		}
		
		protected function clipAndScrollViewableArea():void
		{
		}
	}
}
