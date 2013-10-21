package com.viburnum.managers
{
	import com.viburnum.components.IApplication;
	import com.viburnum.components.IToolTip;
	import com.viburnum.core.LayoutSpriteElement;
	import com.viburnum.core.viburnum_internal;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	use namespace viburnum_internal;
	
	public class ToolTipLayer extends LayoutSpriteElement
	{
		private static const TOOL_TIP_DEFFAULT_OFFX:Number = 11;
		private static const TOOL_TIP_DEFFAULT_OFFY:Number = 22;
		
		public var application:IApplication;
		
		private var _frameWorkToolTip:DisplayObject;
		private var _showFrameWorkToolTipMouseX:Number;
		private var _showFrameWorkToolTipMouseY:Number;
		
		private var _customToolTips:Array = [];//IToolTip
		
		public function ToolTipLayer()
		{
			super();
			
			explicitCanSkipMeasure = true;
		}
		
		public function showFrameWorkToolTip(toolTip:DisplayObject):void
		{
			if(toolTip == null) return;
			
			if(_frameWorkToolTip != toolTip)
			{
				removeFrameWorkToolTip();
				
				_frameWorkToolTip = toolTip;
				addChild(_frameWorkToolTip);
			}
			
			_showFrameWorkToolTipMouseX = application.mouseX;
			_showFrameWorkToolTipMouseY = application.mouseY;
			
			invalidateDisplayList();
		}
		
		public function removeFrameWorkToolTip():void
		{
			if(_frameWorkToolTip == null) return;
			
			removeChild(_frameWorkToolTip as DisplayObject);
			
			_frameWorkToolTip = null;
		}
		
		public function getCurrentFrameWorkToolTip():DisplayObject
		{
			return _frameWorkToolTip;
		}
		
		public function addCustomToolTip(toolTip:DisplayObject, postionX:Number, postionY:Number):void
		{
			if(toolTip == null || toolTip == _frameWorkToolTip) return;
			
			var index:int = _customToolTips.indexOf(toolTip);
			if(index != -1) return;
			
			_customToolTips.push(toolTip);
			
			addChild(toolTip);
			
			LayoutUtil.setDisplayObjectPosition(toolTip, postionX, postionY);
			
			invalidateDisplayList();
		}
		
		public function removeCustomToolTip(toolTip:DisplayObject):void
		{
			if(toolTip == null || toolTip == _frameWorkToolTip) return;
			
			var index:int = _customToolTips.indexOf(toolTip);
			if(index == -1) return;
			
			_customToolTips.splice(index, 1);
			
			removeChild(toolTip);
		}
		
		public function removeAllCustomToolTip():void
		{
			while(_customToolTips.length)
			{
				removeChild(_customToolTips.pop() as DisplayObject);
			}
		}
		
		private var _tempRectangle:Rectangle;
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			var frameWorkToolTipMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(_frameWorkToolTip);
			var frameWorkToolTipMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(_frameWorkToolTip);
			LayoutUtil.setDisplayObjectSize(_frameWorkToolTip, frameWorkToolTipMW, frameWorkToolTipMH);
			
			var x:Number = _showFrameWorkToolTipMouseX + TOOL_TIP_DEFFAULT_OFFX;
			var y:Number = _showFrameWorkToolTipMouseY + TOOL_TIP_DEFFAULT_OFFY;
			
			if(_tempRectangle == null)
			{
				_tempRectangle = new Rectangle(0, 0, layoutWidth, layoutHeight);
			}
			else
			{
				_tempRectangle.width = layoutWidth;
				_tempRectangle.height = layoutHeight;
			}
			
			LayoutUtil.ajustChildPostionInLimitShowArea(_frameWorkToolTip, x, y, _tempRectangle);
			
			var n:uint = _customToolTips.length;
			for(var i:uint = 0; i < n; i++)
			{
				var ctoolTip:IToolTip = _customToolTips[i];
				var ctoolTipMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(ctoolTip);
				var ctoolTipMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(ctoolTip);
				
				LayoutUtil.setDisplayObjectSize(ctoolTip, ctoolTipMW, ctoolTipMH);
			}
		}
	}
}