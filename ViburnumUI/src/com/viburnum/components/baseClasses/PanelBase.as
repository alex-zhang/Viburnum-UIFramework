package com.viburnum.components.baseClasses
{
	import com.viburnum.components.SkinableContainer;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[Event(name="close", type="com.viburnum.events.CloseEvent")]
	
	include "../../style/styleMetadata/WindowTitleBarStyle.as";
	
	[Style(name="titleContentGap", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="titlePaddingLeft", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="titlePaddingRight", type="Number", invalidateSize="true", invalidateDisplayList="true")]

	[Style(name="titleBackgroundSkin", type="Class")]
	
	public class PanelBase extends SkinableContainer
	{
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"titleIcon", type:"Class"},
				{name:"titleLabelStyleName", type:"String"},
				{name:"closeButtonStyleName", type:"String"},
				
				{name:"titleContentGap", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"titlePaddingLeft", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"titlePaddingRight", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				
				{name:"titleBackgroundSkin", type:"Class"},
			]
		}
		
		public var allowDragWhenPopUp:Boolean = true;

		protected var myTitleBar:TitleBarBase;

		public function PanelBase()
		{
			super();
		}
		
		public function getTitleBar():TitleBarBase
		{
			return myTitleBar;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();

			myTitleBar.owner = this;
			myTitleBar.addEventListener(MouseEvent.MOUSE_DOWN, myTitleBarMouseDownHandler);
			addChild(myTitleBar);
		}
		
		override protected function iconChanged():void
		{
			super.iconChanged();

			myTitleBar.icon = icon;
		}
		
		override protected function titleChanged():void
		{
			super.titleChanged();
			
			myTitleBar.title = title;
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
		
			if(styleProp == "titleBackgroundSkin")
			{
				myTitleBar.setStyle("backgroundSkin", getStyle(styleProp));
			}
			else if(styleProp == "titleLabelStyleName" || 
				styleProp == "closeButtonStyleName")
			{
				myTitleBar.setStyle(styleProp, getStyle(styleProp));
			}
			else if(styleProp == "titleIcon")
			{
				if(this.icon == null)
				{
					myTitleBar.setStyle(styleProp, getStyle(styleProp));
				}
			}
		}

		override protected function measure():void
		{
			super.measure();
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			
			var tpl:Number = getStyle("titlePaddingLeft") || 0;
			var tpr:Number = getStyle("titlePaddingRight") || 0;
			
			var titleContentGap:Number = getStyle("titleContentGap") || 0;
			
			var left:Number = bl + pl;
			var right:Number = br + pr;

			var myTitleBarMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(myTitleBar);
			var myTitleBarMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(myTitleBar);
			
			var myTitleBarMinW:Number = LayoutUtil.getDisplayObjectMinWidth(myTitleBar);
			var myTitleBarMinH:Number = LayoutUtil.getDisplayObjectMinHeight(myTitleBar);
			
			var measuredW:Number = Math.max(measuredWidth, myTitleBarMW + tpl + tpr + left + right);
			var measuredH:Number = measuredHeight + myTitleBarMH + titleContentGap;
			
			setMeasuredSize(measuredW, measuredH);
			
			//-

			var minW:Number = Math.max(minWidth, myTitleBarMinW + tpl + tpr);
			var minH:Number = super.minHeight + myTitleBarMinH + titleContentGap;
			
			setMeasuredMinSize(minW, minH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;

			var tpl:Number = getStyle("titlePaddingLeft") || 0;
			var tpr:Number = getStyle("titlePaddingRight") || 0;
			
			var titleContentGap:Number = getStyle("titleContentGap") || 0;

			var left:Number = bl + pl;
			var right:Number = br + pr;
			var top:Number = bt + pt;
			var bottom:Number = bb + pb;
			
			//--
			var myTitleBarMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(myTitleBar);
			
			LayoutUtil.setDisplayObjectLayout2(myTitleBar, 
				left + tpl, top, right + tpr, layoutHeight - top - myTitleBarMH, layoutWidth, layoutHeight);

			var myContentGroupOffY:Number = top + myTitleBarMH + titleContentGap;
			//background the same as myContentGroup
			LayoutUtil.setDisplayObjectLayout2(backgroundSkin, 
				left, myContentGroupOffY, right, bottom, layoutWidth, layoutHeight);
			
			LayoutUtil.setDisplayObjectLayout2(myContentGroup, 
				left, myContentGroupOffY, right, bottom, layoutWidth, layoutHeight);
		}

		private function myTitleBarMouseDownHandler(event:MouseEvent):void
		{
			var moseDowntarget:DisplayObject = event.target as DisplayObject;
			
			if(isPopUp && allowDragWhenPopUp && myTitleBar.contains(moseDowntarget))//self 2 children
			{
				if(stage != null && application != null)
				{
					stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler, false, 0, true);	
					
					this.startDrag(false, getStartDragRect());
				}
			}
		}
		
		protected function getStartDragRect():Rectangle
		{
			var dragRect:Rectangle = application.screen;
			dragRect.width -= width;
			dragRect.height -= height;
			
			return dragRect;
		}
		
		private function stageMouseUpHandler(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);

			this.stopDrag();
		}

		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			event.updateAfterEvent();
		}
	}
}