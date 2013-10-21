package com.viburnum.components.baseClasses
{
    import com.viburnum.components.ToolTip;
    import com.viburnum.events.ViburnumMouseEvent;
    import com.viburnum.components.IFocusManagerComponent;
    import com.viburnum.interfaces.IStyleClient;
    import com.viburnum.components.IToolTip;
    import com.viburnum.utils.LayoutUtil;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    
	[Style(name="hightlightSkin", type="Class", skinClass="true")]
	[Style(name="liveDragging", type="Boolean")]
	[Style(name="slideDuration", type="Number", format="Time")]
	
	[Style(name="dataTipSideoffset", type="Number")]
	[Style(name="dataTip_styleName", type="String")]
	
    public class SliderBase extends TrackBase implements IFocusManagerComponent
    {
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"hightlightSkin", type:"Class", skinClass:"true"},
				{name:"liveDragging", type:"Boolean"},
				{name:"slideDuration", type:"Number", format:"Time"},
				{name:"dataTipSideoffset", type:"Number"},
				{name:"dataTip_styleName", type:"String"},
				]
		}
		
		public var hightlightSkin:DisplayObject;
		
		public var showDataTip:Boolean = true;
		public var dataTipClass:Class;
		
		private var _sliderAnimatorTimer:Timer;
		private var _sliderStartValue:Number;
		private var _sliderEndValue:Number;
		
		private var _textFormatFunction:Function;

		private var _dataTipTarget:DisplayObject;
		
		private var _requestUpdateDataTipTargetPostionFlag:Boolean = false;

        public function SliderBase()
        {
            super();
        }
		
		public function get textFormatFunction():Function
		{
			return _textFormatFunction;
		}
		
		public function set textFormatFunction(value:Function):void
		{
			_textFormatFunction = value;
		}
		
		override protected function onSkinPartAttachToDisplayList(skinPartName:String, skin:DisplayObject):void
		{
			if(hightlightSkin != null)
			{
				Sprite(hightlightSkin).mouseEnabled = false;
			}
		}
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.setDisplayObjectChildIndex(this, hightlightSkin, 1);
		}

		override public function drawFocus(isFocused:Boolean):void
		{
			_thumbButton.drawFocus(isFocused);
		}
		
		private function startSliderAnimator(duration:uint):void
		{
			if(_sliderAnimatorTimer != null)
			{
				_sliderAnimatorTimer.reset();
			}
			else
			{
				_sliderAnimatorTimer = new Timer(10);
				_sliderAnimatorTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
			
			_sliderAnimatorTimer.repeatCount = duration / 10;
			_sliderAnimatorTimer.start();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			var distance:Number = _sliderEndValue - _sliderStartValue;
			var perdistance:Number = distance / _sliderAnimatorTimer.repeatCount;
			var currentValue:Number = _sliderStartValue + perdistance * _sliderAnimatorTimer.currentCount;
			currentValue = nearestValidValue(currentValue, snapInterval);
			setValue(currentValue);

			event.updateAfterEvent();
		}

		protected function createDataTip():void
		{
			destoryDataTip();

			if(dataTipClass == null)
			{
				dataTipClass = ToolTip;
			}
			
			_dataTipTarget = new dataTipClass();

			if(_dataTipTarget != null)
			{
				updateDataTipTargetStyleName();

				if(application != null && application.popupManager != null)
				{
					application.popupManager.addPopUp(_dataTipTarget, false);
				}
				
				updateDataTipShowTipByCurrentValue(_dataTipTarget);
			}
		}
		
		private function updateDataTipTargetStyleName():void
		{
			if(_dataTipTarget != null && _dataTipTarget is IStyleClient)
			{
				IStyleClient(_dataTipTarget).styleName = getStyle("dataTip_styleName");
			}
		}
		
		protected function destoryDataTip():void
		{
			if(application != null && application.popupManager != null)
			{
				application.popupManager.removePopUp(_dataTipTarget);
			}

			_dataTipTarget = null;
		}

		private function updateDataTipShowTipByCurrentValue(dataTipTarget:DisplayObject):void
		{
			if(_dataTipTarget is IToolTip)
			{
				IToolTip(_dataTipTarget).toolTip = formatValueToString(value);

				_requestUpdateDataTipTargetPostionFlag = true;
				invalidateDisplayList();
			}
		}

		protected function layoutDataTipPostion(dataTipTarget:DisplayObject, thumbBtnCenterPostion:Number):void
		{
		}

		override protected function thumbBtnMouseDownHandler(event:MouseEvent):void
		{
			super.thumbBtnMouseDownHandler(event);
			
			if(enabled && showDataTip)
			{
				createDataTip();
			}
		}
		
		override protected function thumbBtnHoldeMoveHandler(event:ViburnumMouseEvent):void
		{
			super.thumbBtnHoldeMoveHandler(event);
			
			if(enabled && showDataTip && _dataTipTarget != null)
			{
				updateDataTipShowTipByCurrentValue(_dataTipTarget);
			}
		}
		
		override protected function thumbBtnHoldeReleaseHandler(event:ViburnumMouseEvent):void
		{
			super.thumbBtnHoldeReleaseHandler(event);
			
			if(enabled && showDataTip)
			{
				destoryDataTip();
			}
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);

			if(styleProp == "dataTip_styleName")
			{
				updateDataTipTargetStyleName();
			}
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			if(_requestUpdateDataTipTargetPostionFlag)
			{
				_requestUpdateDataTipTargetPostionFlag = false;
				
				if(enabled && showDataTip && _dataTipTarget != null)
				{
					layoutDataTipPostion(_dataTipTarget, getThumbCenterPositionByValue(value));
				}
			}
		}

		override protected function trackButtonMouseDownHandler(event:MouseEvent):void
		{
			super.trackButtonMouseDownHandler(event);

			if(!enabled) return;

			var thumbW:Number = _thumbButton.width;
			var thumbH:Number = _thumbButton.height;
			var p:Point = new Point(event.localX, event.localY);
			
			_sliderEndValue = getValueByThumbCenterPosition(p.x, p.y);
			_sliderEndValue = nearestValidValue(_sliderEndValue, snapInterval);

			if(_sliderEndValue != value)
			{
				var slideDuration:Number = getStyle("slideDuration") || 0;
				if(slideDuration != 0)
				{
					_sliderStartValue = value;

					startSliderAnimator(slideDuration);
				}
				else
				{
					setValue(_sliderEndValue);
				}
				
				event.updateAfterEvent();
			}
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
			
			var prevValue:Number = this.value;
			var newValue:Number;

			var keyCode:uint = event.keyCode;

			switch (keyCode)
			{
				case Keyboard.DOWN:
				case Keyboard.LEFT:
				{
					changeValueByStep(false);
					break;
				}
					
				case Keyboard.UP:
				case Keyboard.RIGHT:
				{
					changeValueByStep(true);
					break;
				}

				case Keyboard.HOME:
				{
					value = minimum;
					break;
				}
					
				case Keyboard.END:
				{
					value = maximum;
					break;
				}
			}
		}

		private function formatValueToString(value:Number):String
		{
			var formattedValue:String;
			
			if(_textFormatFunction != null)
			{
				formattedValue = _textFormatFunction(value); 
			}
			else
			{
				formattedValue = int(value).toString();
			}
			
			return formattedValue;
		}
    }
}