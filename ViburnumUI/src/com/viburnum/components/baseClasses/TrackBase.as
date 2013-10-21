package com.viburnum.components.baseClasses
{
	import com.viburnum.components.SimpleButton;
	import com.viburnum.events.ViburnumMouseEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[Style(name="thumbCenterOffset", type="Number")]
	[Style(name="thumbButton_styleName", type="String")]
	[Style(name="trackButton_styleName", type="String")]

    public class TrackBase extends RangeBase
    {
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"thumbCenterOffset", type:"Number"},
				{name:"thumbButton_styleName", type:"String"},
				{name:"trackButton_styleName", type:"String"},
				]
		}
		protected var _thumbButton:SimpleButton;
		protected var _trackButton:SimpleButton;

		private var _mouseDownTarget:DisplayObject;
		
		private var _thumbBtnMouseOffset:Point;
		
        public function TrackBase()
        {
			super();
        }
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "trackButton_styleName")
			{
				_trackButton.styleName = getStyle("trackButton_styleName");
			}
			else if(styleProp == "thumbButton_styleName")
			{
				_thumbButton.styleName = getStyle("thumbButton_styleName");
			}
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();

			_trackButton = new SimpleButton();
			_trackButton.enabled = enabled;
			_trackButton.addEventListener(MouseEvent.MOUSE_DOWN, trackButtonMouseDownHandler);
			addChild(_trackButton);

			_thumbButton = new SimpleButton();
			_thumbButton.enabled = enabled;
			_thumbButton.addEventListener(MouseEvent.MOUSE_DOWN, thumbBtnMouseDownHandler);
			_thumbButton.addEventListener(ViburnumMouseEvent.BUTTON_HOLD_MOVE, thumbBtnHoldeMoveHandler);
			_thumbButton.addEventListener(ViburnumMouseEvent.BUTTON_HOLD_RELEASE, thumbBtnHoldeReleaseHandler);
			addChild(_thumbButton);
		}
		
		protected function trackButtonMouseDownHandler(event:MouseEvent):void
		{
		}
		
		protected function getValueByThumbCenterPosition(thumbCenterX:Number, thumbCenterY:Number):Number
		{
			return 0;
		}
		
		protected function getThumbCenterPositionByValue(value:Number):Number
		{
			return 0;
		}
		
		protected function thumbBtnMouseDownHandler(event:MouseEvent):void
		{
			if(!enabled) return;
			
			_thumbBtnMouseOffset = new Point(event.localX, event.localY);
		}

		protected function thumbBtnHoldeMoveHandler(event:ViburnumMouseEvent):void
		{
			if(!enabled) return;

			var mousePoint:Point = _trackButton.globalToLocal(new Point(stage.mouseX, stage.mouseY));

			var thumbBtnW:Number = _thumbButton.width;
			var thumbBtnH:Number = _thumbButton.height;

			var thumbBtnCenterX:Number = mousePoint.x - _thumbBtnMouseOffset.x + thumbBtnW / 2;
			var thumbBtnCenterY:Number = mousePoint.y - _thumbBtnMouseOffset.y + thumbBtnH / 2;
			
			var newValue:Number = getValueByThumbCenterPosition(thumbBtnCenterX, thumbBtnCenterY);
			newValue = nearestValidValue(newValue, snapInterval);

			if(newValue != value)
			{
				setValue(newValue);
			}
		}
		
		protected function thumbBtnHoldeReleaseHandler(event:ViburnumMouseEvent):void
		{
		}
    }
}