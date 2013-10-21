package com.viburnum.layouts
{
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	//不支持虚拟布局
	public class FlowLayout extends LayoutBase
	{
		private var _paddingLeft:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingBottom:Number = 0;
		
		private var _horizontalGap:Number = 6;
		private var _verticalGap:Number = 6;
		
		public function FlowLayout()
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
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
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
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost);
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
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
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
			LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
		}
		
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		
		public function set horizontalGap(value:Number):void
		{
			if(_horizontalGap != value)
			{
				_horizontalGap = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}
		
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		public function set verticalGap(value:Number):void
		{
			if(_verticalGap != value)
			{
				_verticalGap = value;
				
				LayoutUtil.invalidateSize(myLayoutHost);
				LayoutUtil.invalidateDisplayObjectList(myLayoutHost)
			}
		}
		
		override protected function realMeasure():void
		{
			super.realMeasure();
			
			var measuredMinW:Number = paddingLeft + paddingRight;
			var measuredMinH:Number = paddingTop + paddingBottom;

			LayoutUtil.setMeasuredMinSize(myLayoutHost, measuredMinW, measuredMinH);
		}
		
		override protected function realUpdateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.realUpdateDisplayList(layoutWidth, layoutHeight);
			
			var contentLayoutWidth:Number = layoutWidth - paddingLeft - paddingRight;
			var contentLayoutHeight:Number = layoutHeight - paddingTop - paddingBottom;

			var lastRowX:Number = 0;
			var lastRowY:Number = 0;
			var lastRowMaxH:Number = 0;

			var child:DisplayObject;
			var n:int = realLayoutHost.numLayoutElements;
			for(var i:int = 0; i < n; i++)
			{
				child = realLayoutHost.getLayoutChildAt(i);
				
				var childIncludeLayout:Boolean = LayoutUtil.getDisplayObjectIncludeLayout(child);
				if(!childIncludeLayout) continue;
				
				var childW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(child);
				var childH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(child);
				
				LayoutUtil.setDisplayObjectSize(child, childW, childH);

				if(lastRowX + _horizontalGap + childW > contentLayoutWidth)
				{
					lastRowX = 0;
					lastRowY += _verticalGap + lastRowMaxH;
					lastRowMaxH = 0;
				}
				
				lastRowX += _horizontalGap;
				lastRowMaxH = Math.max(lastRowMaxH, childH);

				LayoutUtil.setDisplayObjectPosition(child, lastRowX + _paddingLeft, lastRowY + _paddingTop);
				
				lastRowX += childW;
			}
		}
	}
}