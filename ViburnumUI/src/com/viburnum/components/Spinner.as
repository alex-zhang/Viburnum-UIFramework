package com.viburnum.components
{
    import com.viburnum.components.baseClasses.RangeBase;
    import com.viburnum.events.ViburnumMouseEvent;
    import com.viburnum.utils.LayoutUtil;
    
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

	[Style(name="repeatInterval", type="Number", format="Time", minValue="0.0")]

	[Style(name="incrementButton_backgroundSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_upSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_overSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_downSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_disabledSkin", type="Class")]
	
	[Style(name="decrementButton_backgroundSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_upSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_overSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_downSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_disabledSkin", type="Class")]

    public class Spinner extends RangeBase implements IFocusManagerComponent
    {
		protected var incrementButton:SimpleButton;
		protected var decrementButton:SimpleButton;

        public function Spinner()
        {
            super();
        }

		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);

			if(styleProp == "incrementButton_backgroundSkin" || styleProp == "incrementButton_backgroundSkin_upSkin" ||
				styleProp == "incrementButton_backgroundSkin_overSkin" || styleProp == "incrementButton_backgroundSkin_downSkin" ||
				styleProp == "incrementButton_backgroundSkin_disabledSkin")
			{
				var incrementButtonStyle:String = styleProp.substr(16);
				incrementButton.setStyle(incrementButtonStyle, getStyle(styleProp));
			}
			else if(styleProp == "decrementButton_backgroundSkin" || styleProp == "decrementButton_backgroundSkin_upSkin" ||
				styleProp == "decrementButton_backgroundSkin_overSkin" || styleProp == "decrementButton_backgroundSkin_downSkin" ||
				styleProp == "decrementButton_backgroundSkin_disabledSkin")
			{
				var decrementButtonStyle:String = styleProp.substr(16);
				decrementButton.setStyle(decrementButtonStyle, getStyle(styleProp));
			}
			else if(styleProp == "repeatInterval")
			{
				decrementButton.setStyle("repeatInterval", getStyle("repeatInterval"));
				incrementButton.setStyle("repeatInterval", getStyle("repeatInterval"));
			}
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			decrementButton = new SimpleButton();
			decrementButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, decrementButtonClickHandler);
			decrementButton.autoRepeat = true;
			decrementButton.enabled  = enabled;
			addChild(decrementButton);

			incrementButton = new SimpleButton();
			incrementButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, incrementButtonClickHandler);
			incrementButton.autoRepeat = true;
			incrementButton.enabled  = enabled;
			addChild(incrementButton);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(decrementButton);
			var decrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(decrementButton);
			var decrementButtonMinW:Number = LayoutUtil.getDisplayObjectMinWidth(decrementButton);
			var decrementButtonMinH:Number = LayoutUtil.getDisplayObjectMinHeight(decrementButton);

			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(incrementButton);
			var incrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(incrementButton);
			var incrementButtonMinW:Number = LayoutUtil.getDisplayObjectMinWidth(incrementButton);
			var incrementButtonMinH:Number = LayoutUtil.getDisplayObjectMinHeight(incrementButton);
			
			var measuredW:Number = Math.max(decrementButtonMW, incrementButtonMW);
			var measuredH:Number = decrementButtonMH + incrementButtonMH;
			
			setMeasuredSize(measuredW, measuredH);
			
			var minW:Number = Math.max(decrementButtonMinW, incrementButtonMinW);
			var minH:Number = decrementButtonMinH + incrementButtonMinH;
			
			setMeasuredMinSize(minW, minH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			var btnW:Number = layoutWidth;
			var btnH:Number = layoutHeight * 0.5;

			LayoutUtil.setDisplayObjectSize(decrementButton, btnW, btnH);
			LayoutUtil.setDisplayObjectLayout(incrementButton, 0, btnH, btnW, btnH);
		}
		
        private function decrementButtonClickHandler(event:ViburnumMouseEvent):void
        {
			changeValueByStep(false);
        }

		private function incrementButtonClickHandler(event:ViburnumMouseEvent):void
        {
			changeValueByStep(true);
        }
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.DOWN:
				case Keyboard.LEFT:
					changeValueByStep(false);
					break;
					
				case Keyboard.UP:
				case Keyboard.RIGHT:
					changeValueByStep(true);
					break;
					
				case Keyboard.HOME:
					value = minimum;
					break;

				case Keyboard.END:
					value = maximum;
					break;

				default:
					break;
			}
		}
    }
}