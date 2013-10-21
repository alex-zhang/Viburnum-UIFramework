package com.viburnum.components.baseClasses
{
	import com.viburnum.components.SimpleButton;
	import com.viburnum.interfaces.IViewport;
	import com.viburnum.events.ViburnumEvent;
	import com.viburnum.events.ViburnumMouseEvent;
	
	[Style(name="fixedThumbSize", type="Boolean")]
	[Style(name="repeatInterval", type="Number", format="Time")]
	[Style(name="smoothScrolling", type="Boolean")]
	[Style(name="autoThumbVisibility", type="Boolean")]
	
	[Style(name="decrementButton_styleName", type="String")]
	[Style(name="incrementButton_styleName", type="String")]

    public class ScrollBarBase extends TrackBase
    {
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"fixedThumbSize", type:"Boolean"},
				{name:"repeatInterval", type:"Number", format:"Time"},
				{name:"smoothScrolling", type:"Boolean"},
				{name:"autoThumbVisibility", type:"Boolean"},
				
				{name:"decrementButton_styleName", type:"String"},
				{name:"incrementButton_styleName", type:"String"},
			]
		}
		protected var _incrementButton:SimpleButton;
		protected var _decrementButton:SimpleButton;
		
		private var _pageSize:Number = 20;
		private var _pageSizeChangedFlag:Boolean = false;

		private var _viewport:IViewport;
		private var _viewportClipAndEnableScrolling:Boolean;
		
        public function ScrollBarBase()
        {
            super();

			tabChildren = false;
        }
		
		public function get pageSize():Number
		{
			return _pageSize;
		}
		
		[Inspectable(type="Number", defaultValue="20")]
		public function set pageSize(value:Number):void
		{
			if(_pageSize == value) return;
			
			_pageSize = value;
			_pageSizeChangedFlag = true;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get viewport():IViewport
		{
			return _viewport;
		}
		
		public function set viewport(value:IViewport):void
		{
			if(_viewport == value) return;
			
			if(_viewport != null)
			{
				_viewport.removeEventListener(ViburnumEvent.VIEWABLE_SIZE_CHANGED, viewableSizeChangedHandler);
				_viewport.clipAndEnableScrolling = _viewportClipAndEnableScrolling;
			}
			
			_viewport = value;
			
			if(_viewport != null)  // new _viewport
			{
				_viewport.addEventListener(ViburnumEvent.VIEWABLE_SIZE_CHANGED, viewableSizeChangedHandler);
				_viewportClipAndEnableScrolling = _viewport.clipAndEnableScrolling;
				_viewport.clipAndEnableScrolling = true;
			}
		}
		
		private function viewableSizeChangedHandler(event:ViburnumEvent):void
		{
			updateMaximumAndPageSize();
		}

		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "decrementButton_styleName")
			{
				_decrementButton.styleName = getStyle("decrementButton_styleName");
			}
			else if(styleProp == "incrementButton_styleName")
			{
				_incrementButton.styleName = getStyle("incrementButton_styleName");
			}
		}

		override protected function onInitialize():void
		{
			super.onInitialize();

			_decrementButton = new SimpleButton();
			_decrementButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, decrement2IncrementBtnMouseDownHandler);
			_decrementButton.autoRepeat = true;
			_decrementButton.enabled  = enabled;
			addChild(_decrementButton);
			
			_incrementButton = new SimpleButton();
			_incrementButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, decrement2IncrementBtnMouseDownHandler);
			_incrementButton.autoRepeat = true;
			_incrementButton.enabled  = enabled;
			addChild(_incrementButton);
		}
		
		private function decrement2IncrementBtnMouseDownHandler(event:ViburnumMouseEvent):void
		{
			var targetBtn:SimpleButton = event.currentTarget as SimpleButton;
			if(targetBtn == _decrementButton)
			{
				changeValueByStep(false);
			}
			else if(targetBtn == _incrementButton)
			{
				changeValueByStep(true);
			}
		}

		override protected function onValidateProperties():void
		{
			super.onValidateProperties();

			if(_pageSizeChangedFlag)
			{
				_pageSizeChangedFlag = false;
				_pageSize = nearestValidSize(_pageSize);
			}
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
		
			if(_viewport != null) updateMaximumAndPageSize();
		}

		protected function updateMaximumAndPageSize():void
		{
			enabled = maximum > minimum;
		}
    }
}