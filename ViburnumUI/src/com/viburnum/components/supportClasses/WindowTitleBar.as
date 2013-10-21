package com.viburnum.components.supportClasses
{
	import com.viburnum.components.Label;
	import com.viburnum.components.SimpleButton;
	import com.viburnum.components.Space;
	import com.viburnum.components.baseClasses.TitleBarBase;
	import com.viburnum.events.CloseEvent;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

//	include "../../style/styleMetadata/WindowTitleBarStyle.as";

	public class WindowTitleBar extends TitleBarBase
	{
		private var _inconChangedFlag:Boolean = false;
		private var _titleChangedFlag:Boolean = false;

		private var _isShowCloseButton:Boolean = false;
		private var _isShowCoseButtonChangedFlag:Boolean = false;
		
		public var iconIntance:DisplayObject;
		public var titleLabel:Label;
		public var titleSpace:Space;
		public var closeButton:SimpleButton;

		public function WindowTitleBar()
		{
			super();
		}
		
		public function get isShowCloseButton():Boolean
		{
			return _isShowCloseButton;
		}
		
		public function set isShowCloseButton(value:Boolean):void
		{
			if(_isShowCloseButton != value)
			{
				_isShowCloseButton = value;
				
				_isShowCoseButtonChangedFlag = true;
				invalidateProperties();
			}
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			titleLabel = new Label();
			addContentChild(titleLabel);
			
			titleSpace = new Space();
			titleSpace.percentWidth = 1;
			addContentChild(titleSpace);

			closeButton = new SimpleButton();
			closeButton.addEventListener(MouseEvent.MOUSE_DOWN, closeButtnMouseDownHandler);
			closeButton.addEventListener(MouseEvent.CLICK, closeButtnClickHandler);
			addContentChild(closeButton);
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "closeButtonStyleName")
			{
				closeButton.styleName = getStyle(styleProp);
			}
			else if(styleProp == "titleLabelStyleName")
			{
				titleLabel.styleName = getStyle(styleProp);
			}
			else if(styleProp == "titleIcon")
			{
				//显示设置的icon style样式不能修改
				if(icon == null)
				{
					rengenerateIconInstance(getStyle(styleProp));
				}
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_isShowCoseButtonChangedFlag)
			{
				_isShowCoseButtonChangedFlag = false;
				
				closeButton.includeInLayout = _isShowCloseButton;
				closeButton.setVisible(_isShowCloseButton);
			}
		}
		
		override protected function iconChanged():void
		{
			super.iconChanged();
			
			rengenerateIconInstance(icon);
		}
		
		private function rengenerateIconInstance(iconCls:Class):void
		{
			if(iconIntance != null)
			{
				removeContentChild(iconIntance);
				iconIntance = null;
			}
			
			if(iconCls != null)
			{
				iconIntance = new iconCls();
				if(iconIntance != null)
				{
					addContentChild(iconIntance);
					
					updateChildIndex();
				}
			}
		}
		
		override protected function titleChanged():void
		{
			super.titleChanged();
			
			titleLabel.text = title;
		}
		
		protected function updateChildIndex():void
		{
			LayoutUtil.sortDisplayObjectChildren(closeButton, 
				titleSpace, 
				titleLabel, 
				iconIntance);
		}
		
		//让关闭按钮不冒泡mouseDown，导致在关闭按钮上按下时，不能拖动
		private function closeButtnMouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		private function closeButtnClickHandler(event:MouseEvent):void
		{
			if(owner != null)
			{
				if(hasEventListener(CloseEvent.CLOSE))
				{
					var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
					owner.dispatchEvent(closeEvent);
				}
			}
		}
	}
}